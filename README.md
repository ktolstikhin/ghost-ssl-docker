# Yet another self-hosted Ghost blog with Docker, Compose, and Nginx.

This is a simple Ghost blog setup wrapped up in Docker containers. Here, the default SQLite database is used. The content backup and updating Let's Encrypt certificates are carried out periodically by cron.

## Deployment

First, install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites.

### Development

In development, the following command brings the blog up and running:
```bash
docker-compose up
```

### Production

First, copy the project folder to `/path/to/ghost_blog` on the remote host and replace all occurancies of `blog.example.com` with your domain name in `.env` and `nginx/ghost.conf` files. Then, run install script as root:
```bash
cd /path/to/ghost_blog
sudo ./bin/install.sh
```
This will add scripts used for backup and certificate update to root's cron jobs and will fetch Let's Encrypt free SSL/TLS certificates for the current domain. The firewall settings can be applied optionally using the `./bin/firewall.sh` script. Once the install script has finished, run the blog using the following command:
```bash
docker-compose -f docker-compose.yml -f production.yml up -d
```

