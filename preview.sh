#!/bin/sh
# Live preview of the site in Docker, reachable over Tailscale. No Ruby needed on the host.
#   ./preview.sh start   build and serve at http://<tailscale-ip>:4000/ (reloads on save)
#   ./preview.sh stop
#   ./preview.sh logs
set -e
NAME=akar-site-preview
PORT=${PORT:-4000}
HOST=${HOST:-$(tailscale ip -4 2>/dev/null | head -1)}
HOST=${HOST:-127.0.0.1}
GEMS=${GEMS:-$HOME/.cache/akar-site-gems}
cd "$(dirname "$0")"

case "${1:-start}" in
  start)
    docker rm -f $NAME >/dev/null 2>&1 || true
    mkdir -p "$GEMS"
    docker run -d --rm --name $NAME --network host \
      --user "$(id -u):$(id -g)" -e HOME=/tmp -e BUNDLE_PATH=/gems \
      -v "$GEMS":/gems -v "$PWD":/site -w /site ruby:3.3 \
      sh -c "bundle install --quiet && bundle exec jekyll serve --host $HOST --port $PORT --livereload" >/dev/null
    printf 'Starting'
    for _ in $(seq 1 90); do
      if curl -fs -o /dev/null "http://$HOST:$PORT/"; then
        printf '\nPreview: http://%s:%s/  (branch: %s)\n' "$HOST" "$PORT" "$(git branch --show-current)"
        exit 0
      fi
      printf '.'; sleep 2
    done
    echo; docker logs --tail 30 $NAME; exit 1 ;;
  stop) docker rm -f $NAME >/dev/null && echo stopped ;;
  logs) docker logs -f $NAME ;;
  *) echo "usage: $0 start|stop|logs" >&2; exit 2 ;;
esac
