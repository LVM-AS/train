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
            pip3 install --no-cache-dir ${PIP_PACKAGES[@]}
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
                   pip3 install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip3 install --no-cache-dir -r "${requirements}"
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


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||||| STARTING INSTALL ||||||||||||||||||"
echo "||||||||||||||||| STARTING INSTALL ||||||||||||||||||"
echo "||||||||||||||||| STARTING INSTALL ||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "backing up current requirements to bak-requirements.txt"
cd /workspace
pip freeze > bak-requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing/updating basic tooling, hf_transfer and huggingface hub"
pip install -U pip
pip install -U huggingface-hub hf_transfer
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "logging in to huggingface hub"
hf auth login --token "$HF_TOKEN"
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "updating ComfyUI"
cd /workspace/ComfyUI
git pull
git config --global --add safe.directory /workspace/ComfyUI
git checkout master
git pull
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing base requirements"
pip3 install -r /workspace/ComfyUI/requirements.txt
pip3 install -r /workspace/ComfyUI/manager_requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing bloat model files to save space"
rm -rf /workspace/ComfyUI/models/checkpoints/*.safetensors
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||||||| CUSTOM NODES ||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing old custom node repositories"
cd /workspace/ComfyUI/custom_nodes
rm -rf ComfyUI-Manager/
rm -rf Civicomfy/
rm -rf ComfyUI-KJNodes/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cloning essential custom nodes repositories"
git clone https://github.com/Comfy-Org/ComfyUI-Manager
git clone https://github.com/kijai/ComfyUI-KJNodes
# git clone https://github.com/city96/ComfyUI-GGUF
# git clone https://github.com/calcuis/gguf
git clone https://github.com/MoonGoblinDev/Civicomfy
# git clone https://github.com/Azornes/Comfyui-Resolution-Master
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cloning general packs and misc custom nodes repositories"
# git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack
# git clone https://github.com/ltdrdata/ComfyUI-Inspire-Pack
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
# git clone https://github.com/yolain/ComfyUI-Easy-Use
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "cloning functions and features custom nodes repositories"
# git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation
# git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
# git clone https://github.com/yuvraj108c/ComfyUI-Video-Depth-Anything
git clone https://github.com/1038lab/ComfyUI-RMBG
# git clone https://github.com/Fannovel16/comfyui_controlnet_aux
git clone https://github.com/1038lab/ComfyUI-QwenVL
# git clone https://github.com/ai-shizuka/ComfyUI-tbox
# git clone https://github.com/ClownsharkBatwing/RES4LYF
# git clone https://github.com/pollockjj/ComfyUI-MultiGPU
# git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess/
# git clone https://github.com/kijai/ComfyUI-SCAIL-Pose
# git clone https://github.com/akatz-ai/ComfyUI-DepthCrafter-Nodes
# git clone https://github.com/kijai/ComfyUI-segment-anything-2
# git clone https://github.com/mengqin/ComfyUI-UnetBnbModelLoader
git clone https://github.com/Lightricks/ComfyUI-LTXVideo
# git clone https://github.com/alisson-anjos/ComfyUI-BFSNodes
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing custom nodes requirements"
echo "installing essential custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/gguf/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Civicomfy/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/Comfyui-Resolution-Master/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite/requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing general packs and misc custom nodes requirements"
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Impact-Pack/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Inspire-Pack/requirements.txt
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
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing functions and features custom nodes requirements"
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Video-Depth-Anything/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-RMBG/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-QwenVL/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-tbox/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/RES4LYF/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-MultiGPU/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanAnimatePreprocess/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-SCAIL-Pose/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-DepthCrafter-Nodes/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-segment-anything-2/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-UnetBnbModelLoader/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo/requirements.txt
# pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-BFSNodes/requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing xformers to avoid conflicts"
pip uninstall -y xformers
pip3 uninstall -y xformers
pip uninstall -y xformers
pip3 uninstall -y xformers
cd /workspace
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "installing sageattention"
# pip install sageattention --no-build-isolation
# pip install sageattention==1.0.6
# echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing base requirements again to ensure all dependencies are met"
pip install -r /workspace/ComfyUI/requirements.txt #numpy==1.26.4 torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
pip install -r /workspace/ComfyUI/manager_requirements.txt #numpy==1.26.4 torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "reinstalling numpy to ensure compatibility"
pip install numpy==1.26.4
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cleaning up pip cache to save space"
pip cache purge
pip3 cache purge
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||||| STARTING DOWNLOADS ||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing files and folders to be replaced by huggingface repo"
rm -rf /workspace/ComfyUI/user/default/comfy.settings.json
rm -rf /workspace/ComfyUI/comfy_extras/nodes_qwen.py
rm -rf /workspace/ComfyUI/custom_nodes/ComfyUI-QwenVL/hf_models.json
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "navigating to ComfyUI directory for repo downloads"
cd /workspace/ComfyUI
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "logging in to huggingface hub again just in case"
hf auth login --token "$HF_TOKEN"
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "- - - - - - |||| 49108215MI 0.013 GB |||| - - - - - -"
echo "downloading MI files"
cd /workspace/ComfyUI && hf download LVMCS/49108215MI --local-dir . && rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "- - - - - - |||| 49108215MM 4.66 GB |||| - - - - - -"
cd /workspace/ComfyUI && hf download LVMCS/49108215MM --local-dir . && rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "- - - - - - |||| 49108215LT 108.0 GB |||| - - - - - -"
# echo "49108215LT                  108.0 GB"
# echo "downloading LT repository"
# cd /workspace/ComfyUI && hf download LVMCS/49108215LT --local-dir . && rm -rf .cache/
# echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cleaning up pip cache to save space"
pip cache purge
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "moving back to ComfyUI directory to finish up"
cd /workspace/ComfyUI
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| LTX TRAIN PROCEDURES ||||||||||||||||"
echo "||||||||||||||| LTX TRAIN PROCEDURES ||||||||||||||||"
echo "||||||||||||||| LTX TRAIN PROCEDURES ||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "moving to ComfyUI directory and logging in to huggingface hub"
cd /workspace/ComfyUI
hf auth login --token "$HF_TOKEN"
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "creating LTX 2.3 checkpoint model folder and changing to it"
mkdir -p /workspace/ComfyUI/models/checkpoints/LTX23
cd /workspace/ComfyUI/models/checkpoints/LTX23
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "downloading LTX 2.3 Dev BF16 checkpoint model from Hugging Face"
hf download Lightricks/LTX-2.3 ltx-2.3-22b-dev.safetensors --local-dir .
rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "downloading LTX 2.3 Dev FP8 checkpoint model from Hugging Face"
# hf download Lightricks/LTX-2.3-fp8 ltx-2.3-22b-dev-fp8.safetensors --local-dir .
# rm -rf .cache/
# echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "downloading Gemma text encoder"
mkdir -p /workspace/ComfyUI/models/text_encoders/LTX23
cd /workspace/ComfyUI/models/text_encoders/LTX23
hf download Lightricks/gemma-3-12b-it-qat-q4_0-unquantized --local-dir .
rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "downloading training repo from GitHub"
cd /workspace/
git clone https://github.com/LVM-AS/train
cd /workspace/train/LTX-2
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "running uv sync to install ltx-core, ltx-pipelines, and ltx-trainer"
# uv sync


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing ltx-core requirements"
cd /workspace/train/LTX-2/packages/ltx-core
pip3 install .
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing ltx-pipelines requirements"
cd /workspace/train/LTX-2/packages/ltx-pipelines
pip3 install .
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing ltx-trainer requirements"
cd /workspace/train/LTX-2/packages/ltx-trainer
pip3 install .
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


# echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
# echo "installing transformers 4.57.6 and numpy 1.26.4 for training compatibility"
# pip3 install -U transformers==4.57.6
# pip3 install numpy==1.26.4
# echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
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
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cleaning up pip cache to save space"
pip3 cache purge
pip cache purge
pip3 cache purge
pip cache purge
uv cache prune
uv cache clean
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"