import mpmath as mp
import numpy as np
from collections import Counter
from scipy.stats import chisquare, entropy
import matplotlib.pyplot as plt


##### step 1: precision and irrational number
# we want 1,000,000 decimal digits, we set
mp.mp.dps = 1_000_050  # small buffer to avoid truncation

# choose an irrational number
chosen_irr = mp.e        # Euler's number
# alternatives:
# mp.pi
# mp.sqrt(2)
# (1 + mp.sqrt(5)) / 2




##### step 2: generate 1,000,000 decimal digits
# convert to decimal string
decimal_str = mp.nstr(chosen_irr, n=mp.mp.dps)

# keep digits only
digits_only = ''.join(ch for ch in decimal_str if ch.isdigit())

# convert to numeric array and truncate
intended_digits = np.array(
    [int(d) for d in digits_only[:1_000_000]],
    dtype=np.int8
)

print(intended_digits[:10])




##### step 3: frequency table & chi-square test
counts = Counter(intended_digits)

observed = np.array([counts.get(i, 0) for i in range(10)])
expected = np.full(10, observed.sum() / 10)

chi2, p_value = chisquare(observed, expected)

print("Chi-square:", chi2)
print("p-value:", p_value)




# step 4: visualization
plt.figure(figsize=(8, 4))
plt.bar(range(10), observed)
plt.xlabel("Digit")
plt.ylabel("Frequency")
plt.title("Digit Frequency (Decimal Expansion)")
plt.xticks(range(10))
plt.tight_layout()
plt.show()





##### step 5: entropy of decimal expansion
probabilities = observed / observed.sum()

entropy_empirical = entropy(probabilities, base=2)

print("Empirical entropy:", entropy_empirical)
print("Theoretical max:", np.log2(10))





##### step 6: reusable function
def analyze_irrational(x, n_digits=1_000_000):
    mp.mp.dps = n_digits + 50
    s = mp.nstr(x, n=mp.mp.dps)

    digits = np.array(
        [int(ch) for ch in s if ch.isdigit()][:n_digits],
        dtype=np.int8
    )

    counts = Counter(digits)
    observed = np.array([counts.get(i, 0) for i in range(10)])
    expected = np.full(10, observed.sum() / 10)

    chi2, p = chisquare(observed, expected)
    ent = entropy(observed / observed.sum(), base=2)

    return {
        "observed": observed,
        "chi2": chi2,
        "p_value": p,
        "entropy": ent
    }

# use the function to analyze pi
result = analyze_irrational(mp.pi)
print(result)
