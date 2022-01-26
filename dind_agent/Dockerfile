FROM jenkins/inbound-agent

USER 0

## Install software
RUN apt -y -v install java-11-openjdk-devel wget rsync unzip procps-ng \
    iputils git docker-ce docker-ce-cli containerd.io python3-pip openldap-devel python3-devel \
    python3-setuptools nss_wrapper libffi-devel gcc iputils \
    tar zip jq && apt clean all
RUN python3 -m pip install --upgrade pip
RUN pip install pyyaml

USER 1000