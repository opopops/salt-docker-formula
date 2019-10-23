{%- from "docker/map.jinja" import docker with context %}

include:
  - docker.service

{%- for repo, params in docker.get('images', {}).get('absent', {}).items() %}
docker_image_{{repo}}:
  docker_image.absent:
    - name: {{repo}}
{%- endfor %}

{%- for repo, params in docker.get('images', {}).get('present', {}).items() %}
docker_image_{{repo}}:
  docker_image.present:
    - name: {{repo}}
    {%- for k, v in params.items() %}
      {%- if k not in ['aliases'] %}
    - {{k}}: {{v}}
      {%- endif %}
    {%- endfor %}

  {%- for alias in params.get('aliases', []) %}
docker_image_alias_{{repo}}_{{alias}}:
  module.run:
    - docker.tag:
      - name: {{repo}}:{{params.tag}}
      - repository: {{repo}}
      - tag: {{alias}}
    - require:
      - docker_image: docker_image_{{repo}}
  {%- endfor %}
{%- endfor %}
