# Determined AI

These instructions are for linux shell

- run a docker cluster https://docs.determined.ai/latest/cluster-setup-guide/deploy-cluster/sysadmin-deploy-on-prem/docker.html
- install the CLI/docker https://docs.determined.ai/latest/cluster-setup-guide/deploy-cluster/sysadmin-deploy-on-prem/requirements.html

# How to run

```
export UID
make up
```

to see the cluster logs run

```
make logs_tail
```


## Alternative as manually described on docs

The above is based on docker-compose ... 
As a comparison you can run the on-prem-bootup.sh

this script does exactly what the documentation of the on premises docker run steps documentation suggests.

After running the containers I run 

```
DET_MASTER=localhost:8080
det cmd run nvidia-smi
```
see the failure results in [runLog202303272300](runLog/runLog202303272300.md)

