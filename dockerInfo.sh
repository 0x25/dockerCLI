#!/bin/bash
. dockerFramework.sh
clear

# variables
idLength=12
space="    "
_version='0'
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
			display "${space}$Name ($containerId) [${StateStatus^^}] $Created" 'MAGENTA'
			for port in $PortsBindings; do
				display "${space}${space}$port"
			done
		fi
	done
	echo ""
done
echo ""
