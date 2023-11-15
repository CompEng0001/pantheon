#! /usr/bin/env bash


DEVICE_NAME=secureDrive
MOUNT_POINT=/mnt/${DEVICE_NAME}


if [[ $1 == '-m' ]];then

	if [[ ! -d ${MOUNT_POINT} ]]; then
		mkdir ${MOUNT_POINT}
		BLOCK_DEVICE=$(lsblk -f | grep crypto_LUKS | awk '{print$1}')
		sudo cryptsetup luksOpen /dev/${BLOCK_DEVICE}  ${DEVICE_NAME}
		sudo mount /dev/mapper/${DEVICE_NAME} ${MOUNT_POINT}
		exit 0
	else
		echo "already mounted... ${MOUNT_POINT}"
		exit 1
	fi

elif [[ $1 == '-u' ]];then

	if [[ -d ${MOUNT_POINT} ]]; then
		sudo umount ${MOUNT_POINT}
		sudo rm -r ${MOUNT_POINT}
		sudo cryptsetup luksClose ${DEVICE_NAME}
		exit 0
	else
	 	echo "already umounted... ${MOUNT_POINT}"
		exit 1
	fi
fi