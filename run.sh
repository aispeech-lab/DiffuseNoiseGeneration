#!/bin/sh
 
ls main_diffuse_noise_* | (while
read line;
do
        echo "Start to run the matlab file:"${line}
        nohup ./../matlab2016b.ln <$line> $(date '+%Y-%m-%d_%H-%M-%S')${line}.out&
        touch $!".pid"
done)

