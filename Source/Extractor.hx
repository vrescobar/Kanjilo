package;
import haxe.io.Eof;
import String;
import haxe.Utf8;
import format.csv.*;

class Extractor {
// Japanese-style punctuation ( 3000 - 303f)
// Hiragana ( 3040 - 309f)
// Katakana ( 30a0 - 30ff)
// Full-width roman characters and half-width katakana ( ff00 - ffef)
// CJK unifed ideographs - Common and uncommon kanji ( 4e00 - 9faf)

    static public function kanji_frequencies(text:String):Array<Dynamic> {
        var all_kanji = new Map<Int,Int>();
        Utf8.iter(text, function (letter:Int) {
            if (iskanji(letter)) {
                if (all_kanji.exists(letter)) {
                    all_kanji[letter] += 1;
                }
                else all_kanji.set(letter, 1);
            }});
        // TODO: convert that to an iterator, work with io streams and use a decent sort
        return [for (kanji in all_kanji.keys()) {
            var u = new Utf8();
            u.addChar(kanji);
            [u.toString(), all_kanji[kanji]];
        }];
    }

    static inline function iskanji(num:Int):Bool {
        return num >= 0x4e00 && num <= 0x9faf;
    }
}
