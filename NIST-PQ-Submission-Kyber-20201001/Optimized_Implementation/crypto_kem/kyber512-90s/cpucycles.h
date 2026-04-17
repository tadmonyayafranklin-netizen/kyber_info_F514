#ifndef CPUCYCLES_H
#define CPUCYCLES_H

#include <stdint.h>
#include <time.h>

#ifdef __GNUC__
#ifdef __x86_64__
static inline uint64_t cpucycles(void) {
    unsigned long long result;
    __asm__ volatile("rdtsc" : "=A"(result));
    return result;
}
#elif defined(__aarch64__)
static inline uint64_t cpucycles(void) {
    uint64_t result;
    __asm__ volatile("mrs %0, cntvct_el0" : "=r"(result));
    return result;
}
#elif defined(__arm__)
static inline uint64_t cpucycles(void) {
    uint32_t result;
    __asm__ volatile("mrc p15, 0, %0, c9, c13, 0" : "=r"(result));
    return result;
}
#else
static inline uint64_t cpucycles(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
#endif
#else
static inline uint64_t cpucycles(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
#endif

static inline uint64_t cpucycles_overhead(void) {
    uint64_t t0, t1, overhead = UINT64_MAX;
    int i;
    
    for (i = 0; i < 100; i++) {
        t0 = cpucycles();
        t1 = cpucycles();
        if (t1 - t0 < overhead) {
            overhead = t1 - t0;
        }
    }
    
    return overhead;
}

#endif
