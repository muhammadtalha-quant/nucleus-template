{ storageDevice, swapSize, ... }:
{
    disko.devices = {
        disk = {
            my-disk = {
                device = storageDevice;
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            type = "EF00";
                            size = "1G";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };

                        swap = {
                            size = swapSize;
                            content = {
                                type = "swap";
                                discardPolicy = "both";
                            };
                        };

                        root = {
                            size = "100%";
                            content = {
                                type = "filesystem";
                                format = "ext4";
                                mountpoint = "/";
                            };
                        };
                    };
                };
            };
        };
    };
}
