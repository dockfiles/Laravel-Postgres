#!/bin/sh
cd /app/laravel/src
php artisan $@
chown -R 1000:1000 /app/laravel/src
