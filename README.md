# chrony

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with chrony](#setup)
    * [What chrony affects](#what-chrony-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with chrony](#beginning-with-chrony)
4. [Usage - Configuration options and additional functionality](#usage)
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

* Installs and removes the chrony package
* Starts and stops the chrony service
* Manages /etc/chrony/chrony.conf or /etc/chrony.conf
* Manages /var/lib/chrony
* Manages /var/log/chrony

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

This module provides a `chrony` class which accepts the following parameters.

### General parameters

[*bindcmdaddress*]

  Restrict the network interface to which chronyd will listen for command
  packets (issued by chronyc).

  Default: `[ '127.0.0.1', '::1' ]`

[*rtconutc*]

  Whether the computer's onboard real-time clock is set to UTC. Set to false
  if the RTC is in local time, such as a system which boots multiple
  operating systems.

  Default: `true`

[*sync_local_clock*]

  Keep the computer's hardware clock in sync.

  Default: `true`

### NTP client parameters

[*offline*]

  Whether the NTP client should start in offline mode. In this mode, clients
  must issue the chronyc online command to begin synchronization (though
  most systems with a GUI will manage to do this automatically). Useful for
  laptops and other intermittently connected devices.

  Default: `false`

[*servers*]

  A list of NTP servers and options for those servers. (It is not necessary
  to specify the offline option; this can be done with the offline
  parameter.)

  Default: Array of public NTP servers, depending on `$::osfamily`

[*source_port*]

  Select a fixed source port for outgoing NTP packets. By default, the
  source port is dynamically assigned by the operating system.

  Default: `undef`

### NTP server parameters

[*client_allow*]

  Designate subnets from which NTP clients are allowed to access the
  computer as an NTP server. IPv4 and IPv6 CIDR ranges can be specified.

  Default: `[]`

[*client_deny*]

  Designate subnets within previously allowed subnets which are denied
  to access the NTP server. IPv4 and IPv6 CIDR ranges can be specified.

  Default: `[]`

[*client_log*]

  Whether to log statistics about NTP clients.

  Default: `false`

[*refclock*]

  Specify one or more reference clocks to which chrony should obtain time
  information to act as a stratum 1 server. See the chrony documentation
  for details.

  Default: `[]`

[*serve_ntp*]

  Whether to enable the NTP server functionality. If disabled, chrony will
  act only as an NTP client.

  Default: `false`

[*udlc*]

  Allow the server to operate without synchronization to an external time
  source (undisciplined local clock).

  Default: `false`

## Limitations

This module currently works only with Debian-based and Red Hat-based systems,
and Arch Linux. It has been tested on:

* Debian (6/squeeze, 7/wheezy)
* Ubuntu (10.04, 12.04, 14.04)
* CentOS/RHEL (6, 7)
* Fedora (19, 20)
* Arch Linux (3.16.1)

## Development

This module is by no means complete. Pull requests are welcome for:

* Fixes for the bugs I left in
* Additional operating system support
* Additional chrony feature support
* Anything else that makes sense
