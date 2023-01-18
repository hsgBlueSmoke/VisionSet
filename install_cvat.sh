export USERNAME=ubuntu
export CVAT_VERSION=release-2.3.0
export NUCLIO_VERION=1.8.14

# Install 
#mkdir /home/${USERNAME}/vision/cvat
## cvat
#git clone --branch ${CVAT_VERSION} https://github.com/opencv/cvat /home/${USERNAME}/vision/cvat
cd /home/${USERNAME}/vision/cvat
## nuclio
wget https://github.com/nuclio/nuclio/releases/download/${NUCLIO_VERION}/nuctl-${NUCLIO_VERION}-linux-amd64
sudo chmod +x nuctl-${NUCLIO_VERION}-linux-amd64
sudo ln -sf $(pwd)/nuctl-${NUCLIO_VERION}-linux-amd64 /usr/local/bin/nuctl

export CVAT_HOST=$DOCKER_HOST_IP

docker-compose -f docker-compose.yml -f components/serverless/docker-compose.serverless.yml up -d
docker exec -it cvat_server bash -ic 'python3 ~/manage.py createsuperuser'

nuctl create project cvat

nuctl deploy --project-name cvat \
  --path serverless/onnx/WongKinYiu/yolov7/nuclio \
  --volume `pwd`/serverless/common:/opt/nuclio/common \
  --platform local
