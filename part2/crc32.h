#ifndef  __CRC32_H
#define __CRC32_H

#include <stddef.h>
#include <stdint.h>

#define NUM_HASH_BUCKETS 512
#define HASH_MASK 0x000001FF


uint32_t
crc32(uint32_t crc, const void *buf, size_t size);

int
hashword(char *word);

#endif
