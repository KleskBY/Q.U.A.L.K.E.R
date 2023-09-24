@echo off
setlocal

rem Set the path to the executable within the "data" folder
set "executable_path=stable_engine\darkplaces-sdl.exe"

rem Check if the executable exists
if not exist "%executable_path%" (
  echo Error: Executable not found in the "data" folder.
  exit /b
)

rem Run the executable
echo Running the executable from the "data" folder: %executable_path%
"%executable_path%" -game data

endlocal
