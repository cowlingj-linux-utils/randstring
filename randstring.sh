#!/usr/bin/env bash

set -euo pipefail

LENGTH='64'
CHARACTER_SET='[:graph:]'

# /dev/urandom is a secure source of randomnes
# see: https://www.2uo.de/myths-about-urandom/
SOURCE="/dev/urandom"

usage() {
  echo "$0 [-h] [-l <LENGTH>] [-c <CHARACTER_SET>] [-s <SOURCE>]"
  echo "  -h"
  echo "    Display this help message"
  echo "  -l"
  echo "    generate a random string of length <LENGTH>"
  echo "    (default: $LENGTH)"
  echo "  -c"
  echo "    generate string from characters in <CHARACTER_SET>"
  echo "    (default: $CHARACTER_SET)"
  echo "  -s"
  echo "    use <SOURCE> as a source of randomness for generating the string"
  echo "    (default: $SOURCE)"
}

while getopts ":hl:c:s:" OPTNAME; do
  case "${OPTNAME}" in
    h )
      usage
      exit 0
      ;;
    l )
      LENGTH="$OPTARG" 
      ;;
    c )
      CHARACTER_SET="$OPTARG"
      ;;
    s )
      SOURCE="$OPTARG"
      ;;
    \? )
      usage >& 2
      exit 1
      ;;
    : )
      usage >& 2
      exit 1
      ;;
  esac

  shift "$(( OPTIND - 1 ))"
done

# flipping the if statement like this also catches non-integers
if [ "$LENGTH" -gt 0 ] 2>/dev/null; then
  :
else
  echo "LENGTH must be greater than 0 (currently $LENGTH)" >& 2
  exit 1
fi 

LC_ALL=C tr -dc "$CHARACTER_SET" < "$SOURCE" | head -c "$LENGTH"
printf '\n'

