# syntax = docker/dockerfile:experimental

FROM chrome-headless-stable

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
  && apt update -y \
  && apt install -y libxss-dev libxss1 fontconfig fonts-dejavu ttf-mscorefonts-installer curl gnupg git \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

USER node

ENV HOME=/home/node
ARG APP_HOME=/home/node/srv

RUN mkdir -p "$APP_HOME"
WORKDIR $APP_HOME

RUN git clone --depth 1 https://github.com/alvarcarto/url-to-pdf-api . \
  && npm install --only=production

HEALTHCHECK CMD curl -I http://localhost:9000/

EXPOSE 9000
CMD [ "node", "." ]
