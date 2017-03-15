initalize-server:
	# Open up plex ports
	sudo firewall-cmd --add-port=32400/tcp
	sudo firewall-cmd --add-port=32400/tcp --permanent
	sudo firewall-cmd --add-port=32400/udp
	sudo firewall-cmd --add-port=32400/udp --permanent
	sudo firewall-cmd --add-port=32469/tcp
	sudo firewall-cmd --add-port=32469/tcp --permanent
	sudo firewall-cmd --add-port=32469/udp
	sudo firewall-cmd --add-port=32469/udp --permanent
	sudo firewall-cmd --add-port=1900/udp
	sudo firewall-cmd --add-port=1900/udp --permanent
	sudo firewall-cmd --add-port=5353/udp
	sudo firewall-cmd --add-port=5353/udp --permanent
	# Open up ports for deluge docker container
	sudo firewall-cmd --add-port=8112/tcp
	sudo firewall-cmd --add-port=8112/tcp --permanent
	sudo firewall-cmd --add-port=58846/tcp
	sudo firewall-cmd --add-port=58846/tcp --permanent

clean rm-containers:
	# Removing all containers
	-docker rm -f plex
	-docker rm -f plexpy
	-docker rm -f deluge
	-docker rm -f plexrequests
	-docker rm -f couchpotato

rm-images: rm-containers
	# Removing all iamges
	-docker rmi linuxserver/plex
	-docker rmi linuxserver/plexpy
	-docker rmi linuxserver/deluge
	-docker rmi linuxserver/plexrequests
	-docker rmi linuxserver/couchpotato

build: clean
	# NOOP Building plex container

create: build
	# Creating plex container
	# The -v /run is a hack see https://github.com/linuxserver/docker-plex/issues/84 for more information
	docker create \
	--name=plex \
	--net=host \
	-e VERSION=latest \
	-e TZ=America/Denver \
	-v /var/docker-data/plex:/config \
	-v /NFS/MOUNT/PATH/series:/data/tvshows \
	-v /NFS/MOUNT/PATH/movies:/data/movies \
	-v /NFS/MOUNT/PATH/music:/data/music \
	-v /run \
	linuxserver/plex
	# Creating plexpy container
	docker create \
	--name=plexpy \
	-e TZ=America/Denver \
	-v /var/docker-data/plexpy:/config \
	-v "/var/docker-data/plex/Library/Application Support/Plex Media Server/Logs":/logs:ro \
	-p 8181:8181 \
	linuxserver/plexpy
	# Creating deluge container
	docker create \
	--name=deluge \
	-p 8112:8112 \
	-p 58846:58846 \
	-p 58946:58946 \
	-p 58946:58946/udp \
	-e TZ=America/Denver \
	-v /var/docker-data/deluge:/config \
	-v /NFS/MOUNT/PATH:/downloads \
	linuxserver/deluge
	# Creating plexrequests container
	docker create \
    --name=plexrequests \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/docker-data/plexrequests:/config \
    -p 3000:3000 \
	-v /run \
    linuxserver/plexrequests
	# Creating couchpotato container
	docker create \
    --name=couchpotato \
	-v /NFS/MOUNT/PATH:/downloads \
	-v /NFS/MOUNT/PATH/movies:/movies \
    -v /var/docker-data/couchpotato:/config \
    -p 5050:5050 \
    linuxserver/couchpotato

plex:
	# Removing any current plex containers
	-docker rm -f plex
	# Creating plex container
	# The -v /run is a hack see https://github.com/linuxserver/docker-plex/issues/84 for more information
	docker create \
	--name=plex \
	--net=host \
	-e VERSION=latest \
	-e TZ=America/Denver \
	-v /var/docker-data/plex:/config \
	-v /NFS/MOUNT/PATH/series:/data/tvshows \
	-v /NFS/MOUNT/PATH/movies:/data/movies \
	-v /NFS/MOUNT/PATH/music:/data/music \
	-v /run \
	linuxserver/plex
	# Starting plex container
	docker start plex

plexpy:
	# Removing any current plexpy containers
	-docker rm -f plexpy
	# Creating plexpy container
	docker create \
	--name=plexpy \
	-e TZ=America/Denver \
	-v /var/docker-data/plexpy:/config \
	-v "/var/docker-data/plex/Library/Application Support/Plex Media Server/Logs":/logs:ro \
	-p 8181:8181 \
	linuxserver/plexpy
	# Starting plexpy container
	docker start plexpy
	
deluge:
	# Removing any current deluge containers
	-docker rm -f deluge
	# Creating deluge container
	docker create \
	--name=deluge \
	-p 8112:8112 \
	-p 58846:58846 \
	-p 58946:58946 \
	-p 58946:58946/udp \
	-e TZ=America/Denver \
	-v /var/docker-data/deluge:/config \
	-v /NFS/MOUNT/PATH:/downloads \
	linuxserver/deluge
	# Starting deluge container
	docker start deluge
	# To connect to couchpotato to deluge we need to add
	# a user to the "auth" file in the deluge config dir.
	#cat << EOF | sudo tee -a  /var/docker-data/deluge/auth
	#krizzo:PASSWORD_HERE:5
	#EOF
	#docker restart deluge

plexrequests:
	# Removing any current plexrequests container
	-docker rm -f plexrequests
	# Creating plex requests container
	docker create \
    --name=plexrequests \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/docker-data/plexrequests:/config \
    -p 3000:3000 \
	-v /run \
    linuxserver/plexrequests
	# Starting plex requests container
	docker start plexrequests

couchpotato:
	# Removing any current couchpotato container
	-docker rm -f couchpotato
	# Creating plex requests container
	docker create \
    --name=couchpotato \
	-v /NFS/MOUNT/PATH:/downloads \
	-v /NFS/MOUNT/PATH/movies:/movies \
    -v /var/docker-data/couchpotato:/config \
    -p 5050:5050 \
    linuxserver/couchpotato
	# Starting plex requests container
	docker start couchpotato

