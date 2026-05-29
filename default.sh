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
echo "installing/updating basic tooling and huggingface hub"
pip install -U pip
pip install huggingface-hub #hf_transfer
pip install hf_xet
pip install -U huggingface-hub #hf_transfer
pip install -U hf_xet
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
git clone https://github.com/city96/ComfyUI-GGUF
git clone https://github.com/calcuis/gguf
git clone https://github.com/MoonGoblinDev/Civicomfy
git clone https://github.com/Azornes/Comfyui-Resolution-Master
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
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
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cloning functions and features custom nodes repositories"
git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation
git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
git clone https://github.com/yuvraj108c/ComfyUI-Video-Depth-Anything
git clone https://github.com/1038lab/ComfyUI-RMBG
git clone https://github.com/Fannovel16/comfyui_controlnet_aux
git clone https://github.com/1038lab/ComfyUI-QwenVL
git clone https://github.com/ai-shizuka/ComfyUI-tbox
git clone https://github.com/ClownsharkBatwing/RES4LYF
git clone https://github.com/pollockjj/ComfyUI-MultiGPU
git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess/
git clone https://github.com/kijai/ComfyUI-SCAIL-Pose
git clone https://github.com/akatz-ai/ComfyUI-DepthCrafter-Nodes
git clone https://github.com/kijai/ComfyUI-segment-anything-2
git clone https://github.com/mengqin/ComfyUI-UnetBnbModelLoader
git clone https://github.com/Nekodificador/ComfyUI-NKD-Klein-Tools
git clone https://github.com/supermansundies/comfyui-klein-edit-composite
git clone https://github.com/capitan01R/Comfyui-flux2klein-Lora-loader
git clone https://github.com/capitan01R/ComfyUI-Flux2Klein-Enhancer
git clone https://github.com/Bisnis3d/ComfyUI_KleinAngleSelector
git clone https://github.com/alisson-anjos/ComfyUI-BFSNodes
git clone https://github.com/Lightricks/ComfyUI-LTXVideo
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing custom nodes requirements"
echo "installing essential custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/gguf/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Civicomfy/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Comfyui-Resolution-Master/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite/requirements.txt
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
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
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "installing functions and features custom nodes requirements"
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Video-Depth-Anything/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-RMBG/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-QwenVL/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-tbox/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/RES4LYF/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-MultiGPU/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-WanAnimatePreprocess/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-SCAIL-Pose/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-DepthCrafter-Nodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-segment-anything-2/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-UnetBnbModelLoader/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-NKD-Klein-Tools/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/comfyui-klein-edit-composite/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/Comfyui-flux2klein-Lora-loader/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Flux2Klein-Enhancer/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_KleinAngleSelector/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-BFSNodes/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo/requirements.txt
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
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||||| STARTING DOWNLOADS ||||||||||||||||"
echo "||||||||||||||||| STARTING DOWNLOADS ||||||||||||||||"
echo "||||||||||||||||| STARTING DOWNLOADS ||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
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
cd /workspace/ComfyUI
hf download LVMCS/49108215MI --local-dir .
rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cleaning up pip cache to save space"
pip cache purge
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


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


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "||||||||||||||| INSTALLATION COMPLETE |||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"