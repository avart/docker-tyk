docker run -d --name redis dockerfile/redis
docker run -d --name mongo mongo
docker run -d -p 8080:8080 --link mongo:mongo --link redis:db docker-tyk
