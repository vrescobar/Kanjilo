package ;
import haxe.Unserializer;
import haxe.io.Path;

class Kanjilo {
    static var help:String;
    static var license:String = "";
    static var meanings:Map<String,Array<String>>;

    static function main() {
        var bytes = haxe.Resource.getBytes("serialized_kanji_dict");
        var uncomp:haxe.io.Bytes = haxe.zip.Uncompress.run(bytes,1024);
        var unserializer = new Unserializer(uncomp.getString(0,uncomp.length));
        meanings = unserializer.unserialize();
        help = 'usage: echo "私は日本語の学生です" | ${Path.withoutDirectory(Sys.executablePath())}';
        if (Sys.args().length > 0) {
            Sys.println(help + "\n");
            Sys.println("The software which conforms the program is distributed under the terms and conditions of the MIT license.\n");
            Sys.println(haxe.Resource.getString("cc_disclaimer"));
            Sys.exit(0);
        }
        var stdin  = Sys.stdin();
        var input:String = stdin.readAll(1).toString();

        if (input.length == 0) {
            Sys.println(help);
            Sys.exit(-1);
        }
        for (freq in Extractor.kanji_frequencies (input)) {
            Sys.println('"${freq[1]}";"${freq[0]}";"${meanings.get(freq[0])}";');
        }
        Sys.exit(0);
    }
}
