package ;

import hxdom.html.Text;
import hxdom.bootstrap.CloseButton;
import hxdom.bootstrap.Modal;
import hxdom.bootstrap.Panel;
import hxdom.bootstrap.Table;
import hxdom.Elements;
import haxe.Unserializer;

using hxdom.BSTools;
using hxdom.DomTools;


typedef KanjiFreq = {
	var freq:Int;
	var kanji:String;
	var meaning:String;
			};

class Main {

	static var html:EHtml;
	static var modalGroup:ModalGroup;
	static var table:Table;
	static var exampleText:String = "エスペラント とは、ルドヴィコ・ザメンホフが考案した人工言語。母語の異なる人々の間での意思伝達を目的とする、いわゆる国際補助語としては最も世界的に認知され、普及の成果を収めた言語となっている。";
	static var meanings:Map<String,Array<String>>;
	/*static var vals:Array<KanjiFreq> =
		[{freq: 100, kanji:"案", meaning:"plan, suggestion, draft, ponder, fear, proposition, idea, expectation, worry, table, bench"},
		{freq:24, kanji:"言", meaning: "say, word"},
		{freq:24, kanji:"語", meaning:"word, speech, language"}];*/


	static function main () {
#if js
		trace("Uncompressing dictionary");
		var bytes = haxe.Resource.getBytes("serialized_kanji_dict");
		var uncomp:haxe.io.Bytes = haxe.zip.Uncompress.run(bytes,1024);
		var unserializer = new Unserializer(uncomp.getString(0,uncomp.length));
		meanings = unserializer.unserialize();
		trace("Booting HTML");
		html = cast hxdom.js.Boot.init();
		modalGroup = new ModalGroup();
		html.node.childNodes[1].vnode().append(modalGroup);

		var cont = new EDiv().container();
		cont.append(new EUnorderedList().breadcrumbs().append(new EListItem().addText("Kanji Extractor")));
		var inptxt:ETextArea = new ETextArea().setAttr("id","user_input").setAttr("style", "width:100%").setAttr("class", "form-control").setAttr("rows", "3").addText(exampleText);

		var col1 = new EDiv().append(new EHeader1().setText("Find all kanjis"))
		.append(new EParagraph().textAlign(Right).lead().addText("Learn kanjis lazily: study the meaning of kanji as soon as you find them in a text, but not before."))
		.append(new EParagraph().addText("Are you a Heisig's RTK fan but cannot stick to it? Be lazy: apply Heisig's method for memorizing by associations as you learn, but do it incrementaly only with the materials which you are about to use."))
		.append(inptxt);


		var panel = new Panel(Primary);
		panel.body.append(new EParagraph().addText("List of kanji found, ordered by increasing complexity/frequency in text"));
		panel.append(populate_table([]));

		var modalBtn = new EButton().button(Primary, Small).addText("Extract");

		cont.append(col1).append(panel);
		col1.append(modalBtn);
		modalBtn.addEventListener("click", onClick);

		var body = new EBody();
		body.append(cont);
		html.append(body);
		trace("HTML completed");
#else
		var body = new EBody();
		html = new EHtml();
		html.setAttr("lang", "en");
		var head = new EHead();
		head.append(new EMeta().setAttr("charset", "utf-8"));
		head.append(new ELink().setAttr("rel", "stylesheet").setAttr("href", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"));
		head.append(new ELink().setAttr("rel", "stylesheet").setAttr("href", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"));
		head.append(new EScript().addText("HTMLDetailsElement = HTMLElement;"));
		head.append(new EScript().setAttr("src", "http://code.jquery.com/jquery-1.12.0.min.js").setAttr("defer", true));
		head.append(new EScript().setAttr("src", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js").setAttr("defer", true));
		head.append(new EScript().setAttr("src", "eventtarget.js").setAttr("defer", true));
		head.append(new EScript().setAttr("src", "client.js").setAttr("defer", true));
		html.append(head).append(body);
		Sys.println(hxdom.HtmlSerializer.run(html));
#end
	}
#if js
	@:client
	static public function onClick (_):Void {
		var parent = table.parent();
		try {
			table.remove();
		} catch(e:Dynamic) {};
		//TODO: Fix this untyped mess
		var inptxt:Dynamic = js.Browser.document.getElementById("user_input");
		var input_text:String = inptxt.value;
		trace("I got that: ", input_text);
		//私は学生の日本語です！
		var found_freqs:Array<KanjiFreq> = [ for (freq in Extractor.kanji_frequencies(input_text)) {
													{ freq: freq[1],
													  kanji: freq[0],
													  meaning: meanings.get(freq[0]).join(", ") }}];
		parent.append(populate_table(found_freqs));

	}
	@:client
	static function populate_table(frequencies:Array<KanjiFreq>):Table {
		var rows:Array<Array<Text>> = [[new Text("Freq#"), new Text("Kanji"), new Text("Meaning")]];
		for (kf in frequencies) rows.push([new Text(Std.string(kf.freq)), new Text(kf.kanji), new Text(kf.meaning)]);

		table = Table.build(rows, [Hover, Striped]);
		return table;
	}
#end
}
