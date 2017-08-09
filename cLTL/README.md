# cLTL

This Matlab implementation takes cLTL specifications, transition matrix, environment as input and synthesizes individual trajectories for agents such that specifications are met.
For more information on cLTL+ please refer to
```Sahin, Yunus Emre, Petter Nilsson, and Necmiye Ozay. "Provably-correct coordination of large collections of agents with counting temporal logic constraints." Proceedings of the 8th International Conference on Cyber-Physical Systems. ACM, 2017. ```

### Dependencies

* [YALMIP](https://yalmip.github.io/)
* YALMIP compatible MILP solver
  * [Gurobi](http://www.gurobi.com/)
  * [CPLEX](https://www-01.ibm.com/software/commerce/optimization/cplex-optimizer/)

### Installing

* Easiest way to install YALMIP is to download [MPT3](http://control.ee.ethz.ch/~mpt/3/Main/Installation?action=download&upname=install_mpt3.m) tool by [Herceg et.al.](http://control.ee.ethz.ch/~mpt)

* Download Gurobi optimizer and acquire a license file

* Go to Gurobi installation path (e.g. ```/Library/gurobi702/mac64/matlab```) and run ```gurobi_setup.m```


## Running the tests

Run ```yalmiptest``` on Matlab to see if YALMIP is installed correctly and if Gurobi is added.

## Examples

* ```earthquake.m``` (Example in ICCPS17 paper with continuous dynamics)
