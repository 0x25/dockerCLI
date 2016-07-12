
#!/bin/bash
# CLI api to Query docker
# fr 11/07/2016
# need sudo

# check sudo
if [ "$(id -u)" != "0" ]; then
	echo "Opps!... not Root :/"
	exit 1
fi

function helpCmd {

	echo "To DO"
}


function getImagesId {

	imagesId=$(docker images -q)
	echo $imagesId
}

function getContainersId {

	containersId=$(docker ps -aq)
	echo $containersId
}

function getValue {

	type=$1
	format=$(echo $2 | sed 's/"/\\"/g')
	id=$3
	echo $(docker inspect --type=$type --format="$format" $id)
}

function display {

	color=$2
	message=$1

	case $color in
	GREEN)
		echo -e "\e[32m${message}\e[39m"
	;;
	MAGENTA)
		echo -e "\e[35m${message}\e[39m"
	;;

	*)
		echo -e "$message"
	;;
	esac
}

