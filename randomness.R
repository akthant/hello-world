

### step 0, preparation
# install.packages("Rmpfr") as the necessary package of High-precision arithmetic

# library Rmpfr for high precision arithmetic
library(Rmpfr)

# library mgrittr from tidyverse for piping
library(magrittr)

# library ggplot2 from tidyverse for drawing barchart
library(ggplot2)

# library entropy for test normality of decimal expansion
library(entropy)



# binary digits as long as 3.32193 so as to hold a decimal max 9 in its place holder
# then it could be repeated in the sequenced 1 million digits
# so an irrational number with this precision would cost 4mb (33219300/8/1024/1024) to store it
prcsn <- 33219300

# the prepared irrational numbers to chose
# pi_mpfr <- Const("pi", prec = prcsn)  # Generate pi to desired precision
ee_mpfr <- exp(mpfr(1, prec = prcsn))  # Euler's number
# gr_mpfr <- (1 + sqrt(mpfr(5, prec = prcsn))) / 2  # Golden ratio
# rt_mpfr <- sqrt(mpfr(2, prec = prcsn))  # Square root of 2
# lt_mpfr <- Const("log2", prec = prcsn)  # log2
# mixed_pingr_mpfr <- pi_mpfr + gr_mpfr

# the chosen one, where you can change
chosen_irr <- ee_mpfr # the chosen irrational Multiple Precision Floating-Point Reliable


### step 1, generate 1 million decimal digits of an irrational number
intended_digits <- chosen_irr %>% 
  formatMpfr(base = 10) %>% # convert pi to a character string
  gsub("[^0-9]", "", .) %>% # remove anything that is not a digit
  {strsplit(., "")} %>% # split into individual digits, explicitly use {} to wrap . to 1st argument
  unlist() %>% # unlist the split digits
  as.numeric() %>% # convert back to numeric
  .[1:1000000] # ensure only the first 1,000,000 digits are considered, avoid rounding errors

head(intended_digits, 10) # view the first 10 digits


### Step 2: test the distribution
# frequency table, if approximately the same numbers of times
tabled_digits <- table(intended_digits)

# chi-square test, if matches the expected uniform distribution
chisqt <- tabled_digits %>% 
  chisq.test(p = rep(0.1, 10)) %>% 
  print()


### Step 3: visualize the distribution
# Create the plot with barplot and adjust the axis

tabled_digits %>% 
  as.data.frame() %>% 
  setNames(c('Digits', 'Frequency')) %>% 
  ggplot(aes(Digits, Frequency)) + 
  geom_bar(stat = 'identity', fill = 'blue') + 
  labs(title = "Digit Frequency", x = "Digits", y = "Frequency") +
  theme_bw()


### Step 4: test normality of decimal expansion
# entropy calculation, high entropy value indicates randomness similar to a uniform distribution
# theoretical maximum, log2(10), 2.302585
entropy_empirical <- entropy.empirical(table(intended_digits)) %>% 
  print()


### Step 5: repeat for other irrational numbers
# repeat the same process for other irrational numbers
