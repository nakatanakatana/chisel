#!/bin/sh

# For local development and test only. See documentation.
if [[ -v GOOGLE_APPLICATION_CREDENTIALS ]]; then
  gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
fi

gcloud sql instances patch $DB_INSTANCE --activation-policy=always

_shutdownCloudSQL()
{
  echo "shutdown Cloud SQL instance $DB_INSTANCE"
  gcloud sql instances patch $DB_INSTANCE --activation-policy=never
}

trap _shutdownCloudSQL SIGINT SIGTERM

/app/chisel server --uds

