#!/bin/bash

. "$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/../../../cmd/$(basename $BASH_SOURCE)" $1 $2 $3 $4 $5

