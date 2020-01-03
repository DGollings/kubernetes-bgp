#!/bin/bash

# source: https://docs.projectcalico.org/v3.11/getting-started/kubernetes/hardway/istio-integration#installing-istio

set -x

export CALICO_DATASTORE_TYPE=kubernetes
export CALICO_KUBECONFIG=/root/.kube/config
calicoctl get felixconfiguration default --export -o yaml | \
sed -e '/  policySyncPathPrefix:/d' \
    -e '$ a\  policySyncPathPrefix: /var/run/nodeagent' > felix-config.yaml
calicoctl apply -f felix-config.yaml

cd /root
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.4.2 sh -
cd $(ls -d istio-*)
cp bin/istioctl /usr/local/sbin/
istioctl manifest apply --set profile=demo

curl https://raw.githubusercontent.com/projectcalico/calico/v3.11.1/master/manifests/alp/istio-inject-configmap-1.4.2.yaml -o istio-inject-configmap.yaml
kubectl patch configmap -n istio-system istio-sidecar-injector --patch "$(cat istio-inject-configmap.yaml)"
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/alp/istio-app-layer-policy.yaml

kubectl label namespace default istio-injection=enabled

# REMOVE
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
#/ REMOVE