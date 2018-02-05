#!/bin/sh
defdate=`date "+%Y-%m"`

read -p "Data logu rrrr-mm [${defdate}]: " date </dev/tty

if [ -z "$date" ]; then
  date=${defdate}
fi


defgituser=`git config user.email`
read -p "Email użytkownika git: [${defgituser}]: " gituser </dev/tty

if [ -z "$gituser" ]; then
  gituser=${defgituser}
fi
echo
echo

echo "========================================================================="
echo "Zmiany w ${PWD##*/} na miesiąc ${date} dla ${gituser}"
echo

git log --all --name-only --pretty=format: --after=${date}-01 --before=${date}-31 --author=${gituser} | grep . | sort | uniq -c | sort -r | awk '{print $2,"->",$1}'

echo "========================================================================="
