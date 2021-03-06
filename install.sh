#!/bin/bash

# NextCloudPlus installation script
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage: ./install.sh 
#
# more details at https://ownyourbits.com

BRANCH=master
#DBG=x

set -e$DBG

TMPDIR=/tmp/nextcloudplus

[[ ${EUID} -ne 0 ]] && {
  printf "Must be run as root. Try 'sudo $0'\n"
  exit 1
}

# check_distro 
grep -q -e "Debian GNU/Linux 9" -e "Raspbian GNU/Linux 9" /etc/issue || {
  echo "distro not supported"; 
  exit 1; 
}

# check installed software
type apache2 &>/dev/null && APACHE_EXISTS=1
type mysqld  &>/dev/null && echo ">>> WARNING: existing mysqld configuration will be changed <<<"

# get install code
echo "Getting build code..."
apt-get update
apt-get install --no-install-recommends -y wget ca-certificates sudo

rm -rf "$TMPDIR" && mkdir "$TMPDIR" && cd "$TMPDIR"
wget -O- --no-check-certificate --content-disposition \
  https://github.com/nextcloud/nextcloudpi/archive/"$BRANCH"/latest.tar.gz \
  | tar -xz \
  || exit 1
cd - && cd "$TMPDIR"/nextcloudpi-"$BRANCH"

# install NCP
echo -e "\nInstalling NextCloudPlus"
source etc/library.sh

install_script  lamp.sh
install_script  etc/ncp-config.d/nc-nextcloud.sh
activate_script etc/ncp-config.d/nc-nextcloud.sh
install_script  nextcloudplus.sh
activate_script etc/ncp-config.d/nc-init.sh

# re-enable mods disabled during install, in case there's other shared services in apache2
[[ "$APACHE_EXISTS" != "" ]] && \
  a2enmod status reqtimeout env autoindex access_compat auth_basic authn_file authn_core alias access_compat

cd -
rm -rf $TMPDIR

echo "Done.

Type 'sudo ncp-config' to configure NCP, or access ncp-web on https://<this_ip>:4443
"

exit 0

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA
