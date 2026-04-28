#!/bin/bash
set -euo pipefail
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
cat > /opt/app-compose.yaml <<'EOF'
services:
  app:
    image: nginx:stable
    ports:
      - "8080:80"
EOF
docker compose -f /opt/app-compose.yaml up -d || true
