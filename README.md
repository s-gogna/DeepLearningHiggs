# DeepLearningHiggs

#### Authors
Nick Smith and Shubham Gogna

#### Project Description
This is a neural net implementation in Torch designed to distinguish between signal processes that produce a Higgs Boson and background processes that do not.

#### Dataset Description
The data has been produced using Monte Carlo simulations. It contains 11,000,000 samples with the last 500,000 used as the test set. The data file available from the [UCI Dataset website](https://archive.ics.uci.edu/ml/datasets/HIGGS) is 2.8GB compressed (8.0GB uncompressed).

| Column(s) | Description |
| ------------- | ------------- |
| 1  | Class label (0 = background, 1 = signal) |
| 2 - 22  | Low level features |
| 23 - 30  | High Level Features |

A signal process is one that produces a Higgs Boson and a background process is one that does not. The low level features are kinematic properties measured by the particle detectors in the accelerator. The high level features are derived by physicists to help discriminate between the two classes.
