[Modelio](https://www.modelio.org) 3.8.1 in a docker container.

# Requirements

* You should have X11 running on the host.
* ... and probably Linux.


# WARNINGS :

* The build uses your UID/GID
* Once Launched :
    * The host shares X11 socket and IPC with the container  
    => This breaks container isolation, and the contained app can listen to all X11 events !
    * **The host shares your ~/.modelio/ and ~/modelio/ folders with the container.**
* Use it at your own risk !


# Build image, and launch

The docker commands are in the [Dockerfile](./Dockerfile).
