@echo off
cd /d "%~dp0"
echo.
echo === MISDEAL UPDATE ===
git pull --ff-only
echo.
echo Done. You can return to Godot.
echo.
pause
