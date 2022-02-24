# install footloose and docker for this demo
# https://github.com/weaveworks/footloose

# create a docker network for our footloose cluster. It will work as the switch between nodes
docker network create footloose-cluster

# create the footloose cluster using footloose.yml file
footloose create

# log in to node0 and install k3s
footloose ssh root@node0 -- "curl -sfL https://get.k3s.io | sh -"

# copy the node-token from node0 and save it as env variable in localhost
# node0 will run as control plane
export k3stoken=$(footloose ssh root@node0 -- cat /var/lib/rancher/k3s/server/node-token)

# set up node1 and node2 as worker nodes using node-token from node0, it will connect worker nodes to master node
footloose ssh root@node1 -- "curl -sfL https://get.k3s.io | K3S_URL=https://node0:6443 K3S_TOKEN=$k3stoken sh - "
footloose ssh root@node2 -- "curl -sfL https://get.k3s.io | K3S_URL=https://node0:6443 K3S_TOKEN=$k3stoken sh - "

# log in node0

footloose ssh root@node0

# run pack.sh for installing some essential package

kubectl create deployment nginx1 --image=nginx
kubectl create deployment nginx2 --image=nginx


# flannel commands

# tcpdump

ip -d link show flannel.1
tcpdump -i cni0 port 80 -vvv
tcpdump -i flannel.1 port 80 -vvv
tcpdump -i eth0 port 80 -vvv
tcpdump -i eth0 port 8472 -vvv
tcpdump -i eth0 -n -e "udp"

# tshark

tshark --color -i -V -c 2 cni0 -f "port 80"
tshark --color -i -V -c 2 flannel.1 -f "port 80"
tshark --color -i eth0 -f "port 8472"
tshark --color -i eth0 -d udp.port==8472,vxlan -f "port 8472"
tshark --color -i eth0 -V -c 2 -d udp.port==8472,vxlan -f "port 8472"

## tcpdump -l -n -i <if> 'port 4789 and udp[8:2] = 0x0800 & 0x0800 and udp[11:4] = <vni> & 0x00FFFFFF'
