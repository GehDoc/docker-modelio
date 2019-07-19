# modelio-3.8.1 on ubuntu 16.04
#
# WARNING :
# - The build uses your UID/GID
# - Once Launched :
#   - The host shares X11 socket and IPC with the container
#     => This breaks container isolation, and the contained app can listen to all X11 events !
#   - The host shares ~/.modelio/ and ~/modelio/ folders with the container 
# - use it at your own risk !
#
# Build : 
#  docker build --rm -f "Dockerfile" -t modelio:latest --build-arg USER_ID=$UID --build-arg GROUP_ID=$(id -g ${USER}) .
#
# Launch :
#  docker run -ti --rm -e DISPLAY -v $HOME/.Xauthority:/home/developer/.Xauthority:z -v $HOME/.modelio:/home/developer/.modelio:z -v $HOME/modelio:/home/developer/modelio:z --net=host --ipc=host modelio
# In case of access to X11 display denied to contained app, try one of these on the host then relaunch :
#  xhost +
#  xhost local:root
FROM ubuntu:16.04
LABEL maintainer="gerald.hameau@gmail.com"

ARG USER_ID=1000
ARG GROUP_ID=1000

# System
RUN apt-get update && \
    apt-get install -y wget && \
    mkdir /modelio && \
    wget -nv --show-progress --progress=bar:force:noscroll -O /modelio/modelio.deb https://www.modelio.org/download/send/31-modelio-3-8-1/147-modelio-3-8-1-debian-ubuntu-64-bit.html && \
    apt install -y /modelio/modelio.deb && \
    rm /modelio/modelio.deb

# User with UID/GID from host user. Not tested as root
RUN mkdir -p /home/developer && \
    if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
        groupadd -g ${GROUP_ID} developer && \
        useradd -l -u ${USER_ID} -g developer developer \
    ;fi && \
    chown ${USER_ID}:${GROUP_ID} -R /home/developer

USER developer
ENV HOME /home/developer

CMD /usr/bin/modelio-open-source3.8