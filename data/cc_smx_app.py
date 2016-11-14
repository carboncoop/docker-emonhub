emoncms_host = "https://emoncms.org"
emoncms_apikey = "b662573e0eaacd51d83e798fe7a41963"

mqtt_topic = ""

import os, fcntl,sys 
import time, math, json 
import paho.mqtt.client as mqtt 
import requests

t = 0
packet = {}

def send_post(post_url, data=None):

    headers = {"Authorization":"Bearer %s"%emoncms_apikey}
    
    r=requests.post(emoncms_host,data=data,headers=headers).json()

    try:
        r.raise_for_status()
    except:
    	print(r.error)
    else:
        reply = r.content
    finally:
        return reply

# ------------------------------------------------------------------------------
def on_message(client, userdata, msg):
    # globals...
    global emoncms_host, emoncms_apikey, t, packet
   
    # Messages are received on a per variable basis
    # sending each variable in its own http request to emoncms
    # would result in a large number of http requests
    # So we group variables up acording to the time received
    # to the nearest second in order to reduce the number of
    # requests send to emoncms
   
    last_t = t
    t = int(math.floor(time.time()))
   
    # Topic clean up
    topic = msg.topic
    topic = topic.replace(mqtt_topic,"") # remove emon/
    topic = topic.replace("/","_")       # replace / with _
    topic = topic.replace(" ","")        # remove spaces
   
    # place in packet object
    packet[topic] = msg.payload
   
    # Data is assembled first into bulk packets
    # in order to reduce the number of http calls
    if last_t!=t and last_t!=0:
        print("SENDING: time="+str(t)+"&data="+json.dumps(packet))
        post_body = "time="+str(t)+"&data="+json.dumps(packet)
        reply = send_post(emoncms_host+"/input/post.json?apikey="+emoncms_apikey, post_body)
        print(reply)
        packet = {}
       
       
# ------------------------------------------------------------------------------

def on_connect(client, userdata, flags, rc):
    mqttc.subscribe(mqtt_topic+"#")

if __name__ == "__main__":
	mqttc = mqtt.Client()
	mqttc.on_connect = on_connect
	mqttc.on_message = on_message
	mqttc.connect("10.10.10.62",1883,60)
	mqttc.loop_start()

	while True:
    		time.sleep(1.0)


