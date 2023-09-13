#install packages
sudo apt update
sudo apt -y install iperf3
#sudo apt -y install moreutils
#install MPTCP Daemon
sudo apt -y install mptcpd
#install python 
sudo apt install python-is-python3
#install bmon
sudo apt -y install bmon
#install nload
sudo apt -y install nload

##Download iproute2 package
## Add the following
#sudo apt -y install bison
#sudo apt -y install flex
#sudo apt -y install pkg-config
#sudo wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/iproute2/5.15.0-1ubuntu2/iproute2_5.15.0.orig.tar.xz
##Extract content
#sudo tar -xf iproute2_5.15.0.orig.tar.xz
#cd iproute2-5.15.0/
#sudo make
#cd

##Follow the following page 
## https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/getting-started-with-multipath-tcp_configuring-and-managing-networking
#sudo apt -y install systemtap
#echo "net.mptcp.enabled=1" | sudo tee /etc/sysctl.d/90-enable-MPTCP.conf
#sudo sysctl -p /etc/sysctl.d/90-enable-MPTCP.conf

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

#mimicing https://medium.com/high-performance-network-programming/how-to-setup-and-configure-mptcp-on-ubuntu-c423dbbf76cc
# Configure routing rules (the mimicing part is the similar configuration btw client and server)
sudo ip rule add from 192.168.3.1 table 1 
sudo ip rule add from 192.168.4.1 table 2 
sudo ip route add 192.168.3.0/24 dev $iface1 scope link table 1
sudo ip route add 192.168.4.0/24 dev $iface2 scope link table 2 
sudo ip route add 192.168.10.0/24 via 192.168.3.2 dev $iface1 table 1 
sudo ip route add 192.168.20.0/24 via 192.168.4.2 dev $iface2 table 2

##Add IP address 192.1688.4.1 as a new MPTCP endpoint on the server:
#sudo ip mptcp endpoint add 192.168.4.1 dev $iface2 signal

#following https://medium.com/@iheb.zannina/setup-mptcpv1-in-linux-v5-6-9b5e48173b5b
#Set the total number of allowed sub-flows (whether they are initiated locally or by the peer) to 1. 
# 1 because In our case, we need just another one sub-flow for the WLAN interface. 
# This max number limit, depends on how much interfaces (a.k.a sub-flows) you gonna use besides your default interface.
#sudo sysctl net.mptcp.enabled
#sudo ip mptcp limits set add_addr_accepted 1
#sudo ip mptcp limits set subflow 2
sudo ip mptcp limits set subflow 2 add_addr_accepted 2
sudo ip mptcp endpoint add 192.168.4.1 dev $iface1 subflow signal
# verify above step using sudo ip mptcp limit show

#testing a download 
#serve a big file
mkdir test
cd test
#do the below manually for testing
#sudo dd if=/dev/zero of=upload_test bs=1M count=10000000
#sudo mptcpize run python -m http.server 8000
#sudo ip mptcp monitor
cd
#Start the iperf3 server:
###sudo iperf3 -s

######
# Verify that MPTCP is enabled in the kernel:
# sysctl -a | grep mptcp.enabled
# results in 'net.mptcp.enabled = 1'
