# chrony

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with chrony](#setup)
    * [What chrony affects](#what-chrony-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with chrony](#beginning-with-chrony)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the chrony NTP client/server daemon. It is capable of
trivial NTP client-only setups all the way up to stratum 1 servers connected
to reference clocks.

## Module Description

The chrony module configures chronyd to act as an NTP client, server, or both.
It also can install or remove the chrony package, and enable or disable the
chrony service.

## Setup

### What chrony affects

* The chrony package
* The chrony service
* /etc/chrony/chrony.conf or /etc/chrony.conf
* /var/lib/chrony
* /var/log/chrony

### Setup Requirements

On most systems, chrony has no special requirements.

On Enterprise Linux 6 or older systems, the EPEL repository is required.
I recommend using the [stahnma/epel](https://forge.puppetlabs.com/stahnma/epel) module as this is the official module
from the EPEL package maintainer. EPEL is not required on Enterprise Linux 7.

### Beginning with chrony

The very basic steps needed for a user to get the module up and running.

The minimum you need to begin using chrony as an NTP client to public NTP
servers is something like:

    class profile::ntp_client {
        class { '::chrony': }
    }

The minimum you need to serve NTP to your local network is:

    class profile::ntp_server {
        class { '::chrony':
            client_allow => '192.168.0.0/16',
            serve_ntp    => true,
        }
    }

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This module currently works only with Debian-based and Red Hat-based systems.
It has been tested on:

* Debian (7/wheezy)
* Ubuntu (12.04, 14.04)
* CentOS/RHEL (6, 7)
* Fedora (19, 20)

## Development

This module is by no means complete. Pull requests are welcome for:

* Additional operating system support
* Additional chrony feature support
* Anything else that makes sense
