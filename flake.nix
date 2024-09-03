{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, disko, ... }:
    let
      # TODO: Adjust these values to your needs
#      system = "x86_64-linux";
#      hostName = "oneclick";
#      rootAuthorizedKeys = [
#        # This user can ssh using `ssh root@<ip>`
#        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxPoqlThDrkR58pKnJgmeWPY9/wleReRbZ2MOZRyd"
#      ];
    in
    {
#      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./disk-config.nix
          disko.nixosModules.disko
          ./configuration.nix
        ];
      };
    };
}
