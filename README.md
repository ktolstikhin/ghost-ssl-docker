# A self-hosted Ghost blog using Nginx with SSL enabled

![](../assets/ghost_and_company.png?raw=true)

This is a simple Ghost blog setup wrapped up in Docker containers for easy development and deployment. Here, the default SQLite database is used as it seems to be a good fit for blogging needs. You are free to change it to something more robust like MySQL, thanks to Docker it is pretty easy to do. The content backup is carried out periodically by cron. While in production, the blog is served over HTTPS, free SSL/TLS certificates are fetched and renewed from the [Let's Encrypt](https://letsencrypt.org/) certificate authority automatically. This project is heavily inspired by this [blog post](https://www.metamost.com/ghost-docker-setup/) and is being feasible thanks to these awesome projects: [nginx-proxy](https://github.com/jwilder/nginx-proxy), [docker-gen](https://github.com/jwilder/docker-gen), and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion).

## Requirements

* A modern GNU/Linux distribution. This setup was tested successfully with Ubuntu 16.04 and 18.04 LTS.

* A fully registered domain name and a DNS record pointing to your server's public IP address.

## Deployment

You will have to install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites. For the production deployment, I would highly recommend to use [Docker Machine](https://docs.docker.com/machine/install-machine/). Once you have Docker installed, you are good to go.

### Development

In development, the following command executed from the project's root directory will bring the blog up and running:
```bash
$ docker-compose up
```
The blog will be running in development mode on port 2368.

### Production

First, spin up a remote server and apply firewall settings using `bin/firewall.sh` script, if needed. Don't forget to update the `DOMAIN_NAME` variable in `.env` file with the actual domain name. Then, create a remote machine using Docker Machine on the development host and connect the running shell to the new machine just created. Finally, execute the following command:
```bash
$ docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

## Backup

The `cron` container defined in `docker-compose.production.yml` file is responsible for periodical backup of data stored in shared volumes:
```yaml
cron:
  build: ./cron
  restart: always
  depends_on:
    - ghost
  volumes:
    - ghost_data:${DATA_PATH}/ghost_data:ro
    - backup:${DATA_PATH}/backup
  environment:
    DATA_PATH: ${DATA_PATH}
```
Note the mount points of all the shared data volumes in `cron` container must have suffix `_data` in their paths such as `${DATA_PATH}/ghost_data` in the snippet above. This convention is used by the backup script `cron/bin/backup.sh` to filter out the data folders for a subsequent backup.

