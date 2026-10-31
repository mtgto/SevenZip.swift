# SevenZip.swift

A tiny Swift library to extract 7zip archive using [LZMA SDK v26.05](https://www.7-zip.org/sdk.html).

## Feature

- [x] Extract a file from 7z archive file to memory

## Requirements

- iOS 13+
- macOS 10.15+

## Not supported features

- Extract encrypted files
- Extract first file immediately from solid archive
- Create a 7z archive

## Usage

```swift
import SevenZip

let archive: Archive = try Archive(fileURL: url)
let entry: Entry = archive.entries.first!
let path: String = entry.path
let size : UInt64 = entry.uncompressedSize
let data = try archive.extract(entry: entry)
```

## Installation

### Swift Package Manager

Add `https://github.com/mtgto/SevenZip.swift` to your Package.swift.

**NOTE**: v0.4.3 and earlier required specifying a git revision instead of a version because of `unsafeFlags`. See [#1 comment](https://github.com/mtgto/SevenZip.swift/issues/1#issuecomment-1690084540) for details. Since v0.5.0 you can specify a version as usual.

## Related projects

- [PLzmaSDK](https://github.com/OlehKulykov/PLzmaSDK)
  - iOS / macOS library which has whole features in LZMA C++ SDK
  - However, it is very slow to extract from large solid file in my environment

## License

Swift parts of this software is released under the MIT License, see [LICENSE.txt](LICENSE.txt).

LZMA SDK is placed in the public domain. See https://www.7-zip.org/sdk.html .
