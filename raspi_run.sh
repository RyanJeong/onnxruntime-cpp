isudo apt-get update
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
mkdir /code
cd /code
wget https://cmake.org/files/v3.16/cmake-3.16.1.tar.gz;
tar zxf cmake-3.16.1.tar.gz

cd /code/cmake-3.16.1
./configure --system-curl
make
sudo make install

# Prepare onnxruntime Repo
cd /code
git clone --recursive https://github.com/Microsoft/onnxruntime

# Start the basic build
cd /code/onnxruntime
./build.sh --config Release --update --build
# ./build.sh --config MinSizeRel --update --build

# Build Shared Library
./build.sh --config Release --build_shared_lib
# ./build.sh --config MinSizeRel --build_shared_lib

# Build Python Bindings and Wheel
./build.sh --config Release --enable_pybind --build_wheel
# ./build.sh --config MinSizeRel --enable_pybind --build_wheel

# Build Output
ls -l /code/onnxruntime/build/Linux/MinSizeRel/*.so
ls -l /code/onnxruntime/build/Linux/MinSizeRel/dist/*.whl
