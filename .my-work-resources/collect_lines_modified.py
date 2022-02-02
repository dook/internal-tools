# credits to OG: Piotr Karkut <karkucik@gmail.com>

import subprocess
import sys
from collections import Counter

data = Counter()
directory, date, gituser = sys.argv[1], sys.argv[2], sys.argv[3]

log = subprocess.check_output(f'git -C ./{directory} log --all --after="{date}-01 00:00" --before="{date}-31 23:59" --author={gituser} --pretty=format:"%h"', shell=True)

for commit in log.splitlines():
  commit = commit.decode()
  try:
    stats = subprocess.check_output(f'git -C ./{directory} diff %s^ %s --numstat' % (commit, commit), shell=True, stderr=open('/dev/null'))
  except Exception:
    stats = subprocess.check_output(f'git -C ./{directory} diff 4b825dc642cb6eb9a060e54bf8d69288fbee4904 %s --numstat' % commit, shell=True)
  for stat in stats.splitlines():
    ins, dels, f = stat.split(None, 2)
    try:
        data[f.decode()] += (int(ins) + int(dels))
    except Exception:
        pass

print("('{0}', {1})".format(directory, list(data.items()) or []))
