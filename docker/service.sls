{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install
  - docker.config

docker_systemctl_reload:
  module.wait:
    - systemd.systemctl_reload: {}
    - watch_in:
      - service: docker_service

{%- if docker.get('daemon', False) %}
  {%- if docker.daemon.get('options', False) %}
docker_daemon_options:
  file.replace:
    - name: {{ docker.docker_service_file }}
    - pattern: '^ExecStart=/usr/bin/dockerd.*$'
    - repl: 'ExecStart=/usr/bin/dockerd {{docker.daemon.get('options', [])|join(' ')}}'
    - append_if_not_found: True
    - watch_in:
      - module: docker_systemctl_reload
      - service: docker_service
  {%- endif %}
{%- endif %}

docker_service:
  service.running:
    - name: {{ docker.service }}
    - enable: True
    - require:
      - pkg: docker_package
