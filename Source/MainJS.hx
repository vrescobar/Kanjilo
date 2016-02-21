package ;

import hxdom.html.Text;
import hxdom.bootstrap.CloseButton;
import hxdom.bootstrap.Modal;
import hxdom.bootstrap.Panel;
import hxdom.bootstrap.Table;
import hxdom.Elements;

import hxdom.html.MutationObserver;
import hxdom.html.MutationRecord;

using hxdom.BSTools;
using hxdom.DomTools;


class MainJS {

	static var table:Table;
	static var inptxt:ETextArea;
	static var exampleText:String = "私は日本語の学生です";
		//"エスペラント とは、ルドヴィコ・ザメンホフが考案した人工言語。母語の異なる人々の間での意思伝達を目的とする、いわゆる国際補助語としては最も世界的に認知され、普及の成果を収めた言語となっている。";
	static var ext:Extractor;
	static function main () {
		ext = new Extractor();
		trace("Booting HTML");
		var html:EHtml = cast hxdom.js.Boot.init();
		var modalGroup:ModalGroup = new ModalGroup();
		html.node.childNodes[1].vnode().append(modalGroup);

		var cont = new EDiv().container();
		inptxt = new ETextArea();
		inptxt.setAttr("id","user_input").setAttr("style", "width:100%").setAttr("spellcheck","false").setAttr("autocomplete","off").addClass("form-control").setAttr("rows", "3").addText(exampleText);
		inptxt.addEventListener("input", updateTable);

		var col1 = new EDiv().append(new EHeader1().setText("Find kanji's meanings"))
		.append(new EParagraph().textAlign(Right).lead().addText("Introduce a text in japanese, this page will prepare you a study table with the kanji meanings."))
		.append(new EParagraph().addText("I was a fan of Heisig's RTK method but I did not want to learn the whole list of kanji before start with the language. My approach is being lazy: do not learn a kanji until it is necessary. In a normal kanji memorizing session I would focus only on the kanji which will appear in the next study lesson. Feel free to copy the generated table in a spreadsheet and prepare or format it at your will before your actual study."))
		.append(inptxt).append(new EParagraph().setAttr("style", "width:100%").addText("Careful on Google Chrome: it is extremely slow pasting large chunks of text, this is a known error and it has been reported to google already."));

		var panel = new Panel(Primary);
		panel.body.append(new EParagraph().addText("List of kanji ordered by frequency in the given text"));
		panel.append(populate_table(ext.freq_and_meanings(exampleText)));

		var disclaimer = new EParagraph().setAttr("style", "color:#D0D0D0").addText(haxe.Resource.getString("cc_disclaimer"));
		cont.append(col1).append(panel).append(disclaimer);

		var body = new EBody().append(cont);
		html.append(body);
		trace("HTML completed");
	}
	static public function updateTable(_:Dynamic):Void {
		var parent = table.parent();
		table.remove(); // Fix: populate table recreates it again
		var input_text:String = inptxt.node.value;
		trace("processing: " + input_text);
		parent.append(populate_table(ext.freq_and_meanings(input_text)));

	}
	@:client
	static function populate_table(frequencies:Array<Extractor.KanjiFreq>):Table {
		var rows:Array<Array<Text>> = [[new Text("#"), new Text("Kanji"), new Text("Meaning")]];
		for (kf in frequencies) rows.push([new Text(Std.string(kf.freq)), new Text(kf.kanji), new Text(kf.meaning)]);
		table = Table.build(rows, [Hover, Striped]);
		return table;
	}
}
