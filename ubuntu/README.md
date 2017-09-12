# Ubuntu Demo
This directory has scripts for quickly deploying to Ubuntu.

- Spin up a 4GB VPS (with adequate storage)
- SSH into VPS
- `git clone https://github.com/sitch-io/demo.git sitch-demo && cd sitch-demo`
- Edit environment variables in `.env`
- `cd ubuntu && sudo bash run.sh``

The script will pause for several inputs:

- configuring Let's Encrypt (choose `standalone` mode and provide your domain name(s))
- prompting the user to record the generated Vault keys and root token
- prompting the user for some of the Vault keys, and eventually the root token
