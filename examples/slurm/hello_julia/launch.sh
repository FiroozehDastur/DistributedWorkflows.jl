set -euo pipefail

module purge
module use /p/hpc/soft/etc/modules
module use /m/usoft/etc/modules

module load path/to/julia # update julia first

source $HOME/spack/share/spack/setup-env.sh

spack load distributedworkflow

NODEFILE=$(mktemp -p $HOME/nodefile_$SLURM_JOB_ID)
scontrol show hostnames > $NODEFILE

log_host=$(head -n 1 $NODEFILE)

tail -n +2 $NODEFILE > $NODEFILE

port=${1:-6789}

# host=$(scontrol show hostnames)
# echo "$host" > $HOME/loghost_$SLURM_JOB_ID

srun -N 1 -n 1 --nodelist=$log_host gspc-logging-to-stdout.exe --port $port &

sleep 5s

# Questions for mirko
# how to convert line separated list into a comma separated list (scontrol show hostnames, bash command)
srun -N 2 -n 2 --nodelist=??? julia -e execute_script.jl $NODEFILE $log_host $port &

wait
