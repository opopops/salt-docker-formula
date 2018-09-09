{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- if docker.get('network_prune', False) %}
docker_network_prune:
  cmd.run:
    - name: docker network prune -f
{%- endif %}

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
    {%- if docker.get('network_prune', False) %}
    - require:
      - cmd: docker_network_prune
    {%- endif %}
{%- endfor %}
