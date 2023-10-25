# Laravel + Postgres + Composer + Cache

This is a dead simple docker-compose setup to create new Laravel apps without abstracting away the Dockerfiles.

This setup:

- Uses PHP 8.1 & installs the latest available version of Laravel
- Utility artisan container to run artisan commands
- Nginx (1.17-alpine)
- 2 preconfigured PostgreSQL 14.1 databases. 1 for app data, and 1 for testing.
- Composer 2.2.5
- Redis & Memcached preconfigured

Note that this setup comes with a preconfigured `.env.example` (copied & renamed to `.env` at install-time), `database.php`, and `phpunit.xml` that get copied into your project directory upon installation.

The databases and the cache driver do not need to be manually configured.

# Requirements

- [Docker Engine](https://www.docker.com)
- [Docker Compose](https://docs.docker.com/compose/install/)

# Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/dockfiles/Laravel-Postgres.git laravel-postgres
```

cd into the new directory

```bash
cd laravel-postgres
```

### 2. Install Laravel with the installer container

- Install the latest version of Laravel with the installer

```bash
docker compose run installer
```

### 3. Run the PHP/Nginx/Postgres/Cache stack

```bash
docker compose up -d
```

This will run all dependencies to start serving Laravel on your `localhost`.

If you see an Nginx Forbidden error, try restarting the containers with `docker compose restart`.

# Database Login

You can access the database on port `5432` of your host machine by using an app such as [dbeaver](https://dbeaver.io/).  
Some default credentials are set in `docker-compose.yml`

- POSTGRES_USER: postgres
- POSTGRES_PASSWORD: password
- POSTGRES_DB: postgres

# Running Composer Commands

To run composer commands, prefix the command with `docker compose run`

Examples:

```bash
docker compose run composer require laravel/breeze --dev
```

```bash
docker compose run composer update
```

# Running Artisan Commands

To run artisan commands, prefix the command with `docker compose run`

Examples:

```bash
docker compose run artisan migrate
```

```bash
docker compose run artisan test
```

```bash
docker compose run artisan make:controller ExampleController
```
