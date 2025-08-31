# CEE_validation.sage
# Statistical validation using NIST test suite for CEE implementation

import numpy as np
from collections import Counter

class CEEValidator:
    """
    Statistical validation class for CEE using NIST test suite methodology
    """
    
    def __init__(self, field, polynomial, iterations):
        """
        Initialize the validator
        
        Args:
            field: The finite field
            polynomial: The polynomial function to iterate
            iterations: Number of iterations (n)
        """
        self.field = field
        self.polynomial = polynomial
        self.iterations = iterations
        self.q = field.order()
        
    def generate_sequence(self, num_samples):
        """
        Generate a sequence of CEE outputs
        
        Args:
            num_samples: Number of samples to generate
            
        Returns:
            List of CEE outputs
        """
        sequence = []
        for _ in range(num_samples):
            x = self.field.random_element()
            y = x
            for _ in range(self.iterations):
                y = self.polynomial(y)
            sequence.append(y)
        return sequence
    
    def to_binary_sequence(self, sequence, bits_per_element=None):
        """
        Convert a sequence of field elements to a binary sequence
        
        Args:
            sequence: List of field elements
            bits_per_element: Number of bits per element (default: ceil(log2(q)))
            
        Returns:
            Binary sequence as a list of bits
        """
        if bits_per_element is None:
            bits_per_element = ceil(log(self.q, 2))
            
        binary_sequence = []
        for element in sequence:
            # Convert element to integer representation
            if hasattr(element, 'integer_representation'):
                int_val = element.integer_representation()
            else:
                int_val = element.integer_representation()
            
            # Convert to binary with fixed length
            bin_str = bin(int_val)[2:].zfill(bits_per_element)
            binary_sequence.extend([int(bit) for bit in bin_str])
            
        return binary_sequence
    
    def frequency_test(self, binary_sequence):
        """
        NIST Frequency (Monobit) Test
        
        Args:
            binary_sequence: List of bits
            
        Returns:
            p-value
        """
        n = len(binary_sequence)
        s_n = sum(1 for bit in binary_sequence if bit == 1) - sum(1 for bit in binary_sequence if bit == 0)
        s_obs = abs(s_n) / sqrt(n)
        p_value = erf(s_obs / sqrt(2))
        
        return p_value
    
    def runs_test(self, binary_sequence):
        """
        NIST Runs Test
        
        Args:
            binary_sequence: List of bits
            
        Returns:
            p-value
        """
        n = len(binary_sequence)
        pi = sum(binary_sequence) / n
        
        # Check if the test is applicable
        if abs(pi - 0.5) >= (2 / sqrt(n)):
            return 0.0  # Test not applicable, return failure
        
        # Count runs
        runs = 1
        for i in range(1, n):
            if binary_sequence[i] != binary_sequence[i-1]:
                runs += 1
                
        # Calculate p-value
        numerator = abs(runs - 2 * n * pi * (1 - pi))
        denominator = 2 * sqrt(2 * n) * pi * (1 - pi)
        p_value = erf(numerator / denominator)
        
        return p_value
    
    def block_frequency_test(self, binary_sequence, block_size=128):
        """
        NIST Block Frequency Test
        
        Args:
            binary_sequence: List of bits
            block_size: Size of each block
            
        Returns:
            p-value
        """
        n = len(binary_sequence)
        num_blocks = n // block_size
        
        # Truncate sequence to multiple of block_size
        truncated_length = num_blocks * block_size
        truncated_sequence = binary_sequence[:truncated_length]
        
        # Calculate proportions for each block
        proportions = []
        for i in range(num_blocks):
            start = i * block_size
            end = start + block_size
            block = truncated_sequence[start:end]
            proportions.append(sum(block) / block_size)
        
        # Calculate chi-squared statistic
        chi_squared = 4 * block_size * sum((pi - 0.5)**2 for pi in proportions)
        
        # Calculate p-value
        p_value = gamma_inc(num_blocks/2, chi_squared/2)
        
        return p_value
    
    def longest_run_ones_test(self, binary_sequence):
        """
        NIST Longest Run of Ones Test
        
        Args:
            binary_sequence: List of bits
            
        Returns:
            p-value
        """
        n = len(binary_sequence)
        
        # Determine block size based on sequence length
        if n < 6272:
            block_size = 8
            k = 3
            pi_values = [0.2148, 0.3672, 0.2305, 0.1875]
        elif n < 750000:
            block_size = 128
            k = 5
            pi_values = [0.1174, 0.2430, 0.2493, 0.1752, 0.1027, 0.1124]
        else:
            block_size = 10000
            k = 6
            pi_values = [0.0882, 0.2092, 0.2483, 0.1933, 0.1208, 0.0675, 0.0727]
        
        # Divide sequence into blocks
        num_blocks = n // block_size
        truncated_sequence = binary_sequence[:num_blocks * block_size]
        
        # Find longest run in each block
        longest_runs = []
        for i in range(num_blocks):
            start = i * block_size
            end = start + block_size
            block = truncated_sequence[start:end]
            
            current_run = 0
            max_run = 0
            for bit in block:
                if bit == 1:
                    current_run += 1
                    max_run = max(max_run, current_run)
                else:
                    current_run = 0
            longest_runs.append(max_run)
        
        # Count runs in each category
        counts = [0] * (k + 2)
        for run in longest_runs:
            if run <= k:
                counts[run] += 1
            else:
                counts[k+1] += 1
        
        # Calculate chi-squared statistic
        chi_squared = 0
        for i in range(k + 1):
            expected = num_blocks * pi_values[i]
            chi_squared += (counts[i] - expected)**2 / expected
        
        # Calculate p-value
        p_value = gamma_inc(k/2, chi_squared/2)
        
        return p_value
    
    def validate(self, num_samples=10000, significance_level=0.01):
        """
        Run all statistical tests on CEE output
        
        Args:
            num_samples: Number of samples to generate
            significance_level: Significance level for tests
            
        Returns:
            Dictionary with test results
        """
        # Generate sequence
        sequence = self.generate_sequence(num_samples)
        binary_sequence = self.to_binary_sequence(sequence)
        
        # Run tests
        results = {
            'frequency': self.frequency_test(binary_sequence),
            'runs': self.runs_test(binary_sequence),
            'block_frequency': self.block_frequency_test(binary_sequence),
            'longest_run': self.longest_run_ones_test(binary_sequence)
        }
        
        # Determine pass/fail
        for test_name, p_value in results.items():
            results[test_name] = {
                'p_value': p_value,
                'passed': p_value > significance_level
            }
        
        return results

def example_validation():
    """
    Example validation using small fields
    """
    print("=== CEE Statistical Validation ===\n")
    
    # Test with small field
    F17 = GF(17)
    f = lambda x: x^2 + F17(2)
    
    validator = CEEValidator(F17, f, 3)
    results = validator.validate(num_samples=1000)
    
    print(f"Field: F_{F17.order()}")
    print(f"Polynomial: x^2 + 2")
    print(f"Iterations: 3")
    print(f"Samples: 1000")
    print("\nTest Results:")
    
    for test_name, result in results.items():
        status = "PASS" if result['passed'] else "FAIL"
        print(f"{test_name:16}: p = {result['p_value']:.6f} [{status}]")
    
    # Test with another field
    print("\n" + "="*50)
    F31 = GF(31)
    f2 = lambda x: x^2 + F31(1)
    
    validator2 = CEEValidator(F31, f2, 2)
    results2 = validator2.validate(num_samples=1000)
    
    print(f"Field: F_{F31.order()}")
    print(f"Polynomial: x^2 + 1")
    print(f"Iterations: 2")
    print(f"Samples: 1000")
    print("\nTest Results:")
    
    for test_name, result in results2.items():
        status = "PASS" if result['passed'] else "FAIL"
        print(f"{test_name:16}: p = {result['p_value']:.6f} [{status}]")

if __name__ == "__main__":
    example_validation()