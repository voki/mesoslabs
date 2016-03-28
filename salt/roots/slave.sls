/etc/hosts:
  file.managed:
    - source: salt://hosts

/etc/mesos/zk:
  file.managed:
    - source: salt://zk
    - require:
      - pkg: mesos

zoo_rpm:
    cmd:
        - run
        - name: rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
mesos_rpm:
    cmd:
        - run
        - name: rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

zookeeper:
  pkg:
    - installed
    - require:
      - cmd: zoo_rpm

mesos:
  pkg:
    - installed
    - require:
      - pkg: zookeeper
      - cmd: mesos_rpm

mesos-master:
  service.dead:
    - enable: False 
    - require:
      - pkg: mesos

mesos-slave:
  service.running:
    - enable: True
    - require:
      - pkg: mesos

/etc/resolv.conf:
  file.managed:
    - source: salt://resolv.conf

chattr_resolv:
  cmd.run:
    - name: /srv/salt/resolv.sh
    - user: root
    - group: root
    - require:
      - file: /etc/resolv.conf
    - watch:
      - file: /etc/resolv.conf

