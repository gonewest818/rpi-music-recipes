rpi-music-recipes
=================

These are recipes for setting up music streaming tools on raspberry pi.

As of right now we have scripts for

* pianod - pandora streaming with web based control
* shairport - Airplay compatible receiver


To get started clone this repo and run the bash scripts.  For example
to install shairport you would

    $ git clone https://github.com/gonewest818/rpi-music-recipes.git
    $ cd shairport
    $ sudo sh pi-shairport.sh

and the script will take care of installing dependencies, setting up
configuration files, downloading/compiling/installing the shairport
software, and installing init scripts so that shairport runs automatically
when the raspberry pi boots.

Enjoy.




