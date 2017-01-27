FROM centos:7
LABEL maintainer "Demetrius Bell meetri@gmail.com>"

ENV DEHYDRATED_VERSION=0.3.1

RUN mkdir /opt/dehydrated /etc/dehydrated \
&& yum install -y openssl epel-release \
&& yum install -y python-pip \
&& pip install boto \
&& curl -o /opt/dehydrated.tar.gz -L -O https://github.com/lukas2511/dehydrated/archive/v0.3.1.tar.gz \
&& tar -xvzf /opt/dehydrated.tar.gz -C /opt/dehydrated --strip-components=1

# Add Tini
ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# Route53 Hook for dehydrated
ADD https://gist.githubusercontent.com/rmarchei/98489c05f0898abe612eec916508f2bf/raw/ffffb87bf7691d5b6cb17553f6538b59d3de878d/route53.py /etc/dehydrated/hooks/route53.py

RUN chmod +x /tini /etc/dehydrated/hooks/route53.py

ADD config /etc/dehydrated/config
ADD bootstrap /bootstrap

ENTRYPOINT ["/tini", "--","/bootstrap"]


