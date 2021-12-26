#!/bin/sh

echo "Setting up environment files (.env) ..."  && \
rm -rf .env && cp -rp .env.example .env && \
echo "docker-compose up -d ..."  && \
docker-compose up -d && \
echo "composer install ..."  && \
docker-compose exec --user www app bash -c "composer install" && \
echo "php artisan key:generate ..."  && \
docker-compose exec --user www app bash -c "php artisan key:generate" && \
echo "php artisan migrate:fresh --seed ..."  && \
docker-compose exec --user www app bash -c "php artisan migrate --seed"  && \
echo "initialize complete..."
