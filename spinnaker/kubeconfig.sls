{%- from "spinnaker/map.jinja" import master with context %}

generate_kubeconfig:
  cmd.run:
    - name: sed "s@/etc/kubernetes/ssl@/root/.kubecreds@"
                 /etc/kubernetes/kubelet.kubeconfig > /etc/kubernetes/spinnaker.kubeconfig
    - unless: test -f /etc/kubernetes/spinnaker.kubeconfig

create_spinnaker_namespace:
  cmd.run:
    - name: hyperkube kubectl create namespace spinnaker
    - unless: hyperkube kubectl get namespaces spinnaker

spin_config_secret:
  cmd.run:
    - name: kubectl create secret generic spinnaker-config
            --from-file={{ master.conf_dir }}/config/.
            --namespace=spinnaker
    - unless: kubectl get secrets spinnaker-config --namespace spinnaker

kube_config_secret:
  cmd.run:
    - name: kubectl create secret generic kubernetes-config
            --from-file=/etc/kubernetes/ssl/ca-kubernetes.crt
            --from-file=/etc/kubernetes/ssl/kubelet-client.crt
            --from-file=/etc/kubernetes/ssl/kubelet-client.key
            --namespace=spinnaker
    - unless: kubectl get secrets kubernetes-config --namespace spinnaker

kube_config_creds:
  cmd.run:
    - name: kubectl create secret generic creds-config
            --from-file=/etc/kubernetes/spinnaker.kubeconfig
            --namespace=spinnaker
    - unless: kubectl get secrets creds-config --namespace spinnaker

