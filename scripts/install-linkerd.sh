#!/bin/bash

set -v
set -e

curl -sL https://run.linkerd.io/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin
echo export 'PATH=$PATH:$HOME/.linkerd2/bin' >> /root/.bashrc

# simple retry
set +e
for i in {0..10}; do 
    linkerd check --pre
done
set -e
linkerd install | kubectl apply -f -
linkerd check