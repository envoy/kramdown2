#!/bin/bash --login

./benchmark/benchmark.sh -k master -r "$@" -a 3

eval $(grep -e '^TMPDIR' benchmark/benchmark.sh)
cd $TMPDIR

for I in kramdown2-ruby*.dat; do
  echo $I | sed -E 's/.*(ruby-.*p[0-9]+(-[my]jit)?).*/\1 ||/' > $I.ruby
  awk '{ print $2 }' $I | tail -n +2 >> $I.ruby
done
paste <(awk '{ print $1 }' $(ls kramdown2-ruby*.dat | head -n 1)) *.ruby > kramdown2-rubies.dat

ruby generate_data.rb -g
