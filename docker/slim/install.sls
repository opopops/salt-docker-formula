{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install

{%- for user in docker.get('users', []) %}
docker_slim_dir_{{user}}:
  file.directory:
    {%- if user == 'root' %}
    - name: {{ docker.root_home_dir }}/.docker/bin
    {%- else %}
    - name: {{ docker.users_home_dir }}/{{ user }}/.docker/bin
    {%- endif %}
    - user: {{ user }}
    - mode: 755
    - makedirs: True

docker_slim_{{user}}:
  archive.extracted:
    {%- if user == 'root' %}
    - name: {{ docker.root_home_dir }}/.docker/bin
    {%- else %}
    - name: {{ docker.users_home_dir }}/{{ user }}/.docker/bin
    {%- endif %}
    - source: {{docker.slim_source}}
    {%- if docker.get('slim_source_hash', False) %}
    - source_hash: {{docker.slim_source_hash}}
    {%- else %}
    - skip_verify: True
    {%- endif %}
    - user: {{ user }}
    - options: --strip-components=1
    - enforce_toplevel: False
    - require:
      - file: docker_slim_dir_{{user}}

docker_slim_file:
  file.managed:
    {%- if user == 'root' %}
    - name: {{ docker.root_home_dir }}/.docker/bin/docker-slim
    {%- else %}
    - name: {{ docker.users_home_dir }}/{{ user }}/.docker/bin/docker-slim
    {%- endif %}
    - user: {{ user }}
    - mode: 755
    - require:
      - archive: docker_slim_{{user}}

docker_slim_sensor_file:
  file.managed:
    {%- if user == 'root' %}
    - name: {{ docker.root_home_dir }}/.docker/bin/docker-slim-sensor
    {%- else %}
    - name: {{ docker.users_home_dir }}/{{ user }}/.docker/bin/docker-slim-sensor
    {%- endif %}
    - user: {{ user }}
    - mode: 755
    - require:
      - archive: docker_slim_{{user}}
{%- endfor %}
