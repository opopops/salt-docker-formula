
{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.install

{%- for registry, auth in docker.get('login', {}).items() %}
docker_login_{{registry}}:
  file.managed:
    - name: /tmp/.{{registry}}
    - contents: |
        {{auth.password|indent(8)}}
    - mode: 600
    - show_changes: False
    - contents_newline: False
  cmd.run:
    - name: cat /tmp/.{{registry}} | docker login --username {{auth.user}} --password-stdin {{registry}} ; rm -f /tmp/.{{registry}}
{%- endfor %}
