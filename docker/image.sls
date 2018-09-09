{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- if docker.get('image_prune', False) %}
docker_image_prune:
  cmd.run:
    - name: docker image prune -f
{%- endif %}

{%- for image, params in docker.get('images', {}).get('absent', {}).items() %}
docker_image_{{image}}:
  docker_image.absent:
    - name: {{image}}
{%- endfor %}

{%- for image, params in docker.get('images', {}).get('present', {}).items() %}
docker_image_{{image}}:
  docker_image.present:
    - name: {{image}}
    {%- for k, v in params.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
    {%- if docker.get('image_prune', False) %}
    - require:
      - cmd: docker_image_prune
    {%- endif %}
{%- endfor %}
