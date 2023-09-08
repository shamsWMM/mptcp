# install packages
sudo apt update
sudo apt -y install iperf3
sudo apt -y install moreutils

# Below commented lines are no longer useful for linux kernel 5.15
# run sysctl commands to enable mptcp
# sudo sysctl -w net.mptcp.mptcp_enabled=1
# sudo sysctl -w net.mptcp.mptcp_checksum=0

#Instead add the following
sudo apt -y install bison
#Download iproute2 package
sudo wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/iproute2/5.15.0-1ubuntu2/iproute2_5.15.0.orig.tar.xz
#Extract content
sudo tar -xf iproute2_5.15.0.orig.tar.xz
cd iproute2-5.15.0/
sudo make

# load and configure mptcp congestion control algorithms
sudo modprobe mptcp_balia 
sudo sysctl -w net.ipv4.tcp_congestion_control=balia

######################################################
# remove Cloudlab created automatically added routes
######################################################
iface1=$(ifconfig | grep -B1 "inet 192.168.3.1" | head -n1 | cut -f1 -d:)
iface2=$(ifconfig | grep -B1 "inet 192.168.4.1" | head -n1 | cut -f1 -d:)
ifaceC=$(ifconfig | grep -B1 "inet " | head -n1 | cut -f1 -d:) 

# bring both interfaces of the client node down and then up
sudo ifconfig $iface1 down; sudo ifconfig $iface1 up 
sudo ifconfig $iface2 down; sudo ifconfig $iface2 up

# add the new routes manually 
sudo route add -net 192.168.10.0/24 gw 192.168.3.2 
sudo route add -net 192.168.20.0/24 gw 192.168.4.2
