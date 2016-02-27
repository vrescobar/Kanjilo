/**
 *   Copyright (c) Victor R. Escobar. All rights reserved.
 *   The use and distribution terms for this software are covered by the
 *   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
 *   which can be found in the file epl-v10.html at the root of this distribution.
 *   By using this software in any fashion, you are agreeing to be bound by
 * 	 the terms of this license.
 *   You must not remove this notice, or any other, from this software.
 **/
package;

import String;
import haxe.Utf8;
import haxe.io.Eof;
import haxe.Unserializer;
import format.csv.*;

typedef KanjiFreq = {
	var freq:Int;
	var kanji:String;
	var meaning:String;
			};

class Extractor {
    static var meanings:Map<String,Array<String>>;
    public function new() {
        trace("Uncompressing kanji dictionary...");
        var bytes = haxe.Resource.getBytes("serialized_kanji_dict");
        var uncomp:haxe.io.Bytes = haxe.zip.Uncompress.run(bytes,1024);
        var unserializer = new Unserializer(uncomp.getString(0,uncomp.length));
        meanings = unserializer.unserialize();
        trace("Dictionary initialized");
    }
	inline function getMeaning(element:String):Array<String> {
		// TODO test: kanjis w/o meaning (utf8/kanji): (35821, 语) (31925,粵)
		return if (meanings.exists(element)) meanings.get(element) else [];
	}
    public function freq_and_meanings(text:String):Array<KanjiFreq> {
        var all_kanji = new Map<Int,Int>();

        // TODO: convert that to an iterator, work with io streams and use a decent sort
        Utf8.iter(text, function (letter:Int) {
            if (iskanji(letter)) {
                if (all_kanji.exists(letter)) {
                    all_kanji[letter] += 1;
                }
                else all_kanji.set(letter, 1);
            }});

        var arr = [for (kanji in all_kanji.keys())
                                {
                                    freq:    all_kanji[kanji],
                                    kanji:   utfInt2string(kanji),
                                    meaning: getMeaning(utfInt2string(kanji)).join(", ")
                                }
                            ];
        arr.sort( function(old:KanjiFreq, nnew:KanjiFreq):Int {
                return nnew.freq - old.freq;
            });
        return arr;
    }
    static inline function utfInt2string(inp_Int:Int):String {
        var u = new Utf8();
        u.addChar(inp_Int);
        return u.toString();
    }
    static inline function iskanji(num:Int):Bool {
        // Japanese-style punctuation ( 3000 - 303f)
        // Hiragana ( 3040 - 309f)
        // Katakana ( 30a0 - 30ff)
        // Full-width roman characters and half-width katakana ( ff00 - ffef)
        // CJK unifed ideographs - Common and uncommon kanji ( 4e00 - 9faf)
        return num >= 0x4e00 && num <= 0x9faf;
    }
}
