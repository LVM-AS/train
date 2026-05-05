echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| UPLOADING 49108215LT ||||||||||||||||"
echo "||||||||||||||| UPLOADING 49108215LT ||||||||||||||||"
echo "||||||||||||||| UPLOADING 49108215LT ||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "creating folders for uploading models to huggingface"
mkdir -p /workspace/upload
mkdir -p /workspace/upload/models/checkpoints
mkdir -p /workspace/upload/models/diffusion_models
mkdir -p /workspace/upload/models/latent_upscale_models
mkdir -p /workspace/upload/models/loras
mkdir -p /workspace/upload/models/text_encoders
mkdir -p /workspace/upload/models/vae
mkdir -p /workspace/upload/models/vae_approx
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "moving downloaded models to upload directory"
mv /workspace/ComfyUI/models/checkpoints/LTX23/ /workspace/upload/models/checkpoints/
mv /workspace/ComfyUI/models/diffusion_models/LTX23/ /workspace/upload/models/diffusion_models/
mv /workspace/ComfyUI/models/latent_upscale_models/LTX23/ /workspace/upload/models/latent_upscale_models/
mv /workspace/ComfyUI/models/loras/LTX23/ /workspace/upload/models/loras/
mv /workspace/ComfyUI/models/loras/LVMCS/ /workspace/upload/models/loras/
mv /workspace/ComfyUI/models/text_encoders/LTX23/ /workspace/upload/models/text_encoders/
mv /workspace/ComfyUI/models/vae/LTX23/ /workspace/upload/models/vae/
mv /workspace/ComfyUI/models/vae_approx/LTX23/ /workspace/upload/models/vae_approx/
mv /workspace/ComfyUI/models/vae_approx/LTX/ /workspace/upload/models/vae_approx/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "changing directory to upload directory"
cd /workspace/upload
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing .cache folders to avoid uploading them to huggingface"
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
echo "uploading LVMCS/49108215LT to huggingface"
hf upload-large-folder LVMCS/49108215LT --repo-type=model . --num-workers=16
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "removing .cache folder from upload process"
rm -rf .cache/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "moving uploaded models back to ComfyUI directory"
mv /workspace/upload/models/checkpoints/LTX23/ /workspace/ComfyUI/models/checkpoints/
mv /workspace/upload/models/diffusion_models/LTX23/ /workspace/ComfyUI/models/diffusion_models/
mv /workspace/upload/models/latent_upscale_models/LTX23/ /workspace/ComfyUI/models/latent_upscale_models/
mv /workspace/upload/models/loras/LTX23/ /workspace/ComfyUI/models/loras/
mv /workspace/upload/models/loras/LVMCS/ /workspace/ComfyUI/models/loras/
mv /workspace/upload/models/text_encoders/LTX23/ /workspace/ComfyUI/models/text_encoders/
mv /workspace/upload/models/vae/LTX23/ /workspace/ComfyUI/models/vae/
mv /workspace/upload/models/vae_approx/LTX23/ /workspace/ComfyUI/models/vae_approx/
mv /workspace/upload/models/vae_approx/LTX/ /workspace/ComfyUI/models/vae_approx/
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "- - - - - - - - - - - ||||||||| - - - - - - - - - - -"
echo "cleaning up upload directory"
cd /workspace
rm -rf /workspace/upload
echo "- - - - - - - - - - --  DONE -- - - - - - - - - - - -"


echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "||||||||||||||| UPLOADING COMPLETION ||||||||||||||||"
echo "||||||||||||||| UPLOADING COMPLETION ||||||||||||||||"
echo "||||||||||||||| UPLOADING COMPLETION ||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"