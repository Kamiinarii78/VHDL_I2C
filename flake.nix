{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pyPkgs = pkgs.python3Packages;

        vunit = pyPkgs.buildPythonPackage rec {
          pname = "vunit_hdl";
          version = "4.7.0";
          pyproject = true;
          src = pyPkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-ol+5kbq9LqhRlm4NvcX02PZJqz5lDjASmDsp/V0Y8i0=" ;
          };
          
          postPatch = ''
            sed -i -E 's/setuptools_scm[^"'"'"']*/setuptools_scm/' pyproject.toml
          '';
          build-system = [ pyPkgs.setuptools pyPkgs.setuptools-scm ];
          dependencies = [ pyPkgs.colorama ];
          doCheck = false;
        };

        py = pkgs.python3.withPackages (_: [ vunit pyPkgs.cocotb pyPkgs.pytest ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.ghdl-llvm pkgs.yosys pkgs.yosys-ghdl
                       pkgs.nextpnr pkgs.icestorm pkgs.gtkwave pkgs.surfer py ];
        };
      });
}
