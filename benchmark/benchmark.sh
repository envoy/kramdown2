#!/bin/bash --login

RUBY_VERSIONS=`rbenv versions --bare | sort`
KD_VERSIONS="`git tag | sort -V` master"
OTHERS=false
AVERAGE=1
MASTER_AS=master

while getopts "r:k:om:a:" optname; do
    case "$optname" in
        "r")
            RUBY_VERSIONS="$OPTARG"
            ;;
        "k")
            KD_VERSIONS="$OPTARG"
            ;;
        "o")
            OTHERS=true
            ;;
        "m")
            MASTER_AS="$OPTARG"
            ;;
        "a")
            AVERAGE="$OPTARG"
            ;;
        "?")
            echo "Unknown option $OPTARG"
            exit 1
            ;;
        ":")
            echo "No argument value for option $OPTARG"
            exit 1
            ;;
        *)
            echo "Unknown error while processing options"
            exit 1
            ;;
    esac
done

TMPDIR=/tmp/kramdown2-benchmark

rm -rf $TMPDIR
mkdir -p $TMPDIR
cp benchmark/md* $TMPDIR
cp benchmark/generate_data.rb $TMPDIR
git clone .git ${TMPDIR}/kramdown2
cd ${TMPDIR}/kramdown2

for RUBY_VERSION in $RUBY_VERSIONS; do
  if [[ ${RUBY_VERSION: -1} = m ]]; then
    rbenv shell ${RUBY_VERSION%m}
    export RUBYOPT=--mjit
  elif [[ ${RUBY_VERSION: -1} = y ]]; then
    rbenv shell ${RUBY_VERSION%y}
    export RUBYOPT=--yjit
  else
    rbenv shell $RUBY_VERSION
    unset RUBYOPT
  fi

  echo "Creating benchmark data for $(ruby -v) and RUBYOPT=${RUBYOPT}"

    for KD_VERSION in $KD_VERSIONS; do
        echo "Using kramdown2 version $KD_VERSION"
        git co $KD_VERSION 2>/dev/null
        if [ -z $MASTER_AS -o $KD_VERSION != master ]; then
            VNUM=${KD_VERSION}
        else
            VNUM=$MASTER_AS
        fi
        ruby -I${TMPDIR}/kramdown2/lib ../generate_data.rb -k ${VNUM} -a ${AVERAGE} >/dev/null
    done

    if [ $OTHERS = "true" ]; then
        ruby -rubygems -I${TMPDIR}/kramdown2/lib ../generate_data.rb -o >/dev/null
    fi
done

cd ${TMPDIR}
rbenv shell --unset
ruby generate_data.rb -g
