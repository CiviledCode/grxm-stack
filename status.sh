#!/bin/bash

echo "--- grxm-stack Environment Status ---"

# Check if containers are running
echo -e "\n[ Container Status ]"
sudo docker-compose ps

# Show container resource usage
echo -e "\n[ Resource Usage ]"
sudo docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

# Check Nginx connectivity and Service Health
echo -e "\n[ Service Health Checks ]"

# Webapp Health Check
WEB_HEALTH=$(curl -s http://localhost/health)
if echo "$WEB_HEALTH" | grep -q '"status": "healthy"'; then
    echo "Webapp Service:  HEALTHY (via Nginx)"
else
    echo "Webapp Service:  UNHEALTHY or OFFLINE"
    echo "  Response: $WEB_HEALTH"
fi

# IAM Health Check
IAM_HEALTH=$(curl -s http://localhost/iam/health)
if echo "$IAM_HEALTH" | grep -q '"status": "alive"'; then
    DB_STATUS=$(echo "$IAM_HEALTH" | grep -o '"database": "[^"]*"' | cut -d'"' -f4)
    if [ "$DB_STATUS" == "ok" ]; then
        echo "IAM Service:     HEALTHY (Database: OK)"
    else
        echo "IAM Service:     DEGRADED (Database: $DB_STATUS)"
    fi
else
    echo "IAM Service:     UNHEALTHY or OFFLINE"
    echo "  Response: $IAM_HEALTH"
fi

# Check Authority WebSocket (should be blocked)
echo -e "\n[ Security Check ]"
WS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/iam/api/v1/authority)
if [ "$WS_STATUS" == "403" ]; then
    echo "Authority WebSocket: SECURE (Access Blocked by Nginx)"
else
    echo "Authority WebSocket: WARNING (Status: $WS_STATUS - check Nginx config)"
fi
