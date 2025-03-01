import subprocess
import shutil
import os
import sys
import struct
from typing import List, Tuple, Dict
from dataclasses import dataclass

def prepare_arm9() -> None:
	print("Preparing arm9 files...")
	with open("unpack/arm9.bin", "rb") as arm9_in_file, \
	     open("arm9/arm9.bin", "wb") as arm9_out_file, \
	     open("arm9/arm9_header.bin", "wb") as arm9_header_file:
		# Separate the first 0x4000 uncompressed bytes
		arm9_in_file.seek(0, os.SEEK_END)
		arm9_size = arm9_in_file.tell()
		arm9_in_file.seek(0, os.SEEK_SET)
		arm9_header_file.write(arm9_in_file.read(0x4000))
		# Ommit the last 12 bytes so it decompresses correctly
		arm9_out_file.write(arm9_in_file.read(arm9_size - 0x4000 - 0x0C))

def build_arm9() -> None:
	print("Building arm9.bin...")
	with open("temp/arm9.bin", "rb") as arm9_in_file, \
	     open("unpack/arm9.bin", "wb") as arm9_out_file, \
	     open("arm9/arm9_header.bin", "rb") as arm9_header_file:
		# Combine the compressed and uncompressed portions again
		arm9_out_file.write(arm9_header_file.read())
		arm9_out_file.write(arm9_in_file.read())
		# Update where the compressed arm9 begins
		arm9_size = arm9_out_file.tell()
		arm9_out_file.seek(0xB78, os.SEEK_SET)
		arm9_out_file.write((arm9_size | 0x02000000).to_bytes(length = 4, byteorder="little"))

def update_y9() -> None:
	print("Updating overlay sizes...")
	# Get overlay sizes and compute the bytes
	overlay_sizes : List[bytes] = [
		(os.path.getsize(f"unpack/overlay/overlay_{ol:04d}.bin") | 0x01000000)
			.to_bytes(length = 4, byteorder = "little")
		for ol in overlay_list
	]
	@dataclass
	class OverlayEntry:
		overlay_id : int
		ram_address : int
		ram_size : int
		bss_size : int
		static_init_start : int
		static_init_end : int
		overlay_file_id : int
		compressed_size : int
	with open("unpack/y9.bin", "r+b") as y9_file:
		y9_data = y9_file.read()
		if len(y9_data) % 32 != 0:
			build_error("y9.bin format is incorrect")
		# The overlays are not always in the same order as the overlay id
		# so making a lookup based on the overlay_file_id
		overlay_entries : Dict[int, int] = {
			OverlayEntry(*y9_entry).overlay_file_id : file_index
			for file_index, y9_entry in enumerate(struct.iter_unpack("<8I", y9_data))
		}
		for ol, size_bytes in zip(overlay_list, overlay_sizes):
			# update the compressed size of the overlay
			y9_file.seek(overlay_entries[ol] * 0x20 + 0x1C)
			y9_file.write(size_bytes)

def check_region() -> int:
	print("Checking Region...")
	with open("unpack/input.nds", "rb") as nds_file:
		nds_file.seek(0x0C, os.SEEK_SET)
		game_id = nds_file.read(4)
		region_lookup ={
			b"BKIE" : 0,
			b"BKIP" : 1,
		}
		return region_lookup.get(game_id, -1)

def decompress_files(file_list: List[Tuple[str, str]]) -> int:
	print("Decompressing arm9 and overlay files...")
	process_list : List[subprocess.Popen] = []
	final_error_code = 0
	for src_file, dst_file in file_list:
		if src_file != dst_file:
			shutil.copy(src_file, dst_file)
		p = subprocess.Popen([
			"blz.exe",
			"-d",
			dst_file
			# src_file,
			# dst_file
			],
			stdout = subprocess.DEVNULL
		)
		process_list.append(p)
		#wait for a process to finish before adding another
		while (len(process_list) >= num_parallel_process):
			for subp in process_list:
				errorCode = subp.poll()
				if(errorCode != None):
					if errorCode != 0:
						print(f"Failed to decompress {subp.args[2]}")
					final_error_code = final_error_code | errorCode
					process_list.remove(subp)
	#wait for everything to finish
	for p in process_list:
		final_error_code = final_error_code | p.wait()
	return final_error_code

def compress_files(file_list: List[Tuple[str, str]]) -> int:
	print("Compressing arm9 and overlay files...")
	process_list : List[subprocess.Popen] = []
	final_error_code = 0
	for src_file, dst_file in file_list:
		if src_file != dst_file:
			shutil.copy(src_file, dst_file)
		p = subprocess.Popen([
			"blz.exe",
			"-eo",
			dst_file
			# src_file,
			# dst_file
			],
			stdout = subprocess.DEVNULL
		)
		process_list.append(p)
		#wait for a process to finish before adding another
		while (len(process_list) >= num_parallel_process):
			for subp in process_list:
				errorCode = subp.poll()
				if(errorCode != None):
					final_error_code = final_error_code | errorCode
					process_list.remove(subp)
	#wait for everything to finish
	for p in process_list:
		final_error_code = final_error_code | p.wait()
	return final_error_code

#Unpacks the input game and extracts needed files
def prepare_build() -> None:
	print("Preparing initial files from input.nds...")

	print("Running ndstool unpack...")
	proc = subprocess.run([
		"ndstool.exe",
		"-x", "input.nds",
		"-9", "arm9.bin",
		"-7", "arm7.bin",
		"-y9", "y9.bin",
		"-y7", "y7.bin",
		"-d", "data",
		"-y", "overlay",
		"-t", "banner.bin",
		"-h", "header.bin"
		],
		cwd = "unpack"
	)
	if(proc.returncode != 0):
		build_error("Error unpacking input.nds")

	prepare_arm9()

	decompress_file_list = [("arm9/arm9.bin", "arm9/arm9.bin")] + [
		(f"unpack/overlay/overlay_{ol:04d}.bin", f"arm9/overlay_{ol:04d}.bin") for ol in overlay_list
	]
	rc = decompress_files(decompress_file_list)
	if rc != 0:
		build_error("Error decompressing arm9 or overlays")

	print("Prepare done...")

def main_build() -> None:
	print("Compiling source files...")
	print("Running armips...")
	proc = subprocess.run([
		"armips.exe",
		"compile.asm",
		"-sym", "unpack\zelda_spirit_tracks_dpad.sym",
		"-equ", "current_region", f"{region}"
		]
	)
	if(proc.returncode != 0):
		build_error("Error running armips")

	compress_file_list = [("temp/arm9.bin", "temp/arm9.bin")] + [
		(f"temp/overlay_{ol:04d}.bin", f"unpack/overlay/overlay_{ol:04d}.bin") for ol in overlay_list
	]
	rc = compress_files(compress_file_list)
	if rc != 0:
		build_error("Error compressing arm9 or overlays")
	
	build_arm9()

	update_y9()

def build_output() -> None:
	print("Running ndstool pack...")
	proc = subprocess.run([
		"ndstool.exe",
		"-c", "zelda_spirit_tracks_dpad.nds",
		"-9", "arm9.bin",
		"-7", "arm7.bin",
		"-y9", "y9.bin",
		"-y7", "y7.bin",
		"-d", "data",
		"-y", "overlay",
		"-t", "banner.bin",
		"-h", "header.bin",
		],
		cwd = "unpack"
	)
	if(proc.returncode != 0):
		build_error("Error packing zelda_spirit_tracks_dpad.nds")

def build_error(errorMessage) -> None:
	print(errorMessage, file = sys.stderr)
	sys.exit("Build Error")

def main() -> None:
	if (not os.path.isdir("unpack/data/")) or (force_prepare):
		prepare_build()

	main_build()

	build_output()

	print("Build done...")

#Force initial game unpack / decompression
force_prepare = False
overlay_list = [0, 17, 24, 93]
num_parallel_process = 16

if __name__ == "__main__":
	if(os.path.isfile("unpack/input.nds") == False):
		build_error("input.nds not found in the unpack directory")
	region = check_region()
	if region == -1:
		build_error("Invalid game ID, this input.nds is not The Legend of Zelda: Spirit Tracks US or EU")
	os.makedirs("arm9", exist_ok = True)
	os.makedirs("temp", exist_ok = True)
	main()