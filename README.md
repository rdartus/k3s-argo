
```
scp jeank@pirate:/home/jeank/.kube/config /home/jeank/.kube/config
kubectl logs svc/argocd-repo-server -n argocd  > argorepo.log
kubectl logs pod/speaker-stlm6 -n metallb-system > speaker.log
kubectl logs svc/webhook-service -n metallb-system > metallb.log

kubectl apply -k ~/k3s-argo/localApps/kusto-argo/
kubectl apply -k ~/k3s-argo/localApps

```