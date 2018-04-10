#!/bin/bash
. dockerFramework.sh
clear

# variables
idLength=12
space="    "
_version='0.1'
_status='beta'

echo -e "\n-------------------------------\
\n--:: DockerCLI version $_version $_beta ::--\n\
-------------------------------\n"


for imageId in $(getImagesId); do

	Id=$(getValue 'image' '{{.Id}}' $imageId); Id=${Id#*:}
	RepoTags=$(getValue 'image' '{{index .RepoTags 0}}' $imageId);
	Repo=${RepoTags%:*}
	Tags=${RepoTags#*:}
	display "Repo: $Repo:$Tags ($imageId)" 'GREEN'

	for containerId in $(getContainersId); do
		Image=$(getValue 'container' '{{.Image}}' $containerId); Image=${Image#*:}
		if [ "$Id" == "$Image" ]; then
			ConfigImage=$(getValue 'container' '{{.Config.Image}}' $containerId)
			StateStatus=$(getValue 'container' '{{.State.Status}}' $containerId)
			Name=$(getValue 'container' '{{.Name}}' $containerId)
			PortsBindings=$(getValue 'container' '{{ range $p,$conf := .HostConfig.PortBindings}} {{( index $conf 0).HostPort}}:{{$p}} {{end}}' $containerId)
			Created=$(getValue 'container' '{{.Created}}' $containerId)
			networks=$(getValue 'container' '{{range $i,$p := .NetworkSettings.Networks}}{{$i}} {{end}}' $containerId)
			ipAdress=$(getValue 'container' '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' $containerId)
			display "${space}$Name ($containerId) [${StateStatus^^}] $Created" 'MAGENTA'
                        for net in $networks; do
                                display "${space}${space}$net"
                        done
			for ip in $ipAdress; do
				display "${space}${space}${space}$ip"
			done
			for port in $PortsBindings; do
				display "${space}${space}${space}${space} $port"
			done
		fi
	done
	echo ""
done
echo ""
