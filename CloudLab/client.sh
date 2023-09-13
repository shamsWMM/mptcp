#install packages
sudo apt update
sudo apt -y install iperf3
sudo apt -y install nload
#Download iproute2 package
# Add the following
sudo apt -y install bison
sudo apt -y install flex
sudo apt -y install pkg-config
sudo wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/iproute2/5.15.0-1ubuntu2/iproute2_5.15.0.orig.tar.xz
#Extract content
sudo tar -xf iproute2_5.15.0.orig.tar.xz
cd iproute2-5.15.0/
sudo make
cd

#Follow the following page 
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/getting-started-with-multipath-tcp_configuring-and-managing-networking
sudo apt -y install systemtap
echo "net.mptcp.enabled=1" | sudo tee /etc/sysctl.d/90-enable-MPTCP.conf
sudo sysctl -p /etc/sysctl.d/90-enable-MPTCP.conf
# Configure the client to accept up to 1 additional remote address, as provided by the server:
sudo ip mptcp limits set add_addr_accepted 1


# get control and experiment interface names
iface1=$(ifconfig | grep -B1 "inet 192.168.10.2" | head -n1 | cut -f1 -d:)
iface2=$(ifconfig | grep -B1 "inet 192.168.20.2" | head -n1 | cut -f1 -d:)
ifaceC=$(ifconfig | grep -B1 "inet " | head -n1 | cut -f1 -d:) 

# remove Cloudlab created automatically added routes: bring both interfaces of the client node down and then up
sudo ifconfig $iface1 down; sudo ifconfig $iface1 up 
sudo ifconfig $iface2 down; sudo ifconfig $iface2 up

# add the new routes manually 
sudo route add -net 192.168.3.0/24 gw 192.168.10.1 
sudo route add -net 192.168.4.0/24 gw 192.168.20.1

# disable mptcp on control interface and enable in the experiment interfaces
sudo ip link set dev $ifaceC multipath off 
sudo ip link set dev $iface1 multipath on 
sudo ip link set dev $iface2 multipath on 

# Configure routing rules
sudo ip rule add from 192.168.10.2 table 1 
sudo ip rule add from 192.168.20.2 table 2 
sudo ip route add 192.168.10.0/24 dev $iface1 scope link table 1
sudo ip route add 192.168.20.0/24 dev $iface2 scope link table 2 
sudo ip route add 192.168.3.0/24 via 192.168.10.1 dev $iface1 table 1 
sudo ip route add 192.168.4.0/24 via 192.168.20.1 dev $iface2 table 2

# Connect the client to the server:
sudo iperf3 -c 192.168.3.1 -t 3
