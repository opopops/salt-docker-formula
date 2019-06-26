
{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for registry, auth in docker.get('login', {}).items() %}
  {%- if auth.get('method', 'docker') == 'aws' %}
docker_login_{{registry}}:
  cmd.run:
    - runas: {{auth.get('runas', 'root')}}
    - env: {{auth.env}}
    - name: $(aws ecr get-login --region $AWS_REGION --no-include-email)
    - require:
      - pkg: docker_package
      {%- if docker.get('manage_awscli', False) %}
      - pip: docker_awscli_pip_package
      {%- endif %}
  {%- else %}
docker_login_{{registry}}:
  file.managed:
    - name: /tmp/.{{registry}}
    - contents: |
        {{auth.password|indent(8)}}
    - user: {{auth.get('runas', 'root')}}
    - mode: 600
    - show_changes: False
    - contents_newline: False
  cmd.run:
    - runas: {{auth.get('runas', 'root')}}
    - name: cat /tmp/.{{registry}} | docker login --username {{auth.user}} --password-stdin {{registry}} ; rm -f /tmp/.{{registry}}
    - require:
      - pkg: docker_package
  {%- endif %}
{%- endfor %}
