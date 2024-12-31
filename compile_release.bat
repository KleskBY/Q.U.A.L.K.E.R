@echo off

:: Copy all files and subfolders from "data" to "/release" except "data/level"
echo Copying files...
robocopy "data\cubemaps" "release\data\cubemaps" /E
robocopy "data\env" "release\data\env" /E
robocopy "data\gfx" "release\data\gfx" /E
robocopy "data\glsl" "release\data\glsl" /E
robocopy "data\maps" "release\data\maps" /E
robocopy "data\models" "release\data\models" /E
robocopy "data\particles" "release\data\particles" /E
robocopy "data\progs" "release\data\progs" /E
robocopy "data\scripts" "release\data\scripts" /E
robocopy "data\scripts" "release\data\scripts" /E
robocopy "data\sound" "release\data\sound" /E
:: robocopy "data\textures" "release\data\textures" /E
copy  "data\autoexec.cfg" "release\data\autoexec.cfg" /Y
copy  "data\default.cfg" "release\data\default.cfg" /Y
copy  "data\csprogs.dat" "release\data\csprogs.dat" /Y
copy  "data\csprogs.dat" "release\data\csprogs.dat" /Y
copy  "data\menu.dat" "release\data\menu.dat" /Y
copy  "data\progs.dat" "release\data\progs.dat" /Y
copy  "data\effectinfo.txt" "release\data\effectinfo.txt" /Y

robocopy "qc" "release\qc" /E 

echo Removing unwanted folder...
rmdir /S /Q "release\data\gfx\ui"
del "release\data\maps\test.bsp"
del "release\data\config.cfg"
del "release\zircon_history.txt"

echo Operation completed.
pause
