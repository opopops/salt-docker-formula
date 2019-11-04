{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.repo
  - docker.install
  - docker.config
  - docker.service
  - docker.login
  - docker.image
  - docker.network
  - docker.volume
  - docker.container
  - docker.exec
  - docker.prune
