# -*-rd-*-
= 付属サンプルを試してみる

サンプルディレクトリ(フォルダ)の中にあるスクリプトやアプリケーションを
試してみましょう。


== RubyCocoaアプリケーション

まずはすでに完成しているRubyCocoaアプリケーションを起動してみましょう。
Finderで'/Developer/Examples/RubyCocoa'フォルダを開いてSimpleAppを
ダブルクリックしてみてください。コマンドラインから以下のように入力
しても起動できます。

  $ cd /Developer/Examples/RubyCocoa
  $ open SimpleApp.app


== コマンドライン(Terminal)から

RubyCocoaを使ってコマンドラインなどから実行する普通のスクリプトを書く
ことができます。サンプルディレクトリに移動して

  $ cd /Developer/Examples/RubyCocoa

簡単なスクリプトを実行してみましょう。

  $ ruby fontnames.rb  # フォント名がずらずらと出力されます
  $ ruby sndplay.rb    # システムの警告音が順番に鳴ります
  $ ruby sndplay2.rb   # システムの警告音が順番に間隔を詰めて鳴ります

Mac OS X 10.2を使っている人はさらに

  $ echo Hello World | ruby speak.rb
  $ head -5 speak_me.txt | ruby speak.rb

などとやってみるとおもしろいでしょう。speak.rbを引数無しで実行すると
'^D'(controlキーを押しながら'D')を入力するまで、1行入力するごとに読み上
げます。これは10.2からCocoaに実装されたAppleScript/AppleEventインター
フェース機能を使っています。

次に、ウィンドウを表示するスクリプトサンプルを実行してみましょう。

  $ ruby HelloWorld.rb                       # ボタン２つのウィンドウ
  $ ruby TransparentHello.rb                 # 透明なウィンドウに文字
  $ (cd Hakoiri-Musume && ruby rb_main.rb )  # パズルゲーム箱入り娘


== MakefileベースのソースからRubyCocoaアプリケーションを作る

次にMakefileベースのものを試してみましょう。

  $ cd /Developer/Examples/RubyCocoa/Hakoniwa-Musume
  $ make

で構築できます。できたら実行してみましょう。そのままコマンドラインから

  $ open CocoHako.app

と入力するか、ファインダでCocoHakoをダブルクリックして起動してみてくだ
さい。


== Project BuilderベースのソースからRubyCocoaアプリケーションを作る

次にProject Builderベースのものを試してみましょう。コマンドラインから

  $ cd /Developer/Examples/RubyCocoa/simpleapp
  $ pbxbuild      # アプリケーション作成

として構築します。もちろんProject Builderを起動してその中で構築したり
実行したりすることもできます。実行してみましょう。

  % open build/SimpleApp.app

と打ち込むか、またはファインダでbuildフォルダの中のSimpleAppをダブルク
リックしてアプリケーションを起動してみてください。


== さらに...

他にもサンプルがいろいろあるので、適当に試してみたりスクリプトを読んで
みてください。

== 補足

* HelloWorld.rb は ((<PyObjc|URL:http://pyobjc.sf.net/>))
  付属のPythonで書かれていたサンプルスクリプトをRubyで書いたものです。

* TransparentHello.rbは雑誌
  ((<DDJ(Dr.Dobbs Journal)2002年5月号
  |URL:http://www.ddj.com/articles/2002/0205/>))
  のChris Thomasさんの記事に掲載されたスクリプトです。

* RubyRaiseManとRubyTypingTutorは
  ((<『Mac OS X Cocoa プログラミング』
  |URL:http://www.amazon.co.jp/exec/obidos/ASIN/489471440X>))
  で作るObjective-CのプログラムをRubyで書いたものです。

* MyViewerは
  ((<『Mac OS X プログラミング入門 Objective-C』
  |URL:http://www.amazon.co.jp/exec/obidos/ASIN/4877780688>))
  で作るObjective-CのプログラムをRubyで書いたものです。


$Date$
