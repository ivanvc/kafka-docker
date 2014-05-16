FROM dockerfile/java
MAINTAINER Ivan Valdes <ivan@vald.es>

# Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# confd
RUN wget -q https://github.com/kelseyhightower/confd/releases/download/v0.3.0/confd_0.3.0_linux_amd64.tar.gz -O /tmp/confd_0.3.0.tar.gz
RUN tar zxf /tmp/confd_0.3.0.tar.gz && mv confd /usr/bin/confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

# Kafka
RUN wget -q http://archive.apache.org/dist/kafka/old_releases/kafka-0.7.2-incubating/kafka-0.7.2-incubating-src.tgz -O /tmp/kafka-0.7.2-incubating-src.tgz
RUN tar xfz /tmp/kafka-0.7.2-incubating-src.tgz -C /opt && mv /opt/kafka* /opt/kafka && cd /opt/kafka && ./sbt update && ./sbt package

# init scripts
ENV KAFKA_HOME /opt/kafka

# Add files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD set_template.sh /opt/set_template.sh
ADD confd/kafka.toml /etc/confd/conf.d/kafka.toml

CMD /opt/set_template.sh && /usr/bin/supervisord
