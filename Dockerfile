FROM phusion/baseimage:0.9.16
MAINTANER Emmanuel Nyberg <emmanuel@stickybit.se>
ENV TYK_VERSION 1.6
ENV TYK_DASH_VERSION 0.9.4

RUN	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list && \
 	apt-get update -qq && \
	apt-get install -y curl gcc make wget mongodb-org && \
	curl -o /tmp/tyk.deb -SL "https://github.com/lonelycode/tyk/releases/download/${TYK_VERSION}/tyk.linux.amd64_${TYK_VERSION}-1_all.deb" && \
	dpkg -i /tmp/tyk.deb && \
	rm -f /tmp/tyk.deb && \
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
        tar -xvzf /tmp/tyk-dashboard-amd64-v${TYK_DASH_VERSION}.tar.gz && mv tyk-analytics-v${TYK_DASH_VERSION} /etc/tyk/tyk-dash  &&  \
	rm -rf /tmp/* && \
	#### Cleanup any unneeded apt files
	apt-get clean -y && \
	apt-get autoclean -y && \
	apt-get autoremove -y

ADD configurations/tyk.conf /etc/tyk/
ADD configurations/tyk_analytics.conf /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/
ADD configurations/host_manager.json /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/host-manager/
ADD bin/start-tyk.sh /etc/service/tyk/run
ADD bin/start-tyk-dash.sh /etc/service/tyk-dash/run
ADD bin/start-mongo.sh /etc/service/mongo/run
ADD bin/start-host-manager.sh /etc/service/host-manager/run
ADD bin/start-redis.sh /etc/service/redis/run
RUN chmod 755 /etc/service/tyk/run /etc/service/redis/run /etc/service/tyk-dash/run /etc/service/mongo/run /etc/service/host-manager/run
EXPOSE 3000 5000
WORKDIR /etc/tyk

CMD ["/sbin/my_init"]
