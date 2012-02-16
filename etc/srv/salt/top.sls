base:
  'webserver*.example.com':
    - webserver
    - java
    - logstash.agent
  'logindex*.example.com':
    - java
    - logstash.indexer
