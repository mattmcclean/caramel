base:
  'webserver*.example.com':
    - webserver
    - logstash.agent
  'logindex*.example.com':
    - logstash.indexer
