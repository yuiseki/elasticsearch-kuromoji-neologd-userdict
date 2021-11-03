curl -X DELETE http://localhost:9200/kuromoji_test?pretty
curl -X PUT -H "Content-Type: application/json" -d @./kuromoji_settings.json http://localhost:9200/kuromoji_test?pretty
