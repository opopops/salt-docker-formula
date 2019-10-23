{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.repo

docker_cli_package:
  pkg.installed:
    - name: {{ docker.pkg }}-cli
    {%- if docker.version is defined %}
    - version: {{ docker.version }}
    {%- endif %}
    {%- if docker.manage_repo %}
    - require:
      - sls: docker.repo
    {%- endif %}

docker_package:
  pkg.installed:
    - name: {{ docker.pkg }}
    {%- if docker.version is defined %}
    - version: {{ docker.version }}
    {%- endif %}
    {%- if docker.manage_repo %}
    - require:
      - sls: docker.repo
      - pkg: docker_cli_pkg
    {%- endif %}

docker_python_packages:
  pkg.installed:
    - pkgs: {{ docker.python_pkgs }}
    - reload_modules: True
    - require:
      - pkg: docker_package

docker_pip_package:
  pip.installed:
    - pkgs: {{ docker.pip_pkgs }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages

{%- if docker.get('manage_awscli', False) %}
docker_awscli_pip_package:
  pip.installed:
    - name: {{ docker.awscli_pip_pkg }}
    - bin_env: {{ docker.python3_bin }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages
{%- endif %}
