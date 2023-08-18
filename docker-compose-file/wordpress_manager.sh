#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing..."
    # Add your installation commands here
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing..."
    # Add your installation commands here
fi

# Define the site name from command-line argument
site_name="example.com"  # Change this to your desired site name

# Create docker-compose.yml file for WordPress
cat <<EOF > docker-compose.yml
version: '3'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: my-example
    volumes:
      - ./wp-content:/var/www/html/wp-content
  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: my-example
      MYSQL_DATABASE: wordpress
EOF

# Start containers
docker-compose up -d

# Add /etc/hosts entry
echo "127.0.0.1 $site_name" | sudo tee -a /etc/hosts

# Prompt user to open the site
echo "Your site is up! Open http://$site_name in your browser."

# Subcommand to enable/disable the site
if [ "$2" == "enable" ]; then
    docker-compose start
    echo "Site enabled."
elif [ "$2" == "disable" ]; then
    docker-compose stop
    echo "Site disabled."
fi

# Subcommand to delete the site
if [ "$2" == "delete" ]; then
    docker-compose down
    echo "Site deleted."
fi

