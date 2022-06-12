# Doesnt work with tauri atm
with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    nodejs-17_x
    yarn
    rustup
  ];
}