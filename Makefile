SOURCE = Source
BUILD = out
KANJIDICT = Assets/kanjidic2.xml
KANJI_DUMPED = ${BUILD}/kanji_dumped.serialized

# Note that hxdom-bootstrap is my patched version: https://github.com/vrescobar/haxe-dom-bootstrap

all: clean xmldump cmd web

web:
	mkdir -p $(BUILD)/web/
	haxe -cp ${SOURCE} -lib hxdom -lib hxdom-bootstrap -js $(BUILD)/web/client.js -main Main -D js-flatten -dce full
	haxe -cp ${SOURCE} -lib hxdom -lib hxdom-bootstrap -neko $(BUILD)/web_gen.n -main Main
	neko $(BUILD)/web_gen.n > $(BUILD)/web/index.html
serve:
	cd $(BUILD)/web && python -m SimpleHTTPServer ; cd -

xmldump: ${KANJIDICT}
	haxe -cp ${SOURCE} -main KanjiDB -neko $(BUILD)/xml-test.n -dce full
	neko ${BUILD}/xml-test.n ${KANJIDICT} ${KANJI_DUMPED}

cmd: ${KANJI_DUMPED}
	haxe -cp Source/ -main Kanjilo -cpp $(BUILD)/cmd-cpp/ -resource ${KANJI_DUMPED}@serialized_kanji_dict -resource disclaimer.txt@cc_disclaimer -dce full

clean:
	rm -rf $(BUILD) && mkdir -p $(BUILD)
