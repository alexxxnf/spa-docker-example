FROM alexxxnf/spa-builder:12.1 as builder

COPY ./package.json ./package-lock.json /app/
RUN cd /app && npm ci --no-audit

COPY . /app
RUN cd /app \
    && npm run build -- --prod --configuration=production

FROM alexxxnf/nginx-spa

COPY ./docker/csr/docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=builder /usr/local/bin/brotli /usr/local/bin
COPY --from=builder /app/dist/docker-spa-example/browser /etc/nginx/html/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
