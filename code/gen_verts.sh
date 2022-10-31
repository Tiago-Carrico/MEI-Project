#!/bin/bash

VERT_MIN=$1
VERT_MAX=$2
VERT_STEP=$3
AMOUNT=$4
P_ARC=$5
RANGE=$6

for ((i = $VERT_MIN ; i <= $VERT_MAX ; i+= $VERT_STEP)); do
    for ((j = 0; j < $AMOUNT; j++)); do
        while : ; do
            seed=$RANDOM
            filename="test_${i}_${P_ARC}_${RANGE}_$seed.txt"
            python3 gen.py $i $P_ARC $RANGE $seed $filename
            result=`head -1 $filename`
            if [[ $result = "-1" ]]
            then
                rm $filename
            fi
            [[ $result = "-1" ]] || break
        done
    done

done


