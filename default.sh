#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
)

WORKFLOWS=(

)

CHECKPOINT_MODELS=(
#    ""
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
)

CONTROLNET_MODELS=(
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi

echo "BEGINNING COMFYUI INSTALL SCRIPT"
#source /venv/main/bin/activate

cd /workspace
pip freeze > bak-requirements.txt

echo "installing/updating basic tooling and huggingface hub"
pip install -U pip huggingface-hub

echo "logging in to huggingface hub"
hf auth login --token "$HF_TOKEN"

echo "updating ComfyUI"
cd /workspace/ComfyUI
git pull
git config --global --add safe.directory /workspace/ComfyUI
git checkout master
git pull
echo "updated ComfyUI to latest version"

echo "installing base requirements"
pip3 install -r /workspace/ComfyUI/requirements.txt
pip3 install -r /workspace/ComfyUI/manager_requirements.txt
echo "finished installing base requirements"

echo "removing bloat model files to save space"
rm -rf /workspace/ComfyUI/models/checkpoints/*.safetensors

#Custom Nodes
#Removing old custom node repositories
echo "removing old custom node repositories"
cd /workspace/ComfyUI/custom_nodes
rm -rf ComfyUI-Manager/
rm -rf Civicomfy/
rm -rf ComfyUI-KJNodes/

#Cloning custom node repositories
#Essential Stuff
echo "cloning comfyui custom nodes"
echo "cloning essential custom nodes repositories"
git clone https://github.com/Comfy-Org/ComfyUI-Manager
git clone https://github.com/kijai/ComfyUI-KJNodes
git clone https://github.com/city96/ComfyUI-GGUF
git clone https://github.com/calcuis/gguf
git clone https://github.com/MoonGoblinDev/Civicomfy
git clone https://github.com/Azornes/Comfyui-Resolution-Master
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite

# General Packs & Misc
echo "cloning general packs and misc custom nodes repositories"
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack
git clone https://github.com/ltdrdata/ComfyUI-Inspire-Pack
git clone https://github.com/djbielejeski/a-person-mask-generator
git clone https://github.com/jags111/efficiency-nodes-comfyui
git clone https://github.com/melMass/comfy_mtb
git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts
git clone https://github.com/cubiq/ComfyUI_essentials
git clone https://github.com/TinyTerra/ComfyUI_tinyterraNodes
git clone https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes
git clone https://github.com/rgthree/rgthree-comfy
git clone https://github.com/evanspearman/ComfyMath
git clone https://github.com/princepainter/Comfyui-PainterAudioCut
git clone https://github.com/chflame163/ComfyUI_LayerStyle
git clone https://github.com/ltdrdata/was-node-suite-comfyui
git clone https://github.com/yolain/ComfyUI-Easy-Use

# Functions & Features
echo "cloning functions and features custom nodes repositories"
git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation
git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
git clone https://github.com/yuvraj108c/ComfyUI-Video-Depth-Anything
git clone https://github.com/1038lab/ComfyUI-RMBG
git clone https://github.com/Fannovel16/comfyui_controlnet_aux
git clone https://github.com/1038lab/ComfyUI-QwenVL
git clone https://github.com/ai-shizuka/ComfyUI-tbox
git clone https://github.com/ClownsharkBatwing/RES4LYF
# git clone https://github.com/pollockjj/ComfyUI-MultiGPU
git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess/
git clone https://github.com/kijai/ComfyUI-SCAIL-Pose
git clone https://github.com/akatz-ai/ComfyUI-DepthCrafter-Nodes
git clone https://github.com/kijai/ComfyUI-segment-anything-2
git clone https://github.com/mengqin/ComfyUI-UnetBnbModelLoader
git clone https://github.com/Lightricks/ComfyUI-LTXVideo
git clone https://github.com/alisson-anjos/ComfyUI-BFSNodes

#Installing custom node repositories
#Essential Stuff
echo "installing custom nodes requirements"
echo "installing essential custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/gguf/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Civicomfy/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Comfyui-Resolution-Master/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite/requirements.txt

#General Packs & Misc
echo "installing general packs and misc custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Impact-Pack/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Inspire-Pack/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/a-person-mask-generator/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/efficiency-nodes-comfyui/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/comfy_mtb/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Custom-Scripts/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_essentials/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_tinyterraNodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Derfuu_ComfyUI_ModdedNodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/rgthree-comfy/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyMath/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Comfyui-PainterAudioCut/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_LayerStyle/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt

#Functions & Features
echo "installing functions and features custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Video-Depth-Anything/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-RMBG/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-QwenVL/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-tbox/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/RES4LYF/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-MultiGPU/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanAnimatePreprocess/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-SCAIL-Pose/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-DepthCrafter-Nodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-segment-anything-2/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-UnetBnbModelLoader/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-BFSNodes/requirements.txt
# pip uninstall -y xformers
cd /workspace
echo "finished installing custom nodes requirements"

# #Sage Attention
echo "installing sageattention"
pip install sageattention --no-build-isolation
# pip install sageattention==1.0.6
echo "finished installing sageattention"

# #Reinstalling base requirements
echo "installing base requirements again to ensure all dependencies are met"
pip install -r /workspace/ComfyUI/requirements.txt #numpy==1.26.4 torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
pip install -r /workspace/ComfyUI/manager_requirements.txt #numpy==1.26.4 torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
echo "finished installing base requirements again"

# #Reinstalling numpy
echo "reinstalling numpy to ensure compatibility"
pip install numpy==1.26.4
echo "finished reinstalling numpy"

#Clearing pip cache
echo "cleaning up pip cache to save space"
pip cache purge
echo "finished cleaning up pip cache"

#Downloading Huggingface repositories and files
echo "."
echo "."
echo "."
echo "!!! BEGINNING DOWNLOAD OF FILES !!!"
echo "."
echo "."
echo "."

echo "removing files and folders to be replaced by huggingface repo"
rm -rf /workspace/ComfyUI/user/default/comfy.settings.json
rm -rf /workspace/ComfyUI/comfy_extras/nodes_qwen.py
rm -rf /workspace/ComfyUI/custom_nodes/ComfyUI-QwenVL/hf_models.json
echo "finished removing files and folders to be replaced by huggingface repo"

echo "Downloading repositories"
cd /workspace/ComfyUI
hf auth login --token "$HF_TOKEN"

# -------------------------------------
# # MAIN
echo "Downloading main models repositories"

# # REPO                        SIZE_GB
# # 49108215MI                  0.013 GB
echo "downloading MI files"
cd /workspace/ComfyUI && hf download LVMCS/49108215MI --local-dir . && rm -rf .cache/
echo "finished downloading MI files"

# # 49108215MM                  4.66  GB
echo "downloading MM model"
cd /workspace/ComfyUI && hf download LVMCS/49108215MM --local-dir . && rm -rf .cache/
echo "finished downloading MM model"

# # 49108215LT                  104.0 GB
# echo "downloading LT repository"
# cd /workspace/ComfyUI && hf download LVMCS/49108215LT --local-dir . && rm -rf .cache/
# echo "finished downloading LT repository"

# # 49108215KL                  35.50 GB
# echo "downloading KL model"
# cd /workspace/ComfyUI && hf download LVMCS/49108215KL --local-dir . && rm -rf .cache/
# echo "finished downloading KL model"

# # 49108215WA                  89.00 GB
# echo "downloading WA model"
# cd /workspace/ComfyUI && hf download LVMCS/49108215WA --local-dir . && rm -rf .cache/
# echo "finished downloading WA model"

# # 49108215QW                  58.30 GB
# echo "downloading QW model"
# cd /workspace/ComfyUI && hf download LVMCS/49108215QW --local-dir . && rm -rf .cache/
# echo "finished downloading QW model"
# -------------------------------------

# -------------------------------------
# # LORA
# echo "downloading LT Lora models"
# mkdir -p /workspace/ComfyUI/models/loras/LVMCS/
# cd /workspace/ComfyUI/models/loras

# # # REPO                        SIZE_GB
# # # s1mps0ns                    1.71  GB
# hf download LVMCS/s1mps0ns --local-dir ./LVMCS/s1mps0ns 
# rm -rf LVMCS/s1mps0ns/.cache/

# # # futur4m4                    1.71  GB
# hf download LVMCS/futur4m4 --local-dir ./LVMCS/futur4m4 
# rm -rf LVMCS/futur4m4/.cache/

# # # hug3br3asts                 1.71  GB
# hf download LVMCS/hug3br3asts --local-dir ./LVMCS/hug3br3asts 
# rm -rf LVMCS/hug3br3asts/.cache/

# # # c3c3_1                      1.71  GB
# hf download LVMCS/c3c3_1 --local-dir ./LVMCS/c3c3_1 
# rm -rf LVMCS/c3c3_1/.cache/

# # # n4tal1a_2                   1.71  GB
# hf download LVMCS/n4tal1a_2 --local-dir ./LVMCS/n4tal1a_2 
# rm -rf LVMCS/n4tal1a_2/.cache/

# # # b3lla                       1.71  GB
# hf download LVMCS/b3lla --local-dir ./LVMCS/b3lla 
# rm -rf LVMCS/b3lla/.cache/

# # # 4siad0ll_3                  1.71  GB
# hf download LVMCS/4siad0ll_3 --local-dir ./LVMCS/4siad0ll_3 
# rm -rf LVMCS/4siad0ll_3/.cache/

# # # 4siad0ll_2                  1.71  GB
# hf download LVMCS/4siad0ll_2 --local-dir ./LVMCS/4siad0ll_2 
# rm -rf LVMCS/4siad0ll_2/.cache/

# # # 4lice_d3lish_3              2.22  GB
# hf download LVMCS/4lice_d3lish_3 --local-dir ./LVMCS/4lice_d3lish_3 
# rm -rf LVMCS/4lice_d3lish_3/.cache/

# # # 4lice_d3lish_2_distilled    2.22  GB
# hf download LVMCS/4lice_d3lish_2_distilled --local-dir ./LVMCS/4lice_d3lish_2_distilled 
# rm -rf LVMCS/4lice_d3lish_2_distilled/.cache/
# -------------------------------------

echo "finished downloading repositories"

echo "removing .cache folders to save space"
cd /workspace
rm -rf .cache/
rm -rf .cache/
rm -rf */.cache/
rm -rf */.cache/
rm -rf */*/.cache/
rm -rf */*/.cache/
rm -rf */*/*/.cache/
rm -rf */*/*/.cache/
rm -rf */*/*/*/.cache/
rm -rf */*/*/*/.cache/
rm -rf */*/*/*/*/.cache/
rm -rf */*/*/*/*/.cache/
rm -rf */*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/*/*/.cache/
rm -rf */*/*/*/*/*/*/*/*/.cache/
echo "finished removing .cache folders to save space"

echo "cleaning up pip cache to save space"
pip cache purge
echo "finished cleaning up pip cache"

echo "."
echo "."
echo "."
echo "FINISHED"
echo "."
echo "."
echo "."
