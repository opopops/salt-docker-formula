{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for network, params in docker.get('networks', {}).get('absent', {}).items() %}
docker_network_{{network}}:
  docker_network.absent:
    - name: {{network}}
{%- endfor %}

{%- for network, params in docker.get('networks', {}).get('present', {}).items() %}
docker_network_{{network}}:
  docker_network.present:
    - name: {{network}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
{%- endfor %}
