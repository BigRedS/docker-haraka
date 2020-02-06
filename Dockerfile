FROM node:6

ENV HARAKA_VERSION 2.8.16
ENV HARAKA_HOME /app
ENV HARAKA_DATA /data
ENV PATH /usr/local/bin:$HARAKA_HOME/node_modules/.bin:$PATH

# node-gyp emits lots of warnings if HOME is set to /
ENV HOME /tmp
RUN npm install -g "Haraka"
RUN haraka --install "$HARAKA_HOME"

COPY app/package.json /app/package.json
WORKDIR /app
RUN npm install

COPY app /app

RUN mkdir -p "$HARAKA_HOME" && \
    mkdir -p "$HARAKA_DATA"

ENV HOME "$HARAKA_HOME"

EXPOSE 2525

RUN useradd -d "$HARAKA_HOME" -s /bin/bash haraka
RUN chown -R haraka "$HARAKA_HOME"
RUN chown -R haraka "$HARAKA_DATA"
RUN ln -s /mnt/secrets/config/smtp-proxy-ini /app/config/smtp-proxy.ini

USER haraka

CMD ["haraka", "-c", "/app"]
