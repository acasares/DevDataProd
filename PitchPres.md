Given the distances from an interior point to three vertices of a rectangle, find the maximum and minimum possible areas of the rectangle.
========================================================
author: A.Casares M.
date: January 6th, 2017
autosize: true
transition: rotate

The original problem and the actual data:
========================================================
left: 45%


![plot of chunk fig1](PitchPres-figure/fig1-1.png)
For instance:    
Let BX = 9, CX = 7, AX = 3

***
**Given AX, BX and CX, is the 4th distance DX determined?**  

- Answer: Yes, with Pythagoras'  help.  


```r
  DX <- sqrt(BX^2+CX^2-AX^2)
  cat(sprintf('DX = %3.1f',DX))
```

```
DX = 11.0
```

The general question:
============================================================
left: 50%
transition: zoom


The point X moves along a circle with   r=AX and center   A.

When X moves, the rectangle adjusts its dimensions.

![alt text](gadgets.png)

***
**To see it and examine the  problem's behaviour:**    
- You can choose the three data distances in a select box.
- And vary the polar angle BAX through a slider control.
- The figures react to these changes. You can see how the area keeps changing.
<br>
<br>
**Between what limits?**

Curve of areas as function of polar angle. 
========================================================
left: 45%
transition: fade

<br>
<br>
![plot of chunk fig2](PitchPres-figure/fig2-1.png)
***   
**Empirical procedure:**

- Areas computed in each point of an uniform sample. 

- The extreme areas may be easily computed from it. 

- The figure shows the answers for a set of distances

- The minimum value of the area is at angle BAX = 0 degrees.

Analytical - Numerical Procedure
========================================================
left: 50%
transition: concave

**Finding the analytical function and its derivative is hard to do.**
<br>

![plot of chunk fig3](PitchPres-figure/fig3-1.png)
*** 
- Looks for angles making the derivative null, without using the cumbersome function. 

- Numerical derivatives, shown in blue, exhibit good linear pattern.

- A linear model fits with high R-square.

- Answers are practically identical, and close to empirical ones.
