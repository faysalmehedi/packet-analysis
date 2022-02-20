# Show the list of available interfaces
tcpdump -D

# How to get the HTTPS traffic? Share the command!
tcpdump -nnSX port 443

# For everything on an interface, what is the command?
tcpdump -i eth0

# Write the command to find Traffic by IP.
tcpdump host 1.1.1.1

# Share the filtering by Source and/or Destination?
tcpdump src 192.168.0.117
tcpdump dst 8.8.8.8

# How to find Packets by Network, write the line.
tcpdump net 192.168.0.0/24

# Using packet contents with Hex Output, write the command.
tcpdump -X icmp -c 1 
# capture one packet with -c flag

# To find a specific port traffic, write the command.
tcpdump port 6443
tcpdump src port 2207

# Show Traffic of One Protocol command.
tcpdump icmp

# Write the command showing only IP6 Traffic.
tcpdump ip6

# Write the command for finding Traffic Using Port Ranges.
tcpdump portrange 21-23
# Write the command of finding traffic using packets of a particular size
tcpdump less 32
tcpdump greater 64
tcpdump <= 128

# What are PCAP (PEE-cap) files?

# How are PCAP files processed and why is it so?

# Which switch is used to write the PCAP file called capture_file?
tcpdump port 80 -w capture_file.pcap

# What is the command for reading / writing to capture a File?
tcpdump -r capture_file.pcap

# get on octat format
tcpdump -X -r capture_file.pcap

# Which switch is used for the ethernet header?
tcpdump -e -r capture_file.pcap

# What is Line-readable output? How is it notified?
tcpdump -r capture_file.pcap -l

# What does -q implify?
# --> Quick output. Prints less protocol information so output lines are shorter.

# What does this tweak: -t work?
# --> Omits the printing of a timestamp on each dump line.

# What does -tttt show?
# --> Prints a timestamp in default format proceeded by date on each dump line.

# To listen on the eth0 interface, which one is used?
tcpdump -i eth0

# Purpose for -vv ?
# --> Verbose output (more v’s gives more output).

# Purpose for -c?
# --> Exits after receiving Count packets.
tcpdump -c 2 -w capture_file.pcap

Why -s is used?
# --> Define the size of the capture in bytes. Use -s0 to get everything, unless you are intentionally capturing less.

# What does -S, -e, -q, -E implify?
# --> -S : Print absolute sequence numbers.
# --> -e : Get the ethernet header as well.
# --> -q : Show less protocol information.
# --> -E : Decrypt IPSEC traffic by providing an encryption key.


# How to show the raw output view?
tcpdump -ttnnvvS

# If a specific IP and destined port are given then which tweak is used for?
tcpdump -nnvvS src 10.5.2.3 and dst port 3389

# To pass from From One Network to Another, the command?
tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16

# If a Non ICMP Traffic Goes to a Specific IP, what should be the query?
tcpdump dst 192.168.0.2 and src net 10.0.0.0/8 and not icmp

# If a host isn't on a specific port, what will be tweaked and commanded?
tcpdump -vv src 192.168.0.2 and not dst port 22

# Why single quotes used?
# --> Single quotes are used in order to tell tcpdump to ignore certain special 
# --> characters—in this case below the “( )” brackets. This same technique can be used
# --> to group using other expressions such as host, port, net, etc.

tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'

# How to isolate TCP RST flags?
tcpdump 'tcp[13] & 4!=0'
tcpdump 'tcp[tcpflags] == tcp-rst'

# To Isolate TCP SYN flags, which query is used?
tcpdump 'tcp[13] & 2!=0'
tcpdump 'tcp[tcpflags] == tcp-syn'

# To Isolate packets that have both the SYN and ACK flags set, what should be the command?
tcpdump 'tcp[13]=18'

# How to Isolate TCP URG flags?
tcpdump 'tcp[13] & 32!=0'
tcpdump 'tcp[tcpflags] == tcp-urg'

# How to Isolate TCP ACK flags?
tcpdump 'tcp[13] & 16!=0'
tcpdump 'tcp[tcpflags] == tcp-ack'

# Isolate TCP PSH flags?
tcpdump 'tcp[13] & 8!=0'
tcpdump 'tcp[tcpflags] == tcp-push'

# Isolate TCP FIN flags.
tcpdump 'tcp[13] & 1!=0'
tcpdump 'tcp[tcpflags] == tcp-fin'

# How is grep used?
# Command for Both SYN and RST?
tcpdump 'tcp[13] = 6'

# Find HTTP User Agents
tcpdump -vvAls0 | grep 'User-Agent:'

# What to do for Cleartext GET Requests?
tcpdump -vvAls0 | grep 'GET'

# What to do to Find HTTP Host Headers?
tcpdump -vvAls0 | grep 'Host:'

# How to Find HTTP Cookies?
tcpdump -vvAls0 | grep 'Set-Cookie|Host:|Cookie:'

# The command line for Find SSH Connections?
tcpdump 'tcp[(tcp[12]>>2):4] = 0x5353482D'

# How to Find DNS Traffic?
tcpdump -vvAs0 port 53

# Command for Find FTP Traffic.
tcpdump -vvAs0 port ftp or ftp-data

# Find NTP Traffic, what is the command?
tcpdump -vvAs0 port 123

# Command to Find Cleartext Passwords?
tcpdump port http or port ftp or port smtp or port imap or port pop3 or port telnet -lA | egrep -i -B5 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd= |password=|pass:|user:|username:|password:|login:|pass |user '

# Describe Evil bit.

# Write the fun filter to find packets where it’s been toggled.
tcpdump 'ip[6] & 128 != 0'


# How to capture All incoming  HTTP GET  traffic (or) requests
tcpdump -r load-balnce.pcap -s 0 -A 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
# 0x47455420 depicts the ASCII value of  characters  'G' 'E' 'T' ' '

# How to capture All incoming HTTP POST requests
tcpdump -r load-balnce.pcap -s 0 -A 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504F5354'
# Here 0x504F5354 represents  the ASCII value of  'P' 'O' 'S' 'T'

# How to capture only HTTP GET requests Incoming to port 80 ( Apache/NGINX)
tcpdump -r load-balnce.pcap -s 0 -A 'tcp dst port 80 and tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'

# How to capture only HTTP POST requests Incoming to port 80 ( Apache/NGINX)
tcpdump -r load-balnce.pcap -s 0 -A 'tcp dst port 80 and tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504F5354'