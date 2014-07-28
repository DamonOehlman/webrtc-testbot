TEMPLATE_NAME ?= rtc-testbot
CHROME_VERSION ?= stable

run: image
	@docker run -d -p 0.0.0.0:3000:3000 -t $(TEMPLATE_NAME)

shell: image
	@docker run -e CHROME_VERSION=$(CHROME_VERSION) -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

image:
	@docker build -t $(TEMPLATE_NAME) .

server: node_modules
	./node_modules/.bin/forever server.js

node_modules:
	npm install --no-spin
