#!/bin/bash

POSITIONAL=()

# Default
LAST="--last 1"
USEARCHIVE=true

# Get computer specific parameters
source BORGPARAM

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    list)
    USEARCHIVE=false
    POSITIONAL+=("$1")
    shift # past argument
    ;;
    mount)
    MNTPNT=$MNT_DIR
    POSITIONAL+=("$1")
    shift # past argument
    ;;
    umount)
    MNTPNT=$MNT_DIR
    USEARCHIVE=false
    REPO_DIR=""
    LAST=""
    POSITIONAL+=("$1")
    shift # past argument
    ;;
    replace)
    REPDIR="$2"
    shift # past argument
    shift # past value
    ;;
    vimdiff)
    VIMDIFFDIR="$2"
    shift # past argument
    shift # past value
    ;;
    -a|--archive)
    USEARCHIVE=true
    ARCHIVE="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--last)
    LAST="--last $2"
    shift # past argument
    shift # past value
    ;;
    -p|--path)
    FPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--use-archive) # Only relevant to "list" command
    USEARCHIVE=true
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Get correct archive, if not already specified manually
if [ $USEARCHIVE == true ]; then
    if [ -z "$ARCHIVE" ]; then
        ARCHIVE=$(borg list --short $LAST $REPO_DIR  | sed -n 1p)
    fi
    echo "The archive used is: $ARCHIVE"

    # The function of LAST has been consumed
    LAST=""

    # Add :: to fit borg syntax
    SPRT=::
fi

if [ -n "$VIMDIFFDIR" ]; then 
    echo "vimdiff of file: $VIMDIFFDIR"
    borg mount $REPO_DIR$SPRT$ARCHIVE $MNT_DIR ${VIMDIFFDIR:1}
    vimdiff $MNT_DIR$VIMDIFFDIR $VIMDIFFDIR
    borg umount $MNT_DIR
elif [ -n "$REPDIR" ]; then
    echo "replace is not yet implemented"
else
    cmd="borg $* $LAST $REPO_DIR$SPRT$ARCHIVE $MNTPNT $FPATH"
    echo "Command: $cmd"
    eval $cmd
fi