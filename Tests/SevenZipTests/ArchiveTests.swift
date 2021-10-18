import XCTest
@testable import SevenZip

final class ArchiveSpecTests: XCTestCase {
    func testOpen() throws {
        guard let url = Bundle.module.url(forResource: "sample", withExtension: "7z") else { XCTFail(); return }
        var archive = try Archive(fileURL: url)
        let data = archive.extract(entry: archive.entries[0])
        XCTAssertNotNil(data)
    }
}
