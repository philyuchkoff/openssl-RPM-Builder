# Security Notes

## Checksum Verification

Both build scripts (`install-openssl_3.sh` and `install-openssl_1.1.1.sh`) now include automatic SHA256 checksum verification:

1. The script downloads the OpenSSL source archive
2. It also downloads the corresponding `.sha256` file from the official OpenSSL website
3. The checksum is verified before proceeding with the build
4. If verification fails, the script exits with an error

This ensures that the downloaded files are authentic and haven't been corrupted or tampered with.

## Security Considerations

- The scripts only download from the official OpenSSL website (https://www.openssl.org/source/)
- HTTPS is used for all downloads to prevent man-in-the-middle attacks
- SHA256 verification provides strong cryptographic verification
- Scripts use `set -euo pipefail` to ensure they fail fast on any error

## Reporting Security Issues

If you discover a security issue in this project, please report it to the project maintainer at:
- GitHub: https://github.com/philyuchkoff/openssl-RPM-Builder/issues

## Best Practices

1. Always verify the GPG signature of downloaded packages when available
2. Consider building in a clean, isolated environment (chroot or container)
3. Review the build configuration options before compiling
4. Keep your build system updated with the latest security patches