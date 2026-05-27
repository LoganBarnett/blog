{
  description = "Logan Barnett's blog";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    emacs-config.url = "github:LoganBarnett/emacs-config";
  };
  outputs = { self, nixpkgs, emacs-config, ...}: {
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
          # Configured Emacs from the user's emacs-config flake.  Used in
          # batch mode by the `just resume-pdf` recipe to export
          # org/resume.org → static/resume.pdf without manual interaction.
          # The Emacs derivation carries its own TeX dependencies — no
          # texlive entry needed here.
          emacs-config.packages.${system}.default
        ];
      };
  };
}
