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
echo 264e2badbe11eabd860ca0c1c928573b26a3849199730727542e9e1c7c1bb203  dist/download-dialog.js | sha256sum -c - || exit -1
curl -o dist/download-dialog.js.map https://raw.githubusercontent.com/conversejs/community-plugins/master/packages/download-dialog/dist/download-dialog.js.map
echo 7336e347374ad8150f505b932007883c5a054901317ad570c77e8e60e7ab20c6  dist/download-dialog.js.map | sha256sum -c - || exit -1
curl -o dist/libsignal-protocol.min.js https://cdn.conversejs.org/3rdparty/libsignal-protocol.min.js
echo fee29499609eb38c0acb51ee32682abb9c0498c5e49158eecd8e49862d698b23  dist/libsignal-protocol.min.js | sha256sum -c - || exit -1

zip -r conversejs7.zip \
	converse_config.js \
	index.html \
	mobile.html \
	multi.html \
	twemoji \
	dist \
