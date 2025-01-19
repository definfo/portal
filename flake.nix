{
  description = "An empty flake template that you can adapt to your own environment";

  # Flake inputs
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.nixpkgs-df23c96.url = "github:NixOS/nixpkgs/df23c968285f443cca67600e91a2724fa3166c34";

  # Flake outputs
  outputs = { self, nixpkgs, nixpkgs-df23c96 }:
    let
      # The systems supported for this flake
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        pkgs-df23c96 = import nixpkgs-df23c96 { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, pkgs-df23c96 }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          # Add any you need here
          packages = with pkgs-df23c96; [ hugo ];

          # Set any environment variables for your dev shell
          env = { };

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
          '';
        };
      });
    };
}
