#!/usr/bin/bash


SRC=gfx/portraits
DST=gfx/portraits_red

find "$SRC" -type d | while IFS= read -r line; do
   mkdir -v -p ${DST}${line/${SRC}}
done

find "$SRC" -name '*.png' -o -name '*.webp' | while IFS= read -r line; do
   if [ "$line" -nt "$0" ] ; then
      res=$(identify -verbose "$line" | grep -o -m 1 'geometry: 400x[0-9][0-9]*')
      if [ "$res" != "" ] ; then
         dst=${DST}${line/${SRC}}
         geom=$( echo "$res" | sed "s/^.*geometry: 400x\([0-9][0-9]*\)$/\1/")
         newgeom=200x$(expr $geom / 2)
         echo "$line:400x$geom -> $dst:$newgeom"
         convert -scale "$newgeom" "$line" "$dst"
      fi
   fi
done
touch $0
