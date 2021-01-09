docker build -t dflack/multi-client:latest -t dflack/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t dflack/multi-worker:latest -t dflack/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker
docker build -t dflack/multi-server:latest -t dflack/multi-server:$GIT_SHA -f ./server/Dockerfile ./server

docker push dflack/multi-client:latest
docker push dflack/multi-worker:latest
docker push dflack/multi-server:latest

docker push dflack/multi-client:$GIT_SHA
docker push dflack/multi-worker:$GIT_SHA
docker push dflack/multi-server:$GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/api-deployment api=dflack/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment frontend=dflack/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=dflack/multi-worker:$GIT_SHA