#! /bin/bash

set -o xtrace

MEASUREMENTS=15
INITIAL_SIZE=16
SIZE=4096
NUM_THREADS=(1 2 4 8 16 32)
NUM_TASKS=(1 8 16 32 64)

make
mkdir results

# mkdir results/mandelbrot_seq
# perf stat -r $MEASUREMENTS ./mandelbrot_seq -0.188 -0.012 0.554 0.754 $SIZE 1 >> triple_spiral.log 2>&1
# mv *.log results/mandelbrot_seq
# rm output.ppm

# mkdir results/mandelbrot_pth
# perf stat -r $MEASUREMENTS ./mandelbrot_pth -0.188 -0.012 0.554 0.754 $SIZE 32 >> triple_spiral.log 2>&1
# mv *.log results/mandelbrot_pth
# rm output.ppm

# mkdir results/mandelbrot_omp
# perf stat -r $MEASUREMENTS ./mandelbrot_omp -0.188 -0.012 0.554 0.754 $SIZE 32 >> triple_spiral.log 2>&1
# mv *.log results/mandelbrot_omp
# rm output.ppm

# export PMIX_MCA_gds=hash
# mkdir results/mandelbrot_ompi
# for NUM_TASK in ${NUM_TASKS[@]}; do
#     perf stat -r $MEASUREMENTS mpirun --hostfile hostfile -np $NUM_TASK mandelbrot_ompi -0.188 -0.012 0.554 0.754 $SIZE 1 >> triple_spiral.log 2>&1
# done
# mv *.log results/mandelbrot_ompi
# rm output.ppm

# export PMIX_MCA_gds=hash
# mkdir results/mandelbrot_ompi_pth
# for NUM_TASK in ${NUM_TASKS[@]}; do
#     for NUM_THREAD in ${NUM_THREADS[@]}; do
#         perf stat -r $MEASUREMENTS mpirun --hostfile hostfile -np $NUM_TASK mandelbrot_ompi_pth -0.188 -0.012 0.554 0.754 $SIZE $NUM_THREAD >> triple_spiral.log 2>&1
#     done
# done
# mv *.log results/mandelbrot_ompi_pth
# rm output.ppm

export PMIX_MCA_gds=hash
mkdir results/mandelbrot_ompi_omp
for NUM_TASK in ${NUM_TASKS[@]}; do
    for NUM_THREAD in ${NUM_THREADS[@]}; do
        perf stat -r $MEASUREMENTS mpirun --hostfile hostfile -np $NUM_TASK mandelbrot_ompi_omp -0.188 -0.012 0.554 0.754 $SIZE $NUM_THREAD >> triple_spiral.log 2>&1
    done
done
mv *.log results/mandelbrot_ompi_omp
rm output.ppm
