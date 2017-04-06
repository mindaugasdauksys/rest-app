#!/bin/sh

echo "Waiting postgres to start..."

while ! nc -z postgres 5432; do
  sleep 0.1
done

echo "postgres started"

bin/rails db:migrate
