FROM node:6-slim
LABEL maintainer="milan.cecrdle@gmail.com"
WORKDIR /tmp
COPY .bowerrc webdriver-versions.js ./
ENV CHROME_PACKAGE="google-chrome-stable_61.0.3163.91-1_amd64.deb" NODE_PATH=/usr/local/lib/node_modules:/protractor/node_modules
RUN npm install -g protractor@5.3.2 minimist@1.2.0 && \
    node ./webdriver-versions.js --chromedriver 2.38 && \
    webdriver-manager update --versions.chrome 2.38 && \
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y xvfb wget sudo && \
    wget https://github.com/webnicer/chrome-downloads/raw/master/x64.deb/${CHROME_PACKAGE} && \
    dpkg --unpack ${CHROME_PACKAGE} && \
    apt-get install -f -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    rm ${CHROME_PACKAGE} && \
    mkdir /protractor
COPY protractor.sh /
COPY environment /etc/sudoers.d/
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null SCREEN_RES=1280x1024x24
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
