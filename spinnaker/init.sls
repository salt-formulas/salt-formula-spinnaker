{%- if pillar.spinnaker is defined %}
include:
  - spinnaker.spinconfig
  - spinnaker.kubeconfig
  - spinnaker.setup
{%- endif %}

