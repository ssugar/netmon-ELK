#!/bin/bash

curl -4 -v -XPUT http://localhost:9200/_template/logstash_per_index -d '{
    "template" : "logstash*",
    "settings": {
      "index.cache.field.type": "soft",
      "index.store.compress.stored": true
    },
    "mappings" : {
        "_default_" : {
           "_all" : {"enabled" : false},
           "properties" : {
              "@message":     { "index": "analyzed", "type": "string"  },
              "@source":      { "index": "not_analyzed", "type": "string"  },
              "@source_host": { "index": "not_analyzed", "type": "string" },
              "@source_path": { "index": "not_analyzed", "type": "string" },
              "@tags":        { "index": "not_analyzed", "type": "string" },
              "@timestamp":   { "index": "not_analyzed", "type": "date" },
              "@type":        { "index": "not_analyzed", "type": "string" },
              "source":       { "index": "not_analyzed", "type": "string" },
              "destination":  { "index": "not_analyzed", "type": "string" },
              "srcip":       { "index": "not_analyzed", "type": "string" },
              "dstip":  { "index": "not_analyzed", "type": "string" },
              "groupName":    { "index": "not_analyzed", "type": "string" },
              "lastLoginName":  { "index": "not_analyzed", "type": "string" },
              "Machine_GroupID":  { "index": "not_analyzed", "type": "string" },
              "Manufacturer":  { "index": "not_analyzed", "type": "string" },
              "ConnectionGatewayIp":  { "index": "not_analyzed", "type": "string" },
              "CPUs.CPU.CpuDesc":  { "index": "not_analyzed", "type": "string" },
              "lastLoginName":  { "index": "not_analyzed", "type": "string" },
              "ComputerName":  { "index": "not_analyzed", "type": "string" },
              "OsType":       { "index": "not_analyzed", "type": "string" },
              "uptime":       { "index": "analyzed", "type": "float" },
              "diskused":     { "index": "analyzed", "type": "integer" },
              "@LoginName":   { "index": "not_analyzed", "type": "string" },
              "netflow": {
                   "dynamic": true,
                   "path": "full",
                   "properties": {
                       "version": { "index": "analyzed", "type": "integer" },
                       "first_switched": { "index": "not_analyzed", "type": "date" },
                       "last_switched": { "index": "not_analyzed", "type": "date" },
                       "direction": { "index": "not_analyzed", "type": "integer" },
                       "flowset_id": { "index": "not_analyzed", "type": "integer" },
                       "flow_sampler_id": { "index": "not_analyzed", "type": "integer" },
                       "flow_seq_num": { "index": "not_analyzed", "type": "long" },
                       "src_tos": { "index": "not_analyzed", "type": "integer" },
                       "tcp_flags": { "index": "not_analyzed", "type": "integer" },
                       "protocol": { "index": "not_analyzed", "type": "integer" },
                       "ipv4_next_hop": { "index": "not_analyzed", "type": "string" },
                       "in_bytes": { "index": "not_analyzed", "type": "long" },
                       "in_pkts": { "index": "not_analyzed", "type": "long" },
                       "out_bytes": { "index": "not_analyzed", "type": "long" },
                       "out_pkts": { "index": "not_analyzed", "type": "long" },
                       "input_snmp": { "index": "not_analyzed", "type": "long" },
                       "output_snmp": { "index": "not_analyzed", "type": "long" },
                       "ipv4_dst_addr": { "index": "not_analyzed", "type": "string" },
                       "ipv4_src_addr": { "index": "not_analyzed", "type": "string" },
                       "dst_mask": { "index": "analyzed", "type": "integer" },
                       "src_mask": { "index": "analyzed", "type": "integer" },
                       "dst_as": { "index": "analyzed", "type": "integer" },
                       "src_as": { "index": "analyzed", "type": "integer" },
                       "l4_dst_port": { "index": "not_analyzed", "type": "long" },
                       "l4_src_port": { "index": "not_analyzed", "type": "long" }
                   },
                   "type": "object"
               },
               "geoip": {
                   "dynamic": true,
                   "path": "full",
                   "properties": {
                      "city_name": { "index": "not_analyzed", "type": "string"},
                      "real_region_name": { "index": "not_analyzed", "type": "string"}
                   },
                   "type": "object"
               },
               "geoipdst": {
                   "dynamic": true,
                   "path": "full",
                   "properties": {
                      "city_name": { "index": "not_analyzed", "type": "string"},
                      "real_region_name": { "index": "not_analyzed", "type": "string"}
                   },
                   "type": "object"
               },
               "geoipsrc": {
                   "dynamic": true,
                   "path": "full",
                   "properties": {
                      "city_name": { "index": "not_analyzed", "type": "string"},
                      "real_region_name": { "index": "not_analyzed", "type": "string"}
                   },
                   "type": "object"
               }
            }
        }
   }
}'

					   
					   
