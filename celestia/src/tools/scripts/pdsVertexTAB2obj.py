#!/usr/bin/env python
#Purpose: To convert SIMPLE PDS Plate-Vertex to Alias WaveFront OBJ
# Trent Hare, April 2013

import sys, os
def Usage():
    print '''
    This script converts a SIMPLE shapemodel Plate-Vertex to Alias Wavefront OBJ
    Usage: %s <input.tab> <output.obj>
    '''%sys.argv[0]
    
if len(sys.argv) < 3:
    Usage()
    sys.exit(0)

#Create the output datasource
try:
    output = sys.argv[2]
except:
    Usage()
    sys.exit(1)

#Open the PDS tab file to read
try:
    input = sys.argv[1]
except:
    Usage()
    sys.exit(1)

infile = open(input, 'r')

#Create an empty file
outfile = open(output, 'w')

#Loop through the input
i = 0
for line in infile:
    if (i == 0):
        nVerts, nFaces = line.split()
        nVerts = int(nVerts)+1
        nFaces = int(nFaces)
        print line
    else:
        l1, l2, l3, l4 =  line.split()
        if i < int(nVerts):
            outfile.write('v ' + l2 + ' ' + l3 + ' ' + l4 + '\n')
        else:
            outfile.write('f ' + l2 + ' ' + l3 + ' ' + l4 + '\n')
    i = i + 1

print "Obj successfully created."