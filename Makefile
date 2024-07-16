SHELL:=/usr/bin/env bash

FASTLANE ?= bundle exec fastlane
SECRETS_DIR ?= ../art-at-gvsu-secrets/ios
PIP ?= pip3

secrets:
	cp -v $(SECRETS_DIR)/ArtAtGVSU/GoogleService-Info.plist ./ArtAtGVSU/GoogleService-Info.plist
	cp -v $(SECRETS_DIR)/ArtAtGVSU/Secrets.plist ./ArtAtGVSU/Secrets.plist

.PHONY: ci-test ci-secrets deploy-beta deploy-production deps py-deps secrets bootstrap

deps: py-deps
	bundle install

py-deps:
	$(PIP) install bumpver==2023.1125
	$(PIP) install pre-commit==3.6.2

bootstrap: deps
	pre-commit install

.PHONY: changelog
changelog:
	./scripts/changelog

.PHONY: bump-version
bump-version:
	bumpver update --commit-message '[skip ci] bump version {old_version} -> {new_version}'

ci-test: ci-secrets
	$(FASTLANE) test

deploy-beta: ci-secrets
	$(FASTLANE) beta

deploy-production: ci-secrets
	$(FASTLANE) production

.SILENT:
ci-secrets:
	echo ${ENCODED_APP_STORE_CONNECT_API_KEY} | base64 --decode > ./app_store_connect_api_key.json
	echo ${ENCODED_GOOGLE_SERVICE_INFO_PLIST} | base64 --decode > ./ArtAtGVSU/GoogleService-Info.plist
	echo ${ENCODED_SECRETS_PLIST} | base64 --decode > ./ArtAtGVSU/Secrets.plist
