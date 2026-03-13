echo "BEGINNING TRAIN INSTALL SCRIPT"
cd /workspace/

echo "installing/updating basic tooling"
pip install -U pip setuptools wheel pip-tools build uv

echo "installing huggingface hub"
pip install -U huggingface-hub
 
echo "logging in to huggingface hub"
hf auth login --token "$HF_TOKEN"
export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"

# echo "removing bloat model files to save space"
# rm -rf /workspace/ComfyUI/models/checkpoints/*.safetensors

echo "."
echo "."
echo "."
echo "!!! BEGINNING INSTALL OF TRAINING !!!"
echo "."
echo "."
echo "."

echo "downloading LTX-2 checkpoint model from Hugging Face"
mkdir -p /workspace/ComfyUI/models/checkpoints/LTX23
cd /workspace/ComfyUI/models/checkpoints/LTX23
hf download Lightricks/LTX-2.3 ltx-2.3-22b-dev.safetensors --local-dir .
rm -rf .cache/
echo "finished downloading LTX-2 checkpoint model from Hugging Face"

echo "downloading LTX-2 text encoder from Hugging Face"
mkdir -p /workspace/ComfyUI/models/text_encoders/LTX23
cd /workspace/ComfyUI/models/text_encoders/LTX23
hf download DreamFast/gemma-3-12b-it-heretic-v2 --exclude="*/*gemma-*" --local-dir .
rm -rf .cache/
echo "finished downloading LTX-2 text encoder from Hugging Face"

echo "downloading LTX-2 text encoder config files from Hugging Face"
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/Lightricks/gemma-3-12b-it-qat-q4_0-unquantized/resolve/main/added_tokens.json
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/Lightricks/gemma-3-12b-it-qat-q4_0-unquantized/resolve/main/chat_template.json
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/Lightricks/gemma-3-12b-it-qat-q4_0-unquantized/resolve/main/preprocessor_config.json
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/Lightricks/gemma-3-12b-it-qat-q4_0-unquantized/resolve/main/processor_config.json
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/Lightricks/gemma-3-12b-it-qat-q4_0-unquantized/resolve/main/tokenizer.model
rm -rf tokenizer_config.json
wget --header="Authorization: $HF_TOKEN" https://huggingface.co/DreamFast/gemma-3-12b-it-heretic-v2/resolve/main/tokenizer_config.json
echo "finished downloading LTX-2 text encoder config files from Hugging Face"

echo "downloading training repo from GitHub"
cd /workspace/
git clone https://github.com/LVM-AS/train
cd /workspace/train/LTX-2
echo "finished downloading training repo from GitHub"

echo "installing base requirements for training"
uv sync
echo "finished installing base requirements for training"

#echo "installing torch and numpy for training"
#uv pip install torch==2.8 torchvision torchaudio numpy==1.26.4
#echo "finished installing torch and numpy for training"

#echo "installing flash-attention 2 with --no-build-isolation"
#uv pip install flash-attn --no-build-isolation
#echo "finished installing flash-attention 2"

#echo "installing sageattention with --no-build-isolation"
#uv pip install sageattention --no-build-isolation
#echo "finished installing sageattention"

#echo "reinstalling numpy to ensure compatibility"
#uv pip install numpy==1.26.4
#echo "finished reinstalling numpy"

#echo "uninstalling xformers if present"
#uv pip uninstall -y xformers
#echo "finished uninstalling xformers"

echo "cleaning up uv & pip cache to save space"
pip cache purge
uv cache prune
echo "finished cleaning up uv & pip cache"

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

cd /workspace/train/LTX-2/packages/ltx-trainer

echo "."
echo "."
echo "."
echo "FINISHED"
echo "."
echo "."
echo "."
