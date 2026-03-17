#!/bin/bash

# Start a tmux server process
tmux -2 -u start-server

echo "Tmux server started in session 'main'."
echo "Connect using: podman exec -it <container_id> tmux attach -t main"

# Instead of tail, we use a loop that stays alive
# This allows the container to receive signals properly
exec sleep infinity
