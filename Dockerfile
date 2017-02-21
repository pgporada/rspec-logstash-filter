FROM java:8-jre

ENV LOGSTASH_VERSION 5.2.1

# Install Logstash
RUN wget \
    https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz \
    -O /tmp/logstash.tar.gz \
    && tar xfz /tmp/logstash.tar.gz -C /opt \
    && rm /tmp/logstash.tar.gz \
    && mv /opt/logstash-${LOGSTASH_VERSION} /opt/logstash

# Install plugins for development
RUN /opt/logstash/bin/logstash-plugin install --development

RUN cd /opt/logstash && \
    export PATH="/opt/logstash/vendor/jruby/bin:$PATH" && \
    jruby -S gem install bundler && \
    bundle install && \
    gem install logstash-core-plugin-api

# Prepare directory & file for test
RUN mkdir -p /test

ADD spec /test/spec
ADD conf /test/conf
ADD scripts/command.sh /command.sh

CMD ["/command.sh"]
