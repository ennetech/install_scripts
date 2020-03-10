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
    CDIR=`pwd`
    mkdir $CDIR\_proxy
    touch $CDIR\_proxy\acme.json
    chmod 600 $CDIR\_proxy\acme.json
    cat <<XXX > $CDIR\_proxy\docker-compose.yml
    dc
XXX
    cat <<XXX > $CDIR\_proxy\traefik.toml
    toml
XXX
  ;;
  *)
    echo "$1 is not a valid proj"
  ;;
  esac
}
EOF

echo "RUN 'exec bash' to activate the aliases in current session"
