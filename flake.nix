{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    texmath = {
      url = "github:jgm/texmath";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, texmath }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        texlive-custom = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic standalone preview dvisvgm ;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            texlive-custom 
            python3
            nodePackages.svgo
            
            gnum4
            moreutils # parallel

            (haskellPackages.developPackage { root = texmath; cabal2nixOptions = "--flag=executable"; })
          ];
        };
  });
}
