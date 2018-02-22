FROM debian:stable

ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# -u $(id -u)
# because jenkins docker pipeline force a -u option on run
# https://github.com/jenkinsci/docker-workflow-plugin/pull/25/files
# see whoAmI function here:
# https://github.com/ndeloof/docker-workflow-plugin/blob/master/src/main/java/org/jenkinsci/plugins/docker/workflow/client/DockerClient.java
# it should be fixed in next plugins version >= 1.14
# jenkins user on sandboxrd has the 1004 id and it is forced by pipeline plugin on docker log on

# --no-create-home
# if we don't want skeleton file so we create home by hand (or by RUN :) )
# RUN mkdir -p $HOME \ && mkdir -p $HOME/bin \ && chown -R $USER:$GROUP $HOME

ARG UID=1004
RUN useradd -d $HOME -g $GROUP -u ${UID} -m $USER

USER $USER:$GROUP
WORKDIR $HOME
