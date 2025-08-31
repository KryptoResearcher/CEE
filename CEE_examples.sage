# CEE_examples.sage
def example_small_fields():
    """Examples with small fields as shown in the paper."""
    print("=== Small Field Examples ===")
    
    # Example over F17
    print("Field F17 with f(x) = x^2 + 2")
    F17 = GF(17)
    f17 = lambda x: x^2 + F17(2)
    
    for n in [1, 2, 3]:
        dist = compute_distribution(f17, n, F17)
        H_inf = min_entropy(dist, 17)
        delta = statistical_distance(dist, 17)
        print(f"n={n}: H_inf={H_inf:.4f} bits, delta={delta:.4f}")
    
    # Example over F31
    print("\nField F31 with f(x) = x^2 + 1")
    F31 = GF(31)
    f31 = lambda x: x^2 + F31(1)
    
    for n in [1, 2]:
        dist = compute_distribution(f31, n, F31)
        H_inf = min_entropy(dist, 31)
        delta = statistical_distance(dist, 31)
        print(f"n={n}: H_inf={H_inf:.4f} bits, delta={delta:.4f}")

def example_large_fields():
    """Examples with cryptographically-sized fields."""
    print("\n=== Large Field Examples ===")
    
    # Mersenne primes as mentioned in the paper
    mersenne_primes = [2^61 - 1, 2^89 - 1, 2^107 - 1, 2^127 - 1]
    iterations = {2^61-1: [20, 30], 2^89-1: [30, 44], 
                  2^107-1: [40, 53], 2^127-1: [50, 63]}
    
    for p in mersenne_primes:
        if p < 2^20:  # Skip very large primes for demonstration
            continue
            
        print(f"\nField F_{p} with f(x) = x^2 + 1")
        Fp = GF(p)
        fp = lambda x: x^2 + Fp(1)
        
        # Use smaller sample size for large fields
        sample_size = min(p, 10^4)
        samples = [Fp.random_element() for _ in range(sample_size)]
        
        for n in iterations.get(p, [1, 2]):
            # Estimate distribution from samples
            distribution = {}
            for x in samples:
                y = iterate_polynomial(fp, n, x)
                distribution[y] = distribution.get(y, 0) + 1
            
            H_inf = min_entropy(distribution, p)
            delta = statistical_distance(distribution, p)
            print(f"n={n}: H_inf={H_inf:.4f} bits, delta={delta:.6f}")

def test_polynomial_class():
    """Test the PolynomialFd class with valid and invalid polynomials."""
    print("\n=== PolynomialFd Class Tests ===")
    
    # Test with valid polynomial
    F17 = GF(17)
    R.<x> = PolynomialRing(F17)
    f_valid = x^2 + 2
    
    try:
        poly_valid = PolynomialFd(f_valid, F17)
        print("Valid polynomial accepted:", poly_valid)
    except ValueError as e:
        print("Valid polynomial rejected:", e)
    
    # Test with invalid polynomial (has fixed point)
    f_invalid = x^2  # x=0 and x=1 are fixed points in some fields
    
    try:
        poly_invalid = PolynomialFd(f_invalid, F17)
        print("Invalid polynomial incorrectly accepted:", poly_invalid)
    except ValueError as e:
        print("Invalid polynomial correctly rejected:", e)

if __name__ == "__main__":
    example_small_fields()
    test_polynomial_class()
    # example_large_fields()  # Uncomment for large field examples (may be slow)