#!/bin/bash

version="0.1.0"
author="Kevin Gimbel"
author_url="<http://kevingimbel.com>"
github_url="https://github.com/kevingimbel/bump"
github_issues="$github_url/issues"
program_name="$(basename "$0")"
do_commit=""

if [ -z "$_bump_default_git" ]; then
  _bump_default_git="[BUMP]"
fi

# Print out version information
version() {
  printf "%s\n" "Version $version" \
  "by $author $author_url" \
  "" \
  "Report Issues on $github_issues"
  exit
}

# Print out usage information
usage() {
  printf "%s\n" \
  "Usage: $program_name [options] Message" \
  "Write a bump text to bump.txt" \
  "" \
  "Options:" \

  echo "
    -u,--usage  & Show usage message
    -h,--help   & Show help
    -v,--version & Show version and author info
    -g, --git & add all changes to git and create commit message
  " | column -s\& -t

  echo ""
  echo "Environment variables:"
  echo "
    _bump_default_git & \"$_bump_default_git\"
  " | column -s\& -t

  echo ""
  echo "Report Issues on $github_issues"
  exit
}

help() {
  printf "%s\n" \
  "Run $program_name 'message' to write a bump message to the bump.txt file" \
  "in the current directory."
  exit
}


write_bump() {
  if [ "$1" == "" ]; then
    echo "Empty text. See $program_name --usage"
    exit
  fi

  if [ ! -f "./bump.txt" ]; then
    echo "Creating bump.txt file"
    touch "./bump.txt"
  fi

  bump_message="[$(date +%x)] $1"

  echo "$bump_message" >> ./bump.txt && echo "Bump text written to bump.txt"
  if [ ! -z "$do_commit" ]; then
    git add . && git commit -m "$_bump_default_git $1"
  fi
  exit $?
}

# We assume message the last argument is the message.
# If it is not, it will be set below.
msg=${@:$#}

case "$1" in
  '-u' | '--usage')
    usage
  ;;

  '-h' | '--help')
    help
  ;;

  '-v' | '--version')
    version
  ;;

  '-g' | '--git')
    do_commit="true"
  ;;
  
  '-m' | '--msg')
    msg=$2
  ;;
esac
shift

write_bump "$msg"
