#!/bin/bash
# uninstall.sh - Uninstall monitoring stack

helm uninstall prometheus -n monitoring
helm uninstall loki -n monitoring
kubectl delete namespace monitoring