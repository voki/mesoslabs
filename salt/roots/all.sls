docker:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: docker

/tmp/mesos/meta/slaves/latest:
  file.absent

/etc/mesos-slave/resources:
  file.managed:
    - source: salt://resources
 
/etc/sysconfig/docker:
  file.replace:
    - pattern: "OPTIONS='--selinux-enabled'"
    - repl: "OPTIONS='--selinux-enabled --insecure-registry master-1:5000'"
    - require:
      - pkg: docker

mesos-slave:
  service.running:
    - watch: 
      - file: /etc/mesos-slave/resources
      - file: /tmp/mesos/meta/slaves/latest
    - order: last

