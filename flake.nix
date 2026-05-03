{
  description = "Logan Barnett's blog";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };
  outputs = { self, nixpkgs, ...}: {
    devShells.aarch64-darwin.default =
      let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      pkgs.mkShell {
        buildInputs = [
        ];
        nativeBuildInputs = [
        ];
        packages = [
          pkgs.just
          pkgs.hugo
        ];
      };
  };
}
