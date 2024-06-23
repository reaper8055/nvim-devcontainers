# Now there's are couple of things remaining:

0. Check if the dockerfile can be hosted in reaper8055/dev-container repo
1. Sync docker volume files to host 
2. Create a docker-compose that does the following:
   - Use reaper8055/dev-container:latest image
   - Create a docker volume and copy the Project files
3. Create a neovim plugin in lua which does the following:
   - At neovim start check if a .devcontainer directory exists within project
   root (or workspace) containing docker-compose.yml
   - If so run the container as per docker-compose definition and load neovim
   from the container in the same buffer.
