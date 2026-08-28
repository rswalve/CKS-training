#!/usr/bin/env bash
echo "==> Q10 setup: no mutation. Run: kubectl get nodes"
kubectl get nodes -o wide
echo "Target: worker kubelet version == control-plane kubelet version"
