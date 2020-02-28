#!/bin/bash

####################### 
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/.. > /dev/null && pwd )

#################### 
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false

########## 
# SOURCE #
##########

for functionFile in ${SCRIPT_DIR}/functions/*.active;
  do source ${functionFile}
done

##########
# SCRIPT #
##########

main () {
  # INITIAL VALUES

  # GETOPT

  ####
  # CHECK INPUT
  # check if all required options are given

  ####
  # Declare Array of scripts that should be executed
  # Important as we have dependencies that require certain scripts to be run before others

  declare -a resourceArr=("commons.sh"
                          "hogarama_commons.sh"
                          "keycloak.sh"
                          "amq.sh"
                          "prometheus.sh"
                          "grafana.sh"
                          "mongodb.sh"
                          "fluentd.sh"
                          "hogajama.sh"
                          )
 
  ####
  # CORE LOGIC
  set -e
  for resource in ${resourceArr[@]}; do

    execute "${SCRIPT_DIR}/wrapper/hogarama_template.sh --resource ${resource} ${*}"
    execute "${SCRIPT_DIR}/wrapper/hogarama_create.sh --resource ${resource} ${*}"
  done
  set +e
}
 
main $@