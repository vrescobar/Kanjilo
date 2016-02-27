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
import haxe.io.Path;

class Kanjilo {
    static var help:String;
    static var license:String = "";

    static function main() {

        help = 'usage: echo "私は日本語の学生です" | ${Path.withoutDirectory(Sys.executablePath())}';
        if (Sys.args().length > 0) {
            Sys.println(help + "\n");
            Sys.println("The software which conforms the program is distributed under the terms and conditions of the MIT license.\n");
            Sys.println("DISCLAIMER\n");
            Sys.println(haxe.Resource.getString("cc_disclaimer"));
            Sys.exit(0);
        }
        var stdin  = Sys.stdin();
        var input:String = stdin.readAll(1).toString();

        if (input.length == 0) {
            Sys.println(help);
            Sys.exit(-1);
        }
        var ext = new Extractor();
        for (freq in ext.freq_and_meanings(input))
            Sys.println('"${freq.freq}";"${freq.kanji}";"${freq.meaning}";');

        Sys.exit(0);
    }
}
