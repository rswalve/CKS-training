# Playground is at https://killercoda.com/

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

Q1. Fix Kubelet and Etcd Security Issues 

When running the CIS benchmark tool on a cluster created by kubeadm, multiple issues requiring immediate resolution were found.
Task
Fix all issues through configuration and restart affected components to ensure new settings take effect.

*After editing, reload the configuration file and resart kubelet:
    systemctl daemon-reload
    systemctl restart kubelet

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

Q2. TLS Secret

You must secure access to the web server using SSL files stored in a TLS Secret.
Task
Create a TLS Secret named `clever-cactus` in the `clever-cactus` namespace for the existing Deployment named `clever-cactus`.

