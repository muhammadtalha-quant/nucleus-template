{ pkgs, ... }: {
    boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        kernelPackages = pkgs.linuxPackages_latest;
        tmp.cleanOnBoot = true;
    };
}
