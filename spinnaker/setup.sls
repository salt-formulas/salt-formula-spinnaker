{%- from "spinnaker/map.jinja" import master with context %}

create_spinnaker_services:
  cmd.run:
    - name: hyperkube kubectl apply -f {{ master.conf_dir }}/svcs --record=true

create_spinnaker_deployments:
  cmd.run:
    - name: hyperkube kubectl apply -f {{ master.conf_dir }}/deployments --record=true
