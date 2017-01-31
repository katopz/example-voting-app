# Ref : https://docs.docker.com/engine/getstarted-voting-app/deploy-app/
# Just for perf, you can skip this.
START_SEC=$(date +'%s')

# Cleaning old manager and worker, you can skip this
docker-machine rm -f manager && docker-machine rm -f worker

# Create manager.
docker-machine create --driver virtualbox manager

# Promote manager.
docker-machine ssh manager "docker swarm init --advertise-addr $(docker-machine ip manager)"

# Create worker.
docker-machine create --driver virtualbox worker

# Promote worker.
docker-machine ssh worker "docker swarm join --token `docker $(docker-machine config manager) swarm join-token worker -q` $(docker-machine ip manager)"

# Get docker-stack.yml either from source code in the lab.
curl -o docker-stack.yml https://raw.githubusercontent.com/docker/example-voting-app/master/docker-stack.yml

# Copy docker-stack.yml to the manager.
docker-machine scp ./docker-stack.yml manager:/home/docker/.

# Deploy the application stack based on the `docker-stack.yml`.
docker-machine ssh manager "docker stack deploy --compose-file docker-stack.yml vote"

# Verify machines.
docker-machine ls

# See things running via browser.
open http://$(docker-machine ip manager):5000
open http://$(docker-machine ip manager):5001
open http://$(docker-machine ip manager):8080

# See how long does it take.
echo "Done in $(($(date +'%s') - $START_SEC)) seconds"