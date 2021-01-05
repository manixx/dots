#/bin/sh

set -x 

if sudo efibootmgr | grep "Boot0001\* Void Linux"; then 
	echo "Entry for Void Linux is present"
	sudo efibootmgr -B -b 1
fi 

opts="
	root=/dev/storage/root rw 

	initrd=\initramfs-linux.img 
	resume=/dev/storage/swap

	rd.luks.uuid=7487d1b4-53f3-491b-9e73-63aa8f32bac6 

	rd.lvm.vg=storage 
	rd.lvm.lv=storage/root 
	rd.lvm.lv=storage/home 
	rd.vlm.lv=storage/swap 
"

opts=`echo "${opts}" | xargs`

sudo efibootmgr \
	--disk /dev/nvme0n1 \
	--part 5 \
	--create \
	--label "Void Linux" \
	--loader /vmlinuz-linux \
	--unicode "${opts}" \
	--verbose 
