# Yet another self-hosted Ghost blog with Docker, Nginx, and Let's Encrypt

This is a simple Ghost blog setup wrapped up in Docker containers for easy development and deployment. Here, the default SQLite database is used even in production as it seems to be a good fit for blogging needs. The content backup is carried out periodically by cron. This project is heavily inspired by this [blog post](https://www.metamost.com/ghost-docker-setup/) and is being feasible thanks to these awesome projects: [nginx-proxy](https://github.com/jwilder/nginx-proxy), [docker-gen](https://github.com/jwilder/docker-gen), and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). The project will allow you to serve a Ghost blog over either HTTP or HTTPS. In the latter case, free SSL/TLS certificates will be fetched and renewed from the [Let's Encrypt](https://letsencrypt.org/) certificate authority automatically. Also, these settings allow for hosting multiple website on a single server.

## Requirements

* A Debian-based GNU/Linux distribution. This setup was tested successfully with Ubuntu 16.04 and 18.04 LTS.

* A fully registered domain name and a DNS record pointing to your server's public IP address.

## Deployment

You need to install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites. For the production deployment, I would highly recommend to use [Docker Machine](https://docs.docker.com/machine/install-machine/).

### Development

In development, the following command brings the blog up and running:
```bash
$ docker-compose up
```

### Production

First, spin up the remote server and apply firewall settings using `bin/firewall.sh` script, if needed. Don't forget to update the `DOMAIN_NAME` variable in `.env` file with the actual domain name. Then, create a host machine using the Docker Machine and connect the running shell on the local machine to the remote one just created. Finally, execute the following command from the project's root directory to run the blog over HTTP:
```bash
$ docker-compose -f docker-compose.yml -f production.yml up -d
```
In order to serve over HTTPS, run this command instead:
```bash
$ docker-compose -f docker-compose.yml -f production.yml -f production.https.yml up -d
```

## Hosting multiple websites & backup

It is possible to host multiple websites on a single VPS using this setup. For example, you would like to serve a wordpress blog alongside with the running ghost blog. In this case, you have to add new services, one for a wordpress image and another one for its database to docker-compose files. Also, you will need to create a separate volume to make a database container persistent. You will end up with something like this:
```yaml
services:
  wp_db:
    image: mysql:5.7
    restart: always
    volumes:
      - wordpress_data:/var/lib/mysql
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: qwerty123
      MYSQL_ROOT_PASSWORD: qwerty12345

  wordpress:
    image: wordpress:latest
    restart: always
    depends_on:
      - wp_db
    environment:
      VIRTUAL_HOST: blog.wordpress.com
      WORDPRESS_DB_HOST: wp_db:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: qwerty123

volumes:
  wordpress_data:
```
The `cron` container defined in `production.yml` file is responsible for periodical backup of data stored in shared volumes. In order to add the newly created `wp_db` service to backup, its shared volume `wordpress_data` has to be added to volumes of the `cron` container, so that the service definition becomes this:
```yaml
cron:
  build: ./cron
  restart: always
  depends_on:
    - ghost
    - wp_db
  volumes:
    - ghost_data:${DATA_PATH}/ghost_data:ro
    - wordpress_data:${DATA_PATH}/wordpress_data:ro
    - backup:${DATA_PATH}/backup
  environment:
    DATA_PATH: ${DATA_PATH}
```
Note the mount points of all the shared data volumes in `cron` container have suffix `_data` in their paths such as `${DATA_PATH}/ghost_data` and `${DATA_PATH}/wordpress_data`. This convention is used by the backup script `cron/bin/backup.sh` to filter out the data folders for a subsequent backup.

