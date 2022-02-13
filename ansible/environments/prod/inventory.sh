#!/bin/bash

yc_compute_instance_app=($(yc compute instance list | grep app | awk -F\| '{print $3 $6 $7}'))
yc_compute_instance_db=($(yc compute instance list | grep db |  awk -F\| '{print $3 $6 $7}'))



if [ $# -lt 1 ]
then
        echo "Usage : $0 --list or $0 --host"
        exit
fi

case "$1" in

--list)
cat<<EOF
{
    "_meta": {
        "hostvars": {
            "${yc_compute_instance_app[0]}": {
                "ansible_host": "${yc_compute_instance_app[1]}",
                "int_addr": "${yc_compute_instance_app[2]}",
                "db_ip_address": "${yc_compute_instance_db[2]}"
            },
            "${yc_compute_instance_db[0]}": {
                "ansible_host": "${yc_compute_instance_db[1]}",
                "int_addr": "${yc_compute_instance_db[2]}",
                "db_ip_address": "${yc_compute_instance_db[2]}"
            }
        }
    },
    "all": {
        "children": [
            "app",
            "db",
            "ungrouped"
        ]
    },
    "app": {
        "hosts": [
            "${yc_compute_instance_app[0]}"
        ]
    },
    "db": {
        "hosts": [
            "${yc_compute_instance_db[0]}"
        ]
    }
}
EOF
;;
--host)
cat<<EOF
{

}
EOF
;;
esac
