# 1970-Draft-Lottery


From the following plot we can see that the December birthdays (far right) were assigned many low draft numbers (bottom), representing early induction, and few high numbers (top).

![alt tag] (https://github.com/karapa/1970-Draft-Lottery/blob/master/scatterplot.png)


The same conclusion is drawn from the following graph. Again, there seems to be a lot fewer high numbers in the later months of the year and a lot fewer low numbers in the earlier months. This ca be interpreted as men that were born in the last months of the year seem to have a higher chance of being called earlier.

put boxplot!!!! 

In order to formally investigate this suspicion that the drawing was not done correctly I fitted non-parametric
curves to the data. I chose the locally weighted regression scatter plot smoothing (lowess) method.
I first fitted local linear regression models with three different span values 2/3, 1/3 and 1/10. The span
represents the fraction of the data that will be included in each fit. 

![alt tag] (https://github.com/karapa/1970-Draft-Lottery/blob/master/linear%20non%20param.png)

As can be seen from the plot, the span=2/3 (red curve) and 1/3 (green curve) provide reasonable smoothing
since they follow the curvilinearity within the data. The span of 1/10 (blue curve) makes the local regressions
highly sensitive to “noise” variation within the data values. This produces an undulating curve, which
obscures the overall structure in the data.

I proceed by fitting a second-order model. 

![alt tag] (https://github.com/karapa/1970-Draft-Lottery/blob/master/quad%20non%20param.png)

Again the span=2/3 and 1/3 provide reasonable smoothing. Span of 1/10 tents to overfit the data.

After plotting the results we have to choose the span and the use of linear or quadratic regression. Regarding
the span we want the smallest that provides a smooth fit. And generally speaking a higher degree polynomial
will provide a better approximation of the underlying mean than a lower polynomial degree—i.e., a higher
degree polynomial will have less bias. Higher degree polynomials also have more coefficients to estimate,
however, resulting in higher variability. Therefore, we have to make a compromise between bias and
variability. Since by examining the graphs there is not clear-cut answer as to which model to select we chose
to base our decision in an objective index. We chose the improved version of a criterion based on the Akaike
Information Criterion (AIC), termed AICc. It is derived and examined as a way to choose the smoothing
parameter, as proposed by Hurvich and Simonoff, 1998. The writers sustain the use of AICc avoids the large
variability and tendency to undersmooth.
The model with the smallest AICc is quadratic with span=0.89. It is plotted in the following graph.

![alt tag] (https://github.com/karapa/1970-Draft-Lottery/blob/master/AICp.png)

To conclude, we have substantial evidence to support our initial suspicion that there were more low lottery
numbers in the later months of the year. With 95% confidence we conclude that men that were born in the
last months of the year had a higher chance be drafted sooner and consequently of being called earlier to
perform their military duty.
