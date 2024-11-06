#distrobox --detach enter ubuntu
distrobox-enter ubuntu -- ollama serve &
sudo docker run -d --network=host --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

