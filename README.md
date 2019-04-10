# Yet another self-hosted Ghost blog with Docker, Compose, and Nginx.

## TODO: Add a link to the blog post: https://www.metamost.com/ghost-docker-setup/
## TODO: Add links to nginx-proxy and letsencrypt-nginx-proxy-companion repos

This is a simple Ghost blog setup wrapped up in Docker containers. Here, the default SQLite database is used. The content backup is carried out periodically by cron. For even simpler HTTP version, checkout the *http* branch.

## Deployment

First, install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites. For the production deployment it is recommended to use the [Docker Machine](https://docs.docker.com/machine/install-machine/). This setup was tested successfully with Ubuntu 16.04 and 18.04 LTS.

### Development

In development, the following command brings the blog up and running:
```bash
docker-compose up
```

### Production

First, update `DOMAIN_NAME` variable in `.env` with the actual domain name. Then, create the host machine using the Docker Machine, connect the running shell on the localhost to the new machine, and finally run the following command from the project's root directory:

HTTP:
```bash
docker-compose -f docker-compose.yml -f production.yml up -d
```

HTTPS:
```bash
docker-compose -f docker-compose.yml -f production.yml -f production.https.yml up -d
```

