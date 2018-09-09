{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install
  - docker.config

docker_service:
  service.running:
    - name: {{ docker.service }}
    - enable: True
    - require:
      - pkg: docker_package
