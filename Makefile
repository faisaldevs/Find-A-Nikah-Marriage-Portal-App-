# Usage: make build-apk ENV=prod   (ENV = dev | staging | prod, default prod)
ENV ?= prod
ARGS = -t lib/flavors/main_$(ENV).dart --dart-define-from-file=lib/flavors/env/$(ENV).json

.PHONY: run build-apk build-aab build-ios

run:
	flutter run $(ARGS)

build-apk:
	flutter build apk --release $(ARGS)

build-aab:
	flutter build appbundle --release $(ARGS)

build-ios:
	flutter build ipa --release $(ARGS)
