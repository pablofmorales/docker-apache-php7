# docker-apache-php7
To build the image you can run:

    docker build -t pablofmorales/apache-php7 .

If you're rebuilding an existing image you need to remove it first: 

    docker rmi -f <uuid>

and stop it if it's currently running:

    docker rm <uuid>

To get the `uuid` for the image:

    docker images

To get the `uuid` of a container:

    docker ps -a
