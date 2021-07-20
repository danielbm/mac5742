#!/bin/python3
import sys

if len(sys.argv) < 2:
    print("missing parameter\nusage: ./parse_results.py <results_dir>")
    exit(0)

result_dir = sys.argv[1]

# for algo in ['mandelbrot_seq', 'mandelbrot_pth', 'mandelbrot_omp']:
#     for file_name in ['elephant.log', 'full.log', 'seahorse.log', 'triple_spiral.log']:
for algo in ['mandelbrot_ompi_omp']:
    for file_name in ['triple_spiral.log']:
        f = open(result_dir+"/"+algo+"/"+file_name, "r")

        count = 1
        command = ''
        cpus = ''
        clock = ''
        cycles = ''
        instructions = ''
        for line in f.readlines():
            if line.startswith(' Performance'):
                tasks = line.strip().split(' ')[8]
                size = line.strip().split(' ')[14]
                threads = line.strip().split(' ')[15][:-1]
                count = 0
            elif count == 2:
                clock = line.strip().split(' ')[0]
                cpus = line.split('#')[1].strip().split(' ')[0]
            elif count == 6:
                cycles = line.strip().split(' ')[0]
            elif count == 9:
                instructions = line.strip().split(' ')[0]
            elif count == 14:
                time = line.strip().split(' ')[0]
                stdev = line.strip().split(' ')[2]
                print(algo+";"+file_name+";"+size+";"+threads+";"+time+";"+stdev+";"+clock+";"+cpus+";"+cycles+";"+instructions+";"+tasks)
            count += 1
        f.close()
