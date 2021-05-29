#/bin/python3

for algo in ['mandelbrot_seq', 'mandelbrot_pth', 'mandelbrot_omp']:
    for file_name in ['elephant.log', 'full.log', 'seahorse.log', 'triple_spiral.log']:
        f = open(algo+"/"+file_name, "r")

        count = 1
        command = ''
        for line in f.readlines():
            if line.startswith(' Performance'):
                size = line.strip().split(' ')[9]
                threads = line.strip().split(' ')[10][:-1]
                count = 0
            elif count == 14:
                time = line.strip().split(' ')[0]
                stdev = line.strip().split(' ')[2]
                print(algo+";"+file_name+";"+size+";"+threads+";"+time+";"+stdev)
            count += 1
        f.close()
