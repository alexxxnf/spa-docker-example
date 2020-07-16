FROM alexxxnf/spa-builder:12.1 as builder

WORKDIR /app

COPY ./package.json ./package-lock.json ./
RUN npm ci --no-audit

COPY . .
RUN npm run build:ssr

FROM alexxxnf/nginx-brotli:1.19.1

RUN apk add nodejs

COPY ./docker/ssr/docker-entrypoint-node.sh /docker-entrypoint-node.sh
COPY ./docker/ssr/prep-stat-files.sh /docker-entrypoint.d/prep-stat-files.sh
COPY ./docker/ssr/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /usr/local/bin/brotli /usr/local/bin
COPY --from=builder /app/dist/docker-spa-example /app

# For SSR
#ENTRYPOINT ["/docker-entrypoint-node.sh"]
#CMD ["node", "/app/server/main.js"]
