# ComfyUI: AMD ROCm Native Windows Setup

This repository provides an automated installation workflow to run ComfyUI on Windows using AMD's native **ROCm/HIP** backend, completely bypassing the DirectML translation layer. 

By pulling nightly multi-architecture packages from the official [ROCm/TheRock](https://github.com/ROCm/TheRock) project, this script installs PyTorch with direct low-level communication to the GPU silicon on Windows.

## The DirectML Problem
The default ComfyUI Portable ecosystem for AMD on Windows relies on DirectML. This introduces severe physical limitations, specifically the `OpaqueTensorImpl` error and lack of support for the `Float8_e4m3fn` data type. In practice, this prevents the use of GGUF files or native FP8 models, causing Out of Memory (OOM) crashes on cards with 8GB of VRAM or less.

### Proven Gains (e.g., RX 5500 XT 8GB - gfx1012)
* Raw iteration time on SDXL (FP16): **1.6s/it**.
* Unlocked support for GGUF decoding on the CPU.
* Base VRAM consumption reduced from ~8GB down to **~4GB**.

## Finding Your Architecture (GFX Target)
To download the correct kernels for your specific GPU, find your architecture string in the table below:

| Product Name / GPU Series                            | GFX Target |
| ---------------------------------------------------- | ---------- |
| AMD Radeon RX 9070 / XT, AI PRO R9700 / R9600D       | `gfx1201`  |
| AMD Radeon RX 9060 / XT                              | `gfx1200`  |
| AMD Ryzen AI 9 HX 375                                | `gfx1150`  |
| AMD Radeon RX 7900 XTX / 7900 XT, PRO W7900 / W7800  | `gfx1100`  |
| AMD Radeon RX 7800 XT / 7700 XT, PRO V710 / W7700    | `gfx1101`  |
| AMD Radeon RX 7600                                   | `gfx1102`  |
| AMD Radeon 780M Laptop iGPU                          | `gfx1103`  |
| AMD Radeon RX 6900 XT / 6800 XT, PRO W6800 / V620    | `gfx1030`  |
| AMD Radeon RX 6750 XT / 6700 XT                      | `gfx1031`  |
| AMD Radeon RX 6600 XT / 6600, PRO W6600              | `gfx1032`  |
| AMD Radeon RX 5700 / XT                              | `gfx1010`  |
| AMD Radeon RX 5500 XT / Pro W5500                    | `gfx1012`  |

*(Note: Instinct Data Center cards like MI300X (`gfx942`) are also supported).*

## How to Install

1. Download the standard [ComfyUI Windows Portable](https://github.com/comfyanonymous/ComfyUI/releases) for AMD.
2. Extract the contents to your drive.
3. Place the `setup_rocm.bat` file from this repository in the root folder (alongside the `python_embeded` folder).
4. Open the Command Prompt (CMD) in that folder and run the script passing your target architecture:

```bat
.\setup_rocm.bat gfx1100
