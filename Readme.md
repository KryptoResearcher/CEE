# Chaotic Entropic Expansion (CEE) - Confidentiality Primitive

![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Research](https://img.shields.io/badge/status-research--implementation-orange)

A reference implementation of the **Chaotic Entropic Expansion (CEE)** primitive, the confidentiality layer of the broader **CASH framework** (Chaotic Affine Secure Hash). CEE provides provable entropy preservation and statistical confidentiality guarantees through iterated polynomial maps over finite fields.

> **Research Implementation Notice**: This project is a theoretical construct and reference implementation intended for research validation. It is not yet audited or ready for production use.

## Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Theoretical Foundations](#-theoretical-foundations)
- [Repository Structure](#-repository-structure)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Examples](#-examples)
- [Benchmarking](#-benchmarking)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)
- [Citation](#-citation)

## Overview

The Chaotic Entropic Expansion (CEE) primitive provides cryptographically secure confidentiality through iterated polynomial maps over finite fields. CEE guarantees provable entropy bounds and statistical distance from uniform distribution, forming the confidentiality foundation of the CASH framework.

CEE completes the CASH framework triad:
- **Confidentiality (CEE)**: Entropy preservation and statistical security
- **Reliability (AOW)**: Temporal binding and one-wayness  
- **Opposability (SH)**: Legal interpretability and semantic anchoring

## Key Features

- **Provable Entropy Bounds**: Mathematically guaranteed min-entropy preservation
- **Statistical Confidentiality**: Bounded statistical distance from uniform distribution
- **Post-Quantum Security**: Security reductions to AIIP, MQ, and HCDLP problems
- **Algebraic Versatility**: Polynomial structure enables efficient ZK proofs
- **Parameter Flexibility**: Configurable for different security levels and field sizes
- **Transparent Design**: Mathematically verifiable security properties

## Theoretical Foundations

CEE is built upon the **Affine Iterated Inversion Problem (AIIP)** with security reductions to:
1. Multivariate Quadratic (MQ) problem hardness
2. High-genus Hyperelliptic Curve Discrete Logarithm Problem (HCDLP)

The primitive maintains three core cryptographic properties:
1. **Min-Entropy Preservation**: H∞(f⁽ⁿ⁾(X)) ≥ log₂q - nlog₂d
2. **Statistical Distance**: Δ(f⁽ⁿ⁾(X), U(𝔽_q)) ≤ (q-1)(dⁿ-1)/(2√q)
3. **One-Wayness**: Computational hardness under AIIP assumption

## Repository Structure

chaotic-entropic-expansion/
├── src/                          # Source code
│   ├── core/                     # Core cryptographic operations
│   │   ├── fields.py             # Finite field implementations
│   │   ├── polynomials.py        # Polynomial class and operations
│   │   ├── iteration.py          # Iterated composition functions
│   │   └── entropy.py            # Entropy calculation and verification
│   ├── applications/             # Cryptographic applications
│   │   ├── key_derivation.py     # KDF from weak secrets
│   │   ├── commitments.py        # Statistically hiding commitments
│   │   ├── prf.py               # Pseudorandom function construction
│   │   └── owf.py               # One-way function family
│   ├── types.py                  # Core data structures
│   └── utils.py                  # Helper functions
├── tests/                        # Comprehensive test suite
│   ├── unit/                     # Unit tests for components
│   ├── property/                 # Property-based tests
│   ├── integration/              # Integration tests
│   └── conftest.py               # Test configuration
├── examples/                     # Practical usage examples
│   ├── basic_iteration.py        # Basic polynomial iteration
│   ├── entropy_verification.py   # Entropy bound verification
│   ├── key_derivation.py         # KDF from weak secrets
│   ├── commitment_scheme.py      # Commitment scheme example
│   └── data/                     # Test vectors and parameters
├── benchmarks/                   # Performance benchmarking
│   ├── scripts/                  # Benchmarking scripts
│   ├── configurations/           # Parameter configurations
│   ├── results/                  # Benchmark results
│   └── analysis/                 # Result analysis & visualization
├── docs/                         # Comprehensive documentation
│   ├── theory/                   # Theoretical explanations
│   ├── user-guide/               # Usage instructions
│   ├── api-reference/            # API documentation
│   └── tutorials/                # Step-by-step tutorials
├── assets/                       # Resources & templates
│   ├── images/                   # Diagrams & visualizations
│   ├── parameters/               # Parameter sets for different security levels
│   └── test-vectors/             # Precomputed test vectors
└── README.md                     # This file

## Installation

# Clone the repository
git clone https://github.com/KryptoResearcher/CEE.git
cd CEE

# Install in development mode
pip install -e .

# Install benchmarking dependencies (optional)
pip install -r benchmarks/requirements.txt


## Quick Start

from src.core.fields import FiniteField
from src.core.polynomials import QuadraticPolynomial
from src.core.iteration import iterate_polynomial
from src.core.entropy import verify_entropy_bounds

# Initialize parameters
field = FiniteField(1000003)  # Prime field
poly = QuadraticPolynomial(1, 0, 5)  # f(x) = x² + 5
iterations = 10
input_value = 123456

# Compute CEE iteration
result = iterate_polynomial(poly, input_value, iterations, field)

# Verify entropy bounds
min_entropy, stat_distance = verify_entropy_bounds(poly, iterations, field.size)
print(f"Min-entropy: {min_entropy:.2f} bits")
print(f"Statistical distance: {stat_distance:.6f}")

print(f"CEE result: {result}")

Run the basic example:

python examples/basic_iteration.py


## Examples

The repository includes several practical examples:

1. **Basic Iteration** (`examples/basic_iteration.py`):
   - Demonstrates core polynomial iteration and result verification

2. **Entropy Verification** (`examples/entropy_verification.py`):
   - Shows verification of min-entropy and statistical distance bounds

3. **Key Derivation** (`examples/key_derivation.py`):
   - Demonstrates KDF from weak secrets using CEE

4. **Commitment Scheme** (`examples/commitment_scheme.py`):
   - Shows implementation of statistically hiding commitments

5. **PRF Construction** (`examples/prf_construction.py`):
   - Demonstrates pseudorandom function construction

## Benchmarking

The benchmarking suite allows performance assessment across different parameter configurations:

```bash
# Run iteration performance benchmarks
python benchmarks/scripts/benchmark_iteration.py \
  -c benchmarks/configurations/standard_params.json \
  -o benchmarks/results/current/iteration_benchmark.csv

# Run entropy verification benchmarks  
python benchmarks/scripts/benchmark_entropy.py \
  -c benchmarks/configurations/standard_params.json \
  -o benchmarks/results/current/entropy_benchmark.csv

# Generate performance visualization
python benchmarks/analysis/plot_performance.py \
  -i benchmarks/results/current/iteration_benchmark.csv \
  -o benchmarks/results/current/iteration_performance.png

# Generate comprehensive report
python benchmarks/analysis/generate_report.py \
  -c benchmarks/configurations/standard_params.json \
  -i benchmarks/results/current/iteration_benchmark.csv \
  -o benchmarks/results/current/report.md
```

Pre-configured parameter sets are available for:
- Development testing (`small_params.json`)
- Realistic assessment (`standard_params.json`) 
- Theoretical validation (`theoretical_params.json`)

## Documentation

Comprehensive documentation is available in the `/docs` directory:

- **Theory Guides**: Mathematical foundations and theoretical framework
- **User Guides**: Practical usage instructions and parameter configuration
- **API Reference**: Technical API documentation
- **Tutorials**: Step-by-step walkthroughs of examples

Key documentation files:
- [Theory Overview](/docs/theory/overview.md)
- [Installation Guide](/docs/user-guide/installation.md) 
- [Quick Start Guide](/docs/user-guide/quickstart.md)
- [Parameter Configuration](/docs/user-guide/parameters.md)

## Contributing

As a research implementation, we welcome contributions from the academic community:

1. **Explore the Theory**: Read the accompanying paper and documentation
2. **Experiment with Code**: Run examples and explore the implementation
3. **Identify Issues**: Report bugs or theoretical concerns via GitHub Issues
4. **Suggest Enhancements**: Propose improvements to algorithms or documentation
5. **Submit Pull Requests**: Contribute code improvements or additional examples

Please see our [Contributing Guidelines](docs/contributing.md) and [Research Statement](docs/research.md) for more details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Citation

If you use this implementation in academic work, please cite the accompanying paper:

@article{cee2025,
  title={Chaotic Entropic Expansion: A Transparent Post-Quantum Data Confidentiality Primitive},
  author={anonymized for double blind review},
  journal={anonymized for double blind review},
  year={2025},
  note={anonymized for double blind review}
}

## Roadmap

Future work includes:

1. **Performance Optimization**: Implementation of efficient field arithmetic
2. **ZK Proof Integration**: Integration with proof systems for verifiable computation
3. **Additional Applications**: Development of more cryptographic applications
4. **Formal Verification**: Application of formal methods to verify implementation correctness
5. **Community Engagement**: Collaboration with cryptographic research communities

---

For questions and discussions, please open an issue on GitHub or contact the research team  at kryptoresearcher@proton.me.