################################################################################
# philcryer/min-tyk
################################################################################
# source https://github.com/philcryer/min-tyk
# forked from an earlier tyk attempt
# build based on philcryer/min-wheezy:latest
FROM philcryer/min-wheezy:latest

ENV TYK_VERSION 1.5
ENV TYK_DASH_VERSION 0.9.3


################################################################################
# Chain all RUN commands to one line (minmize fs layer creation)
################################################################################
RUN apt-get update -qq && \
	apt-get install -y curl wget supervisor && \
	curl -o /tmp/tyk.deb -SL "https://github.com/lonelycode/tyk/releases/download/1.5/tyk.linux.amd64_1.5-1_all.deb" && \
	dpkg -i /tmp/tyk.deb && \
	rm -f /tmp/tyk.deb && \
	rm -f /etc/tyk/apps/* && \
	rm -f /etc/tyk/tyk.conf && \
  mkdir /etc/tyk/tyk-dash && \
  wget https://github.com/lonelycode/tyk/releases/download/${TYK_VERSION}/tyk-dashboard-amd64-v${TYK_DASH_VERSION}.tar.gz -P /tmp/ && \
    tar -xvzf /tmp/tyk-dashboard-amd64-v${TYK_DASH_VERSION}.tar.gz && mv tyk-analytics-v${TYK_DASH_VERSION} /etc/tyk/tyk_dash  &&  rm -rf /tmp/* && \
	#### Cleanup any unneeded apt / debian files
	apt-get clean -y && \
	apt-get autoclean -y && \
	apt-get autoremove -y && \
	rm -rf /var/cache/debconf/*-old && rm -rf /var/lib/apt/lists/* && rm -rf /usr/share/doc/*/ && \
	#### Cleanup any other unneeded files
	cp -R /usr/share/locale/en\@* /tmp/ && \
	rm -rf /usr/share/locale/* && \
	mv /tmp/en\@* /usr/share/locale/ && \
	rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/debconf/* && \
	#### Document build
	echo "`cat /etc/issue.net` Docker Image - philcryer/min-tyk - `date +'%Y/%m/%d'`" > /etc/motd

ADD configurations/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD configurations/tyk.conf /etc/tyk/
ADD configurations/tyk_analytics.conf /etc/tyk/tyk_dash/
ADD configurations/sample_api.json /etc/tyk/apps/
ADD bin/start-tyk.sh /bin/start-tyk.sh

EXPOSE 8080 5000
WORKDIR /etc/tyk

#ENTRYPOINT ["/bin/start-tyk.sh"]

CMD ["/usr/bin/supervisord"]
