{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service
  - docker.compose.install

{%- for project, params in docker.compose.get('projects', {}).items() %}

docker_compose_project_{{project}}_directory:
  file.directory:
    - name: {{params.path}}
    {%- if params.get('user', False) %}
    - user: {{params.user}}
    {%- endif %}
    {%- if params.get('group', False) %}
    - group: {{params.group}}
    {%- endif %}

  {%- if params.source.split('.')|last == 'git' %}
docker_compose_project_{{project}}_source:
  git.latest:
    - name: {{params.source}}
    - target: {{params.path}}
    {%- if params.get('branch', False) %}
    - branch: {{params.branch}}
    {%- endif %}
    {%- if params.get('rev', False) %}
    - rev: {{params.rev}}
    {%- endif %}
    {%- if params.get('user', False) %}
    - user: {{params.user}}
    {%- endif %}
    - require:
      - file: docker_compose_project_{{project}}_directory
    {%- if params.get('retry', False) %}
    - retry:
        attempts: 3
        interval: 30
    {%- endif %}
  {%- elif params.source.split('.')|last in ['gz', 'tgz', 'zip'] %}
docker_compose_project_{{project}}_source:
  archive.extracted:
    - name: {{params.path}}
    - source: {{params.source}}
    {%- if params.get('source_hash', False) %}
    - source_hash: {{params.source_hash}}
    {%- endif %}
    {%- if params.get('user', False) %}
    - user: {{params.user}}
    {%- endif %}
    {%- if params.get('group', False) %}
    - group: {{params.group}}
    {%- endif %}
    {%- if params.get('archive_options', False) %}
    - options: {{params.archive_options}}
    {%- endif %}
    - enforce_toplevel: False
    - force: True
    - trim_output: True
    - require:
      - file: docker_compose_project_{{project}}_directory
    {%- if params.get('retry', False) %}
    - retry:
        attempts: 3
        interval: 30
    {%- endif %}
  {%- else %}
docker_compose_project_{{project}}_source:
  file.recurse:
    - name: {{params.path}}
    - source: {{params.source}}
    - template: jinja
    {%- if params.get('source_hash', False) %}
    - source_hash: {{params.source_hash}}
    {%- endif %}
    {%- if params.get('user', False) %}
    - user: {{params.user}}
    {%- endif %}
    {%- if params.get('group', False) %}
    - group: {{params.group}}
    {%- endif %}
    - require:
      - file: docker_compose_project_{{project}}_directory
  {%- endif %}
  {%- if params.get('retry', False) %}
    - retry:
        attempts: 3
        interval: 30
  {%- endif %}

  {% for command in params.get('commands', []) %}
docker_compose_project_{{project}}_command_{{loop.index}}:
  cmd.run:
    - name: docker-compose {{command.name}}
    {%- if command.get('cwd', False) %}
    - cwd: {{command.cwd}}
    {%- endif %}
    {%- if command.get('runas', False) %}
    - runas: {{command.runas}}
    {%- endif %}
    {%- if params.source.split('.')|last == 'git' %}
    - require:
      - git: docker_compose_project_{{project}}_source
    {%- elif params.source.split('.')|last in ['gz', 'tgz', 'zip'] %}
    - require:
      - archive: docker_compose_project_{{project}}_source
    {%- else %}
    - require:
      - file: docker_compose_project_{{project}}_source
    {%- endif %}
    {%- if command.get('retry', False) %}
    - retry:
        attempts: 3
        interval: 30
    {%- endif %}
  {%- endfor %}

{%- endfor %}
