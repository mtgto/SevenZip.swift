#include "../7z.h"
#include "../7zFile.h"
#include "../7zAlloc.h"
#include "../7zTypes.h"
#include "../7zCrc.h"

// #define SzArEx_IsDir(p, i) (SzBitArray_Check((p)->IsDirs, i))
int SevenZip_SzArEx_IsDir(const CSzArEx *p, size_t fileIndex) {
    return SzArEx_IsDir(p, fileIndex);
}

// #define SzArEx_GetFileSize(p, i) ((p)->UnpackPositions[(i) + 1] - (p)->UnpackPositions[i])
UInt64 SevenZip_SzArEx_GetFileSize(const CSzArEx *p, size_t fileIndex) {
    return SzArEx_GetFileSize(p, fileIndex);
}

// #define SzBitWithVals_Check(p, i) ((p)->Defs && ((p)->Defs[(i) >> 3] & (0x80 >> ((i) & 7))) != 0)
int SevenZip_SzBitWithVals_Check(const CSzBitUi64s *p, size_t i) {
    return SzBitWithVals_Check(p, i);
}

// #define LookToRead2_Init(p) { (p)->pos = (p)->size = 0; }
void SevenZip_LookToRead2_Init(CLookToRead2 *p) {
    LookToRead2_Init(p);
}
