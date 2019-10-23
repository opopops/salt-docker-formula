{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for container, params in docker.get('containers', {}).get('absent', {}).items() %}
docker_container_{{container}}:
  docker_container.absent:
    - name: {{container}}
{%- endfor %}

{%- for container, params in docker.get('containers', {}).get('running', {}).items() %}
docker_container_{{container}}:
  docker_container.running:
    - name: {{container}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
{%- endfor %}
