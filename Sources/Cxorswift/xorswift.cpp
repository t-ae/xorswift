
// https://en.wikipedia.org/wiki/Xorshift

#include <CoreFoundation/CoreFoundation.h>
#include "xorswift.h"

static uint32_t x = arc4random();
static uint32_t y = arc4random();
static uint32_t z = arc4random();
static uint32_t w = arc4random();

void xorshift(unsigned int *start, int count) {
    uint32_t t1, t2, t3, t4;
    uint32_t *p = start;
    int i;
    
    for(i = 0 ; i < count%4 ; ++i) {
        t1 = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        *(p++) = w;
    }
    
    for(; i < count ; i += 4) {
        t1 = x ^ (x << 11);
        t2 = y ^ (y << 11);
        t3 = z ^ (z << 11);
        t4 = w ^ (w << 11);
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8));
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8));
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8));
        *(p++) = x;
        *(p++) = y;
        *(p++) = z;
        *(p++) = w;
    }
}

void xorshift_uniform(float *start, int count, float low, float high) {
    uint32_t t1, t2, t3, t4;
    float *p = start; // in [0, 1)
    float divisor = nextafterf(UINT32_MAX, UINT64_MAX);
    int i;
    
    for(i = 0 ; i < count%4 ; ++i) {
        t1 = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        *(p++) = (high - low) * (float)w / divisor + low;
    }
    
    for(; i < count ; i += 4) {
        t1 = x ^ (x << 11);
        t2 = y ^ (y << 11);
        t3 = z ^ (z << 11);
        t4 = w ^ (w << 11);
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8));
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8));
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8));
        *(p++) = (high - low) * (float)x / divisor + low;
        *(p++) = (high - low) * (float)y / divisor + low;
        *(p++) = (high - low) * (float)z / divisor + low;
        *(p++) = (high - low) * (float)w / divisor + low;
    }
}

void _xorshift_normal(float *start, int count, float mu, float sigma) {
    uint32_t t1, t2, t3, t4;
    float *p = start; // ~ N(mu, sigma)
    float x1, x2; // in (0, 1)
    float divisor = nextafterf(UINT32_MAX, UINT64_MAX);
    
    if(count%2 == 1) {
        t1 = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        x1 = (float)w / divisor + FLT_MIN;
        
        t1 = x ^ (x << 11);
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        x2 = (float)w / divisor + FLT_MIN;
        
        *(p++) = sigma * sqrtf(-2*logf(x1)) * cosf(2*M_PI*x2) + mu;
    }
    
    for(int i = 0 ; i < count ; i+=2) {
        t1 = x ^ (x << 11);
        t2 = y ^ (y << 11);
        t3 = z ^ (z << 11);
        t4 = w ^ (w << 11);
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8));
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8));
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8));
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8));
        
        x1 = (float)x / divisor + FLT_MIN;
        x2 = (float)y / divisor + FLT_MIN;
        *(p++) = sigma * sqrtf(-2*logf(x1)) * cosf(2*M_PI*x2) + mu;
        
        x1 = (float)z / divisor + FLT_MIN;
        x2 = (float)w / divisor + FLT_MIN;
        *(p++) = sigma * sqrtf(-2*logf(x1)) * cosf(2*M_PI*x2) + mu;
    }
}
