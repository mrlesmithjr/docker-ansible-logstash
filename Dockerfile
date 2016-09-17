FROM mrlesmithjr/alpine-ansible

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

# Copy Ansible Related Files
COPY config/ansible/ /

# Run Ansible playbook
RUN ansible-playbook -i "localhost," -c local /playbook.yml && \
  rm -rf /tmp/* && \
  rm -rf /var/cache/apk/*

ENV PATH /opt/logstash/bin:$PATH

# necessary for 5.0+ (overriden via "--path.settings", ignored by < 5.0)
ENV LS_SETTINGS_DIR /etc/logstash
# comment out some troublesome configuration parameters
#   path.log: logs should go to stdout
#   path.config: No config files found: /etc/logstash/conf.d/*
RUN set -ex \
	&& if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then \
		sed -ri 's!^(path.log|path.config):!#&!g' "$LS_SETTINGS_DIR/logstash.yml"; \
	fi

# Copy Docker Entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY config/logstash/*.conf /etc/logstash/conf.d

# Setup volume
VOLUME /etc/logstash/conf.d

COPY config/supervisord/*.ini /etc/supervisor.d/

# Expose Port(s)
EXPOSE 514 514/udp 5044 10514 10514/udp
