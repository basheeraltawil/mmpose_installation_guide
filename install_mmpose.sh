#!/bin/bash

# MMPose Installation Script with UV Virtual Environment
# This script sets up a clean environment for mmpose with CUDA 11.8 and PyTorch 2.1

set -e  # Exit on any error

echo "🚀 Setting up MMPose environment with UV..."

# Step 1: Create UV virtual environment
# echo "📦 Creating UV virtual environment..."
# uv venv ode1 --python 3.9
# source ode1/bin/activate

echo "✅ Virtual environment activated"

# Step 2: Clean up any existing installations
echo "🧹 Cleaning up existing installations..."
uv pip uninstall mmcv mmcv-full torch torchvision torchaudio 

# Step 3: Upgrade pip and install core dependencies
echo "🔧 Installing core dependencies..."
uv pip install --upgrade pip setuptools wheel

# Step 4: Install PyTorch 2.1 with CUDA 11.8 (CRITICAL STEP)
echo "🔥 Installing PyTorch 2.1 with CUDA 11.8 support..."
uv pip install torch==2.1.0+cu118 torchvision==0.16.0+cu118 torchaudio==2.1.0+cu118 --index-url https://download.pytorch.org/whl/cu118

# Step 5: Install MMCV compatible with PyTorch 2.1 + CUDA 11.8
echo "📚 Installing MMCV..."
uv pip install mmcv==2.1.0 -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.1/index.html --trusted-host download.openmmlab.com

# Step 6: Install MMDetection
echo "🔍 Installing MMDetection..."
uv pip install mmdet==3.2.0

# Step 7: Install build dependencies and problematic packages first
echo "🔧 Installing build dependencies..."
uv pip install cython numpy

# Install chumpy separately (common mmpose dependency issue)
echo "📐 Installing chumpy..."
uv pip install chumpy==0.70 --no-build-isolation

# Step 8: Install MMPose
echo "🤸 Installing MMPose..."
uv pip install mmpose==1.3.2

# Step 9: Install additional dependencies
echo "📊 Installing additional dependencies..."
uv pip install pandas
uv pip install pyrealsense2

# Step 10: Install L2CS-Net from GitHub
echo "👁️ Installing L2CS-Net..."
uv pip install git+https://github.com/edavalosanaya/L2CS-Net.git@main

# Step 11: Install SixDRepNet
echo "🎯 Installing SixDRepNet..."
uv pip install sixdrepnet

# Step 12: Create model cache directory
echo "📁 Creating model cache directories..."
mkdir -p ~/.cache/torch/hub/checkpoints/

# Step 13: Download RTMPose models
echo "⬇️ Downloading RTMPose models..."

# RTMPose wholebody model
wget --no-check-certificate \
  https://download.openmmlab.com/mmpose/v1/projects/rtmposev1/rtmpose-m_simcc-coco-wholebody_pt-aic-coco_270e-256x192-cd5e845c_20230123.pth \
  -P /home/basheer/mmpose/checkpoints/

# RTMDet person detection model  
wget --no-check-certificate \
  https://download.openmmlab.com/mmpose/v1/projects/rtmposev1/rtmdet_m_8xb32-100e_coco-obj365-person-235e8209.pth \
  -P /home/basheer/mmpose/checkpoints/

echo "✅ All models downloaded successfully!"

# Step 14: Verify installation
echo "🔍 Verifying installation..."
python -c "import mmpose; print(f'MMPose version: {mmpose.__version__}')"
python -c "import mmcv; print(f'MMCV version: {mmcv.__version__}')"
python -c "import mmdet; print(f'MMDet version: {mmdet.__version__}')"
python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
python -c "import torch; print(f'CUDA version: {torch.version.cuda}')"

echo "🎉 Installation completed successfully!"
echo "💡 To activate the environment in future sessions, run:"
echo "   source ode/bin/activate"
echo ""
echo "📝 Your environment is now ready. You can run:"
