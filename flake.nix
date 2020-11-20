{
  description = "treesitter";

  inputs = {
    treesitterSors = {
      url = file:///git/github.com/tree-sitter/tree-sitter;
      type = "git";
      ref = "cargoNix";
      flake = false;
    };
  };

  outputs = fleiks @{ self, treesitterSors }:
  {
    datom = { sobUyrld = {
      legysiUyrld = true;

      lamdy = { kor, stdenv, mkCargoNix, which, emscripten }:
      let
        cargoNix = mkCargoNix {
          nightly = true;
          cargoNixPath = treesitterSors + /Cargo.nix;
          inherit crateOverrides;
        };

        TREE_SITTER_BASE_DIR = treesitterSors;

        crateOverrides = {
          tree-sitter-cli = attrs: {
            inherit TREE_SITTER_BASE_DIR;
            nativeBuildInputs = [ emscripten which treesitterSors ];
            preBuild = ''
                bash $TREE_SITTER_BASE_DIR/script/build-wasm --debug
            '';
            postInstall = ''
                PREFIX=$out make install
            '';
          };
        };

      in
      {
        cli = cargoNix.workspaceMembers.tree-sitter-cli.build;

      };

    }; };

  };
}
