#
# You need to define

all:

KEY = $(CURRENT_DIR)/secrets/ssl/tls.key
CERT = $(CURRENT_DIR)/secrets/ssl/tls.crt
POD_NAME=$(shell kubectl get pods --namespace=ingress-nginx --output='json' | jq ".items | .[] | .metadata | select(.name | startswith(\"nginx-ingress-controller\")) | .name" | head -1 | sed 's/"//g')

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make deploy    - create resources from files"
	@echo "   2. make apply     - apply configurations to the resources"
	@echo "   3. make delete    - delete resources"
	@echo "   4. make describe  - show details of the resources"
	@echo "   5. make get       - display one or many resources"
	@echo "   6. make change	- change namespace"
	@echo ""

###############################################
#
# Deploy
#
###############################################
deploy:
	kubectl create -f mandatory.yaml --save-config
	@sleep 1
	kubectl create -f cloud-generic.yaml --save-config
	@sleep 1

###############################################
#
# Apply
#
###############################################
apply:
	kubectl apply -f mandatory.yaml --save-config
	kubectl apply -f cloud-generic.yaml --save-config

###############################################
#
# Delete
#
###############################################
delete:
	kubectl delete -f mandatory.yaml --force --ignore-not-found
	kubectl delete -f cloud-generic.yaml --force --ignore-not-found
	kubectl delete validatingwebhookconfiguration ingress-nginx-admission

###############################################
#
# Describe
#
###############################################
describe:
	@echo "---------------------------"
	@echo "---------------------------"

###############################################
#
# Get
#
###############################################
get:
	@echo "---------------------------"
	@echo "---------------------------"

###############################################
#
# Change Namespace
#
###############################################
change:
	kubectl config set-context $(shell kubectl config current-context) --namespace=ingress-nginx

###############################################
#
# Get logs from the pod
#
###############################################
logs:
	kubectl logs pod/$(POD_NAME) --namespace=ingress-nginx
