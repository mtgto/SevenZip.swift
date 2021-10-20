// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import CsevenZip
import Foundation

enum LZMAError: Error {
    case badFile
    case noMemory
}

private var moduleInit: Void = {
    // Need to run only once
    CrcGenerateTable()
}()

public class Archive {
    private(set) var entries: [Entry] = []
    private var allocImp = ISzAlloc(Alloc: SzAlloc, Free: SzFree)
    private var allocTempImp = ISzAlloc(Alloc: SzAlloc, Free: SzFree)
    private var db = CSzArEx()
    private var archiveStream = CFileInStream()
    private var lookStream = CLookToRead2()
    private var blockIndex: UInt32 = 0xFFFFFFFF // it can have any value before first call (if outBuffer = 0)
    private var outBuffer = UnsafeMutablePointer<UInt8>(bitPattern: 0)
    private var outBufferSize: Int = 0 // it can have any value before first call (if outBuffer = 0)
    
    public init(fileURL: URL) throws {
        _ = moduleInit
        let result = fileURL.path.withCString { pathPtr in
            return InFile_Open(&self.archiveStream.file, pathPtr)
        }
        if result != 0 {
            throw LZMAError.badFile
        }
        FileInStream_CreateVTable(&self.archiveStream)
        LookToRead2_CreateVTable(&self.lookStream, 0)
        let bufSize = 1 << 18
        guard let buf = self.allocImp.Alloc(nil, bufSize)?.assumingMemoryBound(to: UInt8.self) else {
            throw LZMAError.noMemory
        }
        self.lookStream.buf = buf
        self.lookStream.bufSize = bufSize
        defer {
            self.allocImp.Free(nil, buf)
        }
        withUnsafePointer(to: &self.archiveStream.vt) { ptr in
            self.lookStream.realStream = ptr
        }
        SevenZip_LookToRead2_Init(&self.lookStream)
        
        SzArEx_Init(&self.db)
        if SzArEx_Open(&self.db, &self.lookStream.vt, &self.allocImp, &self.allocTempImp) != 0 {
            throw LZMAError.badFile
        }
        self.entries = try (0..<self.db.NumFiles).map { i in
            let len = SzArEx_GetFileNameUtf16(&self.db, Int(i), nil)
            guard let temp = SzAlloc(nil, len * MemoryLayout<UInt16>.size)?.assumingMemoryBound(to: UInt16.self) else {
                throw LZMAError.noMemory
            }
            defer {
                SzFree(nil, temp)
            }
            SzArEx_GetFileNameUtf16(&db, Int(i), temp)
            guard let filename = String(data: Data(bytes: temp, count: len * MemoryLayout<UInt16>.size - 1), encoding: .utf16LittleEndian) else {
                throw LZMAError.badFile
            }
            let filesize = SevenZip_SzArEx_GetFileSize(&self.db, Int(i))
            let isDirectory = SevenZip_SzArEx_IsDir(&self.db, Int(i)) != 0
            let mtime: Date?
            if SevenZip_SzBitWithVals_Check(&db.MTime, Int(i)) == 0 {
                let high: UInt64 = UInt64(db.MTime.Vals[Int(i)].High)
                let low: UInt64 = UInt64(db.MTime.Vals[Int(i)].Low)
                mtime = Date(timeIntervalSince1970: TimeInterval((high << 32 | low) / 10_000_000 - UInt64(11_644_473_600)))
            } else {
                mtime = nil
            }
            let entry = Entry(index: i, path: filename, uncompressedSize: filesize, directory: isDirectory, modified: mtime, archive: self)
            return entry
        }
    }
    
    // TODO: super large file
    public func extract(entry: Entry, bufSize: Int = 1 << 18) throws -> Data {
        var offset: Int = 0
        var outSizeProcessed: Int = 0
        guard let buf = self.allocImp.Alloc(nil, bufSize)?.assumingMemoryBound(to: UInt8.self) else {
            throw LZMAError.noMemory
        }
        self.lookStream.buf = buf
        self.lookStream.bufSize = bufSize
        defer {
            self.allocImp.Free(nil, buf)
        }

        let result = SzArEx_Extract(&self.db, &self.lookStream.vt, entry.index, &self.blockIndex, &self.outBuffer, &self.outBufferSize, &offset, &outSizeProcessed, &self.allocImp, &self.allocTempImp)
        if result != 0 {
            throw LZMAError.badFile
        }
        if let pointee = self.outBuffer {
            return Data(bytes: pointee.advanced(by: offset), count: outSizeProcessed)
        } else {
            throw LZMAError.badFile
        }

    }
}
