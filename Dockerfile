FROM fischerscode/flutter:3.22.2 AS build

WORKDIR /tmp

ADD pubspec.yaml /tmp

ADD analysis_options.yaml /tmp

ADD lib /tmp/lib

ADD web /tmp/web

ADD assets /tmp/assets

ADD shaders /tmp/shaders

RUN flutter pub get

RUN flutter build web --web-renderer=canvaskit

FROM nginx

COPY --from=build /tmp/build/web /usr/share/nginx/html

ADD default.conf /etc/nginx/conf.d/

