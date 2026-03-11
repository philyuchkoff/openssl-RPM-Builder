#!/bin/bash
# Mock OpenSSL binary for testing

case "$1" in
    "version")
        echo "OpenSSL 3.6.1"
        ;;
    "version" | "-v")
        echo "OpenSSL 3.6.1"
        echo "built on: Tue Sep 12 13:28:12 2026 UTC"
        echo "platform: linux-x86_64"
        ;;
    *)
        echo "Mock OpenSSL: Unknown command '$1'"
        exit 1
        ;;
esac