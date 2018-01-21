#!/bin/bash
set -eu
psql -U postgres -f postgresql-dbinit.sql
rm postgresql-dbinit.sql
