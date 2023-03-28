# start postgres

docker run -d --rm \
    --name determined-db \
    -p 5432:5432 \
    -v determined_db:/var/lib/postgresql/data \
    -e POSTGRES_DB=determined \
    -e POSTGRES_PASSWORD=determined \
    postgres:10

sleep 5

postgres_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' determined-db)"

/bin/bash bin/wait-for-it.sh $postgres_ip:5432

echo "determined_db running on IP: $postgres_ip"

# run master
docker run -d --rm \
    --name determined-master \
    -p 8080:8080 \
    -e DET_DB_HOST="$postgres_ip" \
    -e DET_DB_NAME=determined \
    -e DET_DB_PORT=5432 \
    -e DET_DB_USER=postgres \
    -e DET_DB_PASSWORD=determined \
    determinedai/determined-master:0.20.1

sleep 5

master_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' determined-master)"

/bin/bash bin/wait-for-it.sh $master_ip:8080

echo "determined-master running on IP: $master_ip"

# run agent
docker run -d --rm --gpus=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name determined-agent \
    -e DET_MASTER_HOST="$master_ip" \
    -e DET_MASTER_PORT=8080 \
    determinedai/determined-agent:0.20.1
