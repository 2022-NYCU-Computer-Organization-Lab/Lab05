#!/bin/bash
rm -rf Lab5test
cp -r Lab5Code Lab5test
cd Lab5test
mkdir -p result
for ((i=1;i<=13;i++)); do
    sed -r -i -e "s/CO_test_data([0-9]+).txt/CO_test_data$i.txt/" Instr_Memory.v
    iverilog -o test *.v && vvp test > /dev/null
    cp ./result.txt result/result_$i.txt
done



basic=0
medium=0
advanced=0
# diff
echo "=============================================="
for ((i=1;i<=13;i++)); do
    echo "*************** CASE $i ******************"
    if [ $(diff -bB <(cat ../Lab5Answer/result_$i.txt) <(cat result/result_$i.txt) | wc -l ) -eq 0 ]; then
        echo "Testcase $i pass"
        if (($i >= 11)); then
            advanced=$(($advanced+10))
        elif (($i >= 7)); then
            medium=$(($medium+10))
        else
            basic=$(($basic+5))
        fi
    else
        echo "Case $i Answer : "
        cat ../Lab5Answer/result_$i.txt
        echo "------------------------------------------"
        echo "Your : "
        cat result/result_$i.txt
        echo "Testcase $i wrong"
    fi
done

echo "=============================================="
echo "Basic Score:$basic"
echo "Medium Score:$medium"
echo "Advanced Score:$advanced"
echo "Total Score:$(($basic+$medium+$advanced))"



