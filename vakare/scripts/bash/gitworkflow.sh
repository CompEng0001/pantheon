#!/usr/bin/env bash

# exit if any command exits with non-zero status
set -e

getRepoPath(){

    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]];then
        REPO_OWNER=$(cat .git/config | grep -m 1 : | awk -F '[:/]' '{print $2}')
        REPO_NAME=$(cat .git/config | grep -m 1 : | awk -F '[:/.]' '{print $4}')
    elif [[ $# == 2 ]]; then
        REPO_OWNER=$1
        REPO_NAME=$2
    else
        echo "Position 1: Owner, position 2: repo name, or be in a git repo"
        exit
    fi
}

WORKFLOW_FILE=".workflow.json"
RATE_FILE=".rate.json"
SLEEP_INTERVAL=20
GITHUB_TOKEN=$(cat ~/Git/.CompEng0001Token)

getRepoPath

echo "Checking the last executed run in "git@github.com:${REPO_OWNER}/${REPO_NAME}" repository's workflow:"

#curl --silent -i -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/rate_limit" > ${RATE_FILE}

#RATELIMIT=$(grep -m 1 x-ratelimit-remaining < ${RATE_FILE} | awk -F ':' '{print $2}')
#echo ${RATELIMIT}

while true; do

    curl \
        --silent \
        --location \
        --request GET \
        --header 'Accept: application/vnd.github.everest-preview+json' \
        --header 'Content-Type: application/json' \
        --header "Authorization: token ${GITHUB_TOKEN}" \
        --header 'cache-control: no-cache' \
        "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/runs" > ${WORKFLOW_FILE}


    STATUS=$(cat ${WORKFLOW_FILE} | grep -w -m 1 "status" | awk -F '[:"]' '{print $5}')

    WORKFLOW_NAME=$(cat ${WORKFLOW_FILE}  | grep -w -m 1 "name" | awk -F '[:"]' '{print $5}')

    if [ "${STATUS}" = "in_progress" ]; then
        echo -e "Workflow: ${WORKFLOW_NAME} | state: ${STATUS}"
    elif [ "${STATUS}" = "queued" ]; then
        echo -e "Workflow: ${WORKFLOW_NAME} | state: ${STATUS}"
    elif [ "${STATUS}" = "completed" ]; then
        echo -e "Workflow: ${WORKFLOW_NAME} | state: ${STATUS}"
        CONCLUSION=$(cat ${WORKFLOW_FILE}  | grep -w -m 1 "conclusion" | awk -F '[:"]' '{print $5}')
        START_TIME=$(cat ${WORKFLOW_FILE} | grep -m 1 created | awk -F '"' '{print $4}')
        END_TIME=$(cat ${WORKFLOW_FILE} | grep -m 1 updated | awk -F '"' '{print $4}')
        TIME_TAKEN=$((($(date -d ${END_TIME} '+%s') - $(date -d ${START_TIME} '+%s'))))
        echo "Workflow conclusion: ${CONCLUSION} | Time: ${TIME_TAKEN}s"
        break;
    else
        echo -e "Workflow: ${WORKFLOW_NAME} | state: ${STATUS} | ❌"
        CONCLUSION=$(cat ${WORKFLOW_FILE}  | grep -w -m 1 "conclusion" | awk -F '[:"]' '{print $5}')
        START_TIME=$(cat ${WORKFLOW_FILE} | grep -m 1 created  | awk -F '"' '{print $4}')
        END_TIME=$(cat ${WORKFLOW_FILE} | grep -m 1 updated  | awk -F '"' '{print $4}')
        TIME_TAKEN=$((($(date -d ${END_TIME} '+%s') - $(date -d ${START_TIME} '+%s'))))
        echo "Workflow conclusion: ${CONCLUSION} | Time: ${TIME_TAKEN}s"
        break;
    fi

    sleep ${SLEEP_INTERVAL}

done

rm ${WORKFLOW_FILE} || true
