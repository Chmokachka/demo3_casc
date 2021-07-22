FROM jenkins/jenkins:latest

USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Install docker-compose
RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN sudo chmod +x /usr/local/bin/docker-compose

# # Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
# ADD ./dind /usr/local/bin/dind
# RUN chmod +x /usr/local/bin/dind
#
# ADD ./wrapdocker /usr/local/bin/wrapdocker
# RUN chmod +x /usr/local/bin/wrapdocker
#
# # Define additional metadata for our image.
# VOLUME /var/lib/docker
RUN apt-get update && apt-get install -y maven

# This will use the latest public release. To use your own, comment it out...
ADD ./docker-latest /usr/local/bin/docker

#Make the Docker binary executable
RUN chmod +x /usr/local/bin/docker

USER jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
