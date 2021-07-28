#!/bin/bash

curl -XDELETE localhost:9200/race

curl -XPUT "localhost:9200/race"  -H "Content-Type: application/json" -d '{
  "mappings": {
    "properties": {
      "coordinates": {
        "type": "geo_point"
      }
    }
  }
}'

split -l 5000 data_all.json race_split_

for f in `ls race_split_*` ; do sed -i '' -e 's/.*/{"index" : {}}\
&/g' $f ; done

for f in `ls race_split_*` ; do curl -X POST http://localhost:9200/race/_bulk -H 'Content-Type: application/x-ndjson' --data-binary > /dev/null @$f ; done


curl -XDELETE localhost:9200/race-info
curl -XPUT "localhost:9200/race-info"

curl -XPOST localhost:9200/race-info/_doc/  -H "Content-Type: application/json" -d  '{
    "Race" : "Varano",
    "Start" : 1590076800000,
    "Drivers" : ["Bini", "Solfaroli", "Machado", "Antongini", "Rizzi", "Bighetti"]
}'


curl -XPOST localhost:9200/race-info/_doc/  -H "Content-Type: application/json" -d  '{
    "Race" : "Nuvolari",
    "Start" : 1590076800000,
    "Drivers" : ["Machado", "Solfaroli", "Rizzi", "Bini"] 
}'
