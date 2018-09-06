KEM CHINA Natural Gas Model
Supplemental Material for Energy Economics Submission

Requires PATH solver to run the GAMS partial-equilibrium model using the Extended Mathematical Programmig (EMP) Framework.

To Run model load the KEM_EMP  GAMS IDE project, and run using the KEM_CHINA Gams IDE file.

NGfuelpflag parameter can be used to toggle pricing policies (marginal cost (1)/ price cap (4)) and the TPA scalar to turn on off third party access to midstream infrastructure.

The build/data directory contains the majority of calibration data that has been queried from a database and stored in .inc files used to calibrate the model in the src/data/ files. Some of the proprietary data sources used in the model have been removed from the prebuilt .inc flies for this open source repository.

Contact the model developer at bertrand.rioux@kapsarc.org for more info.
