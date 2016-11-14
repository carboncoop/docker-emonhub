FROM hypriot/rpi-alpine-scratch

RUN apk update && \
apk upgrade && \
apk add bash && \
apk add python3 && \
pip3 install paho-mqtt requests && \
rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
