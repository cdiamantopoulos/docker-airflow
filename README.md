Start the chrome webserver.

`docker pull selenium/standalone-chrome`

`docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome`

Store ip address of container.

`ruby get_docker_container_ip.rb`

Build the dockerfile. 

`docker build -t $NAME .`

Start the container with dropbox mounted in the container

`docker run -v ~/Dropbox:/mlb -it $NAME /bin/bash`


docker pull selenium/standalone-chrome
docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome
ruby ~/Dropbox/mlb/sim/docker/airflow/get_docker_container_ip.rb 
docker pull thedimo/airflow-scrapes:latest
docker run -v ~/Dropbox:/mlb -d -p 8080:8080 thedimo/airflow-scrapes:latest webserver


# pushing to dockerhub

`docker build -t dairflow .`
`docker tag 9a9c thedimo/airflow-scrapes:latest`
`docker push thedimo/airflow-scrapes:latest`
