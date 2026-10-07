# CHANGELOG

## v0.4.2 (2026-10-07)

- Bump up LZMA SDK to v26.04

## v0.4.1 (2026-09-17)

- Bump up LZMA SDK to v26.03

## v0.4.0 (2026-09-06)

- BREAKING: Remove Entry.archive (#9)
  - It formed a reference cycle, so no Archive was ever deallocated and its file descriptor, parsed index and buffers were never released
  - Use archive.extract(entry:) instead of entry.archive.extract(entry:)
- Entry now conforms to Sendable (#9)

## v0.3.0 (2026-09-06)

- Support extracting PPMd compressed archives (#8)
- Fix Entry.modified was always nil (#5)
- Close the archive file when Archive is deallocated (#7)

## v0.2.7 (2026-06-27)

- Bump up LZMA SDK to v26.02

## v0.2.6 (2026-05-01)

- Bump up LZMA SDK to v26.01

## v0.2.5 (2026-02-12)

- Bump up LZMA SDK to v26.00

## v0.2.4 (2026-02-11)

- Bump up LZMA SDK to v25.01

## v0.2.3 (2025-07-19)

- Bump up LZMA SDK to v25.00

## v0.2.2 (2025-01-03)

- Bump up LZMA SDK to v24.09

## v0.2.1 (2024-05-18)

- Bump up LZMA SDK to v24.05

## v0.2.0 (2023-08-27)

- Change unsafeFlags to `-mcrc` for iOS build (#3)

## v0.1.4 (2023-08-23)

- Set unsafeFlags `march=armv8+crc` for iOS build (#2)
- Set minimum platform versions

## v0.1.3 (2023-07-02)

- Bump up LZMA SDK to v23.01

## v0.1.2 (2023-03-19)

- Bump up LZMA SDK to v22.01

## v0.1.1 (2021-11-02)

- Fix to be able extract empty file

## v0.1.0 (2021-10-23)

First release
