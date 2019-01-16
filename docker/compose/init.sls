{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.compose.install
  - docker.compose.project
