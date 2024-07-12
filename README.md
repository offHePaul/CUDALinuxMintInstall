# CUDA Installation Script for Linux Mint

![CUDA](https://developer.nvidia.com/sites/default/files/akamai/cuda/logos/CUDA_logoset.png)

This repository contains a script to automate the installation of CUDA on Linux Mint. The script checks for necessary requirements, downloads the necessary files, and installs CUDA, ensuring a smooth setup process.

## Features

- Checks for a compatible NVIDIA GPU.
- Verifies if the system is x86_64.
- Ensures `gcc` is installed.
- Downloads and installs CUDA.
- Updates `.bashrc` with necessary environment variables.
- Provides a beautiful and animated user interface.

## Usage

1. **Clone the Repository**

    ```bash
    git clone https://github.com/offHePaul/CUDALinuxMintInstall.git
    cd CUDALinuxMintInstall
    ```

2. **Run the Script**

    ```bash
    chmod +x install_cuda.sh
    ./install_cuda.sh
    ```

    Follow the on-screen instructions. If you haven't rebooted your system after the initial setup, please do so when prompted.

3. **Post-Reboot Setup**

    After rebooting, rerun the script to update your `.bashrc` file and finalize the installation.

    ```bash
    ./install_cuda.sh
    ```

## Script Details

The script performs the following steps:

1. **Check for NVIDIA GPU**

    ```bash
    lspci | grep -i nvidia
    ```

2. **Verify System Architecture**

    ```bash
    uname -m
    ```

3. **Check for gcc Installation**

    ```bash
    gcc --version
    ```

4. **Download and Install CUDA**

    ```bash
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
    sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda-repo-ubuntu2404-12-5-local_12.5.1-555.42.06-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2404-12-5-local_12.5.1-555.42.06-1_amd64.deb
    sudo cp /var/cuda-repo-ubuntu2404-12-5-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-5
    ```

5. **Update .bashrc**

    ```bash
    export PATH=/usr/local/cuda-12.5/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/usr/local/cuda-12.5/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    ```

## Contributing

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions, please reach out via the GitHub repository or directly at [hepaul.dev@gmail.com](hepaul.dev@gmail.com).

---

Happy Coding! 🚀
