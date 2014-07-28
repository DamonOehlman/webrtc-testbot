TEMPLATE_NAME ?= rtc-testbot
CHROME_VERSION ?= stable

run: image
	@docker run -d -t $(TEMPLATE_NAME)

shell: image
	@docker run -e CHROME_VERSION=$(CHROME_VERSION) -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

image:
	@docker build -t $(TEMPLATE_NAME) .

server: xvfb node_modules
	npm start

node_modules:
	npm install --no-spin

xvfb:
	/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16
