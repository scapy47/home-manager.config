{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  # outputs = inputs: {
  #   packages = builtins.mapAttrs (system: pkgs: {
  #     hello = pkgs.hello;
  #
  #     default = inputs.self.packages.${system}.hello;
  #   }) inputs.nixpkgs.legacyPackages;
  # };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = builtins.currentSystem or "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    username = "shion";
  in
  {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ({ pkgs, ... }: {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "25.11";
          };

          programs.home-manager.enable = true;

          home.packages = with pkgs; [
            git
            neovim
            bat
            tmux
          ];
        })
      ];
    };
  };
}
