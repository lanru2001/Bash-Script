#!/bin/bash

# Check if Istio is installed
if kubectl get ns istio-system > /dev/null 2>&1; then
    echo "Istio is already installed."
    exit 0
else
    echo "Istio is not installed. Installing..."

    #create istio-system namespace 
    kubectl create namespace istio-system

    # Install Istio using istioctl
    istioctl install - set profile=default - set values.gateways.istio-ingressgateway.type=NodePort - set meshConfig.outboundTrafficPolicy.mode=ALLOW_ANY - set meshConfig.accessLogFile=/dev/stdout -y         

    # Check if Istio installation is successful
    if kubectl get ns istio-system > /dev/null 2>&1; then
       echo "Istio installation successful."
       exit 0
    else
        echo "Failed to install Istio."
        exit 1
    fi
fi
echo "Script Complete, Exiting"

