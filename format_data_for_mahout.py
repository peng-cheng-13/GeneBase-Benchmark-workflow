#!/usr/bin/python

import os
import sys
import time

def main(argv):
  format_data_for_mahout(argv[1], argv[2] + '/' + os.path.basename(argv[1]) + '_mahout')

def format_data_for_mahout(filename, out_file):
  f = open(filename, 'r')
  fout = open(out_file, 'w')
  first = 0
  num = 0
  data = []
  for line in f:
    if first < 2:
      first = first + 1
    else:
      parts = line.split()
      if len(parts) >=3 :
        parts[2] = "{0:.2f}".format(float(parts[2])) # special because original #s have precision of only 2 places after decimal
	#data.append(','.join(parts)+'\n')
	#fout.write(','.join(parts)+'\n')
	if num > 100000:
	  time_start=time.time()
	  #print 'Write once'
	  fout.write(''.join(data))
	  time_end=time.time()
	  print('Write cost:',time_end-time_start)
	  data = []
	  num = 1
	  time_start=time.time()
	  data.append(','.join(parts)+'\n')
	  time_end=time.time()
          print('Append cost:',time_end-time_start)
	else:
	  data.append(','.join(parts)+'\n')
	  num = num+1

  #fout.write(''.join(data))
  #fout.write(','.join(parts)+'\n')

if __name__ == "__main__":
  main(sys.argv)
