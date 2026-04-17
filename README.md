# Testing

## Running Known Answer Tests (KAT)

To run the Known Answer Tests for the different Kyber variants, navigate to the appropriate implementation directory and use the following commands:

### Reference Implementation

```bash
# Kyber512
cd Reference_Implementation/crypto_kem/kyber512
make
./PQCgenKAT_kem

# Kyber768
cd ../kyber768
make
./PQCgenKAT_kem

# Kyber1024
cd ../kyber1024
make
./PQCgenKAT_kem

# Kyber512-90s (AES-based variant)
cd ../kyber512-90s
make
./PQCgenKAT_kem

# Kyber768-90s (AES-based variant)
cd ../kyber768-90s
make
./PQCgenKAT_kem

# Kyber1024-90s (AES-based variant)
cd ../kyber1024-90s
make
./PQCgenKAT_kem
```

### Optimized Implementation

```bash
# Kyber512
cd Optimized_Implementation/crypto_kem/kyber512
make
./PQCgenKAT_kem

# Kyber768
cd ../kyber768
make
./PQCgenKAT_kem

# Kyber1024
cd ../kyber1024
make
./PQCgenKAT_kem

# Kyber512-90s (AES-based variant)
cd ../kyber512-90s
make
./PQCgenKAT_kem

# Kyber768-90s (AES-based variant)
cd ../kyber768-90s
make
./PQCgenKAT_kem

# Kyber1024-90s (AES-based variant)
cd ../kyber1024-90s
make
./PQCgenKAT_kem
```

### AVX2 Optimized Implementation

```bash
# Kyber512
cd Additional_Implementations/avx2/crypto_kem/kyber512
make
./PQCgenKAT_kem

# Kyber512-90s (AES-based variant)
cd ../kyber512-90s
make
./PQCgenKAT_kem
```

### Clean C Implementation (PQClean)

```bash
# Kyber512
cd Additional_Implementations/clean/crypto_kem/kyber512
make
./test_kem

# Kyber512-90s (AES-based variant)
cd ../kyber512-90s
make
./test_kem
```

## Running Speed Tests

To run performance benchmarks for the reference implementations:

```bash
# Kyber512
cd Reference_Implementation/crypto_kem/kyber512
gcc -O3 -march=native -fomit-frame-pointer -o test_speed test_speed.c cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c reduce.c rng.c verify.c symmetric-shake.c -lcrypto
./test_speed

# Kyber768
cd ../kyber768
gcc -O3 -march=native -fomit-frame-pointer -o test_speed test_speed.c cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c reduce.c rng.c verify.c symmetric-shake.c -lcrypto
./test_speed

# Kyber1024
cd ../kyber1024
gcc -O3 -march=native -fomit-frame-pointer -o test_speed test_speed.c cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c reduce.c rng.c verify.c symmetric-shake.c -lcrypto
./test_speed
```

## Verifying Test Results

The KAT tests generate two files:
- `PQCkemKAT_{N}.req` - Request file with test vectors
- `PQCkemKAT_{N}.rsp` - Response file with computed results

Compare the generated `.rsp` files with the reference files in the `KAT/` directory to verify correctness:

```bash
# Example for Kyber512
cd Reference_Implementation/crypto_kem/kyber512
diff PQCkemKAT_1632.rsp ../../KAT/kyber512/PQCkemKAT_1632.rsp
```

## Clean Up

To clean build artifacts:

```bash
# In any implementation directory
make clean
```

## Notes

- All implementations require OpenSSL (`-lcrypto`) for cryptographic functions
- The AVX2 implementations require a CPU with AVX2 support
- Speed tests measure CPU cycles for various cryptographic operations
- The 90s variants use AES-256 instead of SHAKE256 for symmetric primitives
