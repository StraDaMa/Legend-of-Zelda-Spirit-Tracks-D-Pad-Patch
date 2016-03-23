@echo off
if not exist .\unpack\data (
  call prepare.bat
  if errorlevel 1 exit 1
)

armips compile.asm -sym ".\unpack\zelda_spirit_tracks_dpad.sym"
blz -eo arm9_compressed.bin

makearm9.exe -c "arm9_compressed.bin" "unpack\arm9.bin"

blz -eo overlay_0000_compressed.bin
copy overlay_0000_compressed.bin .\unpack\overlay\overlay_0000.bin

blz -eo overlay_0017_compressed.bin
copy overlay_0017_compressed.bin .\unpack\overlay\overlay_0017.bin

blz -eo overlay_0024_compressed.bin
copy overlay_0024_compressed.bin .\unpack\overlay\overlay_0024.bin

blz -eo overlay_0093_compressed.bin
copy overlay_0093_compressed.bin .\unpack\overlay\overlay_0093.bin

fixy9 .\unpack\y9.bin overlay_0000_compressed.bin overlay_0017_compressed.bin overlay_0024_compressed.bin overlay_0093_compressed.bin

cd unpack
call build.bat
cd ..\
pause
