#!/usr/bin/env bash

SERVER='localhost'
PORT='30443'

echo "curl -ks https://${SERVER}:${PORT}/cloudhost/state?t=xml"
curl -ks  "https://${SERVER}:${PORT}/cloudhost/state?t=xml"

