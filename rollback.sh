#!/bin/bash

NS=models
REVISION=1

RELEASE=( 
       "localize-die-multi" "localize-inaly-die-veneer"  "longbridge-crown-t11-v04"  "longbridge-crown-t12-v04"   "longbridge-crown-t13-v04"  "longbridge-crown-t14"   "longbridge-crown-t15"   "longbridge-crown-t16" "longbridge-crown-t17" "longbridge-crown-t333231-v01" \
       "longbridge-crown-t41um"  "longbridge-lb-hat-mandibular-ant-v01"   "longbridge-lb-hat-mandibular-post-v01"  "longbridge-lb-hat-maxillary-ant-v01"  "longbridge-lb-hat-maxillary-post-v01"   "longbridge-multiponticpos-madibular-ant-v01"  \
                           	
)


echo "Rolling back helm release"
for release  in "${RELEASE[@]}"; do
   helm rollback "${release}" $REVISION -n $NS
done



