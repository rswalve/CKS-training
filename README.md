# CKS practice labs for Killercoda

These are **practice labs**, not a dump of exam answers.
Names match common CKS stems (ollama, secdep, clever-cactus, etc.) so you can drill the *skill*.
Hostnames like `cks001091` are ThinkMo sim artifacts — ignore them on Killercoda.

## How to run on Killercoda

1. Open a playground with a working cluster, ideally **Killer Shell CKS** or a two-node kubeadm lab.
2. Upload/clone this folder into the terminal (or paste files).
3. For each question:

```bash
cd qXX-*
./setup.sh
# do the task
./grade.sh
```

Or from the repo root:

```bash
./run-all-setup.sh q07   # only question 7
./run-all-grade.sh
```

## What works where

| Lab | Needs | Killercoda note |
|---|---|---|
| Q2 TLS, Q3 Dockerfile, Q4 /dev/mem, Q5 secctx, Q7 NetPol, Q8 Ingress, Q9 SA token, Q12 PSS, Q14 Istio objects | kubectl only | Works on almost any playground |
| Q1 kubelet/etcd, Q6 audit, Q15 ImagePolicy, Q16 API auth | edit static Pod / kubelet on control plane | Works on Killer Shell CKS / kubeadm node; skip on managed playgrounds |
| Q10 node upgrade | two nodes + package repos | Often **not** possible; script is grade-only |
| Q11 SPDX/bom | `bom` binary + alpine images | Grade checks file + container removal; bom may be missing |
| Q13 Docker daemon | docker + useradd | Many labs are containerd-only; script detects and SKIPs |

Official docs to keep open:
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
- https://kubernetes.io/docs/concepts/security/pod-security-standards/
- https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/
- https://kubernetes.io/docs/concepts/services-networking/network-policies/
- https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
- https://istio.io/docs/reference/config/security/peer_authentication/
