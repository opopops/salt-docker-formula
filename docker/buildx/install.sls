{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install

{%- for user in docker.get('users', []) %}
docker_buildx_{{user}}:
  file.managed:
    - name: {{ docker.users_home_dir }}/{{ user }}/.docker/cli-plugins/docker-buildx
    - source: {{ docker.buildx_source }}
    {%- if docker.get('buildx_source_hash', False) %}
    - source_hash: {{ docker.buildx_source_hash }}
    {%- else %}
    - skip_verify: True
    {%- endif %}
    - user: {{ user }}
    - mode: 755
    - makedirs: True

  {%- if docker.buildx.get('install', False) %}
docker_buildx_{{user}}_install:
  cmd.run:
    - runas: {{user}}
    - cmd: docker buildx install
  {%- endif %}
{%- endfor %}
