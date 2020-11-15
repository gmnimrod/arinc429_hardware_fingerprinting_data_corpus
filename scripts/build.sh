#!/bin/bash

TITLE="ARINC429 Data Corpus - Hardware fingerprinting for the ARINC 429 avionic bus"
pandoc -s src/README.md -o index.html -H src/github-pandoc.css --metadata title="$TITLE"

# or -c github-pandoc.css if you intend to include css with html. Remove <style></style> then.
