#!/bin/bash

set -e


# setup ros environment

#source /fastdds/install/setup.bash

/fastdds/fast-discovery-server -i 0 -l 127.0.0.1 -p 11811 -b
