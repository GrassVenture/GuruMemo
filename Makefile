
.PHONY: setup
setup:
	brew tap leoafarias/fvm
	brew install fvm
	fvm install --setup
	$(MAKE) run-build-runner

.PHONY: clean
clean:
	fvm flutter clean
	fvm flutter pub get

.PHONY: run-build-runner
run-build-runner:
	fvm dart run build_runner build -d

.PHONY: watch-build-runner
watch-build-runner:
	fvm dart run build_runner watch -d

.PHONY: fix
fix:
	fvm dart fix --apply
