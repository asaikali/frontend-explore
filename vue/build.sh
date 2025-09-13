docker build --platform linux/amd64 -t us-east4-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/my-vue-app:latest .
docker push us-east4-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/my-vue-app:latest
gcloud run deploy my-vue-service \
    --image us-east4-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/my-vue-app:latest \
    --platform managed \
    --region us-east4 \
    --allow-unauthenticated


docker tag boot-docker-cds:1 us-east4-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/boot-docker-cds:1
gcloud auth configure-docker us-east4-docker.pkg.dev --project=$GOOGLE_CLOUD_PROJECT

gcloud run deploy boot \
    --image us-east4-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/boot-docker-cds:1 \
    --platform managed \
    --region us-east4 \
    --allow-unauthenticated