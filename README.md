
WSL Conf
``` zsh
scp jeank@192.168.1.32:/home/jeank/.kube/config /home/jeank/.kube/config
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
