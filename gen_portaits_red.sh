#!/usr/bin/bash


SRC=gfx/portraits
DST=gfx/portraits_red

find "$SRC" -type d | while IFS= read -r line; do
   mkdir -v -p ${DST}${line/${SRC}}
done

find "$SRC" -name '*.png' -o -name '*.webp' | while IFS= read -r line; do
   res=$(identify -verbose "$line" | grep -m 1 'geometry: 400x')
   if [ "$res" != "" ] ; then
      geom=$( echo "$res" | sed "s/^.*geometry: \([0-9]*x[0-9]*\).*$/\1/")
      W=$(echo "$geom" | cut -dx -f1)
      H=$(echo "$geom" | cut -dx -f2)
      newgeom=$(expr $W / 2)x$(expr $H / 2)
      echo "$line:$geom -> ${DST}${line/${SRC}}:$newgeom"
      convert -scale "$newgeom" "$line" ${DST}${line/${SRC}}
   fi
done
