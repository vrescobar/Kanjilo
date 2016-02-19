package ;

import hxdom.html.Text;
import hxdom.bootstrap.CloseButton;
import hxdom.bootstrap.Modal;
import hxdom.bootstrap.Panel;
import hxdom.bootstrap.Table;
import hxdom.Elements;

using hxdom.BSTools;
using hxdom.DomTools;


class MainJS {

	static var html:EHtml;
	static var modalGroup:ModalGroup;
	static var table:Table;
	static var exampleText:String = //"私は日本語の学生です";
		"エスペラント とは、ルドヴィコ・ザメンホフが考案した人工言語。母語の異なる人々の間での意思伝達を目的とする、いわゆる国際補助語としては最も世界的に認知され、普及の成果を収めた言語となっている。";
	static var ext:Extractor;

	static var default_vals:Array<Extractor.KanjiFreq> = [];
		/*[{freq: 1, kanji: "本", meaning: "book, present, main, origin, true, real, counter for long cylindrical things"},
		{freq: 1, kanji: "日", meaning: "day, sun, Japan, counter for days"},
		{freq: 1, kanji: "私", meaning: "private, I, me"},
		{freq: 1, kanji: "学", meaning: "study, learning, science"},
		{freq: 1, kanji: "語", meaning: "word, speech, language"},
		{freq: 1, kanji: "生", meaning: "life, genuine, birth"}];*/
	static function main () {
		ext = new Extractor();
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
		panel.append(populate_table(default_vals));

		var modalBtn = new EButton().button(Primary, Small).addText("Extract");
		modalBtn.addEventListener("click", onClick);

		var disclaimer = new EParagraph().setAttr("style", "color:#D0D0D0").addText(haxe.Resource.getString("cc_disclaimer"));

		cont.append(col1).append(modalBtn).append(panel).append(disclaimer);


		var body = new EBody();
		body.append(cont);

		html.append(body);
		trace("HTML completed");
	}
	@:client
	static public function onClick (_):Void {
		var parent = table.parent();
		table.remove(); // Fix: populate table recreates it again
		//TODO: Fix this untyped mess
		var inptxt:Dynamic = js.Browser.document.getElementById("user_input");
		var input_text:String = inptxt.value;
		trace("I got that text: " + input_text); //私は学生の日本語です！
		parent.append(populate_table(ext.freq_and_meanings(input_text)));

	}
	@:client
	static function populate_table(frequencies:Array<Extractor.KanjiFreq>):Table {
		var rows:Array<Array<Text>> = [[new Text("Freq#"), new Text("Kanji"), new Text("Meaning")]];
		for (kf in frequencies) rows.push([new Text(Std.string(kf.freq)), new Text(kf.kanji), new Text(kf.meaning)]);

		table = Table.build(rows, [Hover, Striped]);
		return table;
	}
}
