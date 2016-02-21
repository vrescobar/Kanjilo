SOURCE = Source
BUILD = out
KANJIDICT = Assets/kanjidic2.xml
KANJI_DUMPED = ${BUILD}/kanji_dumped.serialized

all: clean xmldump cmd web

web:
	haxe build_web.hxml
serve:
	cd $(BUILD)/web && python -m SimpleHTTPServer ; cd -

xmldump: ${KANJIDICT}
	haxe -cp ${SOURCE} -main KanjiDBStripper -neko $(BUILD)/xml-dumper.n
	neko ${BUILD}/xml-dumper.n ${KANJIDICT} ${KANJI_DUMPED}

cmd: ${KANJI_DUMPED}
	haxe -cp Source/ -main Kanjilo -cpp $(BUILD)/cmd-cpp/ -resource ${KANJI_DUMPED}@serialized_kanji_dict -resource Assets/disclaimer.txt@cc_disclaimer -dce full  --no-traces
	#haxe -cp Source/ -main Kanjilo -neko $(BUILD)/cmd-neko.n -resource ${KANJI_DUMPED}@serialized_kanji_dict -resource Assets/disclaimer.txt@cc_disclaimer -dce full
clean:
	rm -rf $(BUILD) && mkdir -p $(BUILD)
