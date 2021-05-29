#! /bin/bash

set -o xtrace

MEASUREMENTS=10
ITERATIONS=10
INITIAL_SIZE=16

SIZE=$INITIAL_SIZE

NUM_THREADS=(1 2 4 8 16 32)

make
mkdir results

mkdir results/mandelbrot_seq

for ((i=1; i<=$ITERATIONS; i++)); do
	perf stat -r $MEASUREMENTS ./mandelbrot_seq -2.5 1.5 -2.0 2.0 $SIZE 1 >> full.log 2>&1
	perf stat -r $MEASUREMENTS ./mandelbrot_seq -0.8 -0.7 0.05 0.15 $SIZE 1 >> seahorse.log 2>&1
	perf stat -r $MEASUREMENTS ./mandelbrot_seq 0.175 0.375 -0.1 0.1 $SIZE 1 >> elephant.log 2>&1
	perf stat -r $MEASUREMENTS ./mandelbrot_seq -0.188 -0.012 0.554 0.754 $SIZE 1 >> triple_spiral.log 2>&1
	SIZE=$(($SIZE * 2))
done

SIZE=$INITIAL_SIZE
mv *.log results/mandelbrot_seq
rm output.ppm

mkdir results/mandelbrot_pth

for ((i=1; i<=$ITERATIONS; i++)); do
	for NUM_THREAD in ${NUM_THREADS[@]}; do
		perf stat -r $MEASUREMENTS ./mandelbrot_pth -2.5 1.5 -2.0 2.0 $SIZE $NUM_THREAD >> full.log 2>&1
		perf stat -r $MEASUREMENTS ./mandelbrot_pth -0.8 -0.7 0.05 0.15 $SIZE $NUM_THREAD >> seahorse.log 2>&1
       	perf stat -r $MEASUREMENTS ./mandelbrot_pth 0.175 0.375 -0.1 0.1 $SIZE $NUM_THREAD >> elephant.log 2>&1
       	perf stat -r $MEASUREMENTS ./mandelbrot_pth -0.188 -0.012 0.554 0.754 $SIZE $NUM_THREAD >> triple_spiral.log 2>&1
	done
       SIZE=$(($SIZE * 2))
done

SIZE=$INITIAL_SIZE
mv *.log results/mandelbrot_pth
rm output.ppm

mkdir results/mandelbrot_omp

for ((i=1; i<=$ITERATIONS; i++)); do
	for NUM_THREAD in ${NUM_THREADS[@]}; do
		perf stat -r $MEASUREMENTS ./mandelbrot_omp -2.5 1.5 -2.0 2.0 $SIZE $NUM_THREAD >> full.log 2>&1
		perf stat -r $MEASUREMENTS ./mandelbrot_omp -0.8 -0.7 0.05 0.15 $SIZE $NUM_THREAD >> seahorse.log 2>&1
        	perf stat -r $MEASUREMENTS ./mandelbrot_omp 0.175 0.375 -0.1 0.1 $SIZE $NUM_THREAD >> elephant.log 2>&1
        	perf stat -r $MEASUREMENTS ./mandelbrot_omp -0.188 -0.012 0.554 0.754 $SIZE $NUM_THREAD >> triple_spiral.log 2>&1
	done
        SIZE=$(($SIZE * 2))
done

mv *.log results/mandelbrot_omp
rm output.ppm


