#!/bin/sh

pg_dump -U postgres \
        -h db \
        -d scorebot_production \
        -Fc \
        -f $(date +/scorebot/tmp/dumps/%Y%m%d%H%M%S.pgdump)
