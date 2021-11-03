FROM debian:stable-slim as neologd
RUN apt-get update && apt-get install -y git xz-utils
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd/seed \
    && xz -dkv mecab-user-dict-seed.*.csv.xz \
    # Elasticsearchのkuromojiのuser_dictionaryの形式に変換する
    # mecab
    #    表層形,左文脈ID,右文脈ID,コスト,品詞,品詞細分類1,品詞細分類2,品詞細分類3,活用型,活用形,原形,読み,発音
    # Elasticsearch kuromoji user_dictionary
    #    <text>,<token 1> ... <token n>,<reading 1> ... <reading n>,<part-of-speech tag>
    && cut -d, -f5,11,12 mecab-user-dict-seed.*.csv | \
      # 記号はElasticsearchで無視されるので除去する
      grep -vE ',記号,' | \
      # 半角スペースを含んでいる単語は読みも半角スペースで区切る必要があるが不可能なので除去する
      grep -vE '\s' | \
      # '#'を含んでいる単語があるとLuceneが狂うので除去する
      #    - https://techblog.istyle.co.jp/archives/2200
      grep -vE '\#' | \
      # 顔文字もエラーになるので除去する
      grep -vE '\,(カオモジー?|エガオ|ウインク|アセ)\,' | \
      # 1文字の単語は除去する
      # 原形を採用し表層形は捨てる
      awk -F "," 'length($2) > 1 {print $2 "," $2 "," $3 ",カスタム名詞"}' > neologd_user_dict_base.csv \
    # 同じ単語が複数あることは許されないのでsort -uで除去する
    && cat neologd_user_dict_base.csv | sort -u -t, -k1,1 > neologd_user_dict.csv \
    && cp neologd_user_dict.csv /neologd_user_dict.csv \
    && cd / && rm -rf /mecab-ipadic-neologd

FROM docker.elastic.co/elasticsearch/elasticsearch:7.15.1
RUN ./bin/elasticsearch-plugin install analysis-kuromoji
COPY --from=neologd --chown=elasticsearch:elasticsearch /neologd_user_dict.csv /usr/share/elasticsearch/config/

