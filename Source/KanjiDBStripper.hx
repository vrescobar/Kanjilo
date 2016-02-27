/**
 *   Copyright (c) Victor R. Escobar. All rights reserved.
 *   The use and distribution terms for this software are covered by the
 *   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
 *   which can be found in the file epl-v10.html at the root of this distribution.
 *   By using this software in any fashion, you are agreeing to be bound by
 * 	 the terms of this license.
 *   You must not remove this notice, or any other, from this software.
 **/
package ;

import sys.FileSystem;
import Xml;
import haxe.xml.Fast;
import haxe.Serializer;
import haxe.io.Bytes;

class KanjiDBStripper {
    public static function main() {
        if (Sys.args().length < 2 || FileSystem.exists(Sys.args()[1]) || !FileSystem.exists(Sys.args()[0])) {
            Sys.stderr().writeString("Usage error: kanjiDB original.xml output_dumped.kanjis\n");
            Sys.exit(1);
        }
        var dumper = new KanjiDB_dump(Sys.args()[0]);
        dumper.SerializeTo(Sys.args()[1]);
    }
}

class KanjiDB_dump {
    private var xml_contents:String;
    public function new(filepath:String) {
        // http://www.csse.monash.edu.au/~jwb/kanjidic2/index.html
        xml_contents = sys.io.File.getContent(filepath);
    }
    public function SerializeTo(output:String) {
        var total:Int = 0;
        var total_meanings:Int = 0;
        var kanjis:Map<String, Array<String>> = new Map();

        var elements:Xml = Xml.parse(xml_contents).elements().next();
        for( character in elements.elementsNamed("character") ) {
            total ++;
            var char = new Fast(character);
            var literal:String = char.node.literal.innerData;
            var meaning:Array<String> = try [for (element in char.node.reading_meaning.node.rmgroup.elements) if (element.name == "meaning") if (!element.has.m_lang)element.innerData]
                catch (msg : String) [];
            if (meaning.length > 0) {
                total_meanings ++;
            }
            kanjis.set(literal, meaning);

        }
        trace("Total Kanji: " + total);
        trace("Total Meanings: " + total_meanings);
        var serializer = new Serializer();
        serializer.serialize(kanjis);
        var b = Bytes.ofString(serializer.toString());
        sys.io.File.saveBytes(output, haxe.zip.Compress.run(b,9));
    }
}
