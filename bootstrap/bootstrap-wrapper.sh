#!/bin/bash

readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )

#TODO: pass force flag through to scripts.
${SCRIPT_DIR}/commons-wrapper.sh
${SCRIPT_DIR}/hogarama-commons-wrapper.sh
${SCRIPT_DIR}/amq-wrapper.sh
${SCRIPT_DIR}/prometheus-wrapper.sh
${SCRIPT_DIR}/grafana-wrapper.sh
${SCRIPT_DIR}/mongodb-wrapper.sh
${SCRIPT_DIR}/fluentd-wrapper.sh
${SCRIPT_DIR}/hogajama-wrapper.sh


