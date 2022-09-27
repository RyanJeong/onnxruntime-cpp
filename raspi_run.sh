sudo apt-get update
sudo apt-get install -y \
    sudo \
    build-essential \
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    git \
    tar

pip3 install --upgrade pip
pip3 install --upgrade setuptools
pip3 install --upgrade wheel
pip3 install numpy

# Build the latest cmake
wget https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1.tar.gz
tar zxf cmake-3.21.1.tar.gz
cd cmake-3.21.1/
./configure --system-curl
# make -j2
make
sudo make install

# Prepare onnxruntime Repo
cd ~/
git clone --recursive https://github.com/Microsoft/onnxruntime

# Start the basic build
cd /code/onnxruntime
./build.sh \
  --skip_submodule_sync \
  --config Release \
  --update \
  --build \
  --parallel \
  --cmake_extra_defines \
  ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER)

# If you want to build onnxruntime shared library:
./build.sh \
  --skip_submodule_sync \
  --config Release \
  --update \
  --build_shared_lib \
  --parallel \
  --cmake_extra_defines \
  ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER)

# Dummy scripts for reference
#   /usr/local/bin/cmake --build /home/pi/onnxruntime/build/Linux/Release --config Release -- -j2
#   /usr/local/bin/cmake --build /home/pi/onnxruntime/build/Linux/Release --config Release -- -j1

# ./build.sh \
#   --skip_submodule_sync \
#   --config Release \
#   --build_wheel \
#   --update \
#   --build \
#   --parallel \
#   --cmake_extra_defines \
#   ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER)

# ./build.sh --config Release --update --build
# # ./build.sh --config MinSizeRel --update --build
# 
# # Build Shared Library
# ./build.sh --config Release --build_shared_lib
# # ./build.sh --config MinSizeRel --build_shared_lib
# 
# # Build Python Bindings and Wheel
# ./build.sh --config Release --enable_pybind --build_wheel
# # ./build.sh --config MinSizeRel --enable_pybind --build_wheel

# Build Output
ls -l /code/onnxruntime/build/Linux/Release/*.so
ls -l /code/onnxruntime/build/Linux/Release/dist/*.whl
# ls -l /code/onnxruntime/build/Linux/MinSizeRel/*.so
# ls -l /code/onnxruntime/build/Linux/MinSizeRel/dist/*.whl
