## A self-contained image for the Tyk API gateway.
First create a persistent volume container:

     docker create -v /data/db --name dbdata philcryer/min-wheezy

Then create the container, using env variables to set your username for the dashboard
if this is your first run.

     docker build --tag docker-tyk/tyk .
     docker run -d -p 3000:3000 -p 5000:5000 --volumes-from dbdata -e ORGANIZATION=<org> \
     -e FIRST_NAME=<first name> -e SURNAME=<surname> -e EMAIL=<email> -e DASHPASS=<your password> \
     --name tyk docker-tyk/tyk
