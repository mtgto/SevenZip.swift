import XCTest

@testable import SevenZip

final class ArchiveSpecTests: XCTestCase {
    func testOpen() throws {
        guard let url = Bundle.module.url(forResource: "sample", withExtension: "7z") else {
            XCTFail()
            return
        }
        let archive = try Archive(fileURL: url)
        let entry = archive.entries.first!
        XCTAssertEqual(entry.path, "LICENSE.txt")
        XCTAssertEqual(entry.uncompressedSize, 1094)
        XCTAssertFalse(entry.directory)
        let data = try archive.extract(entry: entry)
        XCTAssertEqual(data.sha256Digest, "b28b7b6753000c2e5fe368ef69f0c7c8b09de048f8fd140cda102d736c26433b")
    }

    func testLargeFile() throws {
        guard let url = Bundle.module.url(forResource: "largefile", withExtension: "7z") else {
            XCTFail()
            return
        }
        let archive = try Archive(fileURL: url)
        let entry = archive.entries.first!
        XCTAssertEqual(entry.path, "631px-FullMoon2010.bmp")
        var data = try archive.extract(entry: entry)
        XCTAssertEqual(data.sha256Digest, "d666500f1a28b5a40d09a2a1e7558cd3cdd60120b2d4bba0dcf05e78b41b075e")
        data = try archive.extract(entry: entry, bufSize: Int(entry.uncompressedSize))
        XCTAssertEqual(data.sha256Digest, "d666500f1a28b5a40d09a2a1e7558cd3cdd60120b2d4bba0dcf05e78b41b075e")
    }

    func testUtf8Archive() throws {
        guard let url = Bundle.module.url(forResource: "utf8", withExtension: "7z") else {
            XCTFail()
            return
        }
        let archive = try Archive(fileURL: url)
        XCTAssertTrue(archive.entries.contains { $0.path == "日本語🧔‍♂️🍺" })
        XCTAssertTrue(archive.entries.contains { $0.path.contains("これは月の画像です.jpg") })
        XCTAssertTrue(archive.entries.contains { $0.path.contains("Здравствуйте.jpg") })
    }

    func testEmptyArchive() throws {
        guard let url = Bundle.module.url(forResource: "empty", withExtension: "7z") else {
            XCTFail()
            return
        }
        let archive = try Archive(fileURL: url)
        guard let entry = archive.entries.first else {
            XCTFail()
            return
        }
        let data = try archive.extract(entry: entry)
        XCTAssertEqual(data.count, 0)
    }
}
