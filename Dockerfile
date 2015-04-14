FROM phusion/baseimage:latest

ENV TYK_VERSION 1.5
ENV TYK_DASH_VERSION 0.9.3


################################################################################
# Chain all RUN commands to one line (minmize fs layer creation)
################################################################################
RUN	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list && \
 	apt-get update -qq && \
	apt-get install -y curl gcc make wget mongodb-org && \
	curl -o /tmp/tyk.deb -SL "https://github.com/lonelycode/tyk/releases/download/${TYK_VERSION}/tyk.linux.amd64_1.5-1_all.deb" && \
	dpkg -i /tmp/tyk.deb && \
	rm -f /tmp/tyk.deb && \
	rm -f /etc/tyk/apps/* && \
	rm -f /etc/tyk/tyk.conf && \
	cd /tmp && \
	####Redis
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz && \
    cd redis-stable && \
    make && \
    make install && \
    cp -f src/redis-sentinel /usr/local/bin && \
    mkdir -p /etc/redis && \
    cp -f *.conf /etc/redis && \
    rm -rf /tmp/redis-stable* && \
    sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(dir .*\)$/# \1\ndir \/usr\/local\/redis/' /etc/redis/redis.conf && \
    sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf
## Tyk Analytics
RUN mkdir /etc/tyk/tyk-dash && \
    wget https://github.com/lonelycode/tyk/releases/download/${TYK_VERSION}/tyk-dashboard-amd64-v${TYK_DASH_VERSION}.tar.gz -P /tmp/ && \
    tar -xvzf /tmp/tyk-dashboard-amd64-v${TYK_DASH_VERSION}.tar.gz && mv tyk-analytics-v${TYK_DASH_VERSION} /etc/tyk/tyk-dash  &&  rm -rf /tmp/* && \
	#### Cleanup any unneeded apt / debian files
	apt-get clean -y && \
	apt-get autoclean -y && \
	apt-get autoremove -y

ADD configurations/tyk.conf /etc/tyk/
ADD configurations/tyk_analytics.conf /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/
ADD configurations/sample_api.json /etc/tyk/apps/
ADD bin/start-tyk.sh /etc/service/tyk/run
ADD bin/start-tyk-dash.sh /etc/service/tyk-dash/run
ADD bin/start-mongo.sh /etc/service/mongo/run
ADD mongo-data /data/db
ADD bin/start-redis.sh /etc/service/redis/run
RUN chmod 755 /etc/service/tyk/run //etc/service/redis/run etc/service/tyk-dash/run /etc/service/mongo/run
EXPOSE 3000 8080 5000
WORKDIR /etc/tyk

#ENTRYPOINT ["/bin/start-tyk.sh"]

CMD ["/sbin/my_init"]
