@echo off
setlocal enabledelayedexpansion

:: =====================================================================
:: Configuration and Cache File
:: =====================================================================
set "CONFIG_FILE=rocm_config.ini"

:: Default values if the file doesn't exist (First run)
set "LAST_VRAM=normalvram"
set "LAST_FP8=N"
set "LAST_LAN=N"

:: Load previous choices from the file
if exist "%CONFIG_FILE%" (
    for /f "delims=" %%a in (%CONFIG_FILE%) do set "%%a"
)

echo =====================================================================
echo              ComfyUI ROCm - Custom Launcher
echo =====================================================================
echo.

:: =====================================================================
:: 1. VRAM Mode
:: =====================================================================
echo [1] Low VRAM (--lowvram)
echo [2] Mid/Normal VRAM (--normalvram)
echo [3] High VRAM (--highvram)
echo.
echo [Saved Default: %LAST_VRAM%]
set /p "INPUT_VRAM=Choose VRAM mode (1/2/3) or press ENTER for default: "

if "%INPUT_VRAM%"=="" set "INPUT_VRAM=%LAST_VRAM%"
if "%INPUT_VRAM%"=="1" set "INPUT_VRAM=lowvram"
if "%INPUT_VRAM%"=="2" set "INPUT_VRAM=normalvram"
if "%INPUT_VRAM%"=="3" set "INPUT_VRAM=highvram"

:: =====================================================================
:: 2. FP8 Processing
:: =====================================================================
echo.
echo [Saved Default: %LAST_FP8%]
set /p "INPUT_FP8=Enable native FP8 processing (Y/N)? Press ENTER for default: "

if "%INPUT_FP8%"=="" set "INPUT_FP8=%LAST_FP8%"

:: =====================================================================
:: 3. Local Network Access (Listen)
:: =====================================================================
echo.
echo [Saved Default: %LAST_LAN%]
set /p "INPUT_LAN=Allow local network access [--listen] (Y/N)? Press ENTER for default: "

if "%INPUT_LAN%"=="" set "INPUT_LAN=%LAST_LAN%"

:: =====================================================================
:: Save choices for next time
:: =====================================================================
(
    echo LAST_VRAM=!INPUT_VRAM!
    echo LAST_FP8=!INPUT_FP8!
    echo LAST_LAN=!INPUT_LAN!
) > "%CONFIG_FILE%"

:: =====================================================================
:: Build Launch Arguments
:: =====================================================================
set "ARGS=--!INPUT_VRAM!"

if /I "!INPUT_FP8!"=="Y" (
    set "ARGS=!ARGS! --fp8_e4m3fn-unet"
)

if /I "!INPUT_LAN!"=="Y" (
    set "ARGS=!ARGS! --listen"
)

:: =====================================================================
:: Execution
:: =====================================================================
echo.
echo =====================================================================
echo Starting ComfyUI with the following parameters:
echo !ARGS!
echo =====================================================================
echo.

call ".\env_rocm\Scripts\activate.bat"
python .\ComfyUI\main.py !ARGS!

pause
