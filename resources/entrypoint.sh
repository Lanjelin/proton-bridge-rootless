#!/bin/bash

# Remove .lock-files
find "$HOME" -name "*.lock" -delete 2>/dev/null
# Cleans up leftover sockets in the GPG home directory
find "$HOME/.gnupg" -name "S.gpg-agent*" -delete 2>/dev/null

if [[ ! -d $HOME/.gnupg ]]; then
  # Initialize keys
  gpg --generate-key --batch --quiet /protonmail/gpgparams
  pass init proton-bridge
fi

echo "== Proton Bridge startup =="
echo " IMAP  listening on :${IMAP_PORT}  ->  127.0.0.1:1143 (Bridge)"
echo " SMTP  listening on :${SMTP_PORT}  ->  127.0.0.1:1025 (Bridge)"
echo

socat "TCP-LISTEN:${IMAP_PORT},fork,reuseaddr,keepalive" "TCP4:127.0.0.1:1143" &
socat "TCP-LISTEN:${SMTP_PORT},fork,reuseaddr" "TCP4:127.0.0.1:1025" &

proton-bridge --cli $@
