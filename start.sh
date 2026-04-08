#!/bin/bash
npm_process_id=$(pidof npm)
redis_process_id=$(pidof redis-server)
mx3_process_id=$(pidof mxcube3-server)
#isara_process_id=$(pidof python3)

#source ~/mx3env_py3/bin/activate
cd /opt/bl17b_mxcube
if [[ -z $npm_process_id ]]; then
   echo "starting npm..."
   npm start > ~/logs/npm.log 2>&1 &
else
   echo "npm already running"
fi

cd /root
if [[ -z $redis_process_id ]]; then
   echo "starting redis-server..."
   redis-server > ~/logs/redis_server.log 2>&1 &
else
   echo "redis already running"
fi

#if [[ -z $isara_process_id ]]; then
#   echo "starting isara epics server..."
#   cd ~/PyCATS/pycats/epics/
#   python3 ./serverEpics.py > ~/logs/isara_epics.log 2>&1 &
#else
#   echo "isara epics server already running"
#fi

if [[ -z $mx3_process_id ]]; then
   #echo "auxiliary servers started, starting MXCuBE..."
   echo "starting Mxcube..."
   source /home/mxcube19u1/anaconda3/etc/profile.d/conda.sh
   conda activate mxcubeweb

   python3 /home/mxcube19u1/mxcube/mxcube3/mxcube3-server -l ~/logs/mxcube.log -r /home/mxcube19u1/mxcube/mxcubecore/mxcubecore/configuration --static-folder /home/mxcube19u1/mxcube/mxcube3/ui/build
else
   echo "mxcube already running !"
fi

