set -euo pipefail

module purge
module use /p/hpc/soft/etc/modules
module use /m/usoft/etc/modules

module load /p/hpc/soft/etc/modules/soft/julia/1.9.2

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

srun -N "$(cat $NODEFILE | wc -l)" --nodelist="$(cat $NODEFILE | tr '\n' ',')" --ntasks-per-node=2 julia -e execute_script.jl $NODEFILE $log_host $port &

wait
