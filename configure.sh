# Configure TSR token
export TSR_TOKEN=`tsr token` && sed -i "s/__TSR_TOKEN__/$TSR_TOKEN/g" /home/git/.bash_profile

