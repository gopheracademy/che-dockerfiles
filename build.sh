cd $(pwd)/stack-base/debian

docker build -t eclipse/stack-base:debian .
cd ../..
cd $(pwd)/stack-base/ubuntu
docker build -t eclipse/stack-base:ubuntu .
cd ../..
dir=$(find . -maxdepth 3 -mindepth 1 -type d -not -path '*/\.*' -exec bash -c 'cd "$0" && pwd' {} \;)

for d in $dir
    do
	IMAGE=$(echo $d | sed 's/.*recipes\///' | awk -F'/' '{print $1}')
	TAG=$(echo $d | sed 's/.*recipes\///' | awk -F'/' '{print $2}')
	    if [ -n "$TAG" ]; then
	    TAG=$TAG
	    else
	    TAG="latest"
	fi
	    cd $d
	if [ ! -f $d/Dockerfile ]; then
	    echo "No Dockerfile Found. Skipping..."
	    exit
	fi
	    docker build -t eclipse/"$IMAGE":"$TAG"  .
    		if [ "$?" != "0" ]; then
		    echo "Unable to build image: $IMAGE"
		exit $?
		else
		    echo "$IMAGE:$TAG successfully built"
    fi
done
