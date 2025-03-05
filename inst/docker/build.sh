# rebuild docker images with local branch
docker build -t mr148/bioc-redis:RELEASE_3_20 -f Dockerfile.worker.RELEASE_3_20 .
docker build -t mr148/bioc-redis:manager -f Dockerfile.localmanager .

docker push mr148/bioc-redis:RELEASE_3_20
docker push mr148/bioc-redis:manager
