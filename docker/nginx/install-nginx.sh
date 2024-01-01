# pull image
NGINX_IMAGE=$(sudo docker images | grep nginx | awk '{ print $1 }')
echo 'Nginx image :' $NGINX_IMAGE
if [ -n $NGINX_IMAGE ];then
	echo "========================================="
	echo 'Exists nginx image'
	echo "========================================="
else
	echo "========================================="
	echo 'Pull nginx image'
	echo "========================================="
	sudo docker pull nginx
fi

# run nginx
NGINX_CONTAINER_ID=$(sudo docker ps -a | grep nginx | awk '{ print $1 }')
echo 'Nginx container id :' $NGINX_CONTAINER_ID
if [ -n $NGINX_CONTAINER_ID ];then
	echo "========================================="
	echo 'Stop nginx container'
	echo "========================================="
	sudo docker stop $NGINX_CONTAINER_ID
	sudo docker rm $NGINX_CONTAINER_ID
fi
sudo docker run -it \
		--name nginx-docker \
		-d \
		-p 80:80 \
		nginx

