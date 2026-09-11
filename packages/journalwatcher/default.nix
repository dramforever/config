{
  lib,
  libnotify,
  makeWrapper,
  runCommand,
}:

runCommand "journalwatcher" {
  nativeBuildInputs = [ makeWrapper ];
  meta.mainProgram = "journalwatcher";
} ''
  makeWrapper ${./journalwatcher.py} $out/bin/journalwatcher \
    --prefix PATH : ${lib.makeBinPath [ libnotify ]}
''
