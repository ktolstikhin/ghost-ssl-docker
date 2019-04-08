# Ghost self-hosted blog

## Deployment

First, install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) by following instructions from the official websites.

### Development

In development, you can run the blog by invoking the following command from the project root directory:
```bash
docker-compose up
```

### Production

In production, you need to copy the project folder to the remote host directory `/path/to/ghost_blog`. Then, run install script as root:
```bash
cd /path/to/ghost_blog
sudo ./bin/install.sh
```

Once the install script has finished, run the blog using the following command:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

