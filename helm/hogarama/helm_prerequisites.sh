#!/bin/bash

#######################
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/../.. > /dev/null && pwd )

##########
# SOURCE #
##########

for functionFile in ${TOPLEVEL_DIR}/bootstrap/functions/*.active;
  do source ${functionFile}
done

###############
# INIT VALUES #
###############

FLAG_FORCE=""

##########
# SCRIPT #
##########

main () {

  local extravars=""
  # getopts
  local opts=`getopt -o he:fd --long help,force,dryrun -- "$@"`
  local opts_return=$?
  eval set -- "$opts"
  while true ; do
      case "$1" in
      -f | --force)
          FLAG_FORCE=true
          shift
          ;;
      --dryrun)
          FLAG_DRYRUN=true
          shift
          ;;
      -h | --help)
        FLAG_HELP=true
        ;;
      -e )
        extravars="${extravars} -e ${2}"
        shift 2
        ;;
      *)
          break
          ;;
      esac
  done

  ## pipe through flags to underlying script ##
  if [[ "x${FLAG_FORCE}" != "x" ]]; then
    options="${options} --force"
  fi

  if [[ "x${FLAG_DRYRUN}" != "x" ]]; then
    options="${options} --dryrun"
  fi

  if [[ "x${FLAG_HELP}" != "x" ]]; then
    options="${options} --help"
  fi

  GIT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

  set -e
  execute "docker run --rm -it \
    -v ${TOPLEVEL_DIR}:/mnt/hogarama \
    gepardec/j2cli:latest \
    hogarama/bootstrap/scripts/hogarama_template.sh --resource helm ${options} -e GIT_BRANCH="${GIT_BRANCH}" "${extravars}" "
  
  execute "cd ${SCRIPT_DIR} && helm repo add stable https://kubernetes-charts.storage.googleapis.com"
  execute "cd ${SCRIPT_DIR} && helm dep update"
  set +e
}

main $@
