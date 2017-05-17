FROM hypriot/rpi-alpine

RUN apk update && \
apk upgrade && \
#apk add bash && \
#apk add nano && \
apk add openssl && \
apk add python && \
apk add py-setuptools && \
apk add ca-certificates && \
if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi && \
if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi && \
if [[ ! -e /usr/bin/easy_install ]]; then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi && \
apk add py-pip && \
apk add ca-certificates 

RUN mkdir emonhub
COPY emonhub /
RUN cd /emonhub
WORKDIR /emonhub

RUN yes | pip install --noinput -vvv --upgrade pip 
RUN if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip2.7 /usr/bin/pip; fi && \
yes | pip install paho-mqtt pydispatcher ConfigObj pyserial pytz && \
rm -rf /var/cache/apk/*

#RUN mkdir /emonhub
#COPY emonhub /
#VOLUME /emonhub

#ENTRYPOINT ["python","/emonhub/src/emonhub.py"]
CMD ["ls","/emonhub"]
