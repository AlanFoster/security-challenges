FROM postgres:10.5-alpine

# By default the postgres image ships with docker-entrypoint.sh which executes *.sql and *.sh files from this directory
COPY ./init/* /docker-entrypoint-initdb.d/
