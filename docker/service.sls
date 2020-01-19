{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install
  - docker.config

{%- for service, params in docker.get('systemd', {}).items() %}
  {%- if service == 'containerd' %}
docker_containerd_systemd:
  file.managed:
    - name: {{docker.containerd_service_file}}
    - source: {{params.source}}
    {%- if params.get('source_hash', False) %}
    - source_hash: {{params.source_hash}}
    {%- endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - module: docker_systemctl_reload
  {%- elif service == 'docker' %}
docker_systemd:
  file.managed:
    - name: {{docker.docker_service_file}}
    - source: {{params.source}}
    {%- if params.get('source_hash', False) %}
    - source_hash: {{params.source_hash}}
    {%- endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - module: docker_systemctl_reload
  {%- endif %}
{%- endfor %}

docker_systemctl_reload:
  module.wait:
    - service.systemctl_reload: {}
    {%- if docker.service_watch %}
    - watch_in:
      - service: docker_service
    {%- endif %}

docker_service:
  service.running:
    - name: {{ docker.service }}
    - enable: True
    - require:
      - pkg: docker_package
      - module: docker_systemctl_reload
