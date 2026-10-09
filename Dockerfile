FROM nginx:alpine

COPY manifest.json popup.html popup.css popup.js /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
