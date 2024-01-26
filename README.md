
WSL Conf
``` zsh
cd ~/code/jeanpi/ && sudo docker compose down && cp ~/config/radarr/radarr.db ~/tmp/radarr.db && cp ~/config/sonarr/sonarr.db ~/tmp/sonarr.db && cp ~/config/prowlarr/prowlarr.db ~/tmp/prowlarr.db && cd ~/code/jeanpi/ && sudo docker compose up -d

scp jeank@192.168.1.32:/home/jeank/.kube/config /home/jeank/.kube/config
scp jeank@192.168.1.16:/home/jeank/tmp/prowlarr.db /home/jeank/k3s-argo/db/prowlarr.db
scp jeank@192.168.1.16:/home/jeank/tmp/radarr.db /home/jeank/k3s-argo/db/radarr.db
scp jeank@192.168.1.16:/home/jeank/tmp/sonarr.db /home/jeank/k3s-argo/db/sonarr.db
scp /home/jeank/k3s-argo/db/prowlarr.db jeank@192.168.1.32:/home/jeank/k3s-argo/db/prowlarr.db
scp /home/jeank/k3s-argo/db/radarr.db jeank@192.168.1.32:/home/jeank/k3s-argo/db/radarr.db
scp /home/jeank/k3s-argo/db/sonarr.db jeank@192.168.1.32:/home/jeank/k3s-argo/db/sonarr.db
sed -i 's/127.0.0.1/192.168.1.32/g' ~/.kube/config
```

Deploy JeanKluter & K3S : 
``` zsh
kubectl apply -k ~/k3s-argo/localApps/kusto-argo/
kubectl apply -k ~/k3s-argo/localApps
sudo k3s ctl images import k3s-argo/pgloader.tar
```
Vault Conf :
```zsh
mkdir ~/cred
sudo chown jeank:1000 cred
kubectl exec -it vault-0 -- /bin/sh vault auth enable kubernetes
kubectl exec -it vault-0 -- /bin/sh vault operator init -key-shares=3 -key-threshold=2
kubectl exec -it vault-0 -- /bin/sh vault operator
```

Get logs
```zsh
kubectl logs svc/argocd-server -n argocd  > argo.log
kubectl logs svc/argocd-repo-server -n argocd  > argorepo.log
kubectl logs svc/webhook-service -n metallb > metallb.log
kubectl logs pod/speaker-stlm6 -n metallb > speaker.log
```

Delete :
```
kubectl delete pod -l app.kubernetes.io/component=speaker -n metallb
```
