# first to launch
#!/bin/bash
set -euo pipefail

port=${1:-6789}

source $HOME/spack/share/spack/setup-env.sh

spack load distributedworkflow

host=$(scontrol show hostnames)

# add the path here
echo "$host" > $HOME/loghost_$SLURM_JOB_ID


gspc-logging-to-stdout.exe --log-port $port --log-host $host
