#!/bin/bash
export ASSET_PATH=/dist/

if [[ ! -d "twemoji" ]]; then
	curl -o v13.0.1.tar.gz https://codeload.github.com/twitter/twemoji/tar.gz/v13.0.1
	echo "08801831c02015ef23f409fae8f11bf9b768210c6810130b4c3d9e805f7800f7  v13.0.1.tar.gz" | sha256sum -c - || exit -1
	mkdir -p twemoji
	tar xf v13.0.1.tar.gz --strip-components=2 -C twemoji twemoji-13.0.1/assets/72x72
	rm v13.0.1.tar.gz
fi

make clean
make pot
make po
tee -a src/i18n/converse.pot src/i18n/de/LC_MESSAGES/converse.po << EOF
msgid "Start Download-Dialog"
msgstr "Starte Download-Dialog"
msgid "Attachements from the Chat"
msgstr "Anlagen aus dem Chatverlauf"
msgid "Please enter the name of the zip file."
msgstr "Bitte geben Sie den Namen der Zip-Datei an."
msgid "Timestamp"
msgstr "Zeitstempel"
msgid "User"
msgstr "Nutzer"
msgid "File"
msgstr "Datei"
msgid "Filename"
msgstr "Dateiname"
msgid "Download attachements"
msgstr "Anlagen speichern"
msgid "Download in Progress..."
msgstr "Dateien werden heruntergeladen"
msgid "_ERROR.txt"
msgstr "_FEHLER.txt"
msgid "The file "
msgstr "Die Datei "
msgid " could not be downloaded."
msgstr " konnte nicht heruntergeladen werden."
msgid "There are no files to download."
msgstr "Es sind keine Dateien zum Download verfügbar."
msgid "No files for Download selected."
msgstr "Es wurden keine Dateien zum Download ausgewählt."
EOF

make dist

curl -o dist/download-dialog.js https://raw.githubusercontent.com/conversejs/community-plugins/master/packages/download-dialog/dist/download-dialog.js
echo f4967b7005e08f9fcf6eadedc820969c2b1b4663475581eb49c25f4adcf82a7b  dist/download-dialog.js | sha256sum -c - || exit -1
curl -o dist/download-dialog.js.map https://raw.githubusercontent.com/conversejs/community-plugins/master/packages/download-dialog/dist/download-dialog.js.map
echo 65d9a412781a8807c96ada7c0283c08e62746e597aae15487a91962c37439fe3  dist/download-dialog.js.map | sha256sum -c - || exit -1
curl -o dist/libsignal-protocol.min.js https://cdn.conversejs.org/3rdparty/libsignal-protocol.min.js
echo fee29499609eb38c0acb51ee32682abb9c0498c5e49158eecd8e49862d698b23  dist/libsignal-protocol.min.js | sha256sum -c - || exit -1

zip -r conversejs7.zip \
	converse_config.js \
	index.html \
	mobile.html \
	multi.html \
	twemoji \
	dist \
