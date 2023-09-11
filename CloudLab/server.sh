#install packages
sudo apt update
sudo apt -y install iperf3
#sudo apt -y install moreutils
#install MPTCP Daemon
sudo apt -y install mptcpd
#install bmon
sudo apt -y install bmon

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

##Add IP address 192.1688.4.1 as a new MPTCP endpoint on the server:
#sudo ip mptcp endpoint add 192.168.4.1 dev $iface2 signal

#following https://medium.com/@iheb.zannina/setup-mptcpv1-in-linux-v5-6-9b5e48173b5b
#Set the total number of allowed sub-flows (whether they are initiated locally or by the peer) to 1. 
# 1 because In our case, we need just another one sub-flow for the WLAN interface. 
# This max number limit, depends on how much interfaces (a.k.a sub-flows) you gonna use besides your default interface.
sudo ip mptcp limits set subflow 1
sudo ip mptcp endpoint add 192.168.4.1 dev $iface2 subflow signal
# verify above step using sudo ip mptcp limit show

#Start the iperf3 server:
sudo iperf3 -s

######
# Verify that MPTCP is enabled in the kernel:
# sysctl -a | grep mptcp.enabled
# results in 'net.mptcp.enabled = 1'
