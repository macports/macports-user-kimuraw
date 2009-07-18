#!/bin/sh
# $Id: port-pack-rabbit.sh 114 2008-09-07 09:10:54Z kimuraw $
# make port archive of rb-rabbit and its dependencies, this archive will 
# be uploaded onto MacPortsWikiJP
#

svnroot=https://www.cozmixng.org/repos/dports/trunk
targets="rb-rabbit rb-gtk2 rb-pango rb-glib2 rb-atk rb-rsvg rb-poppler rb-gettext"
if [ "x${*}" != "x" ]; then
  targets=${*}
fi

workdir=`mktemp -d /tmp/portXXXX`

if [ "x$*" = "x--help" ]; then
  echo "[usage] port-arch port1 port2 ..." 1>&2
  exit 1
fi

first_port=`echo "${targets}"|cut -f1 -d\  `
port_version=`port -q info --version ${first_port} `
if [ "${port_version}" = "No port foo found." ]; then
  echo "error: port \"${first_port}\" not found" 1>&2
  exit 1
fi
archname=${first_port}-${port_version}

for target in ${targets}
do
  cat1=`port -q info --category ${target}|tail -1|cut -f1 -d,`
  path=${cat1}/${target}
  echo ${path}
  tmp_target="${workdir}/${path}"
  mkdir -p `dirname ${tmp_target}`
  svn export "${svnroot}/${path}" "${tmp_target}" >/dev/null
done

tar cvjf ${archname}.tbz2 -C "${workdir}" .
rm -rf "${workdir}" 2>/dev/null

