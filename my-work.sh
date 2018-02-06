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


pyscr="$(cat <<-EOF
import subprocess
from collections import Counter

data = Counter()

log = subprocess.check_output('git log --all --after=${date}-01 --before=${date}-31 --author=${gituser} --pretty=format:"%h"', shell=True)

for commit in log.splitlines():
  commit = commit.decode()
  try:
    stats = subprocess.check_output('git diff %s^ %s --numstat' % (commit, commit), shell=True, stderr=open('/dev/null'))
  except Exception:
    stats = subprocess.check_output('git diff 4b825dc642cb6eb9a060e54bf8d69288fbee4904 %s --numstat' % commit, shell=True)
  for stat in stats.splitlines():
    # print(stat.decode())
    ins, dels, f = stat.split(None, 2)
    data[f.decode()] += (int(ins) + int(dels))

for f, ch in data.items():
  print("Plik %s, zmienionych linii: %s" % (f, ch))
EOF
)"

python > /dev/tty <<< ${pyscr}

echo "========================================================================="
