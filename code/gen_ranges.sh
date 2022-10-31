#!/bin/bash

RANGE_MIN=$1
RANGE_MAX=$2
RANGE_STEP=$3
AMOUNT=$4
VERT=$5
P_ARC=$6

for ((i = $RANGE_MIN ; i <= $RANGE_MAX ; i+= $RANGE_STEP)); do
    for ((j = 0; j < $AMOUNT; j++)); do
        while : ; do
            seed=$RANDOM
            filename="test_${VERT}_${P_ARC}_${i}_$seed.txt"
            python3 gen.py $VERT $P_ARC $i $seed $filename
            result=`head -1 $filename`
            if [[ $result = "-1" ]]
            then
                rm $filename
            fi
            [[ $result = "-1" ]] || break
        done
    done

done


