cat <<'EOF' > ~/.bash_aliases
alias ll='ls -al'
alias xtargz='tar -zxvf'
alias ctargz='tar -zcvf'
alias dirsize='du -h --max-depth=1 | sort -hr'

alias dc='docker-compose'

myip () {
  curl ifconfig.me
  echo ""
}

proj () {
  case $1 in
  traefik)
    docker network create web
    CDIR=`pwd`
    mkdir $CDIR/_proxy
    touch $CDIR/_proxy/acme.json
    chmod 600 $CDIR/_proxy/acme.json
    cat <<XXX > $CDIR/_proxy/docker-compose.yml
version: '3'

services:
  traefik:
    image: traefik:1.6.4
    command: --api
    networks:
      - web
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.toml:/traefik.toml
      - ./acme.json:/acme.json
networks:
  web:
    external: true
XXX
    read -p 'Email?: ' EMAIL
    cat <<XXX > $CDIR/_proxy/traefik.toml
debug = false

logLevel = "ERROR"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
watch = true
exposedByDefault = false

[acme]
email = "$EMAIL"
storage = "acme.json"
entryPoint = "https"
onHostRule = true
[acme.httpChallenge]
entryPoint = "http"

XXX
  ;;
  service-echo)
    CDIR=`pwd`
    mkdir $CDIR/echo
    cat <<XXX > $CDIR/echo/docker-compose.yml
version: '3'

services:
  echo:
    image: mendhak/http-https-echo
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=web"
      - "traefik.frontend.rule=HostRegexp:echo.{domain:.+}"
      - "traefik.port=80"
networks:
  default:
    external:
      name: web
XXX
  ;;
  *)
    echo "$1 is not a valid proj"
  ;;
  esac
}
EOF

echo "RUN 'exec bash' to activate the aliases in current session"
