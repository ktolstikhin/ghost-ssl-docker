# Yet another self-hosted Ghost blog with Docker, Nginx, and Let's Encrypt

This is a simple Ghost blog setup wrapped up in Docker containers for easy development and deployment. Here, the default SQLite database is used as it seems to be a good fit for blogging needs. The content backup is carried out periodically by cron. This project is heavily inspired by this [blog post](https://www.metamost.com/ghost-docker-setup/) and is being feasible thanks to these awesome projects: [nginx-proxy](https://github.com/jwilder/nginx-proxy), [docker-gen](https://github.com/jwilder/docker-gen), and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). The project will allow you to serve a Ghost blog over either HTTP or HTTPS. In the latter case, the free SSL/TLS certificates will be fetched and renewed from the [Let's Encrypt](https://letsencrypt.org/) certificate authority automatically.

## Requirements

* A Debian-based GNU/Linux distribution. This setup was tested successfully with Ubuntu 16.04 and 18.04 LTS.

* A fully registered domain name and a DNS record pointing to your server's public IP address.

## Deployment

You need to install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites. For the production deployment, I would highly recommend to use [Docker Machine](https://docs.docker.com/machine/install-machine/).

### Development

In development, the following command brings the blog up and running:
```bash
docker-compose up
```

### Production

First, spin up the remote server and apply firewall settings using `bin/firewall.sh` script, if needed. Don't forget to update the `DOMAIN_NAME` variable in `.env` file with the actual domain name. Then, create the host machine using the Docker Machine and connect the running shell on the local machine to the remote one just created. Finally, execute the following command from the project's root directory to run the blog over HTTP:
```bash
docker-compose -f docker-compose.yml -f production.yml up -d
```
In order to serve over HTTPS, run this command instead:
```bash
docker-compose -f docker-compose.yml -f production.yml -f production.https.yml up -d
```

