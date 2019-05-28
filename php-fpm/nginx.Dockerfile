FROM nginx:1.15.12

EXPOSE 80
ADD /code /code
ADD /site.conf /etc/nginx/conf.d/default.conf
