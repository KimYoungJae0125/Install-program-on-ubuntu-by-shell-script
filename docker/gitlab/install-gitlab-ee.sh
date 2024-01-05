GIT_LAB_VOLUME=/var/gitlab

## 깃 랩 데이터 저장 위치 폴더 생성
if [ ! -d $GIT_LAB_VOLUME ]; then
	sudo mkdir $GIT_LAB_VOLUME
	echo "create Git lab volume"
fi

for FOLDER in data logs config
do
	GIT_LAB_VOLUME_DETAIL=$GIT_LAB_VOLUME/$FOLDER
	echo "Check exist $GIT_LAB_VOLUME_DETAIL"

	if [ ! -d $GIT_LAB_VOLUME_DETAIL ]; then
		sudo mkdir $GIT_LAB_VOLUME_DETAIL
		echo "create Git lab volume $FOLDER"
	fi
done

GITLAB_IMAGE=$(sudo docker images | grep $GITLAB_IMAGE_NAME | awk '{ print $1 }')
echo "Gitlab image : $GITLAB_IMAGE"
if [ -z $GITLAB_IMAGE ];then
	echo "================================="
	echo "Pull gitlab image"
	echo "================================="
	sudo docker pull $GITLAB_IMAGE_NAME
fi

GITLAB_CONTAINER_ID=$(sudo docker ps -a | grep $GITLAB_CONTAINER_NAME | awk '{ print $1 }')
echo "Gitlab container ID : $GITLAB_CONTAINER_ID"

if [ -n $GITLAB_CONTAINER_ID ];then
	echo "========================"
	echo "Stop & Remove gitlab container"
	echo "========================"
	sudo docker stop $GITLAB_CONTAINER_ID
	sudo docker rm $GITLAB_CONTAINER_ID
fi

##-d [--detach] : 백그라운드에서 컨테이너 실행 후 컨테이너 ID 인쇄
##-h [--hostname] : 깃 랩에서 사용할 도메인
##-p [--publish] : 로컬 포트와 도커 포트 매핑 [ 80 : 깃랩 웹 서비스, 22 : 깃랩 SSH ]
##--name  도커 컨테이너 이름
##--restart always \ ## 컨테이너 종료 시 계속 다시 시작
##-v [--volume] \ ## 도커 데이터 저장 위치 마운트
##gitlab/gitlab-ee:latest : docker 실행 할 깃랩 이미지

sudo docker run -d \
	-h gitlab.example.com \
	-p 9080:80 -p 9022:22 \
	--name $GITLAB_CONTAINER_NAME \
	--restart always \
	-v $GIT_LAB_VOLUME/config:/etc/gitlab \
	-v $GIT_LAB_VOLUME/logs:/var/log/gitlab \
	-v $GIT_LAB_VOLUME/data:/var/opt/gitlab \
	$GITLAB_IMAGE_NAME
