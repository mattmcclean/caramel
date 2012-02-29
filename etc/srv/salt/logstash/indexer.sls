include:
  - logstash.base

zip:
  pkg:
    - installed

elasticsearch-binary:
  file:
    - managed
    - name: /tmp/elasticsearch-0.18.7.zip
    - source: https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.18.7.zip
    - source_hash: md5=9587b222277852b8c778180019d4a551

unzip /tmp/elasticsearch-0.18.7.zip:
  cmd:
    - run
    - unless: test -d /usr/local/lib/logstash/elasticsearch-0.18.7
    - cwd: /usr/local/lib/logstash
    - makedirs: True
    - require:
      - pkg: zip
      - file: elasticsearch-binary

/etc/init.d/logstash:
  file:
    - managed
    - source: salt://logstash/logstash-web
    - mode: 744

/etc/logstash/indexer.conf:
  file:
    - managed
    - source: salt://logstash/indexer.conf
    - makedirs: True
    - mode: 644

logstash-service:
  service:
    - running
    - name: logstash
    - watch:
      - file: /etc/logstash/indexer.conf
      - file: /etc/init.d/logstash
#      - file: logstash-binary
    
