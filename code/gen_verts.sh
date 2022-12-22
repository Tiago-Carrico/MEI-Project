#!/bin/bash

VERT_MIN=$1
VERT_MAX=$2
VERT_STEP=$3
AMOUNT=$4
P_ARC=$5
RANGE=$6
RSEED=$7

if [[ $# -ne 7 ]]
then
    echo "Usage: $0 <vertices_min> <vertices_max> <vertices_step> <num_repetitions> <arc_prob> <max_capacity> <rand_seed>"
    exit 2
fi

RANDOM=$RSEED

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


