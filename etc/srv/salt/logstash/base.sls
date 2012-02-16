logstash:
  group:
    - present
  user:
    - present
    - gid: logstash
    - groups:
      - adm
    - require:
      - group: logstash

logstash-binary:
  file:
    - managed
    - name: /usr/local/lib/logstash/logstash-1.1.0-monolithic.jar
    - source: http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar
    - source_hash: md5=357c01ae09aa4611e31347238d762729
    - user: logstash
    - group: logstash
    - makedirs: True
    - mode: 644
    - require:
      - user: logstash

