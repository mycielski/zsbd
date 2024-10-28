#!/bin/sh

wget -O case_study/baza-erd.png http://thinkpad/baza.png
wget -O sample_data/schema.sql http://thinkpad/baza.sql
pandoc sprawko.md -o sprawko.pdf
