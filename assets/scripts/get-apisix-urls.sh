echo "Getting url service address"
# sleep 30
export RELEASE_NAME=$1
export NAMESPACE=$2
export dashboard=$(kubectl get service -n $NAMESPACE | grep "$RELEASE_NAME-dashboard" | grep LoadBalancer | awk '{print $1}' | xargs kubectl get service -n $NAMESPACE --no-headers | awk '{print $4}')
export data_plane=$(kubectl get service -n $NAMESPACE | grep "$RELEASE_NAME-data-plane" | grep LoadBalancer | awk '{print $1}' | xargs kubectl get service -n $NAMESPACE --no-headers | awk '{print $4}')

echo dashboard=$dashboard
echo data_plane=$data_plane