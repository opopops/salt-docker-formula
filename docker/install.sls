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
    - reload_modules: True
    - require:
      - pkg: docker_package

docker_pip_package:
  pip.installed:
    - pkgs: {{ docker.pip_pkgs }}
    - bin_env: {{ docker.pip_bin_env }}
    - reload_modules: True
    - require:
      - pkg: docker_python_packages
