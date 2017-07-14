
// https://en.wikipedia.org/wiki/Xorshift

#include <CoreFoundation/CoreFoundation.h>
#include "xorswift.h"

void xorshift(unsigned int *start, int count) {
    static uint32_t y = arc4random();
    uint32_t *p = start;
    for(int i = 0 ; i < count ; ++i) {
        y = y ^ (y << 13);
        y = y ^ (y >> 17);
        y = y ^ (y << 5);
        *p = y;
        ++p;
    }
}

void xorshift_uniform(float *start, int count, float low, float high) {
    static uint32_t y = arc4random();
    
    float *p = start; // in [0, 1)
    float divisor = (float)((uint64_t)UINT32_MAX + 1);
    for(int i = 0 ; i < count ; ++i) {
        
        y = y ^ (y << 13);
        y = y ^ (y >> 17);
        y = y ^ (y << 5);
        *p = (high - low) * (float)y / divisor + low;
        ++p;
    }
}

void _xorshift_normal(float *start, int count, float mu, float sigma) {
    static uint32_t y = arc4random();
    
    float *p = start; // ~ N(mu, sigma)
    float x1, x2; // in (0, 1)
    float divisor = (float)((uint64_t)UINT32_MAX + 1);
    
    for(int i = 0 ; i < count ; ++i) {
        y = y ^ (y << 13);
        y = y ^ (y >> 17);
        y = y ^ (y << 5);
        x1 = (y + FLT_MIN) / divisor;
        
        y = y ^ (y << 13);
        y = y ^ (y >> 17);
        y = y ^ (y << 5);
        x2 = (y + FLT_MIN) / divisor;
        
        
        *p = sqrtf(-2*logf(x1)) * cosf(2*M_PI*x2);
        ++p;
    }
}
