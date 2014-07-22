TEMPLATE_NAME ?= rtc-testbot

shell: build
	@docker run -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

build:
	@docker build -t $(TEMPLATE_NAME) .

