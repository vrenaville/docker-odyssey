#!/bin/bash
# Test if CERT file exist, if yes store the expiration date
if [ -f "$CERTFILE" ]; then
    openssl x509 -enddate -noout < $CERTFILE > /tmp/TLSENDDATE
else
    echo "No cert file"
    echo "no CRT" > /tmp/TLSENDDATE
fi
# Start Odyssey
/usr/local/bin/odyssey $1
