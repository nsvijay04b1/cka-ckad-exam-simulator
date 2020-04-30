docker-compose -f docker-compose-builder.yaml down
docker rmi  cka-ckad-exam-lab cka-ckad-exam-gateone
docker-compose -f docker-compose-builder.yaml up -d

