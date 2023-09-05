"""Multipath TCP experiment: This profile instantiates a topology in CloudLab with two links between a server and client, and also sets up the routing configuration necessary to run MPTCP over this link."""


# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal object,
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Node client
node_client = request.RawPC('client')
node_client.addService(pg.Execute('/bin/sh','/usr/bin/sudo /bin/bash /local/repository/CloudLab/client.sh'))
iface0 = node_client.addInterface('interface-0', pg.IPv4Address('192.168.10.2','255.255.255.0'))
iface1 = node_client.addInterface('interface-4', pg.IPv4Address('192.168.20.2','255.255.255.0'))

# Node emulator2
node_emulator2 = request.RawPC('emulator2')
node_emulator2.addService(pg.Execute('/bin/sh','/bin/bash /local/repository/CloudLab/emulator2.sh'))
iface2 = node_emulator2.addInterface('interface-5', pg.IPv4Address('192.168.20.1','255.255.255.0'))
iface3 = node_emulator2.addInterface('interface-6', pg.IPv4Address('192.168.2.1','255.255.255.0'))

# Node emulator1
node_emulator1 = request.RawPC('emulator1')
node_emulator1.addService(pg.Execute('/bin/sh','/usr/bin/sudo /bin/bash /local/repository/CloudLab/emulator1.sh'))
iface4 = node_emulator1.addInterface('interface-1', pg.IPv4Address('192.168.10.1','255.255.255.0'))
iface5 = node_emulator1.addInterface('interface-2', pg.IPv4Address('192.168.1.1','255.255.255.0'))

# Node server
node_server = request.RawPC('server')
node_server.addService(pg.Execute('/bin/sh','/usr/bin/sudo /bin/bash /local/repository/CloudLab/server.sh'))
iface6 = node_server.addInterface('interface-10', pg.IPv4Address('192.168.3.1','255.255.255.0'))
iface7 = node_server.addInterface('interface-12', pg.IPv4Address('192.168.4.1','255.255.255.0'))

# Node router1
node_router1 = request.RawPC('router1')
node_router1.addService(pg.Execute('/bin/sh','/usr/bin/sudo /bin/bash /local/repository/CloudLab/router1.sh'))
iface8 = node_router1.addInterface('interface-7', pg.IPv4Address('192.168.1.2','255.255.255.0'))
iface9 = node_router1.addInterface('interface-9', pg.IPv4Address('192.168.3.2','255.255.255.0'))

# Node router2
node_router2 = request.RawPC('router2')
node_router2.addService(pg.Execute('/bin/sh','/usr/bin/sudo /bin/bash /local/repository/CloudLab/router2.sh'))
iface10 = node_router2.addInterface('interface-3', pg.IPv4Address('192.168.2.2','255.255.255.0'))
iface11 = node_router2.addInterface('interface-11', pg.IPv4Address('192.168.4.2','255.255.255.0'))

# Link link-0
link_0 = request.Link('link-0')
link_0.addInterface(iface0)
link_0.addInterface(iface4)

# Link link-1
link_1 = request.Link('link-1')
link_1.addInterface(iface5)
link_1.addInterface(iface8)

# Link link-2
link_2 = request.Link('link-2')
link_2.Site('undefined')
link_2.addInterface(iface1)
link_2.addInterface(iface2)

# Link link-3
link_3 = request.Link('link-3')
link_3.addInterface(iface3)
link_3.addInterface(iface10)

# Link link-4
link_4 = request.Link('link-4')
link_4.addInterface(iface9)
link_4.addInterface(iface6)

# Link link-5
link_5 = request.Link('link-5')
link_5.addInterface(iface11)
link_5.addInterface(iface7)


# Print the generated rspec
pc.printRequestRSpec(request)

