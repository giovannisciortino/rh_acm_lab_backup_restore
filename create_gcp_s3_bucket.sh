#!/bin/bash
source ./python_venv/bin/activate
echo "GCP Project ID:"
read PROJECT_ID
echo "Service account name file path:"
read SERVICE_ACCOUNT_FILE_PATH
echo "Bucket name velero:"
read BUCKET_VELERO
echo "Bucket name observability:"
read BUCKET_OBSERVABILITY

echo "GCP AUTHENTICATION"

gcloud auth activate-service-account --project="$PROJECT_ID" --key-file=$SERVICE_ACCOUNT_FILE_PATH

echo "GCP ENABLE STORAGE API"

gcloud services enable storage.googleapis.com --project $PROJECT_ID

echo "GCP CREATE BUCKET VELERO"

gcloud storage buckets create gs://$BUCKET_VELERO/ --project="$PROJECT_ID" --location eu

echo "GCP CREATE SERVICE_ACCOUNT VELERO"

gcloud iam service-accounts create velero --display-name "Velero service account"

echo "GCP GET SERVICE ACCOUNT EMAIL VELERO"

VELERO_SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:Velero service account" --format 'value(email)')
VELERO_ROLE_PERMISSIONS=(
    compute.disks.get
    compute.disks.create
    compute.disks.createSnapshot
    compute.snapshots.get
    compute.snapshots.create
    compute.snapshots.useReadOnly
    compute.snapshots.delete
    compute.zones.get
    storage.objects.create
    storage.objects.delete
    storage.objects.get
    storage.objects.list
    iam.serviceAccounts.signBlob
)

echo "GCP CREATE IAM ROLE VELERO"

gcloud iam roles create velero.server \
    --project $PROJECT_ID \
    --title "Velero Server" \
    --permissions "$(IFS=","; echo "${VELERO_ROLE_PERMISSIONS[*]}")"

echo "GCP ASSIGN IAM ROLE TO SERVICE ACCOUNT VELERO"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$VELERO_SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/velero.server

echo "GCP ASSIGN IAM POLICY BINDING TO BUCKET VELERO"
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_VELERO \
            --member=serviceAccount:$VELERO_SERVICE_ACCOUNT_EMAIL \
            --role=roles/storage.objectAdmin

echo "GCP CREATE SERVICE ACCOUNT KEYS AND STORAGE THEM IN FILE credentials-velero"
gcloud iam service-accounts keys create credentials-velero \
    --iam-account $VELERO_SERVICE_ACCOUNT_EMAIL


echo "GCP CREATE BUCKET OBSERVABILITY"

gcloud storage buckets create gs://$BUCKET_OBSERVABILITY/ --project="$PROJECT_ID" --location eu

echo "GCP CREATE SERVICE_ACCOUNT OBSERVABILITY"

gcloud iam service-accounts create acmobservability --display-name "acm observability service account"

ACM_OBSERVABILITY_SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:acm observability service account" --format 'value(email)')

echo "GCP ASSIGN IAM POLICY BINDING TO BUCKET OBSERVABILITY"
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_OBSERVABILITY \
            --member=serviceAccount:$ACM_OBSERVABILITY_SERVICE_ACCOUNT_EMAIL \
            --role=roles/storage.objectCreator

gcloud storage buckets add-iam-policy-binding gs://$BUCKET_OBSERVABILITY \
            --member=serviceAccount:$ACM_OBSERVABILITY_SERVICE_ACCOUNT_EMAIL \
            --role=roles/storage.objectViewer

OBSERVABILITY_ROLE_PERMISSIONS=(
    storage.objects.create
    storage.objects.delete
    storage.objects.get
    storage.objects.list
    storage.buckets.list
)

echo "GCP CREATE IAM ROLE OBSERVABILITY"

gcloud iam roles create observability.server \
    --project $PROJECT_ID \
    --title "OBSERVABILITY" \
    --permissions "$(IFS=","; echo "${OBSERVABILITY_ROLE_PERMISSIONS[*]}")"

echo "GCP ASSIGN IAM ROLE TO SERVICE ACCOUNT OBSERVABILITY"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$ACM_OBSERVABILITY_SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/observability.server

echo "GCP CREATE SERVICE ACCOUNT KEYS AND STORAGE THEM IN FILE credentials-observability"
gcloud iam service-accounts keys create credentials-observability \
    --iam-account $ACM_OBSERVABILITY_SERVICE_ACCOUNT_EMAIL
