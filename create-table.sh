#!/bin/bash
set -u
echo "CREATE TABLE status (
	timestamp timestamp NOT NULL DEFAULT current_timestamp,
	bot varchar(15) PRIMARY KEY,
	message text NOT NULL
);" | psql $DATABASE_URL
