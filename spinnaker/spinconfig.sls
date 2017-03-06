{%- from "spinnaker/map.jinja" import master, clouddriver with context %}

spin_config_dir:
  file.directory:
  - name: {{ master.conf_dir }}/config
  - user: root
  - group: root
  - mode: 750
  - makedirs: True

{% set custom_service_config = ['clouddriver', 'echo', 'front50', 'gate', 'igor', 'rosco', 'orca'] %}
{%- for service in custom_service_config %}
{{ service }}_config:
  file.managed:
    - name: {{ master.conf_dir }}/config/{{ service }}.yaml
    - source: salt://spinnaker/files/config/{{ service }}.yaml
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

