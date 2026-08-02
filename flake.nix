{
    description = "A modular multi host flake that manages a complete NixOS system one at a time, using the nucleus architecture.";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        homeManager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        import-tree.url = "github:denful/import-tree";
        disko = {
            url = "github:nix-community/disko/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            self,
            nixpkgs,
            nixpkgs-unstable,
            homeManager,
            disko,
            ...
        }@inputs:
        let
            # !=== SYSTEM CONFIG ===!
            userName = "YOUR_PREFERRED_USER_NAME";
            hostName = "YOUR_PREFERRED_HOST_NAME";
            # THE GIVEN HASH RESEMBLES THE PASSWORD '0', AND IS USED FOR BOTH ROOT AND USER ACCOUNT.
            # TO GENERATE A NEW HASH, IN YOUR TERMINAL TYPE THE FOLLOWING COMMAND WITHOUT THE '$'
            # $ mkpasswd -m yescrypt
            # YOU WILL BE PROMPTED FOR PASSWORD, ENTER YOUR DESIRED PASSWORD, AND THEN REPLACE
            # THE FOLLOWING HASH WITH THE GENERATED ONE.
            hashedPassword = "$y$j9T$hbguh04FZh1JSM8nYVXS0.$9yG.bzlFyYT2NcDEKwxPmZuyN1Cz91DMpyewyfQAyM5";
            timeZone = "YOUR_REGION/YOUR_CITY";
            locale = "en_US.UTF-8"; # CHANGE IT IF YOU WANT, ENGLISH IS FINE FOR MANY USERS.

            # !=== FLAKE CONFIG ===!
            system = "x86_64-linux";
            # must match nixpkgs.hostPlatform = lib.mkDefault "<<arch>>";
            # from the generated hardware-configuration.nix
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

            # !=== USER CONFIG ===!
            realName = "YOUR_REAL_NAME";
            # your user configuration, that you would like pass down to home manager as well.

            # !=== DISKO CONFIG ===!
            # BY DEFAULT, DISKO IS CONFIGURED FOR EXT4 FS FOR UEFI SYSTEMS (NO DUAL BOOT !)
            # OFCOURSE, CHANGE IT TO FS LAYOUT OF YOUR CHOICE
            storageDevice = "/dev/name";
            swapSize = "4G"; # size of swap partition

            # !=== ENVIRONMENT CONFIG ===!
            configDirectory = "/home/${userName}/EXAMPLE/";
        in
        {
            nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                    inherit userName;
                    inherit realName;
                    inherit hostName;
                    inherit hashedPassword;
                    inherit timeZone;
                    inherit configDirectory;
                    inherit storageDevice;
                    inherit locale;
                    inherit swapSize;
                    inherit pkgs-unstable;
                    inherit inputs;
                };
                modules = [
                    ./modules/features/configuration/configuration.nix
                    homeManager.nixosModules.home-manager
                    {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.${userName} = import ./modules/features/dotfiles/home.nix;
                            backupFileExtension = "bak";
                            extraSpecialArgs = {
                                inherit inputs;
                                inherit userName;
                                inherit pkgs-unstable;
                            };
                        };
                    }
                    disko.nixosModules.disko
                    ./modules/common/disko.nix
                ];
            };
        };
}
