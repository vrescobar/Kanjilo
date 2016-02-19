package ;

import hxdom.html.Text;
import hxdom.bootstrap.CloseButton;
import hxdom.bootstrap.Modal;
import hxdom.bootstrap.Panel;
import hxdom.bootstrap.Table;
import hxdom.Elements;

using hxdom.BSTools;
using hxdom.DomTools;


class ServeHTML {

	static function main () {
		var body = new EBody();
		var html = new EHtml();
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
	}
}
