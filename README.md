Package Checker and Installer Script

This script is designed to read a text file containing package names and check whether each package is installed on the system. If a package is not installed, the script provides available versions and gives the option to install the packages.

Usage

1. Clone the repository or download the script directly.
2. Make sure the script has executable permissions. If not, you can provide the permissions using the following command:
   chmod +x package_checker_installer.sh
3. Run the script with a text file containing package names as an argument, like this:
   ./package_checker_installer.sh package_list.txt
   Make sure the package list file contains one package name per line.
4. Follow the prompts to choose whether to install the listed packages.

Requirements

- This script requires 'bash' to run.
- It uses 'apt-cache', 'dpkg', and 'apt-get' to check and install packages, so it is primarily intended for Debian-based Linux distributions.

Notes

- The script provides a list of packages that are not installed and offers the option to install them.
- Make sure to run the script with appropriate permissions, especially when using 'apt-get' to install packages.

Disclaimer

Use this script at your own risk. The author is not responsible for any damage or issues caused by the script.

# ubuntu_package_detection_script
