# Add /var/lib/rancher/rke2/bin to the path for sh compatible users

if [ -z "${PATH-}" ] ; then
  export PATH=/var/lib/rancher/rke2/bin
elif ! echo "${PATH}" | grep -q /var/lib/rancher/rke2/bin ; then
  export PATH="${PATH}:/var/lib/rancher/rke2/bin"
fi
