# PolynomialFd.sage
class PolynomialFd:
    """
    A class representing polynomials in the F_d class suitable for cryptographic iteration.
    """
    
    def __init__(self, f, field):
        """
        Initialize a polynomial in F_d class.
        
        Args:
            f: A polynomial function or expression
            field: The finite field over which the polynomial is defined
        """
        self.field = field
        self.f = f
        self.d = f.degree()
        
        # Verify the polynomial meets F_d conditions
        self._verify_conditions()
    
    def _verify_conditions(self):
        """Verify that the polynomial meets all F_d conditions."""
        # 1. Non-linearity condition
        if self.d < 2:
            raise ValueError("Polynomial must have degree ≥ 2")
        
        # 2. Fixed-point free condition
        for x in self.field:
            if self.f(x) == x:
                raise ValueError(f"Polynomial has fixed point at x = {x}")
        
        # 3. Image expansion condition
        image_set = set(self.f(x) for x in self.field)
        q = self.field.order()
        if len(image_set) < q - sqrt(q):
            raise ValueError("Polynomial does not satisfy image expansion condition")
    
    def evaluate(self, x):
        """Evaluate the polynomial at point x."""
        return self.f(x)
    
    def __call__(self, x):
        """Evaluate the polynomial at point x."""
        return self.evaluate(x)
    
    def __str__(self):
        return f"Polynomial in F_d: {self.f} over {self.field}"