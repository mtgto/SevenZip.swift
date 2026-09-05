import XCTest

@testable import SevenZip

/// `Archive` has to die when its last user lets go of it: it owns the archive's file
/// descriptor, the parsed index and `outBuffer`, none of which are given back before
/// `deinit` runs.
///
/// `Entry` holds a strong reference to its archive, so an `Archive` that also stored its
/// `[Entry]` could never reach a retain count of zero.
final class ArchiveLifetimeTests: XCTestCase {
    private func sampleURL() throws -> URL {
        try XCTUnwrap(Bundle.module.url(forResource: "sample", withExtension: "7z"))
    }

    func testArchiveIsReleasedWithItsLastReference() throws {
        let url = try sampleURL()
        weak var weakArchive: Archive?
        try autoreleasepool {
            var archive: Archive? = try Archive(fileURL: url)
            weakArchive = archive
            let entry = try XCTUnwrap(archive?.entries.first { !$0.directory && $0.uncompressedSize > 0 })
            _ = try archive?.extract(entry: entry)
            archive = nil
        }
        XCTAssertNil(weakArchive, "the archive outlived its last reference; its file handle and buffers leak")
    }

    /// The other half of the contract: an `Entry` kept by the caller keeps its archive alive,
    /// so `entry.archive` never dangles.
    func testAnEntryKeepsItsArchiveAlive() throws {
        let url = try sampleURL()
        weak var weakArchive: Archive?
        var heldEntry: Entry?
        try autoreleasepool {
            var archive: Archive? = try Archive(fileURL: url)
            weakArchive = archive
            heldEntry = archive?.entries.first { !$0.directory && $0.uncompressedSize > 0 }
            archive = nil
        }
        XCTAssertNotNil(weakArchive, "an entry must keep its archive alive")
        try autoreleasepool {
            let entry = try XCTUnwrap(heldEntry)
            XCTAssertEqual(try entry.archive.extract(entry: entry).count, Int(entry.uncompressedSize))
        }
        heldEntry = nil
        XCTAssertNil(weakArchive, "letting the last entry go must release the archive")
    }
}
