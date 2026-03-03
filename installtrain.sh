echo "BEGINNING TRAIN INSTALL SCRIPT"
cd /workspace/

echo "installing/updating basic tooling"
pip install -U pip setuptools wheel pip-tools build uv

echo "installing huggingface hub"
pip install -U huggingface-hub
 
echo "logging in to huggingface hub"
hf auth login --token "$HF_TOKEN"
export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"

echo "removing bloat model files to save space"
rm -rf /workspace/ComfyUI/models/checkpoints/*.safetensors

echo "."
echo "."
echo "."
echo "!!! BEGINNING INSTALL OF TRAINING !!!"
echo "."
echo "."
echo "."

# echo "downloading LTX-2 checkpoint model from Hugging Face"
# cd /workspace/train/models/checkpoint
# hf download Lightricks/LTX-2 ltx-2-19b-distilled.safetensors --local-dir .
# rm -rf .cache/
# echo "finished downloading LTX-2 checkpoint model from Hugging Face"

# echo "downloading LTX-2 text encoder from Hugging Face"
# cd /workspace/train/models/text_encoder
# hf download p-e-w/gemma-3-12b-it-heretic --local-dir .
# rm -rf .cache/
# echo "finished downloading LTX-2 text encoder from Hugging Face"

echo "downloading training repo from GitHub"
cd /workspace/
git clone https://github.com/fqwqwf/train
cd /workspace/train/LTX-2

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
uv cache prune
pip cache purge
echo "finished cleaning up uv & pip cache"

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
