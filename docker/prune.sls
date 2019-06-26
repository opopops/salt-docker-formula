{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install
  - docker.service
  - docker.image
  - docker.network
  - docker.volume
  - docker.container


{%- if docker.get('network_prune', False) %}
docker_network_prune:
  cmd.run:
    - name: docker network prune -f
    - require:
      - service: docker_service
      - sls: docker.network
{%- endif %}

{%- if docker.get('container_prune', False) %}
docker_container_prune:
  cmd.run:
    - name: docker container prune -f
    - require:
      - service: docker_service
{%- endif %}

{%- if docker.get('volume_prune', False) %}
docker_volume_prune:
  cmd.run:
    - name: docker volume prune -f
    - require:
      - service: docker_service
{%- endif %}

{%- if docker.get('image_prune', False) %}
docker_image_prune:
  cmd.run:
    - name: docker image prune -f
    - require:
      - service: docker_service
{%- endif %}
