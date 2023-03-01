#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
REEMOVERSION="1.10.1"

print_status() {
    echo
    echo "## $1"
    echo
}


bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}


setup() {

print_status "Installing the Reemo ${REEMOVERSION} package..."

if $(uname -m | grep -Eq ^armv6); then
    print_status "You appear to be running on ARMv6 hardware. Unfortunately this is not currently supported by the Reemo Linux distributions."
    exit 1
fi

PRE_INSTALL_PKGS=""

if [ ! -x /usr/bin/lsb_release ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} lsb-release"
fi

if [ ! -x /usr/bin/curl ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} curl"
fi

# Populating Cache
print_status "Populating apt-get cache..."
exec_cmd_nobail 'apt-get update'

if [ "X${PRE_INSTALL_PKGS}" != "X" ]; then
    print_status "Installing packages required for setup:${PRE_INSTALL_PKGS}..."
    # This next command needs to be redirected to /dev/null or the script will bork
    # in some environments
    exec_cmd "apt-get install -y${PRE_INSTALL_PKGS} > /dev/null 2>&1"
fi


IS_PRERELEASE=$(lsb_release -d | grep 'Ubuntu .*development' >& /dev/null; echo $?)
if [[ $IS_PRERELEASE -eq 0 ]]; then
    print_status "Your distribution, identified as \"$(lsb_release -d -s)\", is a pre-release version of Ubuntu. Reemo does not maintain official support for Ubuntu versions until they are formally released."
    exit 1
fi

DISTRO=$(lsb_release -c -s)

check_alt() {
    if [ "X${DISTRO}" == "X${2}" ]; then
        echo
        echo "## You seem to be using ${1} version ${DISTRO}."
        echo "## This maps to ${3} \"${4}\"... Adjusting for you..."
        DISTRO="${4}"
    fi
}

check_alt "Astra Linux"    "orel"            "Debian"        "stretch"
check_alt "BOSS"           "anokha"          "Debian"        "wheezy"
check_alt "BOSS"           "anoop"           "Debian"        "jessie"
check_alt "BOSS"           "drishti"         "Debian"        "stretch"
check_alt "BOSS"           "unnati"          "Debian"        "buster"
check_alt "BOSS"           "urja"            "Debian"        "bullseye"
check_alt "bunsenlabs"     "bunsen-hydrogen" "Debian"        "jessie"
check_alt "bunsenlabs"     "helium"          "Debian"        "stretch"
check_alt "bunsenlabs"     "lithium"         "Debian"        "buster"
check_alt "Devuan"         "jessie"          "Debian"        "jessie"
check_alt "Devuan"         "ascii"           "Debian"        "stretch"
check_alt "Devuan"         "beowulf"         "Debian"        "buster"
check_alt "Devuan"         "chimaera"        "Debian"        "bullseye"
check_alt "Devuan"         "ceres"           "Debian"        "sid"
check_alt "Deepin"         "panda"           "Debian"        "sid"
check_alt "Deepin"         "unstable"        "Debian"        "sid"
check_alt "Deepin"         "stable"          "Debian"        "buster"
check_alt "Deepin"         "apricot"         "Debian"        "buster"
check_alt "elementaryOS"   "luna"            "Ubuntu"        "precise"
check_alt "elementaryOS"   "freya"           "Ubuntu"        "trusty"
check_alt "elementaryOS"   "loki"            "Ubuntu"        "xenial"
check_alt "elementaryOS"   "juno"            "Ubuntu"        "bionic"
check_alt "elementaryOS"   "hera"            "Ubuntu"        "bionic"
check_alt "elementaryOS"   "odin"            "Ubuntu"        "focal"
check_alt "elementaryOS"   "jolnir"          "Ubuntu"        "focal"
check_alt "Kali"           "sana"            "Debian"        "jessie"
check_alt "Kali"           "kali-rolling"    "Debian"        "bullseye"
check_alt "Linux Mint"     "maya"            "Ubuntu"        "precise"
check_alt "Linux Mint"     "qiana"           "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rafaela"         "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rebecca"         "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rosa"            "Ubuntu"        "trusty"
check_alt "Linux Mint"     "sarah"           "Ubuntu"        "xenial"
check_alt "Linux Mint"     "serena"          "Ubuntu"        "xenial"
check_alt "Linux Mint"     "sonya"           "Ubuntu"        "xenial"
check_alt "Linux Mint"     "sylvia"          "Ubuntu"        "xenial"
check_alt "Linux Mint"     "tara"            "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tessa"           "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tina"            "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tricia"          "Ubuntu"        "bionic"
check_alt "Linux Mint"     "ulyana"          "Ubuntu"        "focal"
check_alt "Linux Mint"     "ulyssa"          "Ubuntu"        "focal"
check_alt "Linux Mint"     "uma"             "Ubuntu"        "focal"
check_alt "Linux Mint"     "una"             "Ubuntu"        "focal"
check_alt "Linux Mint"     "vanessa"         "Ubuntu"        "jammy"
check_alt "Linux Mint"     "vera"            "Ubuntu"        "jammy"
check_alt "Liquid Lemur"   "lemur-3"         "Debian"        "stretch"
check_alt "LMDE"           "betsy"           "Debian"        "jessie"
check_alt "LMDE"           "cindy"           "Debian"        "stretch"
check_alt "LMDE"           "debbie"          "Debian"        "buster"
check_alt "LMDE"           "elsie"           "Debian"        "bullseye"
check_alt "MX Linux 17"    "Horizon"         "Debian"        "stretch"
check_alt "MX Linux 18"    "Continuum"       "Debian"        "stretch"
check_alt "MX Linux 19"    "patito feo"      "Debian"        "buster"
check_alt "MX Linux 21"    "wildflower"      "Debian"        "bullseye"
check_alt "Pardus"         "onyedi"          "Debian"        "stretch"
check_alt "Parrot"         "ara"             "Debian"        "bullseye"
check_alt "PureOS"         "green"           "Debian"        "sid"
check_alt "PureOS"         "amber"           "Debian"        "buster"
check_alt "PureOS"         "byzantium"       "Debian"        "bullseye"
check_alt "SolydXK"        "solydxk-9"       "Debian"        "stretch"
check_alt "Sparky Linux"   "Tyche"           "Debian"        "stretch"
check_alt "Sparky Linux"   "Nibiru"          "Debian"        "buster"
check_alt "Sparky Linux"   "Po-Tolo"         "Debian"        "bullseye"
check_alt "Tanglu"         "chromodoris"     "Debian"        "jessie"
check_alt "Trisquel"       "toutatis"        "Ubuntu"        "precise"
check_alt "Trisquel"       "belenos"         "Ubuntu"        "trusty"
check_alt "Trisquel"       "flidas"          "Ubuntu"        "xenial"
check_alt "Trisquel"       "etiona"          "Ubuntu"        "bionic"
check_alt "Ubilinux"       "dolcetto"        "Debian"        "stretch"
check_alt "Uruk GNU/Linux" "lugalbanda"      "Ubuntu"        "xenial"

print_status "Checking \"${DISTRO}\" is supported..."

exec_cmd_nobail "curl -sLf -o /dev/null 'https://download.reemo.io/linux/deb/${REEMOVERSION}/${DISTRO}/Release'"
RC=$?

if [[ $RC != 0 ]]; then
    print_status "Your distribution, identified as \"${DISTRO}\", is not currently supported, please contact Reemo at https://reemo.io/ if you think this is incorrect or would like your distribution to be considered for support"
    exit 1
fi

# Uncomment to install ffmpeg4 on older distributions
# print_status "Installing ffmpeg 4 via PPA"

# exec_cmd "add-apt-repository ppa:jonathonf/ffmpeg-4 -y"
# exec_cmd_nobail "apt-get update"
# exec_cmd "apt install -y libavcodec58 libavformat58 libavutil56 libswscale5"

print_status "Installing binutils..."

exec_cmd "apt install -y binutils"

print_status "Downloading Reemo ${REEMOVERSION} package..."

exec_cmd "curl -sL -o /tmp/reemo.${REEMOVERSION}.deb 'https://download.reemo.io/linux/deb/${REEMOVERSION}/${DISTRO}/reemo.deb'"

print_status "Installing Reemo ${REEMOVERSION} package..."

exec_cmd "apt install -y /tmp/reemo.${REEMOVERSION}.deb"

print_status "Deleting Reemo ${REEMOVERSION} package file..."

exec_cmd_nobail "rm /tmp/reemo.${REEMOVERSION}.deb"

print_status "Configuring Reemo ${REEMOVERSION} service..."

exec_cmd_nobail "systemctl stop reemod.service"
exec_cmd_nobail "systemctl disable reemod.service"

exec_cmd "curl -sL -o /etc/systemd/system/reemod.service 'https://download.reemo.io/linux/deb/reemod.service'"

exec_cmd "systemctl daemon-reload"
exec_cmd "systemctl enable reemod.service"
exec_cmd "systemctl start reemod.service"

print_status "Checking reemo.ini configuration..."

CFGFILE=/opt/reemo/reemo.ini
if test -f "$CFGFILE"; then
    echo -e "\e[32m$CFGFILE exists"
else
    echo -e "\e[33m$CFGFILE does not exist. Creating one..."
    echo -e "\e[33mPlease fill your Private Key or Studio Key to complete the setup:"
    read PRIVATEKEY

    echo "[auth]" > ${CFGFILE}
    echo "token = $PRIVATEKEY" >> ${CFGFILE}
fi

echo -e "\e[32mDONE"

}

## Defer setup until we have the complete script
setup
