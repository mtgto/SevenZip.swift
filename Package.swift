// swift-tools-version:5.5
// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import PackageDescription

let package = Package(
    name: "SevenZip",
    products: [
        .library(
            name: "SevenZip",
            targets: ["SevenZip"])
    ],
    targets: [
        .target(
            name: "SevenZip",
            dependencies: ["CsevenZip"]),
        .target(
            name: "CsevenZip",
            exclude: [
                "7zVersion.rc",
                "Util/7z/7z.dsp",
                "Util/7z/7z.dsw",
                "Util/7z/makefile",
                "Util/7z/makefile.gcc",
                "Util/Lzma/LzmaUtil.dsp",
                "Util/Lzma/LzmaUtil.dsw",
                "Util/Lzma/makefile",
                "Util/Lzma/makefile.gcc",
                "Util/LzmaLib/LzmaLib.def",
                "Util/LzmaLib/LzmaLib.dsp",
                "Util/LzmaLib/LzmaLib.dsw",
                "Util/LzmaLib/makefile",
                "Util/LzmaLib/resource.rc",
                "Util/SfxSetup/SfxSetup.dsp",
                "Util/SfxSetup/SfxSetup.dsw",
                "Util/SfxSetup/makefile",
                "Util/SfxSetup/makefile_con",
                "Util/SfxSetup/resource.rc",
                "Util/SfxSetup/setup.ico",

                "Aes.c",
                "AesOpt.c",
                "Alloc.c",
                "Bcj2Enc.c",
                "DllSecur.c",
                "LzmaEnc.c",
                "Lzma2DecMt.c",
                "Lzma2Enc.c",
                "Lzma86Dec.c",
                "Lzma86Enc.c",
                "LzmaLib.c",
                "LzFind.c",
                "LzFindMt.c",
                "MtCoder.c",
                "MtDec.c",
                "Ppmd7Enc.c",
                "Sha256.c",
                "Sort.c",
                "Threads.c",
                "XzDec.c",
                "XzEnc.c",
                "XzIn.c",
                "Xz.c",
                "XzCrc64.c",
                "XzCrc64Opt.c",
                "Util/7z/7zMain.c",
                "Util/7z/Precomp.c",
                "Util/Lzma/LzmaUtil.c",
                "Util/LzmaLib/LzmaLibExports.c",
                "Util/SfxSetup/Precomp.c",
                "Util/SfxSetup/SfxSetup.c",
            ],
            sources: [
                "7zAlloc.c",
                "7zArcIn.c",
                "7zBuf.c",
                "7zBuf2.c",
                "7zCrc.c",
                "7zCrcOpt.c",
                "7zDec.c",
                "CpuArch.c",
                "Delta.c",
                "LzmaDec.c",
                "Lzma2Dec.c",
                "Bra.c",
                "Bra86.c",
                "BraIA64.c",
                "Bcj2.c",
                "Ppmd7.c",
                "Ppmd7Dec.c",
                "7zFile.c",
                "7zStream.c",
            ],
            cSettings: [
                // .define("_SZ_ALLOC_DEBUG") // if you want to debug alloc/free operations to stderr.
            ]
        ),
        .testTarget(
            name: "SevenZipTests",
            dependencies: ["SevenZip"],
            resources: [.process("fixture")]),
    ]
)
