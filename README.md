docker run -d --name redis dockerfile/redis
docker run -d --name mongo mongo
docker run -d -p 3000:3000 -p5000:5000 -p 8080:8080 --link mongo:mongo --link redis:db eskobaba/docker-tyk
