git submodule update --init
mkdir docker
cd docker
docker build -t onnxruntime-source -f Dockerfile.arm64 ..
docker run -it onnxruntime-source
