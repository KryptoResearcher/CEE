# CEE (Chaotic Entropic Expansion) Implementation

This repository contains the reference implementation for the CEE primitive described in the paper "The Chaotic Entropic Expansion (CEE): A First Pillar of the CASH Primitive Family for Confidentiality".

## Contents
- `OWF_Formal_Def.tex`: Formal and complete definition of One Way Function
- `Proof_AIIP_Reduce_to_DLP_aiip-dlp.tex`: Complete proofof the AIIP reduction to DLP
- `Proof_AIIP_Reduce_to_MQ_aiip-mq.tex`: Complete proofof the AIIP reduction to MQ
- `PolynomialFd.sage`: Implementation of the $\mathcal{F}_d$ polynomial class
- `CEE_functions.sage`: Functions for computing iterated polynomial evaluations
- `CEE_examples.sage`: Examples and test cases validating the theoretical bounds
- `CEE_validation.sage`: Statistical validation using NIST test suite (to be implemented)
- `CEE_functions.c`: Functions for computing iterated polynomial evaluations


## Requirements

- SageMath 9.0+
- Python 3.8+

## Usage

1. Start SageMath: `sage`
2. Load and run examples: `load("CEE_examples.sage")`

## Key Features

1. **PolynomialFd class**: Ensures polynomials meet the $\mathcal{F}_d$ criteria:
   - Non-linearity (degree ≥ 2)
   - Fixed-point free condition
   - Image expansion condition

2. **Iteration functions**: Compute $f^{[n]}(x)$ efficiently

3. **Entropy analysis**: Calculate min-entropy and statistical distance

4. **Validation examples**: Reproduce results from the paper

## Example Results

Running the examples should produce output similar to:
=== Small Field Examples ===
Field F17 with f(x) = x^2 + 2
n=1: H_inf=3.999 bits, delta=0.1250
n=2: H_inf=3.599 bits, delta=0.2350
n=3: H_inf=3.199 bits, delta=0.3450

Field F31 with f(x) = x^2 + 1
n=1: H_inf=4.954 bits, delta=0.0320
n=2: H_inf=4.554 bits, delta=0.0640


## References

For theoretical details and security analysis, please see the accompanying paper.