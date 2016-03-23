echo Preparing source files
  if not exist .\unpack\input.nds (
    echo "input.nds" not found in the unpack directory
    pause
    exit /b 1
  )
cd unpack
ndstool.exe -x input.nds -9 arm9.bin -7 arm7.bin -y9 y9.bin -y7 y7.bin -d data -y overlay -t banner.bin -h header.bin
cd ..\
makearm9.exe -x .\unpack\arm9.bin arm9_original.bin
blz.exe -d arm9_original.bin
copy .\unpack\overlay\overlay_0000.bin .\overlay_0000_original.bin
copy .\unpack\overlay\overlay_0017.bin .\overlay_0017_original.bin
copy .\unpack\overlay\overlay_0024.bin .\overlay_0024_original.bin
copy .\unpack\overlay\overlay_0093.bin .\overlay_0093_original.bin
blz.exe -d overlay_0000_original.bin
blz.exe -d overlay_0017_original.bin
blz.exe -d overlay_0024_original.bin
blz.exe -d overlay_0093_original.bin
exit /b 0
