{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, ...}: {
    devShells.aarch64-darwin.default =
      let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
  #         # My failed attempt at using an earlier libxml2.
  #         overlays = [
  #           (final: prev: {
  #             libxml2 = (import (builtins.fetchGit {
  #               name = "libxml2-2.10.4";
  #               url = "https://github.com/NixOS/nixpkgs/";
  #               ref = "refs/heads/nixpkgs-unstable";
  #               rev = "5a8650469a9f8a1958ff9373bd27fb8e54c4365d";
  #             }) {
  #               inherit system;
  #             }).libxml2;
  #           })
  #         ];
        };
      in
      pkgs.mkShell {

        buildInputs = [
        ];
        nativeBuildInputs = [
        ];
        packages = [
          # There is a jekyll package but I can't get it to build due to
          # nokogiri not being able to build against it's native dependencies.
          # From
          # https://www.postgresql.org/message-id/CACpMh%2BDMZVHM%2BiDSyqdcpK8sr7jd_HxxLJRNvGTzcLBE0W07QA%40mail.gmail.com
          # it can be seen that libxml2 has introduced some breaking changes
          # (see commits
          # https://github.com/GNOME/libxml2/commit/61034116d0a3c8b295c6137956adc3ae55720711
          # and
          # https://github.com/GNOME/libxml2/commit/45470611b047db78106dcb2fdbd4164163c15ab7
          # where the error types changed and went out as part of v2.12.0.  The
          # nokogiri issue tracker has
          # https://github.com/sparklemotion/nokogiri/issues/3071 which says
          # this is fixed in 1.16.0rc1 and currently (2024-02-11) the most
          # recent release is 1.16.2 (released 2024-02-04).  I don't believe
          # Jekyll is using this version, or at least it isn't pinned in the
          # bundler/nix files.  Jekyll appears to be actively maintained but I
          # may or may not chase this because 1) Jekyll makes me maintain
          # front-matter in an ugly way and 2) I would love to use a static site
          # generator that isn't affixed to a brittle series of FFI bindings.
          #
          # The place to contribute any fixes would go back to
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/jekyll/default.nix
          # or in that vicinity.
          pkgs.ruby
        ];
      };
  };
}
