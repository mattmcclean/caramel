include:
  - logstash.base

zip:
  pkg:
    - installed

elasticsearch-binary:
  file:
    - managed
    - name: /tmp/elasticsearch-0.18.7.zip
    - source: salt://logstash/elasticsearch-0.18.7.zip
#      - https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.18.7.zip: md5=9587b222277852b8c778180019d4a551

unzip /tmp/elasticsearch-0.18.7.zip:
  cmd:
    - run
    - unless: test -d /usr/local/lib/logstash/elasticsearch-0.18.7
    - cwd: /usr/local/lib/logstash
    - makedirs: True
    - require:
      - pkg: zip
      - file: elasticsearch-binary
      - file: /usr/local/lib/logstash

/etc/logstash/logstash.conf:
  file:
    - managed
    - source: salt://logstash/indexer.conf
    - makedirs: True
    - mode: 644

/etc/logstash/grok/patterns/salt:
  file:
    - managed
    - source: salt://logstash/grok/patterns/salt
    - makedirs: True
    - mode: 644

extend:
  /etc/init.d/logstash:
    file:
      - context:
          logstash_args: "agent -f /etc/logstash/logstash.conf -- web --backend elasticsearch:///?local"
      - require:
        - file: elasticsearch-binary     
