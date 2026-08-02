{
    inputs,
    pkgs,
    hostName,
    timeZone,
    locale,
    ...
}:

{
    imports = [
        ../../hosts/${hostName}/default.nix
        (inputs.import-tree ./modules)
    ];

    environment.sessionVariables = {
        EDITOR = "vim";
        VISUAL = "nano";
        LANG = locale;
    };
    environment.systemPackages = with pkgs; [
        nix-output-monitor
        vim
    ];

    time.timeZone = timeZone;
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "26.05";

}
