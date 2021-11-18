USER_NAME='user'

# Update

apt update -y
apt upgrade -y


# QEMU

apt install qemu-kvm qemu libvirt-daemon-system libvirt-clients bridge-utils -y

adduser $USER_NAME libvirt
adduser $USER_NAME kvm
systemctl enable --now libvirtd

mkdir /ISOs
virsh pool-define-as ISOs dir - - - - "/ISOs"
virsh pool-build ISOs
virsh pool-autostart ISOs
virsh pool-start ISOs

# Tailscale

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list

apt update -y
apt install tailscale -y

tailscale up


# Cockpit

. /etc/os-release
apt install -t ${VERSION_CODENAME}-backports cockpit cockpit-machines pcp cockpit-pcp packagekit -y