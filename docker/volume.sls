{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for volume, params in docker.get('volumes', {}).get('absent', {}).items() %}
docker_volume_{{volume}}:
  docker_volume.absent:
    - name: {{volume}}
    - require:
      - service: docker_service
{%- endfor %}

{%- for volume, params in docker.get('volumes', {}).get('present', {}).items() %}
docker_volume_{{volume}}:
  docker_volume.present:
    - name: {{volume}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
    - require:
      - service: docker_service
{%- endfor %}
