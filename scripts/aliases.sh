cat <<EOF > ~/.bash_aliases
alias ll='ls -al'
alias xtargz='tar -zxvf'
alias ctargz='tar -zcvf'
alias dirsize='du -h --max-depth=1 | sort -hr'

myip () {
  curl ifconfig.me
  echo ""
}
EOF

echo "RUN 'exec bash' to activate the aliases in current session"
