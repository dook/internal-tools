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
echo "ZAŁĄCZNIK A do Raportu wykonania zlecenia"
echo "Changes in ${PWD##*/} for date: ${date}, created by: ${gituser}"
echo


python > /dev/tty <<-EOF
import subprocess
from collections import Counter

data = Counter()

log = subprocess.check_output('git log --all --after="${date}-01 00:00" --before="${date}-31 23:59" --author=${gituser} --pretty=format:"%h"', shell=True)

for commit in log.splitlines():
  commit = commit.decode()
  try:
    stats = subprocess.check_output('git diff %s^ %s --numstat' % (commit, commit), shell=True, stderr=open('/dev/null'))
  except Exception:
    stats = subprocess.check_output('git diff 4b825dc642cb6eb9a060e54bf8d69288fbee4904 %s --numstat' % commit, shell=True)
  for stat in stats.splitlines():
    # print(stat.decode())
    ins, dels, f = stat.split(None, 2)
    try:
        data[f.decode()] += (int(ins) + int(dels))
    except Exception:
        pass

for f, ch in data.items():
  print("File %s, modified lines: %s" % (f, ch))
EOF

echo ".............                                              .............."
echo "Zleceniodawca                                              Zleceniobiorca"
echo "========================================================================="
