POSTGRE_SQL_VOLUME=/var/postgreSQL/data

## 포스트그리 데이터 저장 위치 폴더 생성
if [ ! -d $POSTGRE_SQL_VOLUME ]; then
	sudo mkdir -p $POSTGRE_SQL_VOLUME
	echo "create PostgreSQL volume"
fi

POSTGRE_SQL_IMAGE_NAME=postgres
POSTGRE_SQL_TAG=16.1
POSTGRE_SQL_IMAGE=$(sudo docker images | grep $POSTGRE_SQL_IMAGE_NAME | awk '{ print $1 }')
echo "PostgresQL image : $POSTGRE_SQL_IMAGE"
if [ -z $POSTGRE_SQL_IMAGE ];then
	echo "================================="
	echo "Pull postgresql image"
	echo "================================="
	sudo docker pull $POSTGRE_SQL_IMAGE_NAME:$POSTGRE_SQL_TAG
fi

POSTGRE_SQL_CONTAINER_NAME=postgreSQL-docker
POSTGRE_SQL_CONTAINER_ID=$(sudo docker ps -a | grep $POSTGRE_SQL_CONTAINER_NAME | awk '{ print $1 }')
echo "PostgreSQL container ID : $POSTGRE_SQL_CONTAINER_ID"

if [ -n $POSTGRE_SQL_CONTAINER_ID ];then
	echo "========================"
	echo "Stop & Remove postgreSQL container"
	echo "========================"
	sudo docker stop $POSTGRE_SQL_CONTAINER_ID
	sudo docker rm $POSTGRE_SQL_CONTAINER_ID
fi

##-d [--detach] : 백그라운드에서 컨테이너 실행 후 컨테이너 ID 인쇄
##-h [--hostname] : 깃 랩에서 사용할 도메인
##-p [--publish] : 로컬 포트와 도커 포트 매핑 [ 80 : 깃랩 웹 서비스, 22 : 깃랩 SSH ]
##--name  도커 컨테이너 이름
##--restart always \ ## 컨테이너 종료 시 계속 다시 시작
##-v [--volume] \ ## 도커 데이터 저장 위치 마운트
##gitlab/gitlab-ee:latest : docker 실행 할 깃랩 이미지

sudo docker run -d \
	-p 54321:5432 \
	--name $POSTGRE_SQL_CONTAINER_NAME \
	--restart always \
	-e POSTGRES_PASSWORD=root \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v $POSTGRE_SQL_VOLUME:/var/lib/postgresql/data \
	$POSTGRE_SQL_IMAGE_NAME:$POSTGRE_SQL_TAG
