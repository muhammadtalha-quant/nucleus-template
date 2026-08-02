{
    pkgs,
    userName,
    ...
}:

{

    imports = [ ];

    programs.home-manager.enable = true;

    home = {
        username = userName;
        homeDirectory = "/home/${userName}";
        packages = with pkgs; [
            hello
        ];
        stateVersion = "26.05";
    };

}
