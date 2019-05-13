#!/bin/bash

command -v ufw > /dev/null 2>&1 || {
  apt-get update && apt-get install -y ufw
}

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 2376/tcp
ufw enable

