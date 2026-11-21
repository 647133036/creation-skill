PYTHON315 ?= /opt/python3.15/bin/python3

PKGS := ffmpeg-skill gif-factory cinecode claude-animated-shorts rea-video craft-anything unlose

CHECK_TARGETS := $(PKGS:%=check-%)
BUILD_TARGETS := $(PKGS:%=build-%)

help:
	@echo "make check          - verify every package (build + smoke/test)"
	@echo "make build          - build every package"
	@echo "make check-<pkg>    - verify one package (e.g. make check-ffmpeg-skill)"
	@echo "make build-<pkg>    - build one package"

check: $(CHECK_TARGETS)
	@echo "All package checks finished."

build: $(BUILD_TARGETS)
	@echo "All package builds finished."

# Static pattern rules: naming the goals in .PHONY as expanded names makes
# plain pattern rules "Nothing to be done" on GNU make 4.3, so each target
# is bound explicitly here instead.
$(CHECK_TARGETS): check-%:
	@bash tools/check-package.sh "$*" "$(PYTHON315)"

$(BUILD_TARGETS): build-%:
	@bash tools/build-package.sh "$*" "$(PYTHON315)"

.PHONY: help check build $(CHECK_TARGETS) $(BUILD_TARGETS)
