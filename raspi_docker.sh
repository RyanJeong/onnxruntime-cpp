curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
git clone git@github.com:microsoft/onnxruntime.git
cd onnxruntime
git submodule sync
git submodule update --init --recursive
cd dockerfiles
docker build -t onnxruntime-source -f Dockerfile.arm64 ..
docker run -it onnxruntime-source
