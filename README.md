# smx-cc-app

Dockerfile description of Carbon Co-op SMX app.

To build the app:

docker build -t [[/HUB:]/USER:]smx-cc-app ./
docker run -v $PWD/emonhub:/emonhub -it /emonhub/src/emonhub.py --config-file=/emonhub/conf/interfacer_examples/smx/smx.emonhub.conf
