FROM dockerfile/java
MAINTAINER Ivan Valdes <ivan@vald.es>

# Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Kafka
RUN wget -q http://mirror.gopotato.co.uk/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz -O /tmp/kafka_2.8.0-0.8.1.1.tgz
RUN tar xfz /tmp/kafka_2.8.0-0.8.1.1.tgz -C /opt

# confd
RUN wget -q https://github.com/kelseyhightower/confd/releases/download/v0.3.0/confd_0.3.0_linux_amd64.tar.gz -O /tmp/confd_0.3.0.tar.gz
RUN tar zxf /tmp/confd_0.3.0.tar.gz && mv confd /usr/bin/confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates
ADD confd/server.properties.tmpl /etc/confd/templates/server.properties.tmpl
ADD confd/kafka.toml /etc/confd/conf.d/kafka.toml

# init scripts
ENV KAFKA_HOME /opt/kafka_2.8.0-0.8.1.1

CMD ["/usr/bin/supervisord"]
