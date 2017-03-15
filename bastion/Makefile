initalize-server:
	# Open up ovpn ports
	sudo firewall-cmd --add-port=1194/udp
	sudo firewall-cmd --add-port=1194/udp --permanent
	yes | git clone git@github.com:krizzo/docker-openvpn.git /tmp/docker-openvpn

clean rm-containers:
	# Removing all containers
	-docker rm -f ovpn

rm-images: rm-containers
	# Removing all iamges
	-docker rmi ovpn

build: clean
	# Building ovpn container
	docker build --rm=true \
	-t ovpn \
	/tmp/docker-openvpn

run: build
	# Creating data volume for file storage and persistence.
	docker volume create \
	--name ovpn-data
	# Creating ovpn configs
	docker run \
	-v ovpn-data:/etc/openvpn \
	--rm ovpn ovpn_genconfig \
	-u udp://MY.PUBLIC.DOMAIN \
	-C 'AES-256-CBC' \
	-a 'SHA384'
	# Genereate PKI
	docker run \
	-e EASYRSA_KEY_SIZE=4096 \
	-v ovpn-data:/etc/openvpn \
	--rm \
	-it \
	ovpn ovpn_initpki
	# Starting ovpn server
	docker run \
	-d \
	--name=ovpn \
	-v ovpn-data:/etc/openvpn \
	--cap-add=NET_ADMIN \
	-p 1194:1194/udp \
	ovpn

client:
	# Creating client certificate
	@read -p "Enter client name: " client_name; \
	docker run \
	-e EASYRSA_KEY_SIZE=4096 \
	-v ovpn-data:/etc/openvpn \
	--rm \
	-it \
	ovpn easyrsa build-client-full $$client_name nopass ; \
	docker run \
	--log-driver=none \
	-v ovpn-data:/etc/openvpn \
	--rm \
	ovpn ovpn_getclient $$client_name > $${client_name}_home-krizzo-io.ovpn

client-list:
	# Listing all the VPN clients
	docker run \
	--rm \
	-it \
	-v ovpn-data:/etc/openvpn ovpn ovpn_listclients

rm-client:
	# Revoke a clients config
	@read -p "Enter client name to remove: " client_name; \
	docker run \
	--rm \
	-it \
	-v ovpn-data:/etc/openvpn \
	ovpn easyrsa revoke $$client_name ; \
	docker run \
	--rm \
	-it \
	-v ovpn-data:/etc/openvpn \
	ovpn easyrsa gen-crl
