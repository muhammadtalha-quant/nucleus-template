{ configDirectory, ... }:
{
    programs.nh = {
        enable = true;
        flake = configDirectory;

        clean = {
            enable = true;
            dates = "Mon *-*-* 09:00:00";
            extraArgs = "--keep 2 --keep-since 2d";
        };
    };
}
