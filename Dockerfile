FROM node:lts-alpine as build
COPY . /build
WORKDIR /build
COPY package*.json ./
COPY . .
RUN npm install
RUN npm run build

FROM nginx:1.27-alpine
LABEL org="qtdevops" author="venkat"
ARG USERNAME=venkat
RUN adduser -D -h /build -s /bin/sh ${USERNAME}
COPY --from=build --chown=${USERNAME}:${USERNAME} /build/dist /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]