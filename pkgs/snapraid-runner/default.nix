{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "snapraid-runner";
  system = "x86_64-linux";
  src = fetchFromGitHub {
    owner = "Chronial";
    repo = "snapraid-runner";
    # rev = "bb7193cf1f1b2e1662150400164b0b07e646b4a5";
    # hash = "sha256-MAOa7pHEIPijRulc0oz+KCd6dZ1WgShEmnrX1isuHBU=";
  };
  installPhase = ''
    mkdir -p $out/
    cp snapraid-runner.py snapraid-runner.conf.example README.md LICENSE.txt $out/
  '';
}
