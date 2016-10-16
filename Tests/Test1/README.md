## Comparison of different array searching implementation in MATLAB
http://stackoverflow.com/a/1913831/97160

Two benchmarks are included, one for searching a single value,
another for searching multiple values (vectorized version).

You could also try different matrix sizes, as well as changing the search values
(compare best case where all values are found in the array
vs. worst case scenario when none of the values are found).

Note: Floating-point comparison is not considered here!
See [`ismembertol`][1] function for that.

[1]: http://www.mathworks.com/help/matlab/ref/ismembertol.html
