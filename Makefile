
JS_SOURCE_DIR = app/javascripts
JS_APP_DIR = $(JS_SOURCE_DIR)/app
JS_LIBS_DIR = $(JS_SOURCE_DIR)/libs
JS_OUTPUT_DIR = public/javascripts

help:
	@echo ""
	@echo "USAGE: make <target>"
	@echo "libs             Concatenates the external libraries into a libs.js file"
	@echo "app              Concatenates the application .js files into a app.js file"
	@echo "docs             Generates the documentation for the concatenated .js files"
	@echo "commit           Run this before committing changes for sweetness"
	@echo "-------------------------------------------------------------------------------"
	@echo "In development mode run the following to generate js, css, specs on the fly:"
	@echo "watchn .watchn"
	@echo "This assumes node.js is installed and you've run 'npm install watchn -g'"
	@echo ""

libs:
	cat $(JS_LIBS_DIR)/jquery-1.6.2.js > $(JS_OUTPUT_DIR)/libs.js
	cat $(JS_LIBS_DIR)/underscore.js >> $(JS_OUTPUT_DIR)/libs.js
	cat $(JS_LIBS_DIR)/backbone.js >> $(JS_OUTPUT_DIR)/libs.js

app:
	cat $(JS_APP_DIR)/config/namespace.js > $(JS_OUTPUT_DIR)/app.js
	cat $(JS_APP_DIR)/views/document_view.js >> $(JS_OUTPUT_DIR)/app.js
	cat $(JS_APP_DIR)/views/navigation_view.js >> $(JS_OUTPUT_DIR)/app.js
	cat $(JS_APP_DIR)/views/section_view.js >> $(JS_OUTPUT_DIR)/app.js
	cat $(JS_APP_DIR)/config/routes.js >> $(JS_OUTPUT_DIR)/app.js

.PHONY: help libs app

