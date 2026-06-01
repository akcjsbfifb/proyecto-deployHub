#!/bin/sh
set -e

echo "==> Waiting for database..."
i=0
while [ $i -lt 30 ]; do
  if echo "SELECT 1" | npx prisma db execute --stdin > /dev/null 2>&1; then
    echo "   Database is ready!"
    break
  fi
  i=$((i + 1))
  echo "   Attempt $i/30, retrying in 2s..."
  sleep 2
done

echo "==> Running database migrations..."
npx prisma migrate deploy

echo "==> Starting NestJS..."
exec node dist/src/main.js
