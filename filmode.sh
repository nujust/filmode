#!/bin/bash

# $1: .fil name
# $2: output key
# $3: output id

this=$(readlink -f $0)
exe=${this%.*}
fil_dir=$(dirname $1)
fil_name=$(basename $1)
key=$2
id=$3

pushd $fil_dir

if [ -f $fil_name ]; then
  abaqus $exe<<EOS
${fil_name%.*}
${fil_name%.*}_mode${id}.txt
$key
$id
EOS

else
  echo 'Error: '$fil_name' not found'
fi

popd
