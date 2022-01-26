FROM jenkins/jenkins:centos

USER 0
# RUN dnf -y install python3 && \
#   python3 -m pip install --upgrade pip setuptools wheel

COPY --chown=1000 plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY --chown=1000 casc/. /usr/share/jenkins/ref/casc/
COPY --chown=1000 locale.xml /usr/share/jenkins/ref/locale.xml
RUN echo -e "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile /dev/null" > /etc/ssh/ssh_config
COPY --chown=jenkins ./.build/. /var/lib/jenkins/
RUN chown 1000 /var/lib/jenkins/shared-library.git

USER 1000
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/casc"

COPY --chown=1000 log.properties /var/jenkins_home/log.properties
RUN git config --global user.email "jenkins@example.com" && \
  git config --global user.name "jenkins"

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# RUN pip3 install ansible==2.10 --user
# ENV PATH="${PATH}:${JENKINS_HOME}/.local/bin"