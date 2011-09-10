# Supported OS

## FreeBSD port

zfSnap was developed on FreeBSD, therefore zfSnap works best on FreeBSD :)

<http://www.freshports.org/sysutils/zfsnap/>

## NetBSD

There are plans to make a NetBSD port for zfSnap, but probably not until NetBSD
officially supports zfs.

## GNU/Linux

zfSnap might work on GNU/Linux out of the box, but it hasn't been tested
because zfs on Linux hasn't matured.

Please let me (graudeejs at gmail dot com) know if you've tried zfSnap on GNU/Linux



## Solaris/OpenSolaris?

Starting with zfSnap v1.10.0 from solarislike branch, zfSnap was tested to work
out of the box on:

  * Solaris 11 Express
  * OpenIndiana build 148



## Solaris 10

zfSnap v1.10.0 from solarislike branch was tested to work on Solaris 10, but
GNU tools (grep, sed, date, ...) must be installed and **PATH** environment set
in such way, that GNU tools would be used instead of Solaris 10 default tools.


Also you need to patch zfSnap **#!/bin/sh** to **#!/bin/ksh** or
**#!/usr/local/bin/bash** (or wherever bash 4 or newer is installed. Bash 3
won't work)

There are absolutely no plans to make zfSnap work with Solaris 10 native tools.
These tools are way too crappy, to say the least. Modifying zfSnap to work with
them, would make zfSnap even more harder to read.


## OpenSolaris 2009.06

zfSnap v1.10.0 from solarislike branch was tested to work on OpenSolaris
2009.06, but you must make sure, that **PATH** environment is set in such way,
that GNU tools (grep, sed, date, ...) are used, instead of native tools.
