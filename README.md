# MMPose Installation Guide 

A comprehensive guide to install MMPose with CUDA 11.8 and PyTorch 2.1 in a clean virtual environment. This guide helps you avoid common dependency conflicts and version compatibility issues.
> **Important Note:**  
Every time you start your PC, the system may use the default (possibly updated) CUDA version. To ensure compatibility with your MMPose setup, always activate your virtual environment (`my_env`) before running any MMPose commands.  
If you encounter issues after a system update, reactivate `my_env` and re-run `./install_mmpose.sh` to restore the correct dependencies.
> in ros2 workspace , when building , deactivate the virtual environment 
##  Prerequisites

- Ubuntu/Linux system with NVIDIA GPU
- CUDA 11.8 compatible GPU
- Python 3.9
- Conda (recommended) or UV package manager
- Git

### Install Prerequisites

**Option 1: Install Conda (Recommended)**
```bash
# Download and install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
```

**Option 2: Install UV (Alternative)**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env
```

## Step-by-Step Installation

### Step 1: Create Virtual Environment

```bash
# Create conda environment with Python 3.9
conda create -n my_env python=3.9
conda activate my_env

# Install CUDA 11.8 toolkit and cuDNN (IMPORTANT for CUDA support)
conda install cudatoolkit=11.8 cudnn=8.2 -c conda-forge
```



### Step 2: Download and Modify Installation Script

Create a file named `install_mmpose.sh` and modify it based on your environment:




### Step 3: Make Script Executable and Run

```bash
# Make the script executable
chmod +x install_mmpose.sh

# Run the installation
./install_mmpose.sh
```

### Step 4: Clone MMPose Repository (for demos and configs)

```bash
# Clone the official MMPose repository
git clone https://github.com/open-mmlab/mmpose.git
cd mmpose

# Install MMPose in development mode (optional)
pip install -r requirements.txt
pip install -v -e .
```


##  Verification & Testing

### Step 1: Verify Installation

```bash
# Check all components are installed correctly
python -c "
import mmpose; print(f'✅ MMPose version: {mmpose.__version__}')
import mmcv; print(f'✅ MMCV version: {mmcv.__version__}')
import mmdet; print(f'✅ MMDet version: {mmdet.__version__}')
import torch; print(f'✅ PyTorch version: {torch.__version__}')
print(f'✅ CUDA available: {torch.cuda.is_available()}')
print(f'✅ CUDA version: {torch.version.cuda}')
"
```

Expected output:
```
✅ MMPose version: 1.3.2
✅ MMCV version: 2.1.0
✅ MMDet version: 3.2.0
✅ PyTorch version: 2.1.0+cu118
✅ CUDA available: True
✅ CUDA version: 11.8
```

### Step 2: Test with Demo Image

```bash
# Test pose estimation on a sample image
python demo/image_demo.py \
    tests/data/coco/000000000785.jpg \
    td-hm_hrnet-w48_8xb32-210e_coco-256x192.py \
    td-hm_hrnet-w48_8xb32-210e_coco-256x192-0e67c616_20220913.pth \
    --out-file vis_results.jpg \
    --draw-heatmap
```

If successful, you should see:
```
Loads checkpoint by local backend from path: td-hm_hrnet-w48_8xb32-210e_coco-256x192-0e67c616_20220913.pth
08/27 11:50:13 - mmengine - INFO - the output image has been saved at vis_results.jpg
```

### Step 3: Test with Different Images

```bash
# Test with another COCO image
python demo/image_demo.py \
    tests/data/coco/000000196141.jpg \
    td-hm_hrnet-w48_8xb32-210e_coco-256x192.py \
    td-hm_hrnet-w48_8xb32-210e_coco-256x192-0e67c616_20220913.pth \
    --out-file vis_results_2.jpg \
    --draw-heatmap
```
## 🤖 Integrate & Build MMPose in a ROS 2 Workspace

You can use MMPose inside a ROS 2 workspace with a dedicated virtual environment to avoid dependency conflicts.

### Step 4: Set Up MMPose in ROS 2 Workspace

1. **Create a Colcon Workspace**
    ```bash
    mkdir -p ~/ros2_ws/src
    cd ~/ros2_ws
    ```

2. **Activate Your Virtual Environment**
    ```bash
    source mmpose_rosvenv/bin/activate
    # Prevent Colcon from building the venv
    touch mmpose_rosvenv/COLCON_IGNORE
    ```

3. **Install MMPose Dependencies**
    - Run your `install_mmpose.sh` script inside the activated environment:
    ```bash
    ./install_mmpose.sh
    ```

4. **Set Up ROS 2 Environment**
    ```bash
    # Source ROS 2 first, then your virtual environment
    source /opt/ros/humble/setup.bash
    source mmpose_rosvenv/bin/activate
    ```

5. **Build Your Workspace**
    ```bash
    colcon build --symlink-install
    source install/local_setup.bash
    ```


##  Common Issues & Solutions

### Issue 1: NumPy Version Conflicts
```
ValueError: numpy.dtype size changed, may indicate binary incompatibility
```

**Solution:**
```bash
pip install "numpy<2.0"
pip install "opencv-python-headless<4.10" --force-reinstall
```

### Issue 2: MMCV Version Mismatch
```
AssertionError: MMCV==1.7.2 is used but incompatible. Please install mmcv>=2.0.0rc4
```

**Solution:**
```bash
pip uninstall mmcv mmcv-full -y
pip install mmcv==2.1.0 -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.1/index.html
```

### Issue 3: Config File Not Found
```
FileNotFoundError: [Errno 2] No such file or directory: 'td-hm_hrnet-w48_8xb32-210e_coco-256x192.py'
```

**Solution:**
Make sure you're in the mmpose directory and the config file exists:
```bash
ls configs/body_2d_keypoint/topdown_heatmap/coco/ | grep hrnet
```

### Issue 4: Old API Functions Not Found
```
ImportError: cannot import name 'inference_top_down_pose_model'
```

**Solution:**
Use the modern `image_demo.py` instead of `top_down_img_demo.py`:
```bash
python demo/image_demo.py [args...]  # ✅ Correct
# instead of
python demo/top_down_img_demo.py [args...]  # ❌ Old API
```
### Issue 5: NumPy Version Conflicts
```
ValueError: numpy.dtype size changed, may indicate binary incompatibility
```

**Solution:**
```bash
pip install "numpy<2.0"
pip install "opencv-python-headless<4.10" --force-reinstall
```

### Issue 6: OpenCV Pulls NumPy 2.x Back In
```
When installing OpenCV, it may automatically reinstall NumPy 2.x as a dependency, breaking compatibility.
```
Successfully installed numpy-2.0.2 opencv-python-headless-4.9.0.80
**Solution: Install Both Together:**
```bash
pip install "numpy<2.0" "opencv-python-headless<4.10" --force-reinstall --no-deps
pip install "opencv-python-headless<4.10"  # Reinstall to get other dependencies
```

### Issue 6: Webcam Issue
```
with open(filepath, encoding=encoding) as f: FileNotFoundError: [Errno 2] No such file or directory:```
Successfully installed numpy-2.0.2 opencv-python-headless-4.9.0.80
**Solution: Install Both Together:**
```bash
cd ~/mmpose
export PYTHONPATH=$(pwd):$PYTHONPATH

```
## 🎥 Webcam Demonstration

Test pose estimation live using your webcam:

**Hand Pose:**
```bash
python demo/inferencer_demo.py webcam --pose2d 'hand' --show
```

**Human Body Pose:**
```bash
python demo/inferencer_demo.py webcam --pose2d 'human'
```

**Whole Body Pose:**
```bash
python demo/inferencer_demo.py webcam --pose2d 'wholebody' --show
```
##  Key Version Compatibility

| Component | Version | Notes |
|-----------|---------|-------|
| Python | 3.9 | Tested and stable |
| PyTorch | 2.1.0+cu118 | CUDA 11.8 support |
| MMCV | 2.1.0 | Compatible with PyTorch 2.1 |
| MMPose | 1.3.2 | Latest stable |
| MMDetection | 3.2.0 | For detection demos |
| NumPy | <2.0 | Avoid 2.x conflicts |
| OpenCV | <4.10 | Avoid NumPy 2.x deps |

##  Environment Management

### Activate Environment (Future Sessions)
```bash
# For UV environments
source mmpose_env/bin/activate

# For Conda environments  
conda activate mmpose_env
```

### Deactivate Environment
```bash
# For UV environments
deactivate

# For Conda environments
conda deactivate
```

### Remove Environment (if needed)
```bash
# For UV environments
rm -rf mmpose_env

# For Conda environments
conda env remove -n mmpose_env
```

##  Additional Resources

- [MMPose Official Documentation](https://mmpose.readthedocs.io/)
- [OpenMMLab GitHub](https://github.com/open-mmlab/mmpose)
- [Model Zoo](https://mmpose.readthedocs.io/en/latest/model_zoo.html)
- [Config Files Guide](https://mmpose.readthedocs.io/en/latest/tutorials/0_config.html)

## 🎉 Success Checklist

- [ ] Virtual environment created and activated
- [ ] PyTorch 2.1.0+cu118 installed
- [ ] MMCV 2.1.0 installed
- [ ] MMPose 1.3.2 installed
- [ ] CUDA available: True
- [ ] Demo runs successfully
- [ ] Output image generated

---

** Congratulations!** Your MMPose environment is now ready for pose estimation tasks!

> **Tip:** Always use the same virtual environment for consistency and bookmark this guide for future reference.
