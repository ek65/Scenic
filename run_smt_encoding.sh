#!/bin/bash

result=`dreal test_smt_encoding.smt2`
echo $result
if [[ "$result" == *"delta-sat"* ]]; then
	output=1
else
	output=0
fi
echo $output

exit $output