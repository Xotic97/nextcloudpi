#!/bin/bash

# Change password for the Nextcloud admin user
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage:
# 
#   ./installer.sh nc-admin.sh <IP> (<img>)
#
# See installer.sh instructions for details
# More at: https://ownyourbits.com
#

USER_=ncp
PASSWORD_=ownyourbits
CONFIRM_=ownyourbits

DESCRIPTION="Change password for the Nextcloud admin user"

configure()
{
  [[ "$PASSWORD_" == "$CONFIRM_" ]] || { echo "passwords do not match"; return 1; }

  OC_PASS="$PASSWORD_" \
    sudo -E -u www-data php /var/www/nextcloud/occ \
    user:resetpassword --password-from-env "$USER_"
}

install() { :; }

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
