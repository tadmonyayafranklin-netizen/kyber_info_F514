#!/bin/bash

# Script to run Kyber benchmarks across all implementations
# Results will be saved to a markdown table

echo "# Kyber CPU Cycle Benchmarks"
echo ""
echo "| Implementation | Security Level | Key Generation | Encapsulation | Decapsulation | NTT | INVNTT | Matrix Generation |"
echo "|----------------|---------------|---------------|---------------|---------------|-----|--------|------------------|"

# Function to extract median value from benchmark output
extract_median() {
    local operation="$1"
    local output="$2"
    echo "$output" | grep -A 2 "$operation:" | grep "median:" | awk '{print $2}' | sed 's/cycles\/ticks,//'
}

# Function to run benchmark and extract results
run_benchmark() {
    local impl_path="$1"
    local impl_name="$2"
    local security_level="$3"
    
    echo "Running benchmark for $impl_name $security_level..."
    
    cd "$impl_path"
    
    # Compile if needed
    if [ ! -f "test_speed" ]; then
        if [[ "$impl_name" == "AVX2" ]]; then
            # AVX2 compilation with specific flags
            gcc -mavx2 -mbmi2 -mpopcnt -maes -march=native -mtune=native -O3 -fomit-frame-pointer -o test_speed test_speed.c speed_print.c cbd.c consts.c indcpa.c kem.c poly.c polyvec.c rejsample.c rng.c verify.c fips202.c fips202x4.c keccak4x/KeccakP-1600-times4-SIMD256.c symmetric-shake.c fq.S invntt.S ntt.S shuffle.S basemul.S -lcrypto 2>/dev/null
        else
            # Standard compilation
            gcc -O3 -march=native -fomit-frame-pointer -o test_speed test_speed.c speed_print.c ntt.c poly.c polyvec.c reduce.c cbd.c fips202.c indcpa.c kem.c rng.c verify.c symmetric-shake.c -lcrypto 2>/dev/null
        fi
    fi
    
    if [ -f "test_speed" ]; then
        local output=$(./test_speed 2>/dev/null)
        
        local keypair=$(extract_median "kyber_keypair" "$output")
        local encaps=$(extract_median "kyber_encaps" "$output")
        local decaps=$(extract_median "kyber_decaps" "$output")
        local ntt=$(extract_median "NTT" "$output")
        local invntt=$(extract_median "INVNTT" "$output")
        local gen_a=$(extract_median "gen_a" "$output")
        
        echo "| $impl_name | $security_level | $keypair | $encaps | $decaps | $ntt | $invntt | $gen_a |"
    else
        echo "| $impl_name | $security_level | Failed to compile | - | - | - | - | - |"
    fi
}

# Reference Implementation
echo "Running Reference Implementation benchmarks..."
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Reference_Implementation/crypto_kem/kyber512" "Reference" "512"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Reference_Implementation/crypto_kem/kyber768" "Reference" "768"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Reference_Implementation/crypto_kem/kyber1024" "Reference" "1024"

# Optimized Implementation  
echo "Running Optimized Implementation benchmarks..."
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Optimized_Implementation/crypto_kem/kyber512" "Optimized" "512"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Optimized_Implementation/crypto_kem/kyber768" "Optimized" "768"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Optimized_Implementation/crypto_kem/kyber1024" "Optimized" "1024"

# Additional AVX2 Implementation
echo "Running AVX2 Implementation benchmarks..."
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Additional_Implementations/avx2/crypto_kem/kyber512" "AVX2" "512"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Additional_Implementations/avx2/crypto_kem/kyber768" "AVX2" "768"
run_benchmark "/home/franklin/Desktop/INFO-F514-Cryptanalysis & Protocols/Kyber-Round3/NIST-PQ-Submission-Kyber-20201001/Additional_Implementations/avx2/crypto_kem/kyber1024" "AVX2" "1024"

echo ""
echo "*All values are median CPU cycles over 10,000 iterations*"
