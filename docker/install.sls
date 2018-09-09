{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.repo

docker_package:
  pkg.installed:
    - name: {{ docker.pkg }}
    {%- if docker.version is defined %}
    - version: {{ docker.version }}
    {%- endif %}
    {%- if docker.manage_repo %}
    - require:
      - sls: docker.repo
    {%- endif %}

docker_python_packages:
  pkg.installed:
    - pkgs: {{ docker.python_pkgs }}
    - require:
      - pkg: docker_package

docker_pip_package:
  pip.installed:
    - pkgs: {{ docker.pip_pkgs }}
    - bin_env: {{ docker.pip_bin_env }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages

{%- if docker.get('manage_compose', False) %}
docker_compose:
  file.managed:
    - name: {{ docker.compose_path }}
    - source: {{ docker.compose_source }}
    {%- if docker.get('compose_hash', False) %}
    - source_hash: {{ docker.compose_hash }}
    {%- else %}
    - skip_verify: True
    {%- endif %}
    - user: root
    - group: root
    - mode: 755
{%- endif %}
