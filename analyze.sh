echo "kuromoji_analyzer"
curl -s -X GET -H "Content-Type: application/json" -d "{\"analyzer\": \"kuromoji_analyzer\",\"text\": \"$1\"}" http://localhost:9200/kuromoji_test/_analyze?pretty | jq '[.tokens[].token]' -c
echo "kuromoji_search_analyzer"
curl -s -X GET -H "Content-Type: application/json" -d "{\"analyzer\": \"kuromoji_search_analyzer\",\"text\": \"$1\"}" http://localhost:9200/kuromoji_test/_analyze?pretty | jq '[.tokens[].token]' -c
echo "kuromoji_neologd_analyzer"
curl -s -X GET -H "Content-Type: application/json" -d "{\"analyzer\": \"kuromoji_neologd_analyzer\",\"text\": \"$1\"}" http://localhost:9200/kuromoji_test/_analyze?pretty | jq '[.tokens[].token]' -c
echo "kuromoji_neologd_search_analyzer"
curl -s -X GET -H "Content-Type: application/json" -d "{\"analyzer\": \"kuromoji_neologd_search_analyzer\",\"text\": \"$1\"}" http://localhost:9200/kuromoji_test/_analyze?pretty | jq '[.tokens[].token]' -c
