# Spinnaker salt formulas

Spinnaker is an open source, multi-cloud continuous delivery platform for releasing software changes with high velocity and confidence. This repository contains salt formulas and service-level metadata definition (in terms of MDA)

## Requirements

- Environment with at least 4 nodes: salt master and three minions
- Kubernetes, deployed with MK deployment procedure

## Deployment

1. Clone repository to the Salt master.
```
git clone https://gerrit.mcp.mirantis.net/oss/salt-formula-spinnaker
cd salt-formula-spinnaker
```
2. Configure service-level metadata inside *metadata/service/init.yaml*
3. Copy service-level metadata into reclass folder
```
SPINNAKER_SERVICE=/srv/salt/reclass/classes/service/spinnaker
mkdir $SPINNAKER_SERVICE -p
cp metadata/service/init.yaml $SPINNAKER_SERVICE
```
4. Copy salt-formulas into salt-formula path (*/srv/salt/env/prd* by default)
```
cp spinnaker /srv/salt/env/prd/ -R
```

5. Add *service.spinnaker* class to the one of the Kubernetes master nodes cluster-level definition.
*/srv/salt/reclass/classes/cluster/<your env>/infra/config.yml*
```
parameters:
  reclass:
    storage:
      node:
        kubernetes_control_node01:
          classes:
            - service.spinnaker
```

6. Update reclass
```
salt -C 'I@kubernetes:master' state.sls spinnaker
```

7. Run Spinnaker deployment
```
salt 'kubernetes_control_node01' state.sls spinnaker
```
8. Verify deployment
```
root@cfg01:/srv/salt/env/prd# kubectl get pods --namespace spinnaker
NAME                           READY     STATUS    RESTARTS   AGE
data-redis-master-v000-sp986   1/1       Running   0          1m
spin-clouddriver-v000-qv291    1/1       Running   0          1m
spin-deck-v000-t0vj1           1/1       Running   0          1m
spin-echo-v000-dpv47           1/1       Running   0          1m
spin-front50-v000-59dw5        1/1       Running   0          1m
spin-gate-v000-jqcbp           1/1       Running   0          1m
spin-igor-v000-5nwhm           1/1       Running   0          1m
spin-orca-v000-kkdxn           1/1       Running   0          1m
```
