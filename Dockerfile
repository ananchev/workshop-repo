FROM public.ecr.aws/nginx/nginx:latest 
LABEL maintainer="DevOpsWorkshop"
COPY index.html AWS_logo.png /usr/share/nginx/html/
