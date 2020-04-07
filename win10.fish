#!/usr/bin/env fish

if [ (whoami) != "root" ]
    echo "Script must be run as root. Try: `sudo fish win10.fish`."
    exit
end

function __find_nvidia_gpu
    if not test -x (which nvidia-smi)
        echo "Please install nvidia-smi..."
        exit
    end

    set info (string lower (nvidia-smi --query-gpu="pci.bus_id,display_mode" --format=csv,noheader))
    set pciBus ""
    for gpu in $info
        if contains "enabled" gpu
            set pciBus (string replace ", enabled" "" $gpu)
            break
        end
    end

    if test -n $pciBus
        echo (string sub -s 5 $pciBus)  # remove the first four digits
    else
        echo "Failed to find a GPU with an active display connection."
        exit
    end
end

function lazily_gpu -a extraArgs -d "Lets the system find a usable GPU for KVM."
    set pciBus __find_nvidia_gpu

    echo unbind_gpu $pciBus $extraArgs
end

function unbind_gpu -a pciBus -a extraArgs -d "Prepares a GPU device to be passed into KVM."
    set opts (unbind_pci $pciBus)
    if test -n extraArgs  # check if optional arguments are set
        set opts "$opts,$extraArgs"
    end

    set audioBus (string replace ".0" ".1" $pciBus)
    set opts (string join0 $opts (unbind_pci $audioBus))
end


function unbind_pci -a pciBus -d "Prepares a PCI device to be passed into KVM."
    set vendor (string match -ir "[\da-f]{4}:[\da-f]{4}" (lspci -s $pciBus -n))
    set vendor (string replace ":" " " $vendor)

    # Unmount the PCI device's driver(s)
    echo $vendor > /sys/bus/pci/drivers/vfio-pci/new_id
    echo $pciBus > /sys/bus/pci/devices/$pciBus/driver/unbind
    echo $pciBus > /sys/bus/pci/drivers/vfio-pci/bind
    echo $vendor > /sys/bus/pci/drivers/vfio-pci/remove_id

    echo $pciBus >> /tmp/vfio-pci

    echo " -device vfio-pci,host=$pciBus"
end


function unbind_usb -a venID -d "Prepares a USB device to be passed into KVM."
    # turns $venID into vendorid=0x{vendorID},productid=0x{productID} by replacing
    #   the ":" in XXXX:XXXX
    set ids (string join0 "vendorid=0x" $venID)
    set ids (string replace ":" ",productid=0x" $ids)

    echo " -device usb-host,$ids"
end

function rebind_pci
    for pci in (cat /tmp/vfio-pci)
        echo 1 > /sys/bus/pci/devices/$pciBus/remove
    end

    echo 1 > /sys/bus/pci/rescan
end

set OPTS ""
set OPTS "$OPTS -vga none"
set OPTS "$OPTS -nographic"
set OPTS "$OPTS -enable-kvm"
set OPTS "$OPTS -cpu host,kvm=off,+topoext"
set OPTS "$OPTS -smp 8,cores=4,threads=2,sockets=1"
set OPTS "$OPTS -machine type=q35,accel=kvm"
set OPTS "$OPTS -m 32G -mem-prealloc"

# Unbind 1080 Ti
set OPTS (lazily_gpu "multifunction=on")

# Mount OVMF VARS
cp /usr/share/ovmf/x64/OVMF_VARS.fd /tmp/ovmf
set OPTS "$OPTS -drive file=/tmp/ovmf,if=pflash,format=raw,readonly"
set OPTS "$OPTS -device virtio-scsi-pci,id=scsi"

# Mount VirtIO iso
set OPTS "$OPTS -drive file=/usr/share/virtio/virtio-win.iso,id=virtio,format=raw,if=none"
set OPTS "$OPTS -device ide-cd,bus=ide.1,drive=virtio"

# Mount Win10 iso
set OPTS "$OPTS -drive file=win10.iso,id=iso,format=raw,if=none"
set OPTS "$OPTS -device scsi-cd,drive=iso"

# Mount Win10 image
set OPTS "$OPTS -drive file=win10.img,id=disk,format=qcow2,if=none,cache=writeback"
set OPTS "$OPTS -device scsi-hd,drive=disk"

set OPTS "$OPTS -usb"
set OPTS (string join0 $OPTS (unbind_usb "apple"))  # Keytron K1 (it goes by "Apple, Inc." for some reason)
set OPTS (string join0 $OPTS (unbind_usb "dark core"))  # Corsair Dark Core RGB
set OPTS (string join0 $OPTS (unbind_usb "h100i"))  # Corsair H100i

# qemu-system-x86_64 $OPTS
print $OPTS

rebind_pci
