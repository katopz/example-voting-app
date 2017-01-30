Ref : https://docs.docker.com/engine/getstarted-voting-app/deploy-app/

# Create manager.
docker-machine create --driver virtualbox manager

#  Create worker.
docker-machine create --driver virtualbox worker

# Verify machines are running and get IP addresses.
docker-machine ls

# Copy yml
docker-machine scp ./docker-stack.yml manager:/home/docker/.

# Getting in
docker-machine ssh manager

# Run
docker stack deploy --compose-file docker-stack.yml vote