# --- minimal CMake wrapper (Unix Makefiles) ---
BUILD_DIR ?= build
BT        ?= Debug      # Debug | RelWithDebInfo | Release

# auto-detect if viz/tests are actually present
HAS_VIEW   := $(and $(wildcard apps/solarsim_viewer.cpp),$(wildcard src/viz/renderer_opengl.cpp))
HAS_TESTS  := $(wildcard tests/CMakeLists.txt)

VIZ   ?= $(if $(HAS_VIEW),ON,OFF)
TESTS ?= $(if $(HAS_TESTS),ON,OFF)

.PHONY: configure build reconfigure run viewer test clean distclean help

configure:
	@cmake -S . -B $(BUILD_DIR) -G "Unix Makefiles" \
	  -DCMAKE_BUILD_TYPE=$(BT) \
	  -DSOLAR_WITH_VIZ=$(VIZ) \
	  -DSOLAR_WITH_TESTS=$(TESTS)

build:
	@$(MAKE) -C $(BUILD_DIR) || ( $(MAKE) configure && $(MAKE) -C $(BUILD_DIR) )

reconfigure:
	@cmake -S . -B $(BUILD_DIR) -G "Unix Makefiles" \
	  -DCMAKE_BUILD_TYPE=$(BT) \
	  -DSOLAR_WITH_VIZ=$(VIZ) \
	  -DSOLAR_WITH_TESTS=$(TESTS)

cli: build
	@if [ -x "$(BUILD_DIR)/solarsim_cli" ]; then \
	  "$(BUILD_DIR)/solarsim_cli"; \
	else \
	  echo "Missing binary: $(BUILD_DIR)/apps/solarsim_cli"; exit 1; \
	fi

viz: build
	@if [ "$(VIZ)" != "ON" ]; then echo "VIZ=OFF (no viewer sources detected)"; exit 1; fi
	@if [ -x "$(BUILD_DIR)/solarsim_viewer" ]; then \
	  "$(BUILD_DIR)/solarsim_viewer"; \
	else \
	  echo "Missing binary: $(BUILD_DIR)/apps/solarsim_viewer"; exit 1; \
	fi

test: build
	@if [ "$(TESTS)" != "ON" ]; then echo "Tests disabled (no tests/CMakeLists.txt)"; exit 1; fi
	@ctest --test-dir $(BUILD_DIR) --output-on-failure

clean:
	@$(MAKE) -C $(BUILD_DIR) clean || true

distclean:
	@rm -rf "$(BUILD_DIR)"

help:
	@echo "make build            # configure + build"
	@echo "make run              # run CLI (apps/solarsim_cli.cpp must exist)"
	@echo "make viewer           # run viewer (auto OFF unless viewer sources exist)"
	@echo "make test             # run ctest (auto OFF unless tests/CMakeLists.txt exists)"
	@echo "make clean | distclean"
	@echo "Variables: BT=Debug|RelWithDebInfo|Release"
