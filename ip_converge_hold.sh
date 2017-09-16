for (( ; ; ))
do
  echo "Checking convergence of IP addresses..."
  echo "My IP is ${MY_IP}"
  echo "DNS says my IP is `host ${DNS_NAME} | awk '{print $4}'`"
  if [ `host ${DNS_NAME} | awk '{print $4}'` == "${MY_IP}" ]; then
    echo "IP addresses converged. we can continue..."
    exit 0
  fi
  echo "Will wait 30 seconds and check again."
  sleep 30
done
