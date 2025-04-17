#!/bin/bash
set -e # Script akan berhenti jika ada perintah yang gagal

# Load .env jika ada
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs) # Export semua variabel dari .env kecuali yang dikomentari dengan #
fi

USERNAME=rezar2p # Mendefinisikan username untuk GitHub Container Registry
IMAGE=ghcr.io/$USERNAME/karsajobs-ui # Mendefinisikan nama image lengkap di GHCR

# Mengecek apakah variabel GHCR_TOKEN sudah di-set, jika belum script berhenti
if [ -z "$GHCR_TOKEN" ]; then
  echo "GHCR_TOKEN belum di-set. Silakan set di .env atau environment variable."
  exit 1
fi

echo "🔨 Building image $IMAGE:latest ..."
docker build -t $IMAGE:latest ./karsajobs-ui # Build Docker image dari folder ./karsajobs-ui

echo "🔐 Logging in to GitHub Container Registry ..."
echo $GHCR_TOKEN | docker login ghcr.io -u $USERNAME --password-stdin # Login ke GHCR menggunakan token

echo "🚀 Pushing image $IMAGE:latest ..."
docker push $IMAGE:latest # Push image ke GHCR

echo "✅ Selesai!" # Notifikasi bahwa proses selesai