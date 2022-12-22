#!/bin/bash

ARC_MIN=$1
ARC_MAX=$2
ARC_STEP=$3
AMOUNT=$4
VERT=$5
RANGE=$6
RSEED=$7

if [[ $# -ne 7 ]]
then
    echo "Usage: $0 <arc_prob_min> <varc_prob_max> <arc_prob_step> <num_repetitions> <num_vertices> <max_capacity> <rand_seed>"
    exit 2
fi

RANDOM=$RSEED

for ((i = ${ARC_MIN} ; i <= $ARC_MAX ; i+= $ARC_STEP)); do
    for ((j = 0; j < $AMOUNT; j++)); do
        while : ; do
            seed=$RANDOM
            hundo=100
            abc=$(echo "scale=1; ${i} / $hundo" | bc | sed -e 's/^\./0./')
            filename="test_${VERT}_${abc}_${RANGE}_$seed.txt"
            python3 gen.py $VERT $abc $RANGE $seed $filename
            result=`head -1 $filename`
            if [[ $result = "-1" ]]
            then
                rm $filename
            fi
            [[ $result = "-1" ]] || break
        done
    done

done


