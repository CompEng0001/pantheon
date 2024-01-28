#!/usr/bin/env nix-shell
#!nix-shell -i bash -p multipath-tools

# Elevate user to su if not already, needed for mounting operations
if [ "$EUID" -ne 0 ]
then
   echo -e "For mounting opeations you need to be elevated to super user if you are not already..."
   # relaunch program with all agurments as superuser
   exec sudo -s "$0" "$@"
fi

## VARIABLES

KPARTX=$(which kpartx | grep -o "/nix/store/")

ROOTFS=/mnt/rootfs
BOOTFS=/mnt/bootfs
ISOFILE=""
LOOPROOT=/dev/loop0
LOOP1=/dev/mapper/
LOOP2=/dev/mapper/

## FUNCTIONS

USAGE(){
   echo -e "editImage\n"
   echo -e "\t -f <path/to/file>"
   echo -e "\t -c needed to create mount points /mnt/bootfs /mnt/rootfs for /dev/mapper/loop0p#"
   echo -e "\t -u needed to unmount"
   echo -e "\t -d needed to remove partions for .img from /dev/\n\t if supplied before -u (unmount) then unmount is invoked first"
   echo -e "\t -h helper"
}

CHECKFS(){
  # Check for mandatory arguments
   if [ ! -d  ${BOOTFS} ]; then
       echo -e "Creating ${BOOTFS}"
       mkdir ${BOOTFS}
   fi

   if [ ! -d ${ROOTFS} ]; then
       echo -e "Creating ${ROOTFS}"
       mkdir ${ROOTFS}
   fi
}

MAPDEVS(){

   if [ $1 == `c` ];then
      DEVICES=$(kpartx -av ${ISOFILE} | awk '{print$3}')
   else [ $1 == `u` ]

      DEVICES=$(kpartx -l ${ISOFILE} | awk '{print$1}')
   fi

   LOOP1+=$(echo $DEVICES | awk '{print$1}' )
   LOOP2+=$(echo $DEVICES | awk '{print$2}' )
}


DELETEKPARTX(){

   if [[ $(lsblk | grep -o ${ROOTFS}) == ${ROOTFS} ]];then

      UNMOUNTKPARTX
   fi
   echo -e "Removing ${LOOPROOT}"
   kpartx -d ${ISOFILE}
}

CREATEKPARTX(){

   CHECKFS

   DEVICES=$(kpartx -av ${ISOFILE} | awk '{print$3}')
   LOOP1+=$(echo $DEVICES | awk '{print$1}' )
   LOOP2+=$(echo $DEVICES | awk '{print$2}' )

   mount -o loop ${LOOP1} ${BOOTFS}
   echo -e "mounted: ${LOOP1} -> ${BOOTFS}"
   mount -o loop ${LOOP2} ${ROOTFS}
   echo -e "mounted: ${LOOP2} -> ${ROOTFS}"
}

UNMOUNTKPARTX(){

   CHECKFS

   DEVICES=$(kpartx -l ${ISOFILE} | awk '{print$1}')
   LOOP1+=$(echo $DEVICES | awk '{print$1}' )
   LOOP2+=$(echo $DEVICES | awk '{print$2}' )

   umount ${BOOTFS}
   echo -e "unmounted: ${BOOTFS} -> ${LOOP1}"

   umount ${ROOTFS}
   echo -e "unmounted: ${ROOTFS} -> ${LOOP2}"

}

## LOGIC

if [[ ! $1 -eq "-f" ]];then
   echo  -e "Usage: editImage:\n\tfirst argument must be -f with path/to/file\n"
   exit 1
fi

while getopts "f:cud" arg; do
  case $arg in
    f) # Speciy p value.
      ISOFILE=${OPTARG}
      if [ -z "${ISOFILE}" ]; then
          echo -e "Usage: editImage\n\t-f needs an path/to/file, see -h for more help"
          exit 1
      fi

      if [ ! -f "${ISOFILE}" ];then
          echo -e "Usage: editImage\n\tPath to image/iso: $1 does not exist\nExiting script.\n"
          exit 1
      fi

      if [[ ! $(echo ${ISOFILE} | awk -F '.' '{print$2}') -eq "img" ]];then
          echo -e "Usage: editImage\n\tFile is not a .img file. Ensure uncompressed: $1\t\nExiting script.\n"
	  exit 1
      fi
      ;;
    c)
      CREATEKPARTX
      ;;
    u)
      UNMOUNTKPARTX
      ;;
    d)
      DELETEKPARTX
      ;;
    h | *) # Display help.
      USAGE
      exit 0
      ;;
   \?)  ## LOGIC)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

exit 0
