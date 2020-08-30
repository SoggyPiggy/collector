export SECRET_KEY_BASE="$(mix phx.gen.secret)"
export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/collector_dev"
export APP_NAME=collector
export MY_HOSTNAME=localhost.com
export MY_COOKIE=oeuoeoeueouoeuoeuoeuoeuoeu
export REPLACE_OS_VARS=true
export MIX_ENV=prod
mix distillery.release --env=prod
echo "To test build use:"
echo "MIX_ENV=prod MY_NODE_NAME=collector_dev@127.0.0.1 PORT=4000 _build/prod/rel/collector/bin/collector foreground"