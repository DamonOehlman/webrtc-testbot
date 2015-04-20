# testbot

This is a `Dockerfile` and supporting node application that make it simple(ish) to create a run a headless testing instance of chrome that attempts to interact with other WebRTC browser instance that are powered by rtc.io modules.  Test bot uses [rtc-quickconnect](https://github.com/rtc-io/rtc-quickconnect) to establish a connection with a remote peer.

## Running testbot

Before you will be able to run testbot, you will need to have [docker](https://www.docker.com/) installed on your machine.  If you haven't then go do that first.  Additionally, this process have been optimized for working in a *nix environment and uses a `Makefile` to pass through some of the options to docker when running the container.

To run testbot, first clone this repo:

```
git clone https://github.com/rtc-io/testbot.git
```

Then you need to use docker to make the container, which is done most easily by simply running `make`:

```
cd testbot
make
```

Once this process is completed, you will have a docker container running which you should be able to see by running `docker ps`.  This container has exposed port `6633` and also directed traffic from your local machine (on port `6633` to the container).  So in theory you should now be able to run open the following page in your browser:

<http://localhost:6633/examples/main.html>

If that has worked, let's now proceed to provide this page some additional querystring arguments:

<http://localhost:6633/examples/main.html?room=roomname&video=true&iceServers=stun%3Astun1.l.google.com%3A19302&iceServers=stun%3Astun2.l.google.com%3A19302>

By providing this additional arguments we are telling testbot that we want to capture video, and add it to any peer connections it establishes with peers that join room "roomname".

On that page, now open the developer console and you should see the following output:

```
connecting to signaller
```

This tells you that you local browser has connected to the signaller, so now let's tell testbot to fire up a headless chrome instance to connect to the same room.  We do this by issuing a `PUT` request to the `/bot/:id` endpoint to the same webserver that hosts the page we just loaded.  It is expecting a JSON payload, so let's provide it the following by way of a `curl` command:

```sh
curl --include \
     --request PUT \
     --header "Content-Type: application/json" \
     --data-binary '{
    "room": "roomname",
    "video": true,
    "channels": [ "a", "b" ],
    "iceServers": [
        "stun:stun1.l.google.com:19302",
        "stun:stun2.l.google.com:19302"
    ]
}' http://localhost:6633/bot/4eeaf205-29e6-44cf-88dc-3bc8550e16ce
```

After a period of time, you should see some additional output rendered in the developer console of your previously opened browser window.  Something like the following:

```
call started with peer: 8b77bace-5180-484c-98c1-e8cb940e6d06
remote stream count: 1
```

If you see this then that is awesome, because it means that a connection has been estaliblished between your local browser instance and the headless chrome browser that is running inside the docker container.

To terminate the headless chrome instance, we need to send testbot a `DELETE` request at the same `/bot:id` endpoint:

```
curl --request DELETE http://localhost:6633/bot/4eeaf205-29e6-44cf-88dc-3bc8550e16ce
```

Again, after a short period of time (plus the time it takes for the connection to timeout) you should see a message similar to the following appear in the developer console:

```
call ended with peer: 8b77bace-5180-484c-98c1-e8cb940e6d06
```

## Questions / Issues

If you have any questions or issues with regards to testbot, please feel free to register an issue in this repository.

## License(s)

ISC
