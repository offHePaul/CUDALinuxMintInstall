#!/bin/bash

# Function to show a loading animation
function show_loading {
  pid=$!
  spin='-\|/'
  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r${spin:$i:1}"
    sleep .1
  done
  printf "\r"
}

# Function to print success message
function print_success {
  echo -e "[ \e[32m✓\e[0m ] $1"
}

# Check if the user has rebooted after initial setup
read -p "Have you rebooted your system after the initial CUDA setup? (y/n): " rebooted
if [[ "$rebooted" == "y" || "$rebooted" == "Y" ]]; then
  echo "Updating .bashrc with CUDA paths..."
  {
    echo 'export PATH=/usr/local/cuda-12.5/bin${PATH:+:${PATH}}'
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.5/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}'
  } >> ~/.bashrc
  source ~/.bashrc
  print_success ".bashrc updated with CUDA paths"
  echo "Please restart your terminal and type 'nvcc --version' to verify the installation."
  exit 0
fi

# Check for compatible NVIDIA GPU
echo "Checking for compatible NVIDIA GPU..."
(lspci | grep -i nvidia > /dev/null) & show_loading
if [[ $? -eq 0 ]]; then
  print_success "NVIDIA GPU found"
else
  echo "[ x ] No NVIDIA GPU found. Exiting..."
  exit 1
fi

# Check for x86_64 architecture
echo "Checking if the system is x86_64..."
if [[ $(uname -m) == "x86_64" ]]; then
  print_success "System is x86_64"
else
  echo "[ x ] System is not x86_64. Exiting..."
  exit 1
fi

# Check if gcc is installed
echo "Checking if gcc is installed..."
(gcc --version > /dev/null) & show_loading
if [[ $? -eq 0 ]]; then
  print_success "gcc is installed"
else
  echo "[ x ] gcc is not installed. Please install gcc and try again. Exiting..."
  exit 1
fi

# Downloading and installing CUDA
echo "Downloading CUDA repository pin..."
(wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin -q) & show_loading
print_success "CUDA repository pin downloaded"

echo "Moving CUDA repository pin to /etc/apt/preferences.d/..."
(sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600) & show_loading
print_success "CUDA repository pin moved"

echo "Downloading CUDA repository installer..."
(wget https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda-repo-ubuntu2404-12-5-local_12.5.1-555.42.06-1_amd64.deb -q) & show_loading
print_success "CUDA repository installer downloaded"

echo "Installing CUDA repository..."
(sudo dpkg -i cuda-repo-ubuntu2404-12-5-local_12.5.1-555.42.06-1_amd64.deb) & show_loading
print_success "CUDA repository installed"

echo "Copying CUDA keyring..."
(sudo cp /var/cuda-repo-ubuntu2404-12-5-local/cuda-*-keyring.gpg /usr/share/keyrings/) & show_loading
print_success "CUDA keyring copied"

echo "Updating package lists..."
(sudo apt-get update -qq) & show_loading
print_success "Package lists updated"

echo "Installing CUDA toolkit..."
(sudo apt-get -y install cuda-toolkit-12-5 -qq) & show_loading
print_success "CUDA toolkit installed"

echo "Please reboot your system and rerun this script to complete the installation."
