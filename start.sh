#!/bin/bash

set -e

echo "== Preparing DB =="
bundle exec rails db:migrate

echo "== Starting Rails Server =="
bundle exec rails server -b 0.0.0.0 -p 3000
