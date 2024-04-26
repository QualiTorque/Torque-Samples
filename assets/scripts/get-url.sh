echo "Getting url service address"
sleep 30s
export RELEASE_NAME=$1
export NAMESPACE=$2
export url=$(kubectl get service $RELEASE_NAME -n $NAMESPACE --no-headers | awk '{print $4}')

echo $url