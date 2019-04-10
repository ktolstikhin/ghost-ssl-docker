# Yet another self-hosted Ghost blog with Docker, Compose, and Nginx.

## TODO: Add a link to the blog post: https://www.metamost.com/ghost-docker-setup/
## TODO: Add links to nginx-proxy and letsencrypt-nginx-proxy-companion repos

This is a simple Ghost blog setup wrapped up in Docker containers. Here, the default SQLite database is used. The content backup and updating Let's Encrypt SSL/TLS certificates are carried out periodically by cron. For even simpler HTTP version, checkout the *http* branch which offers easier deployment using Docker Machine.

## Deployment

First, install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites. This setup was tested successfully with Ubuntu 16.04 and 18.04 LTS.

### Development

In development, the following command brings the blog up and running:
```bash
docker-compose up
```

### Production

First, copy the project folder to `/path/to/ghost_blog` on the remote host and replace `blog.example.com` with your domain name in `.env`. The firewall settings can be applied optionally using the `./bin/firewall.sh` script. Then, run the blog using the following command:
```bash
docker-compose -f docker-compose.yml -f production.yml up -d
```

