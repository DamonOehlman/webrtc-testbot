TEMPLATE_NAME ?= rtc-testbot

shell: image
	@docker run -a stdin -a stdout -i -t $(TEMPLATE_NAME) /bin/bash

image:
	@docker build -t $(TEMPLATE_NAME) .

