Docker Desktops
===============

A collection of dockerfiles for starting up desktops inside of a docker environment.

I'm sick and tired of replicating my dev environment. Committing memory and CPU to a VM doesn't work so well on lesser powered machines. I want to make optimal use of my hardware, and optionally be able to set up a dev environment in the cloud.

This is still early stage. Everything works, but it's not very configurable.


Features
--------

- Connect via RDP or X2Go.
- Optionally preserve your home directory as a docker volume.
- Host anywhere.


Future
------

- Guacamole support.
- Possibly noVNC support.
- More mature dev environment (not everything is tested atm).
- VPN support.


Usage
-----

Modify common/build.sh to pass in the USER variable you want for the user to create.
You can also pass in PASSWORD with another --build-arg.
If you don't pass in USER or PASSWORD when building, it defaults to ubuntu/ubuntu.

Run the script commands inside of one of the subdirs:

- build.sh: Build the image.
- run.sh: Run the image. When running, you can connect via RDP or X2go.
- shell.sh: Open a root shell into the container for debugging.
- destroy.sh: Stop and destroy the container.

Each desktop type is registered with a port index in the `registry` file. RDP
and SSH ports will be bound as `3390 + index` for RDP, and `2000 + index` for SSH.

The base-XYZ directories are for base images, and are not meant to be run directly.
You'll need to build them as precursors to the runnable desktop images.


Current Desktop Types
---------------------

- desktop: A basic desktop with the lubuntu package
- development: The basic desktop + development tools for various popular languages
- work: The development desktop + Slack.

Each of the desktops preserves `/home` as a Docker volume.


Adding More Images
------------------

Make a copy of one of the desktop image directories and:

- Modify docker-config to set the name you want + any extra configuration parameters.
- Modify ../registry to add a port index for your new image.
- Modify the Dockerfile to your tastes.


Admin Commands
--------------

In the `admin` directory you'll find some helpful administration scripts for Docker:

- remove-stopped.sh: Remove all stopped containers.
                     Often you'll end up with containers that were built during
                     development & testing but are now useless. This clears them out.

- remove-unused.sh: Remove all images that aren't being used by anything.
                    During development of Dockerfiles, you'll end up with a lot of
                    orphaned images from previous builds. This clears them out.


Copyright & License
-------------------

Copyright (c) Karl Stenerud

Released under standard MIT License https://opensource.org/licenses/MIT

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in the documentation of any redistributions of the template files themselves (but not in projects built using the templates).

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
