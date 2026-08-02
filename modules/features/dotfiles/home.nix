{
    pkgs,
    userName,
    inputs,
    ...
}:

{

    imports = [
        (inputs.import-tree ./modules)
    ];

    # KEEP THIS FILE AS MINIMAL AS YOU CAN AND ADD PER APP CONFIG (<= 200 LOC)
    # IN A SEPARATE FILE INSIDE THE MODULES DIRECTORY WITH THE NAMING CONVENTION app.nix
    # AND THEN IT WILL BE AUTO IMPORTED.

    # !=== ** IMPORTANT ** ===!
    # IF YOUR APPLICATION CONFIG IS BIG, LIKE NEOVIM, THE BEST PRACTICE IS TO CREATE
    # DIRECTORY FOR THE APPLICATION, AND MODULARIZE IT AND THEN IMPORT THE INITIALIZER NIX
    # FILE INSIDE THE IMPORTS LIST ABOVE
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
