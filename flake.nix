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
          # Renders #+begin_src plantuml blocks during ox-hugo export
          # (e.g. cicd-flow.svg in the ultimate-cicd-setup post).  Without
          # it, those exports fail and the diagrams go stale.
          pkgs.plantuml
          # plantuml's runtime dep for non-sequence diagram types.
          pkgs.graphviz
        ];
      };
  };
}
