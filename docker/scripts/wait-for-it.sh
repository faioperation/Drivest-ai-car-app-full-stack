#!/usr/bin/env bash
#   Use this script to test if a given TCP host and port are available
#   Adopted from github.com/vishnubob/wait-for-it

# Initialize options
WAITFORIT_cmdname=${0##*/}
WAITFORIT_strict=0
WAITFORIT_quiet=0
WAITFORIT_timeout=15
WAITFORIT_host=""
WAITFORIT_port=""

echo_warning() {
    if [ "$WAITFORIT_quiet" -ne 1 ]; then echo "$@" 1>&2; fi
}

usage() {
    exitcode=$1
    cat << USAGE >&2
Usage:
    $WAITFORIT_cmdname host:port [-s] [-t timeout] [-- command args]
    -h | --host          Host or IP under test
    -p | --port          TCP port under test
                         Alternatively, you can specify the host and port as host:port
    -s | --strict        Only execute subcommand if the test succeeds
    -q | --quiet         Don't output any status messages
    -t | --timeout       Timeout in seconds, zero for no timeout
    -- COMMAND ARGS      Execute subcommand after the test finishes
USAGE
    exit "$exitcode"
}

wait_for() {
    if [ "$WAITFORIT_timeout" -gt 0 ]; then
        echo_warning "$WAITFORIT_cmdname: waiting $WAITFORIT_timeout seconds for $WAITFORIT_host:$WAITFORIT_port"
    else
        echo_warning "$WAITFORIT_cmdname: waiting for $WAITFORIT_host:$WAITFORIT_port without a timeout"
    }
    WAITFORIT_start_ts=$(date +%s)
    while :
    do
        if [ "$WAITFORIT_strict" -eq 1 ]; then
            nc -z "$WAITFORIT_host" "$WAITFORIT_port" >/dev/null 2>&1
            WAITFORIT_result=$?
        else
            (echo > /dev/tcp/"$WAITFORIT_host"/"$WAITFORIT_port") >/dev/null 2>&1
            WAITFORIT_result=$?
        fi
        if [ $WAITFORIT_result -eq 0 ]; then
            WAITFORIT_end_ts=$(date +%s)
            echo_warning "$WAITFORIT_cmdname: $WAITFORIT_host:$WAITFORIT_port is available after $((WAITFORIT_end_ts - WAITFORIT_start_ts)) seconds"
            break
        fi
        sleep 1
    done
    return $WAITFORIT_result
}

# Parse arguments
while [ $# -gt 0 ]
do
    case "$1" in
        *:* )
        WAITFORIT_host=${1%%:*}
        WAITFORIT_port=${1##*:}
        shift 1
        ;;
        -h | --host)
        WAITFORIT_host="$2"
        if [ "$WAITFORIT_host" = "" ]; then break; fi
        shift 2
        ;;
        --host=*)
        WAITFORIT_host="${1#*=}"
        shift 1
        ;;
        -p | --port)
        WAITFORIT_port="$2"
        if [ "$WAITFORIT_port" = "" ]; then break; fi
        shift 2
        ;;
        --port=*)
        WAITFORIT_port="${1#*=}"
        shift 1
        ;;
        -s | --strict)
        WAITFORIT_strict=1
        shift 1
        ;;
        -q | --quiet)
        WAITFORIT_quiet=1
        shift 1
        ;;
        -t | --timeout)
        WAITFORIT_timeout="$2"
        if [ "$WAITFORIT_timeout" = "" ]; then break; fi
        shift 2
        ;;
        --timeout=*)
        WAITFORIT_timeout="${1#*=}"
        shift 1
        ;;
        --)
        shift
        WAITFORIT_cli=("$@")
        break
        ;;
        -*)
        usage 1
        ;;
        *)
        WAITFORIT_cli=("$@")
        break
        ;;
    esac
done

if [ "$WAITFORIT_host" = "" ] || [ "$WAITFORIT_port" = "" ]; then
    echo_warning "Error: you must provide a host and port to test."
    usage 2
fi

WAITFORIT_timeout=${WAITFORIT_timeout:-15}
WAITFORIT_strict=${WAITFORIT_strict:-0}
WAITFORIT_quiet=${WAITFORIT_quiet:-0}

# Run execution loop
wait_for
WAITFORIT_exitcode=$?

if [ "${#WAITFORIT_cli[@]}" -gt 0 ]; then
    if [ $WAITFORIT_exitcode -ne 0 ] && [ "$WAITFORIT_strict" -eq 1 ]; then
        echo_warning "$WAITFORIT_cmdname: strict mode, refusing to execute subcommand"
        exit $WAITFORIT_exitcode
    fi
    exec "${WAITFORIT_cli[@]}"
else
    exit $WAITFORIT_exitcode
fi
