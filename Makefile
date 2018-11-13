build/edn: build edn/*.pony
	ponyc edn -o build --debug

build:
	mkdir build

test: build/edn
	build/edn

clean:
	rm -rf build

.PHONY: clean test