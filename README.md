# mptcpl4spqc
## 1: Creating the topology on CloudLab
### 1.1 Creating a basic profile
1. Log in to your CloudLab account.
2. Navigate to Experiments > Create Experiment Profile.
3. Create a name for the profile such as "pqcexperiment".
4. Select Git Repo and copy and paste the link for [our GitHub repository](https://github.com/shamsWMM/Multipath-Wireless-Link-Traces.git).
5. Click Confirm then click Create.
### 1.2 Instantiating the profile and implementing L4S
1. Click instantiate on the profile page created in section [1.1 above](#11-Creating-a-basic-profile).
2. Select Cloudlab Wisconson from the Cluster dropdown menu, then click next.
3. Click Finish. 







-------------------------

Below is a description of the forked repo. To be modified to describe current repo.

This repo contains artifacts for reproducing our experiment on emulating multipath wireless scenarios on a networking testbed from the following pape:

Ilknur Aydin, Fraida Fund, Shivendra Panwar, _A Data Set and Reference Experiments for Multipath Wireless Emulation on Public Testbeds_, IEEE INFOCOM 2023 CNERT Worshop
https://infocom.info/workshops/track/CNERT

In particular, we provide the  
* the wireless (WiFi and Cellular) network link traces that were collected in the same time and place (see [Traces](Traces) folder)
* instructions and scripts to run the reference experiment that emulates a multipath wireless scenario by "playing back" the link traces in both CloudLab and FABRIC testbeds. (see [the witestlab blog](https://witestlab.poly.edu/blog/emulating-multipath-wireless/))
