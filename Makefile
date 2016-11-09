NUKE=rm -rf
OUT=index.html

help:
	@cat Makefile

build:
	elm make --warn src/Main.elm --output=$(OUT)

clean:
	$(NUKE) elm-stuff/build-artifacts $(OUT)

open:
	open index.html

b: build
o: open
