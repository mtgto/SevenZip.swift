// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import CsevenZip
import Foundation

enum LZMAError: Error {
    case badFile
}

public struct Archive {
    private var archiveStream: CFileInStream
    private var lookStream: CLookToRead2

    public init(fileURL: URL) throws {
        let result = fileURL.path.withCString { pathPtr in
            return InFile_Open(&self.archiveStream.file, pathPtr)
        }
        if result != 0 {
            throw LZMAError.badFile
        }
        FileInStream_CreateVTable(&self.archiveStream)
        LookToRead2_CreateVTable(&self.lookStream, 0)
        self.lookStream.buf = nil
        var db = CSzArEx()
        var allocImp: ISzAlloc = ISzAlloc(Alloc: SzAlloc, Free: SzFree)
        SzArEx_Init(&db)
        SzArEx_Open(&db, self.lookStream.vt, &allocImp, &allocImp)
    }
}
