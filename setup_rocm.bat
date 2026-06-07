@echo off
setlocal

:: Set default architecture to gfx1012, override if user passes an argument
set "TARGET_ARCH=gfx1012"
if not "%~1"=="" (
    set "TARGET_ARCH=%~1"
)

echo =====================================================================
echo ComfyUI: Native PyTorch ROCm/HIP Setup (AMD Windows)
echo Target Architecture: %TARGET_ARCH%
echo =====================================================================
echo.

set "PYTHON_EXE=.\python_embeded\python.exe"
set "VENV_DIR=env_rocm"

if not exist "%PYTHON_EXE%" (
    echo [ERROR] The portable Python interpreter was not found.
    echo Please run this script directly from the ComfyUI_windows_portable root folder.
    pause
    exit /b 1
)

echo [1/4] Installing virtualenv on the embedded Python...
"%PYTHON_EXE%" -m pip install virtualenv
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to install virtualenv.
    pause
    exit /b 1
)

echo [2/4] Creating isolated virtual environment (%VENV_DIR%)...
"%PYTHON_EXE%" -m virtualenv "%VENV_DIR%"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to create the virtual environment.
    pause
    exit /b 1
)

echo [3/4] Downloading native Multi-arch PyTorch via AMD servers for %TARGET_ARCH%...
call ".\%VENV_DIR%\Scripts\activate.bat"
python -m pip install --upgrade pip
pip install --index-url https://rocm.nightlies.amd.com/whl-multi-arch/ "torch[device-%TARGET_ARCH%]" "torchvision[device-%TARGET_ARCH%]" torchaudio
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to install PyTorch for %TARGET_ARCH%. Check your architecture string or connection.
    pause
    exit /b 1
)

echo [4/4] Installing ComfyUI dependencies and GGUF...
pip install -r .\ComfyUI\requirements.txt
pip install gguf
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to install ComfyUI dependencies.
    pause
    exit /b 1
)

echo.
echo =====================================================================
echo [SUCCESS] Installation completed for %TARGET_ARCH%!
echo To generate images, use your custom launcher: run_rocm.bat
echo =====================================================================
pause
