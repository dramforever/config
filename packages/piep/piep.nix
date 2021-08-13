{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, nose
, pygments
}:

buildPythonPackage rec {
  version = "0.9.2";
  pname = "piep";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5anpsq16xkiisws95jif5s5mplkl1kdnhy0w0i6m0zcy50jnxq";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/2b133edef2f711cd494d4023e6c446126b23e999/trunk/piep-python3.8.patch";
      sha256 = "sha256-IEYqEXxOAc3kIyNaBP1+h/81wMPtS/9bp/ONPI8lb8w=";
    })
  ];

  propagatedBuildInputs = [ pygments ];
  checkInputs = [ nose ];

  meta = with lib; {
    description = "Bringing the power of python to stream editing";
    homepage = "https://github.com/timbertson/piep";
    maintainers = with maintainers; [ timbertson ];
    license = licenses.gpl3;
  };

}
