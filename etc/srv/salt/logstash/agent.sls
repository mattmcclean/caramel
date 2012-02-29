include:
  - logstash.base

/etc/init.d/logstash:
  file:
    - managed
    - source: salt://logstash/logstash-agent
    - mode: 744

/etc/logstash/agent.conf:
  file:
    - managed
    - source: salt://logstash/agent.conf
    - makedirs: True
    - mode: 644

logstash-service:
  service:
    - running
    - name: logstash
    - watch:
      - file: /etc/init.d/logstash
      - file: /etc/logstash/agent.conf
#      - file: logstash-binary


