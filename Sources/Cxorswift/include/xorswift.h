
#ifdef __cplusplus
extern "C"{
#endif
    
    void xorshift(unsigned int *start, int count);
    
    void xorshift_uniform(float *start, int count, float low, float high);
    
    void _xorshift_normal(float *start, int count, float mu, float sigma);
    
#ifdef __cplusplus
}
#endif
