# second to launch
#!/bin/bash

sbatch --nodes=2 --ntasks-per-node=2 --time=08:30:00 --job-name=test_julia ${PWD}/launch.sh
