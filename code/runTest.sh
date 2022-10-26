#!/bin/bash

TIMEOUT=$1
FOLDER=$2
FPREFIX=$3
REPEAT=$4
FOUT=$5

LINE=$(echo -n "num_verts prob_arc max_cap seed")
for IND in $(seq 1 $REPEAT)
do
    LINE=$(echo -n "$LINE dinic$IND ek$IND mpm$IND")
done
echo "$LINE" >> $FOUT

for FILE in $(ls ./$FOLDER | grep $FPREFIX)
do
    echo "[TEST] $FILE"
    #PRE=$(echo -n $FPREFIX | wc -c)
    VERTS=$(echo -n $FILE | cut -d_ -f2)
    PROBARC=$(echo -n $FILE | cut -d_ -f3)
    MAXCAP=$(echo -n $FILE | cut -d_ -f4)
    SEED=$(echo -n ${FILE%.*} | cut -d_ -f5)

    LINE=$(echo -n "$VERTS $PROBARC $MAXCAP $SEED")

    for IND in $(seq 1 $REPEAT)
    do
        echo "[LOOP] $IND"
        echo -n "[EXEC] DINIC..."
        DINIC=$(./Dinic $TIMEOUT "$FOLDER/$FILE" | tail -n1)
        echo "done!"

        echo -n "[EXEC] EK..."
        EK=$(./EK $TIMEOUT "$FOLDER/$FILE" | tail -n1)
        echo "done!"

        echo -n "[EXEC] MPM..."
        MPM=$(./MPM $TIMEOUT "$FOLDER/$FILE" | tail -n1)
        echo "done!"

        LINE=$(echo -n "$LINE $DINIC$IND $EK$IND $MPM$IND")
    done

    echo "$LINE" >> $FOUT
done
