{ hostName, ... }:
{
    networking = {
        inherit hostName;
        networkmanager.enable = true;
    };
}
