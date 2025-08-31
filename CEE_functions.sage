# CEE_functions.sage
def iterate_polynomial(f, n, x):
    """
    Compute the n-th iteration of polynomial f at point x.
    
    Args:
        f: A polynomial function or PolynomialFd instance
        n: Number of iterations
        x: Input value
        
    Returns:
        Result of f^{[n]}(x)
    """
    result = x
    for _ in range(n):
        result = f(result)
    return result

def compute_distribution(f, n, field):
    """
    Compute the distribution of f^{[n]}(x) for all x in the field.
    
    Args:
        f: A polynomial function or PolynomialFd instance
        n: Number of iterations
        field: The finite field
        
    Returns:
        Dictionary mapping output values to their frequency
    """
    distribution = {}
    for x in field:
        y = iterate_polynomial(f, n, x)
        distribution[y] = distribution.get(y, 0) + 1
    return distribution

def min_entropy(distribution, q):
    """
    Calculate the min-entropy of a distribution.
    
    Args:
        distribution: Dictionary of value frequencies
        q: Field size
        
    Returns:
        Min-entropy in bits
    """
    max_count = max(distribution.values())
    max_prob = max_count / q
    return -log(max_prob, 2).n()

def statistical_distance(distribution, q):
    """
    Calculate the statistical distance from uniform distribution.
    
    Args:
        distribution: Dictionary of value frequencies
        q: Field size
        
    Returns:
        Statistical distance
    """
    uniform_prob = 1 / q
    distance = 0.0
    for count in distribution.values():
        prob = count / q
        distance += abs(prob - uniform_prob)
    return distance / 2