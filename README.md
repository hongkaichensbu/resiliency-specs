# STL-based Resiliency Specification

This is an implementation of the resiliency framework and case studies in the paper "An STL-based Formulation of Resilience in Cyber-Physical Systems"


## Prerequisites

1. Matlab R2021b or later (R2021a should work).
2. [Breach](https://github.com/decyphir/breach) toolbox 1.10.0

We note that modifications have been made to Breach for additional features such as identifying an STL formula is an argument of an SRS atom.

## Resiliency Framework

Our implementation includes two major parts: one for core functionalities and one for presentation.

### Core Functions

Under ReSV_quant/Core. The folder contains all necessary files to compute the r-values of any SRS formula.

### Presentation

Under ReSV_quant/Display. The folder contains methods to display ReSV sets with text or graphs.

## Example 2 in the paper

Execute example2_plot.m file.

## UAV package delivery

We use an [implememtation](https://github.com/yrlu/quadrotor) of quadrotor modeling used in the GRASP UAV testbed [1].

> [1] Michael, Nathan, et al. "The GRASP multiple micro-UAV testbed." IEEE Robotics & Automation Magazine 17.3 (2010): 56-65. 

### Re-produce Fig 3, Tables 1 and 2 in the paper

Run trace_uav.m file under uav_example/.

## Flock Formation

We use an implememtation of the Reynolds flocking model [2,3] for generating trajectories.

> [2] Reynolds, Craig W. "Flocks, herds and schools: A distributed behavioral model." Proceedings of the 14th Annual Conference on Computer Graphics and Interactive Techniques. 1987.  
> [3] Reynolds, Craig W. "Steering behaviors for autonomous characters." Game Developers Conference. Vol. 1999. 1999.

### Re-produce Figs 4 and 5, Tables 3 and 4 in the paper

Go to "flocking_example" folder. Run the trace1.m file. Then run plot_flock_snapshots.m file.

### Run the flock simulation

Go to "flocking_example" folder. Run Boids.m file.
