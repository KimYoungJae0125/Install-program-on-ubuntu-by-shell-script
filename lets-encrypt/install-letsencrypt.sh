## SSL 인증서 적용할 도메인 입력
DOMAIN=''

## Let's Encrpyt 설치
sudo apt update
sudo apt install letsencrypt -y 
sudo apt install certbot -y

## certbot 설치
sudo certbot certonly --manual -d "*.$DOMAIN" -d $DOMAIN  --preferred-challenges dns
