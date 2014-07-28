TEMPLATE_NAME ?= rtc-testbot
CHROME_VERSION ?= stable

run: image
	@docker run -d -p 0.0.0.0:80:80 -t $(TEMPLATE_NAME)

shell: image
	@docker run -e CHROME_VERSION=$(CHROME_VERSION) -p 0.0.0.0:80:80 -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

image:
	@docker build -t $(TEMPLATE_NAME) .

server: xvfb node_modules nginx
	sudo -u testbot npm start

node_modules:
	npm install --no-spin

xvfb:
	/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16

nginx:
	nginx -s stop || echo "nginx not running, no need to stop"
	nginx -c `pwd`/nginx.conf
