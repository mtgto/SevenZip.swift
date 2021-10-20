import CryptoKit
import XCTest
@testable import SevenZip

final class ArchiveSpecTests: XCTestCase {
    func testOpen() throws {
        guard let url = Bundle.module.url(forResource: "sample", withExtension: "7z") else { XCTFail(); return }
        let archive = try Archive(fileURL: url)
        let entry = archive.entries.first!
        XCTAssertEqual(entry.path, "LICENSE.txt")
        XCTAssertEqual(entry.uncompressedSize, 1094)
        XCTAssertFalse(entry.directory)
        let data = try archive.extract(entry: entry)
        XCTAssertEqual(SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined(), "b28b7b6753000c2e5fe368ef69f0c7c8b09de048f8fd140cda102d736c26433b")
    }
    
    func testLargeFile() throws {
        guard let url = Bundle.module.url(forResource: "largefile", withExtension: "7z") else { XCTFail(); return }
        let archive = try Archive(fileURL: url)
        let data = try archive.extract(entry: archive.entries[0])
        XCTAssertEqual(SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined(), "b28b7b6753000c2e5fe368ef69f0c7c8b09de048f8fd140cda102d736c26433b")
    }
}
