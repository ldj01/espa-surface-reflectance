#!/bin/bash
#
# Test lndpm.

base_scene="LE07_L1TP_043028_20020419_20180206_01_T1"
mtl="${base_scene}_MTL.txt"
xml="${base_scene}.xml"

if [ "$#" -ne 2 ]; then
    echo "Usage:  $0 <path_to_lndpm> <data_path>"
    exit 1
fi
bin_dir=$1
data_dir=$2

data_files=(${data_dir}/*)
input_dir=$LEVEL2_UNIT_TEST_DATA/espa-surface-reflectance/input

mkdir -p lndpm && cd lndpm

$bin_dir/lndpm --xml $input_dir/$xml
if [ $? -ne 0 ]; then
    echo "Error: lndpm processing failed."
    exit 1
fi

status=0
for i in "${data_files[@]}"; do
    sed -e s%LEVEL2_UNIT_TEST_DATA%${input_dir}% \
        -e s%LEDAPS_AUX_DIR%${LEDAPS_AUX_DIR}% $i > tmp.dat

    diff tmp.dat `basename $i`
    if [ $? -ne 0 ]; then
        echo "$i differs from reference version."
        status=1
    fi
done

if [ $status -ne 0 ]; then
    echo "Test differences found."
    exit 1
fi

cd ..
rm -r lndpm

echo "Test completed successfully."
exit 0
