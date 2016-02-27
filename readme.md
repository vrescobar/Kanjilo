# Kanjilo

I was a fan of Heisig's RTK method to learn Japanese Kanji but I did not want to learn the whole list of kanji before start with the learning of the japanese language. Here I bring you the tool which I created for myself in order to study lazily japanese kanji.

Check the [github](https://github.com/vrescobar/Kanjilo) of the project (sources)

## Download an usage
  - See it as a [single HTML](http://vrescobar.github.io/Kanjilo/out/web/index.html) **webpage** (no active internet connection is required)
  - [Binary](http://vrescobar.github.io/Kanjilo/out/cmd-cpp/Kanjilo) **command line tool** for Mac OSX (C++, static linked)
  - The whole [source code](https://github.com/vrescobar/Kanjilo) in **github**, for free (as Haxe/C++ you could compile it without problems under Mac, windows or Linux)

## Command line tool usage
You can use it as any regular *nix command line tool; stdin your japanese text, stdout CSV information parsed. Example:


    $ curl https://ja.wikipedia.org/wiki/%E3%82%A8%E3%82%B9%E3%83%9A%E3%83%A9%E3%83%B3%E3%83%88 | ./Kanjilo
    "690";"語";"word, speech, language";
    "272";"詞";"part of speech, words, poetry";
    "166";"年";"year, counter for years";
    "142";"集";"gather, meet, congregate, swarm, flock";
    "141";"編";"compilation, knit, plait, braid, twist, editing, completed poem, part of a book";
    "136";"在";"exist, outskirts, suburbs, located in";
    "127";"文";"sentence, literature, style, art, decoration, figures, plan, literary radical (no. 67)";
    "117";"意";"idea, mind, heart, taste, thought, desire, care, liking";
    "115";"形";"shape, form, style";
    "114";"存";"exist, suppose, be aware of, believe, feel";
    "112";"用";"utilize, business, service, use, employ";
    "110";"人";"person";
    "109";"法";"method, law, rule, principle, model, system";
    "106";"日";"day, sun, Japan, counter for days";
    "105";"言";"say, word";
    .
    .
    .

### Technology

* [Haxe](http://haxe.org) - A programming language and crosscompiler which generates source code such as C++ and Javascript  :)
* [Bootstrap](http://getbootstrap.com) - A famous HTML/CSS frontend

### Compilation
```sh
$ make all
```
Alternatively make only one of the tools separately:
```sh
$ make cmd
$ make web
$ make clean
```

### Development

Want to contribute? Great! Just send a git push or clone the project and make yourself :)

### License
The source code is licensed under the [Eclipse Public License 1.0](https://www.eclipse.org/legal/epl-v10.html).

The kanjis and associated meanings belong to the [Electronic Dictionary Research and Development Group](http://www.csse.monash.edu.au/~jwb/kanjidic2/index.html) and are distributed under Creative Commons Attribution-ShareAlike Licence (V3.0) as specified in [the license of its original web page](http://www.edrdg.org/edrdg/licence.html). All contents are the same as the original unmodified sources from the Electronic Dictionary Research and Development Group webpage.



