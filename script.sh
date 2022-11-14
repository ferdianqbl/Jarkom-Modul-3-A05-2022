#!bin/bash
Ostania(){
    apt-get update
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.171.0.0/16

    # Ostania Sebagai DHCP Relay (No 2)
    apt-get install isc-dhcp-relay -y
    service isc-dhcp-relay start

    echo 'SERVERS="192.171.2.4"
    INTERFACES="eth1 eth2 eth3"
    OPTIONS= ' > /etc/default/isc-dhcp-relay

    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

    service isc-dhcp-relay restart

}

Westalis(){
    apt-get update
    apt-get install isc-dhcp-server -y

    echo 'INTERFACES="eth0"' > /etc/default/isc-dhcp-server
    service isc-dhcp-server start
     # No 3
    echo 'nameserver 192.168.122.1' > /etc/resolv.conf
    echo "
    subnet 192.171.2.0 netmask 255.255.255.0 {
    }
    subnet 192.171.1.0 netmask 255.255.255.0 {
        range 192.171.1.50 192.171.1.88;
        range 192.171.1.120 192.171.1.155;
        option routers 192.171.1.1;
        option broadcast-address 192.171.1.255;
        option domain-name-servers 192.171.2.2;
        default-lease-time 300;
        max-lease-time 6900;
    }" > /etc/dhcp/dhcpd.conf

    # No 4
    echo "
    subnet 192.171.3.0 netmask 255.255.255.0 {
        range 192.171.3.10 192.171.3.30;
        range 192.171.3.60 192.171.3.85;
        option routers 192.171.3.1;
        option broadcast-address 192.171.3.255;
        option domain-name-servers 192.171.2.2;
        default-lease-time 600;
        max-lease-time 6900;
    }" >> /etc/dhcp/dhcpd.conf

    # No 7
    echo "
    host Eden {
        hardware ethernet 92:a9:d9:6e:fa:f4;
        fixed-address 192.171.3.13;
    }" >> /etc/dhcpd/dhcpd.conf

    service isc-dhcp-server restart
}

Berlint(){
    echo "nameserver 192.168.122.1" > /etc/resolv.conf
    apt-get update
    apt-get install squid -y
    service squid start

    apt-get install php -y
    apt-get install apache2 -y
    apt-get install libapache2-mod-php7.0 -y
}

Wise(){
    echo "nameserver 192.168.122.1" > /etc/resolv.conf
    apt-get update
    apt-get install bind9 -y
    service bind9 start

    # No 5
    echo "
    options {
            directory \"/var/cache/bind\";

            forwarders {
                    8.8.8.8;
                    8.8.8.4;
            };

            // dnssec-validation auto;
            allow-query { any; };
            auth-nxdomain no;    # conform to RFC1035
            listen-on-v6 { any; };
    };
    " > /etc/bind/named.conf.options
    service bind9 restart
}

Eden() {
    echo "nameserver 192.168.122.1" > /etc/resolv.conf
    apt-get install apache2 -y
    service apache2 start
    apt-get install php -y
    apt-get install libapache2-mod-php7.0 -y
    apt-get install ca-certificates openssl -y

    # No 7
    echo "hwaddress ether 92:a9:d9:6e:fa:f4 " >> /etc/network/interface
}

NewstoneCastle(){
    echo "
    auto eth0
    iface eth0 inet dhcp" > /etc/network/interface
}

SSS() {
    echo "
    auto eth0
    iface eth0 inet dhcp" > /etc/network/interface
}

Garden(){
    echo "
    auto eth0
    iface eth0 inet dhcp" > /etc/network/interface
}

if [ $HOSTNAME == "Ostania" ]
then
    Ostania
elif [ $HOSTNAME == "WISE" ]
then
    Wise
elif [ $HOSTNAME == "Berlint" ]
then
    Berlint
elif [ $HOSTNAME == "Westalis" ]
then
    Westalis
elif [ $HOSTNAME == "NewstoneCastle" ]
then
    NewstoneCastle
elif [ $HOSTNAME == "Eden" ]
then
    Eden
elif [ $HOSTNAME == "KemonoPark" ]
then
    KemonoPark
elif [ $HOSTNAME == "SSS" ]
then
    SSS
elif [ $HOSTNAME == "Garden" ]
then
    Garden
fi
