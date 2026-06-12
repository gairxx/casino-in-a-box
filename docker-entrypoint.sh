#!/bin/sh
set -e

# Wait for database to be ready
echo "Waiting for database..."
until nc -z -v -w30 $DB_HOST $DB_PORT; do
  echo "Database is unavailable - sleeping"
  sleep 2
done
echo "Database is up!"

# Generate app key if not set
if [ -z "$APP_KEY" ]; then
    echo "Generating app key..."
    php artisan key:generate --force
fi

# Run migrations
echo "Running migrations..."
php artisan migrate --force

# Create storage link
echo "Creating storage link..."
php artisan storage:link || true

# Execute the main command
exec "$@"
