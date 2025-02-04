FROM node:lts-alpine As build
COPY . /build
WORKDIR /build
COPY package*.json ./
RUN npm install
RUN npm run build

FROM nginx:1.27-alpine
LABEL org="qtdevops" author="venkat"
ARG USERNAME=venkat
RUN adduser -D -h /test -s /bin/sh ${USERNAME}
COPY --from=build --chown=${USERNAME}:${USERNAME} /build/test /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]