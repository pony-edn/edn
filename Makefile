prefix ?= /usr/local
destdir ?= ${prefix}
config ?= release
arch ?=

BUILD_DIR ?= build/$(config)
SRC_DIR ?= edn
binary := $(BUILD_DIR)/edn
tests_binary := $(BUILD_DIR)/test

ifdef config
  ifeq (,$(filter $(config),debug release))
    $(error Unknown configuration "$(config)")
  endif
endif

ifeq ($(config),release)
	PONYC = ponyc
else
	PONYC = ponyc --debug
endif

ifneq ($(arch),)
  arch_arg := --cpu $(arch)
endif

$(tests_binary): $(GEN_FILES) $(SOURCE_FILES) $(TEST_FILES) | $(BUILD_DIR)
	${PONYC} $(arch_arg) --debug -o ${BUILD_DIR} $(SRC_DIR)/test

test: $(tests_binary)
	$^ --exclude=integration --sequential

clean:
	rm -rf build

all: test $(binary)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean test