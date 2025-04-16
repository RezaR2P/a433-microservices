#!/bin/bash
set -e

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

USERNAME=rezar2p
IMAGE=ghcr.io/$USERNAME/karsajobs

if [ -z "$GHCR_TOKEN" ]; then
  echo "GHCR_TOKEN belum di-set. Silakan set di .env atau environment variable."
  exit 1
fi

echo "🔨 Building image $IMAGE:latest ..."
docker build -t $IMAGE:latest ./karsajobs

echo "🔐 Logging in to GitHub Container Registry ..."
echo $GHCR_TOKEN | docker login ghcr.io -u $USERNAME --password-stdin

echo "🚀 Pushing image $IMAGE:latest ..."
docker push $IMAGE:latest

echo "✅ Selesai!"