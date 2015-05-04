build:
	docker create -v /data/db --name dbdata philcryer/min-wheezy
	docker build --tag docker-tyk/tyk .
run:
	docker run -d -p 3000:3000 -p 5000:5000 --volumes-from dbdata -e ORGANIZATION=org \
        -e FIRST_NAME=foo -e SURNAME=bar -e EMAIL=arsel@bar.com -e DASHPASS=bazbaz \
        --name tyk docker-tyk/tyk
