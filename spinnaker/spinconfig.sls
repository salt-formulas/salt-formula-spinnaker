{%- from "spinnaker/map.jinja" import master, clouddriver with context %}

copy_static_config:
  file.recurse:
    - name: {{ master.conf_dir }}/config
    - source: salt://spinnaker/files/config
    - exclude_pat: E@local

{% set custom_service_config = ['clouddriver', 'spinnaker', 'echo', 'front50', 'gate', 'igor', 'rosco', 'orca'] %}
{%- for service in custom_service_config %}
{{ service }}_config:
  file.managed:
    - name: {{ master.conf_dir }}/config/{{ service }}-local.yaml
    - source: salt://spinnaker/files/config/{{ service }}-local.yaml
    - template: jinja
{%- endfor %}

copy_svcs_config:
  file.recurse:
    - name: {{ master.conf_dir }}/svcs
    - source: salt://spinnaker/files/svcs

spin_deployment_dir:
  file.directory:
  - name: {{ master.conf_dir }}/deployments
  - user: root
  - group: root
  - mode: 750
  - makedirs: True

{% set deployments = ['redis-server', 'clouddriver', 'deck', 'echo', 'front50', 'gate', 'igor', 'orca'] %}
{%- for deployment in deployments %}
{{ deployment }}_spin:
  file.managed:
    - name: {{ master.conf_dir }}/deployments/{{ deployment }}.yaml
    - source: salt://spinnaker/files/deployments/{{ deployment }}.yaml
    - template: jinja
{%- endfor %}

