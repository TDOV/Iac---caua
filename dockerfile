FROM nginx:latest

COPY ./index.html /usr/share/nginx/html/index.html
COPY ./about.html /usr/share/nginx/html/about.html
COPY ./lorenzo.html /usr/share/nginx/html/lorenzo.html
COPY ./heitor.html /usr/share/nginx/html/heitor.html
COPY ./style.css /usr/share/nginx/html/style.css

EXPOSE 80

CMD ["nginx", "-g", "daemon off,"]