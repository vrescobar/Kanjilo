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
