# Doesnt work with tauri atm
with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    nodejs-19_x
    yarn
    rustup
  ];
}
