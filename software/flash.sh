#!/bin/sh

~/altera/13.1/quartus/bin/quartus_cpf -c -q 15MHz -g 3.3 -n p ./output_files/main.sof afc.svf
sudo rmmod ftdi_sio
sudo ./mbftdi afc.svf
#sudo modprobe ftdi_sio
