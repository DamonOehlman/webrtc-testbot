TEMPLATE_NAME ?= rtc-testbot
CHROME_VERSION ?= stable

shell: image
	@docker run -e CHROME_VERSION=$(CHROME_VERSION) -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

image:
	@docker build -t $(TEMPLATE_NAME) .
