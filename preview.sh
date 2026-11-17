#!/bin/sh
# Preview of the site in Docker; no Ruby needed on the host. Jekyll listens on localhost only;
# the kar-home preview server (port 8124, already open on the tailnet) proxies /site/ to it.
#   ./preview.sh start   build and serve at http://<tailscale-ip>:8124/site/ (rebuilds on save; refresh)
#   ./preview.sh stop
#   ./preview.sh logs
set -e
NAME=akar-site-preview
PORT=${PORT:-4000}
PUBLIC=http://$(tailscale ip -4 2>/dev/null | head -1 || echo 127.0.0.1):8124/site/
GEMS=${GEMS:-$HOME/.cache/akar-site-gems}
cd "$(dirname "$0")"

case "${1:-start}" in
  start)
    docker rm -f $NAME >/dev/null 2>&1 || true
    mkdir -p "$GEMS"
    docker run -d --rm --name $NAME --network host \
      --user "$(id -u):$(id -g)" -e HOME=/tmp -e BUNDLE_PATH=/gems \
      -v "$GEMS":/gems -v "$PWD":/site -w /site ruby:3.3 \
      sh -c "bundle install --quiet && bundle exec jekyll serve --host 127.0.0.1 --port $PORT --baseurl /site" >/dev/null
    printf 'Starting'
    for _ in $(seq 1 90); do
      if curl -fs -o /dev/null "http://127.0.0.1:$PORT/site/"; then
        printf '\nPreview: %s  (branch: %s)\n' "$PUBLIC" "$(git branch --show-current)"
        exit 0
      fi
      printf '.'; sleep 2
    done
    echo; docker logs --tail 30 $NAME; exit 1 ;;
  stop) docker rm -f $NAME >/dev/null && echo stopped ;;
  logs) docker logs -f $NAME ;;
  *) echo "usage: $0 start|stop|logs" >&2; exit 2 ;;
esac
