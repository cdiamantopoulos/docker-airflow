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

# local development
`docker build -t dairflow .`
`docker run -v ~/Dropbox:/mlb -d -p 8080:8080 $CID webserver`



docker exec -u 0 -it CONTAINER_ID /bin/bash
pip install flask_bcrypt
python3 /mlb/mlb/sim/scripts_python/prod/push_dags_to_production.py

# TEMP WORKAROUND BECAUSE I HATE EVERYTHING AND GOD IS REAL
docker run -v ~/Dropbox:/mlb -d -p 8080:8080 -it --entrypoint /bin/bash $cid
docker exec -it $cid /bin/bash
cd /
bash entrypoint.sh webserver&
