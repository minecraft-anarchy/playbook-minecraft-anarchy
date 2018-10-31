# Playbook-Minecraft-Anarchy

This Ansible Playbook sets up a minecraft spigot server ready for public production usage. It was written for Ubuntu 18.04.  
It is used by the project https://www.minecraft-anarchy.org  
Feel free to join our anarchy server at: minecraft-anarchy.org


## Installation and use of this Playbook
```
# Install Vagrant Version 2.2.0
# Install Virtualbox Version 5.1.38
vagrant plugin repair

# Install python packages
pip install -r requirements.txt

# Install ansible roles
make deps

# Setup and install vagrant
make vag

# Install production on a created public server
make prod
```


# TODO

## Ansible
- sudo ip addr add pub_ip dev eth0 automaically
- expose minecraft server and website on ipv6
- own volume for data:
  sudo mkfs.ext4 -F /dev/disk/by-id/scsi-0HC_Volume_1212571
  mkdir /srv/spigot
  mount -o discard,defaults /dev/disk/by-id/scsi-0HC_Volume_1212571 /srv/spigot
- optional ramdisk for world files?
  - setup some rsync to sync /srv/spigot/app/minecraft-anarchy to /srv/spigot/app/minecraft-anarchy-data
  - systemd job to:
    - mount -t tmpfs -o uid=999,gid=999,size=200M none /srv/spigot/app/minecraft-anarchy
    - sync -data into the tmpfs
- nginx & minecraft log to fifo

## Tools / Plugins for players
- wirte a teleport plugin: /sethome, /home, /spawn, /tpp <player>, with cooldown
  https://github.com/eccentricdevotion/Non-Specific-Odyssey
- want my permission plugin: https://www.youtube.com/watch?v=Geo8xG0vri4

## Admin tools
- permissions
- https://github.com/ORelio/Minecraft-Console-Client
- dynamap? warn! sends data to cloud: https://dev.bukkit.org/projects/dynmap
- monitoring? https://dev.bukkit.org/projects/performance-monitor
- chat spam protection
- https://github.com/twoolie/NBT edit level.dat files? could set spawn radius before server start..

## Performance
- measure and reduce lag: https://www.spigotmc.org/wiki/reducing-lag/
- optimize performance: https://www.spigotmc.org/threads/guide-server-optimization%E2%9A%A1.283181/

## PR
- finish website
  - write about commands
  - write about PR rewards
- nicen up github repos & github account
- maybe write a bit about how to use all of this
- advertise in forums
- donations
