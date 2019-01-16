{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- if docker.get('volume_prune', False) %}
docker_volume_prune:
  cmd.run:
    - name: docker volume prune -f
{%- endif %}

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
