# Docker SPA Example

This project shows how to use Docker to build and serve a single page application.

As an example of SPA, I use Angular, but my approach with minor modifications
can be applied to any framework.

If you use CDN or something else to serve your app, then this repo is probably not for you.

## Goals

Create a Docker image that can be easily run on Kubernetes or Docker-compose
in both production and development environments. The image should be

* simple to use
* small (in terms of RAM and HDD)
* configurable via environment variables
* effective in serving static files.

## High level overview
In order to keep the final image as small as possible, I use multistage build process.

The first stage installs dependencies and builds the app. I created a [custom base
image](https://github.com/alexxxnf/spa-builder) for that purpose.
It contains NPM, yarn, node-gyp. It also has gzip and Brotli to produce pre-compressed
static files.

The second stage copies the application into
[custom-made nginx image](https://github.com/alexxxnf/nginx-spa).
That concludes the building process.

When a container based on the image runs for the first time, a special script
replaces configuration variables with the values from environmental variables.
Ii also compresses the files and deals with hashes.

> For security reasons, consider using your own base images.

## How to use it
If you have an Angular-based SPA, using this approach takes two simple steps.

1. Replace actual values in `environment.prod.ts` with placeholders
 that looks like this: `${TITLE}`.
2. Copy the `docker` directory from this project to your repo.

Then you can build your image and create a container based on it
to run anywhere you like.

## Building Docker images

In the root directory run `docker build -t <TAG_NAME> -f docker/Dockerfile .`.

## Running Docker container

Run `docker run -p 80:80 -e TITLE="Title passed via env vars" <TAG_NAME>`
or use [docker/docker-compose.yaml](docker/docker-compose.yaml).
