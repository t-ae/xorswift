
// https://en.wikipedia.org/wiki/Xorshift

#include <CoreFoundation/CoreFoundation.h>
#include "xorswift.h"

uint32_t x = arc4random();
uint32_t y = arc4random();
uint32_t z = arc4random();
uint32_t w = arc4random();

void xorshift(unsigned int *start, int count) {
    uint32_t t;
    uint32_t *p = start;
    
    for(int i = 0 ; i < count ; ++i) {
        t = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
        *p = w;
        ++p;
    }
}

void xorshift_uniform(float *start, int count, float low, float high) {
    uint32_t t;
    float *p = start; // in [0, 1)
    float divisor = (float)((uint64_t)UINT32_MAX + 1);
    
    for(int i = 0 ; i < count ; ++i) {
        t = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
        *p = (high - low) * (float)w / divisor + low;
        ++p;
    }
}

void _xorshift_normal(float *start, int count, float mu, float sigma) {
    uint32_t t;
    float *p = start; // ~ N(mu, sigma)
    float x1, x2; // in (0, 1)
    float divisor = (float)((uint64_t)UINT32_MAX + 1);
    
    for(int i = 0 ; i < count ; ++i) {
        t = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
        x1 = (w + FLT_MIN) / divisor;
        
        t = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
        x2 = (w + FLT_MIN) / divisor;
        
        
        *p = sqrtf(-2*logf(x1)) * cosf(2*M_PI*x2);
        ++p;
    }
}
