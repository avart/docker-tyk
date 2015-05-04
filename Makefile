build:
	docker build --tag docker-tyk/tyk .
run:
	docker run -d -p 3000:3000 -p 5000:5000 --volumes-from dbdata -e ORGANIZATION=<org> \
        -e FIRST_NAME=<first name> -e SURNAME=<surname> -e EMAIL=<email> -e DASHPASS=<your password> \
        --name tyk docker-tyk/tyk
