#!/bin/bash

# Function to get the package version
get_package_version() {
    local package_name="$1"
    dpkg -s "$package_name" | awk '/Version:/ {print $2}'
}

# Function to get available package versions
get_available_versions() {
    local package_name="$1"
    if ! versions=$(apt-cache show "$package_name" | awk '/Version:/ {print $2}' | head -n 3); then
        echo "无法获取软件包 $package_name 的信息。"
        exit 1
    fi
    echo "$versions"
}

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "请提供一个包含软件包信息的文本文件作为参数。"
    exit 1
fi

# Check if the input file is readable
if [ ! -r "$1" ]; then
    echo "无法读取文件 '$1'。"
    exit 1
fi

# Initialize counters
total_packages=0
installed_packages=0
not_installed_packages=0
packages_to_install=()

# Read the file line by line and check each package
while IFS= read -r package_name; do
    ((total_packages++))
    if dpkg -s "$package_name" >/dev/null 2>&1; then
        package_version=$(get_package_version "$package_name")
        echo "软件包 $package_name 已安装，版本为 $package_version。"
        ((installed_packages++))
    else
        package_available_versions=$(get_available_versions "$package_name")
        num_available_versions=$(echo "$package_available_versions" | wc -l)
        
        echo "软件包 $package_name 未安装。可用版本："
        if [ "$num_available_versions" -le 3 ]; then
            echo "$package_available_versions"
        else
            echo "$(echo "$package_available_versions" | head -n 3)..."
            echo "可用版本超过3个，请自行查看。"
        fi
        
        ((not_installed_packages++))
        packages_to_install+=("$package_name")
    fi
done < "$1"

# Output the results
echo -e "\n总共检测了 $total_packages 个软件包。其中 $installed_packages 个已经安装，$not_installed_packages 个未安装。"

if [ "$installed_packages" -gt 0 ]; then
    echo -e "\n已安装的软件包："
    for package in "${packages_to_install[@]}"; do
        echo "$package"
    done
fi

if [ "$not_installed_packages" -gt 0 ]; then
    echo -e "\n以下软件包未安装，您可以选择安装："
    for package in "${packages_to_install[@]}"; do
        echo "$package"
    done
    read -p "是否要安装这些软件包？[y/n] " choice
    case "$choice" in
      y|Y ) 
        echo "开始安装..."
        for package in "${packages_to_install[@]}"; do
            sudo apt-get install -y "$package"
        done
        ;;
      n|N ) 
        echo "放弃安装。"
        ;;
      * ) 
        echo "无效的选择，放弃安装。"
        ;;
    esac
fi
