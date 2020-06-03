# Docker SPA Example

This project shows how to use Docker to build and serve a single page application.

## Building Docker images

In the root directory run `docker build -t <TAG_NAME> -f docker/Dockerfile .`.

## Running Docker container

Run `docker run -p 80:80 -e TITLE="Title passed via env vars" <TAG_NAME>`.
