{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.repo

{%- if docker.get('require_pkgs', []) %}
docker_require_packages:
  pkg.installed:
    - pkgs: {{ docker.require_pkgs }}
{%- endif %}

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
      - pkg: docker_cli_package
    {%- endif %}

{%- if docker.get('python_pkgs', []) %}
docker_python_packages:
  pkg.installed:
    - pkgs: {{ docker.python_pkgs }}
    - reload_modules: True
    - require:
      - pkg: docker_package
{%- endif %}

{%- if docker.get('pip_pkgs', []) %}
docker_pip_package:
  pip.installed:
    - pkgs: {{ docker.pip_pkgs }}
    - bin_env: {{ docker.python_bin }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages
{%- endif %}

{%- if docker.get('manage_awscli', False) %}
docker_awscli_pip_package:
  pip.installed:
    - name: {{ docker.awscli_pip_pkg }}
    - bin_env: {{ docker.python_bin }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages
{%- endif %}

