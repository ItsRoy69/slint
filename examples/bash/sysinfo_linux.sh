#!/bin/bash -e
# LICENSE BEGIN
# This file is part of the SixtyFPS Project -- https://sixtyfps.io
# Copyright (c) 2021 Olivier Goffart <olivier.goffart@sixtyfps.io>
# Copyright (c) 2021 Simon Hausmann <simon.hausmann@sixtyfps.io>
#
# SPDX-License-Identifier: GPL-3.0-only
# This file is also available under commercial licensing terms.
# Please contact info@sixtyfps.io for more information.
# LICENSE END

if command lsb_release 2>/dev/null >/dev/null; then
   os_name=`lsb_release -ds | tr -d '"\\\\'`
else
   os_name="(unable to determine Linux distribution)"
fi

uptime=`uptime -p | cut -d " " -f2-` | tr -d '"\\\\'
cpu_count=`grep processor /proc/cpuinfo | wc -l`
cpu_vendor=`awk -F ": " '/vendor_id/{ print $2; exit}' < /proc/cpuinfo | tr -d '"\\\\'`
cpu_model=`awk -F ": " '/model name/{ print $2; exit}' < /proc/cpuinfo | tr -d '"\\\\'`
mem_size_kb=`sed -n -e "s,MemTotal:\s\+\(.*\)\s\+.\+,\1,p"< /proc/meminfo`
partitions=`df --block-size=1 | tail -n+2 | sed 's/\([^ ]*\)  *\([^ ]*\)  *\([^ ]*\)  *\([^ ]*\)  *\([^ ]*\)  *\([^ ]*\)/{ "dev": "\1", "mnt": "\6", "total": \2, "used": \3 },/' | sed '$s/,$//'`

sixtyfps-viewer `dirname $0`/sysinfo.60 --load-data - <<EOT
{
    "os_name": "$os_name",
    "uptime": "$uptime",
    "cpu_count": "$cpu_count",
    "cpu_vendor": "$cpu_vendor",
    "cpu_model": "$cpu_model",
    "mem_size_kb": $mem_size_kb,
    "partitions": [ $partitions ]
}
EOT
