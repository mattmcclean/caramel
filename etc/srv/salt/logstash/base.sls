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
    - source: salt://logstash/logstash-1.1.0-monolithic.jar
#      - http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar: md5=357c01ae09aa4611e31347238d762729
    - user: logstash
    - group: logstash
    - makedirs: True
    - mode: 644
    - require:
      - user: logstash
      - file: /usr/local/lib/logstash

/usr/local/lib/logstash:
  file:
    - directory
    - user: logstash
    - group: logstash
    - mode: 744
    - makedirs: True
    
/etc/init.d/logstash:
  file:
    - managed
    - source: salt://logstash/logstash-service
    - mode: 744
    - template: jinja
    - defaults:
        logstash_args: "agent -f /etc/logstash/logstash.conf"

logstash-service:
  service:
    - running
    - name: logstash
    - watch:
      - file: /etc/logstash/logstash.conf
      - file: /etc/init.d/logstash
      - file: logstash-binary
