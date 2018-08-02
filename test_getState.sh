#!/usr/bin/env bash

SERVER='localhost'
PORT='30443'
NODE='8100'

echo "curl -ks https://${SERVER}:${PORT}/cloudhost/state/${NODE}?t=xml"
curl -ks  "https://${SERVER}:${PORT}/cloudhost/state/${NODE}?t=xml"

