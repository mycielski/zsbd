#!/bin/sh

export PGPASSWORD='xOMMJ0NpO3'

# psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f drop_db.sql
# psql -q -h raspberrypi -p 30956 -U postgres -d postgres -f schema.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f driver.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f fuel_type.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f vehicle_type.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f vehicle.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f trailer.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f vendor.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f card.sql
psql -q -h raspberrypi -p 30956 -U postgres -d eltrans -f trip.sql

unset PGPASSWORD
