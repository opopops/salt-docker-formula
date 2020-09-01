{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install

{%- if docker.compose.get('pip_install', False) %}
docker_compose:
  pkg.installed:
    - pkgs: {{ docker.compose_pip_require_pkgs }}
  pip.installed:
    - name: docker-compose == {{docker.compose.version}}
    - bin_env: {{ docker.python_bin }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages
{%- else %}
docker_compose:
  file.managed:
    - name: {{ docker.compose_path }}
    - source: {{ docker.compose_source }}
    {%- if docker.get('compose_source_hash', False) %}
    - source_hash: {{ docker.compose_source_hash }}
    {%- else %}
    - skip_verify: True
    {%- endif %}
    - user: root
    - group: root
    - mode: 755
{%- endif %}
