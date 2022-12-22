#!/bin/bash

TIMEOUT=$1
FOLDER=$2
FPREFIX=$3
REPEAT=$4
FOUT=$5

if [[ $# -ne 5 ]]
then
    echo "Usage: $0 <timeout> <folder> <file_prefix> <num_repetitions> <output_file>"
    exit 2
fi

LINE=$(echo -n "num_verts prob_arc num_arcs max_cap seed algo time")
# for IND in $(seq 1 $REPEAT)
# do
#     LINE=$(echo -n "$LINE dinic$IND ek$IND mpm$IND")
# done
echo "$LINE" >> $FOUT

for FILE in $(ls ./$FOLDER | grep $FPREFIX)
do
    echo "[TEST] $FILE"
    #PRE=$(echo -n $FPREFIX | wc -c)
    VERTS=$(echo -n $FILE | cut -d_ -f2)
    PROBARC=$(echo -n $FILE | cut -d_ -f3)
    MAXCAP=$(echo -n $FILE | cut -d_ -f4)
    SEED=$(echo -n ${FILE%.*} | cut -d_ -f5)
    ARC=$(cat "$FOLDER/$FILE" | head -n1 | cut -d" " -f2)
    ARC=$(echo -n ${ARC//[$'\t\r\n']})

    LINE=$(echo -n "$VERTS $PROBARC $ARC $MAXCAP $SEED")

    for IND in $(seq 1 $REPEAT)
    do
        echo "[LOOP] $IND"
        echo -n "[EXEC] DINIC..."
        DINIC=$(./Dinic $TIMEOUT "$FOLDER/$FILE")
        DINICTIME=$(echo $DINIC | cut -d" " -f2)

        if [[ $(echo $DINIC | cut -d" " -f1) == "-1" ]]
        then
            echo "timeout!"
        else
            echo "done!"
            echo "$LINE dinic $DINICTIME" >> $FOUT
        fi

        echo -n "[EXEC] EK..."
        EK=$(./EK $TIMEOUT "$FOLDER/$FILE")
        EKTIME=$(echo $EK | cut -d" " -f2)

        if [[ $(echo $EK | cut -d" " -f1) == "-1" ]]
        then
            echo "timeout!"
        else
            echo "done!"
            echo "$LINE ek $EKTIME" >> $FOUT
        fi

        echo -n "[EXEC] MPM..."
        MPM=$(./MPM $TIMEOUT "$FOLDER/$FILE")
        MPMTIME=$(echo $MPM | cut -d" " -f2)

        if [[ $(echo $MPM | cut -d" " -f1) == "-1" ]]
        then
            echo "timeout!"
        else
            echo "done!"
            echo "$LINE mpm $MPMTIME" >> $FOUT
        fi
    done
done
