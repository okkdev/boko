with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    nodejs-17_x
    yarn
    cargo
    rustc
    rustfmt
  ];
}