if [ "$OSTYPE" == "linux-gnu" ]; then
    GIT=env/ubuntu/git
else
    GIT=git
fi

$GIT add .
$GIT commit -m "$1"
$GIT push
