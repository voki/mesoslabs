/root/post.sh:
  file.managed:
    - source: salt://post.sh
    - mode: 755

/root/dns.json:
 file.managed:
    - source: salt://dns.json

import_apps:
  cmd.run:
    - name: /root/post.sh 
    - cwd: /root
    - user: root
    - order: last
