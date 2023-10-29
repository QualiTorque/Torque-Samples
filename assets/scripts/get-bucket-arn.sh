echo "Getting frontend service address"
sleep 30s
export BUCKET_NAME=$1
export bucket_arn=$(kubectl get Bucket $BUCKET_NAME -o jsonpath="{.status.atProvider.arn}")

echo $bucket_arn
