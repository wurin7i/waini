echo "⏳ Preparing system..."

sudo apt update
sudo apt install apt-transport-https curl git make -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Checking docker installation..."
sudo systemctl is-active docker
sudo docker --version

echo "Initializing Docker Swarm..."
sudo docker swarm init
sudo docker info | grep "Swarm"

sudo usermod -aG docker $USER

echo "🟢 System ready."
echo "Please log out and log back in to apply the group changes."
