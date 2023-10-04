echo "Getting frontend service address"
sleep 20s
export ENV_ID=$1
export frontend=$(kubectl get service web-$ENV_ID -n torque-sandboxes --no-headers | awk '{print $4}')

echo $frontend
