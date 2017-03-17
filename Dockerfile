FROM hypriot/rpi-alpine

RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add python
RUN apk add py-setuptools
RUN apk add ca-certificates && \
if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi && \
if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi && \
if [[ ! -e /usr/bin/easy_install ]]; then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi && \
easy_install pip && \
pip install --upgrade pip && \
if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip2.7 /usr/bin/pip; fi && \
pip install paho-mqtt pydispatcher ConfigObj pyserial pytz && \
rm -rf /var/cache/apk/*

RUN mkdir /emonhub
#COPY emonhub /
VOLUME /emonhub

CMD ["/bin/bash"]
