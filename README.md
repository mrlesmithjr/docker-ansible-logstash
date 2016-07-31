Repository Information
======================
Builds a [Docker] container running [Logstash] ready for use.
Provisioning provided via [Ansible].

How-To
------
Build
```
docker build -t ansible-logstash .
```

Consume

`Default`
```
docker run -d -p 5044:5044 -p 10514:10514 -p 10514:10514/udp mrlesmithjr/logstash
```

Consume using docker-compose (Spins up [Elasticsearch] with persistent
volume/data and a working [Logstash] instance)
```
docker-compose up -d
```

Logstash configuration
----------------------
The following `logstash.conf` is included and used during startup of the container.
```
input {
  beats {
    port => 5044
  }
}

input {
  tcp {
    type => "syslog"
    port => "10514"
  }
}

input {
  udp {
    type => "syslog"
    port => "10514"
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
  }
}

```
This is configured for [Beats] input `TCP/5044`, syslog input `TCP/10514`, syslog
input `UDP/10514` and [Elasticsearch] output `http://elasticsearch:9200`.

Configure your clients to send syslog using `TCP/10514`.
Example Linux rsyslog configuration would be configured as `*.* @@HostOrIP:10514`

License
-------

BSD

Author Information
------------------

Larry Smith Jr.
- [@mrlesmithjr]
- [everythingshouldbevirtual.com]
- [mrlesmithjr@gmail.com]


[Ansible]: <https://www.ansible.com/>
[Beats]: <https://www.elastic.co/products/beats>
[Docker]: <https://www.docker.com>
[Elasticsearch]: <https://www.elastic.co/products/elasticsearch>
[Logstash]: <https://www.elastic.co/products/logstash>
[@mrlesmithjr]: <https://twitter.com/mrlesmithjr>
[everythingshouldbevirtual.com]: <http://everythingshouldbevirtual.com>
[mrlesmithjr@gmail.com]: <mailto:mrlesmithjr@gmail.com>
