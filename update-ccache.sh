IMAGE_NAME=
SOURCE_PATH=
DESTINATION_PATH=

function help
{
      echo "this utility extracts ccache files from a Docker image into your ccache directory"
      echo "the following flags are required: -i <image name> -s <source path> -d <destination path>"
}

# start parsing options
while getopts "h?i:s:d:" opt; do
  case "$opt" in
  h|\?)
      help
      break
      ;;
  i)  echo "setting image name: " $OPTARG
      IMAGE_NAME=$OPTARG
      ;;
  s)  echo "setting source path: " $OPTARG
      SOURCE_PATH=$OPTARG
      ;;
  d)  echo "setting destination path: " $OPTARG
      DESTINATION_PATH=$OPTARG
      ;;
  esac
done


# if the image name is not set, abort
if [ -z "$IMAGE_NAME" ] || [ -z "$SOURCE_PATH" ] || [ -z "$DESTINATION_PATH" ]
then 
  echo "error: image name or paths not set."
  help
  exit
fi

# get container ID by creating temporary container
CONTAINER_ID=$(docker create $IMAGE_NAME)

# copy ccache files from container
docker cp $CONTAINER_ID:$SOURCE_PATH /tmp/tmpccache

# copy ccache files to ccache folder
cp -R /tmp/tmpccache/* $DESTINATION_PATH

# Remove temporary container
docker rm $CONTAINER_ID

# rebuild ccache base container
cd ~/.ccache
docker build . -t ccache
cd -

