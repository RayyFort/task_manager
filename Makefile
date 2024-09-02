# Makefile for deploying the Flutter web projects to GitHub

BASE_HREF = /$(OUTPUT)/
# Replace this with your GitHub username
GITHUB_USER = rayyfort
GITHUB_REPO = https://github.com/$(GITHUB_USER)/$(OUTPUT)
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

# Deploy the Flutter web project to GitHub
deploy:
ifndef OUTPUT
 	$(error OUTPUT is not set. Usage: make deploy OUTPUT=<output_repo_name>)
endif

	flutter clean

	flutter pub get

	flutter create . --platform web

	flutter build web --base-href $(BASE_HREF) --release

	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u -f origin main 

	$(info "success")

.PHONY: deploy
