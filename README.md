# finite-difference-PDE
There are some course materials based on MATH5212 of CUHK.


Leapfrog scheme is extensively investigated in Chapter 4 and 5, where I learn that the phenomenon 'bounce back' occurs if there is inconsitent boundary condition. 
At first, I added the inconsistent condition to scheme_computation but it's proved to be unnecessary. Review the stentil of leapfrog, 
we inevitably have the points on the right boundary to be 0, which means 'bounce back' as long as the non-zero part of wave arrives at this line!


