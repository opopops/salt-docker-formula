{%- from "docker/map.jinja" import docker with context %}

{%- set osfamily   = salt['grains.get']('os_family') %}
{%- set os         = salt['grains.get']('os') %}
{%- set osrelease  = salt['grains.get']('osrelease') %}
{%- set oscodename = salt['grains.get']('oscodename') %}

{%- if docker.manage_repo %}
docker_repo_pkgs:
  pkg.installed:
    - pkgs: {{ docker.repo_pkgs }}

  {%- if 'repo' in docker and docker.repo is mapping %}
docker_repo:
  pkgrepo.managed:
    {%- for k, v in docker.repo.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
    - retry:
        attempts: 3
        interval: 10
  {%- endif %}
    - require:
      - pkg: docker_repo_pkgs
{%- endif %}
