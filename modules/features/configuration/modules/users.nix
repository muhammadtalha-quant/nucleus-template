{
    pkgs,
    userName,
    realName,
    hashedPassword,
    ...
}:
{
    users = {
        mutableUsers = false;
        users.root = { inherit hashedPassword; };
        users.${userName} = {
            isNormalUser = true;
            description = realName;
            extraGroups = [
                "networkmanager"
                "wheel"
            ];
            shell = pkgs.bash;
            inherit hashedPassword;
        };
    };
}
