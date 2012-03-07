include:
  - logstash.base

/etc/logstash/logstash.conf:
  file:
    - managed
    - source: salt://logstash/agent.conf
    - makedirs: True
    - mode: 644


