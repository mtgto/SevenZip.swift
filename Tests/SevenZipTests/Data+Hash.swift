// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import CryptoKit
import Foundation

extension Data {
    var sha256Digest: String {
        SHA256.hash(data: self).map { String(format: "%02x", $0) }.joined()
    }
}
