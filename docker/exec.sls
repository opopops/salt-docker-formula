{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.container

{%- for container, cmds in docker.get('exec', {}).items() %}
  {%- for cmd in cmds %}
docker_exec_{{container}}_{{loop.index}}:
  cmd.run:
    {%- if 'env' in cmd.keys() %}
    - env: {{cmd.env}}
    {%- endif %}
    - name: docker exec {{cmd.get('args', '')}} {{container}} {{cmd.name}}
    {%- if 'unless' in cmd.keys() %}
    - unless: docker exec {{cmd.get('args', '')}} {{container}} {{cmd.unless}}
    {%- endif %}
    {%- if 'onlyif' in cmd.keys() %}
    - onlyif: docker exec {{cmd.get('args', '')}} {{container}} {{cmd.onlyif}}
    {%- endif %}
  {%- endfor %}
{%- endfor %}
