echo "Getting url service address"
# sleep 30
export RELEASE_NAME=$1
export NAMESPACE=$2
export url=$(kubectl get service -n $NAMESPACE | grep $RELEASE_NAME | grep LoadBalancer | awk '{print $1}' | xargs kubectl get service -n $NAMESPACE --no-headers | awk '{print $4}')

echo url=$url