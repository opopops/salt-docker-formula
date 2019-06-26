{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for network, params in docker.get('networks', {}).get('absent', {}).items() %}
docker_network_{{network}}:
  docker_network.absent:
    - name: {{network}}
    - require:
      - service: docker_service
{%- endfor %}

{%- for network, params in docker.get('networks', {}).get('present', {}).items() %}
docker_network_{{network}}:
  docker_network.present:
    - name: {{network}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
    - require:
      - service: docker_service
{%- endfor %}
