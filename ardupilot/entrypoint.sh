#!/bin/sh
set -e
if [ -z "${NEED_START}" ]; then
    NEED_START=false
fi
echo "NEED_START ?"
echo $NEED_START
if [ "$NEED_START" = true ]; then
    echo "Starting ArduPilot instance"
else
    echo "Shutting down"
    exit 0  # Prevent docker restart
fi

if [ -z "${SITL_LOCATION}" ]; then
    SITL_LOCATION="-35.363261,149.165230,584,353"
fi

if [ -z "${SITL_PARAMETER_LIST}" ]; then
    SITL_PARAMETER_LIST="/ardupilot/copter.parm"
fi

if [ -z "${SITL_MCAST}" ]; then
    SITL_MCAST="--uartA mcast:"
fi

if [ -z "${INSTANCE}" ]; then
    INSTANCE="-I0"
fi

if [ -z "${SYSID}" ]; then
    SYSID=1
fi


if [ -z "${FOLL_ENABLE}" ]; then
    echo "Follow disabled"
    FOLLOW_STRING=""
else
    if [ $((SYSID & 1)) -eq 1 ]; then
        FOLL_OFS_X=-${SYSID}
    else
        FOLL_OFS_X=${SYSID}
    fi
    FOLLOW_STRING="FOLL_ENABLE 1\nFOLL_OFS_X ${FOLL_OFS_X}\nFOLL_OFS_TYPE 1\nFOLL_SYSID ${FOLL_SYSID}\nFOLL_DIST_MAX 1000\n"
fi

printf "SYSID_THISMAV ${SYSID}\nTERRAIN_ENABLE 0\n${FOLLOW_STRING}" > identity.parm
echo "INSTANCE:"
echo $INSTANCE

args="-S $INSTANCE --home ${SITL_LOCATION} --model + --speedup 1 --defaults ${SITL_PARAMETER_LIST},identity.parm $SITL_MCAST"

echo "args:"
echo "$args"

# Start Ardupilot simulator
/ardupilot/arducopter ${args}

