// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import Foundation

public struct Entry {
    public let index: UInt32
    public let path: String
    public let uncompressedSize: UInt64
    public let directory: Bool
    public let modified: Date?
}
