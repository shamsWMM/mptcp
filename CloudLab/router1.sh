# get control and experiment interface names
ifacetoC=$(ifconfig | grep -B1 "inet 192.168.1.2" | head -n1 | cut -f1 -d:)
ifacetoS=$(ifconfig | grep -B1 "inet 192.168.3.2" | head -n1 | cut -f1 -d:)

# remove Cloudlab created automatically added routes: bring both interfaces of the client node down and then up
sudo ifconfig $ifacetoC down; sudo ifconfig $ifacetoC up 
sudo ifconfig $ifacetoS down; sudo ifconfig $ifacetoS up

# add the new routes manually 
sudo route add -net 192.168.10.0/24 gw 192.168.1.1 

# Set bottleneck capacity and buffer size at the router
sudo tc qdisc del dev $ifacetoS root # don’t worry if you get RTNETLINK  error
sudo tc qdisc replace dev $ifacetoS root handle 1: htb default 3 
sudo tc class add dev $ifacetoS parent 1: classid 1:3 htb rate 100mbit 
sudo tc qdisc add dev $ifacetoS parent 1:3 handle 3: bfifo limit 375000 

# 7 9 23 Implement L4S source: https://github.com/L4STeam/linux
wget https://github.com/L4STeam/linux/releases/download/testing-build/l4s-testing.zip
unzip l4s-testing.zip
sudo dpkg --install debian_build/*
sudo update-grub  # This should auto-detect the new kernel
# You can optionally set newly installed kernel as the default, e.g., editing GRUB_DEFAULT in /etc/default/grub
# You can now reboot (and may have to manually select the kernel in grub)
# Be sure that the newly installed kernel is successfully used, e.g., checking output of
# sudo reboot 0
# uname -r
# Be sure to ensure the required modules are loaded before doing experiments, e.g.,
# sudo modprobe sch_dualpi2
# sudo modprobe tcp_prague
