{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install
  - docker.service

docker_group:
  group.present:
    - name: {{ docker.group }}
    - addusers: {{ docker.get('users', []) }}
    - watch_in:
      - service: docker_service

{%- if docker.get('config', False) %}
docker_config:
  file.serialize:
    - name: {{ docker.conf_file }}
    - dataset: {{ docker.config }}
    - formatter: json
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - watch_in:
      - service: docker_service
{%- endif %}