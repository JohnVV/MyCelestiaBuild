#! /bin/bash
function min () {
         if(( $1 < $2 )); then
                  echo $1
         else
                  echo $2
         fi
}

if [ $# -lt 3 -o "$1" = " --help" ] ; then
 echo
 echo ' Usage: vipsvt [--help | <texture name><tile size><tile format>] [e|E|w|W]'
 echo
else
block_width=$2;
block_height=$2;

dir=`dirname $1`
file=`basename $1`
fileformat=$3
#copy=$$_$file.v
 #echo making local copy of image as $copy ...
 
#vips im_copy $1 $copy

width=`vips im_header_int Xsize $file`
height=`vips im_header_int Ysize $file`

j=0

while (( j * block_width + block_width <= height ));do
      ((top = j * block_width ))
  if [ $# -eq 4 ]; then
     if [ "$4" = "e" -o "$4" = "E" ]; then
          ioff=$(( width/block_width ))
     elif ["$4" = "w" -o "$4" = "W" ]; then
          ioff=0
      else
       echo
       echo "*** Incorrect 4th paramenter! **"
       echo
      return
    fi
 fi 
 
i=0

    while (( i * block_width + block_width <= width )); do
          ((left = i * block_width))
          toname=$dir/tx_$((i + ioff))_${j}.$fileformat
          
          ((right = $width - $left))
          ((bottom = $height - $top))
          
          tile_width=`min $block_width $right`
          tile_height=`min $block_height $bottom`
          
     echo extracting tile $left $top as $toname
          vips im_extract_area $file $toname \
              $left $top $tile_width $tile_height

   
   ((i++))
   done
   ((j++))
  done
  
  # rm $$_$file.v
  # rm $copy
   #rm $$_$file.desc
fi
