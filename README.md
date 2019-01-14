KEM CHINA Natural Gas Model
Supplemental Material for Energy Economics Submission

Requires PATH solver to run the GAMS partial-equilibrium model using the Extended Mathematical Programmig (EMP) Framework.

To download the code use

git clone https://github.com/brioux/KEM_CHINA_EE.git

or downalod and unzip to your computer.


To run the model load the KEM_EMP GAMS IDE project, and run the KEM_CHINA Gams IDE file.

IN KEM_CHINA.gms the NGfuelpflag parameter is used to toggle pricing policies (marginal cost (1)/ price cap (4)) and the TPA scalar is used to turn on off third party access to midstream infrastructure.

The build/data directory contains the majority of calibration data that has been queried from a database and stored in .inc files ( src/data/ directory). Proprietary data sources from IHS (Vantage, EDIN) have been removed from the prebuilt .inc flies or replaced with dummy values for this open source repository.

Please contact the model developer at bertrand.rioux@kapsarc.org (or betrand.rioux@gmail.com) to request access to the full model data. A subscription to the correspondin IHS products is reuqired.
