#!/bin/bash
set -e # Script akan berhenti jika ada perintah yang gagal

# Jika file .env ada, export semua variabel di dalamnya (kecuali yang dikomentari dengan #)
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

USERNAME=rezar2p # Mendefinisikan username untuk GitHub Container Registry
IMAGE=ghcr.io/$USERNAME/karsajobs # Mendefinisikan nama image lengkap di GHCR

# Mengecek apakah variabel GHCR_TOKEN sudah di-set, jika belum script berhenti
if [ -z "$GHCR_TOKEN" ]; then
  echo "GHCR_TOKEN belum di-set. Silakan set di .env atau environment variable."
  exit 1
fi

echo "🔨 Building image $IMAGE:latest ..."
docker build -t $IMAGE:latest ./karsajobs # Build Docker image dari folder ./karsajobs

echo "🔐 Logging in to GitHub Container Registry ..."
echo $GHCR_TOKEN | docker login ghcr.io -u $USERNAME --password-stdin # Login ke GHCR menggunakan token

echo "🚀 Pushing image $IMAGE:latest ..."
docker push $IMAGE:latest # Push image ke GHCR

echo "✅ Selesai!" # Notifikasi bahwa proses selesai