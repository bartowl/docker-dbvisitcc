#!/bin/sh
if ! [ -l /usr/dbvisit/standbymp/db ]; then
  if [ -d /usr/dbvisit/persistent/db ]; then
    echo "Using persisted settings from from external volume..."
    rm -rf /usr/dbvisit/standbymp/{certificates,conf,db}
    AGENT_PASSWORD="persisted, do not re-generate"
  else
    echo "First-time execution, preparing persistent storage from template..."
    mv /usr/dbvisit/standbymp/certificates /usr/dbvisit/persistent
    mv /usr/dbvisit/standbymp/conf /usr/dbvisit/persistent
    mv /usr/dbvisit/standbymp/db /usr/dbvisit/persistent
  fi
  ln -s /usr/dbvisit/persistent/certificates /usr/dbvisit/standbymp/certificates
  ln -s /usr/dbvisit/persistent/conf /usr/dbvisit/standbymp/conf
  ln -s /usr/dbvisit/persistent/db /usr/dbvisit/standbymp/db
  if [ -z "$AGENT_PASSWORD" ]; then
    AGENT_PASSWORD=$(echo date | sha256sum | base64 | head -c 32)
    echo "Generated Agent Password: $AGENT_PASSWORD"
    echo "To change it run /usr/dbvisit/standbymp/bin/change-passphrase inside this container"
    echo "$AGENT_PASSWORD" | /usr/dbvisit/standbymp/bin/change-passphrase -f -
  fi
fi

while : ; do
  /usr/dbvisit/standbymp/bin/dbvcontrol service run
  sleep 10
done
