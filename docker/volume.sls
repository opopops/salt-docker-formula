{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for volume, params in docker.get('volumes', {}).get('absent', {}).items() %}
docker_volume_{{volume}}:
  docker_volume.absent:
    - name: {{volume}}
{%- endfor %}

{%- for volume, params in docker.get('volumes', {}).get('present', {}).items() %}
docker_volume_{{volume}}:
  docker_volume.present:
    - name: {{volume}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
{%- endfor %}
