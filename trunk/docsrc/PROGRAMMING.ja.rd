# -*-rd-*-
= RubyCocoaプログラミング

== 目次

* ((<irb - インターラクティブ Ruby>))
* ((<ライブラリのロード>))
* ((<動いた実感を味わえる例>))
* ((<Cocoaクラス>))
* ((<Cocoaオブジェクトの生成>))
* ((<オーナーシップとメモリ管理>))
* ((<メソッドの返す値>))
* ((<メソッド名の決定方法とバリエーション>))
* ((<メソッドの引数は可能な限り変換する>))
* ((<メソッド名が重複するときに使う接頭辞 "oc_">))
* ((<Cocoaクラスの派生クラスとそのインスタンス>))
* ((<Cocoa派生クラスの定義>))
* ((<アウトレット>))
* ((<メソッドのオーバーライド>))
* ((<Cocoa派生クラスのインスタンス生成>))
* ((<インスタンス生成時の初期化コードはどこに書くべきか?>))
* ((<RubyCocoaアプリケーションのデバッグ>))


== irb - インターラクティブ Ruby

ここにあるスクリプトの切れ端を試してみるのに irb を使うとよいでしょう。
irb はコマンドラインで対話的に Ruby インタープリタを使う Ruby付属のコ
マンドです。以下のよう起動します。

  % irb -r osx/cocoa

(注) Mac OS X 10.1 では irb と RubyCocoa をいっしょに使うとしばしば
バスエラーが発生します。Mac OS X 10.2 またはそれ以降での使用をお勧めします。

== ライブラリのロード

RubyCocoaのライブラリは以下のようにロードします。

  require 'osx/cocoa'


== 動いた実感を味わえる例

まずは動いた実感を味わえる(音が鳴る)簡単な例です。irb を使って試してみ
ましょう。

  include OSX
  files = `ls /System/Library/Sounds/*.aiff`.split
  NSSound.alloc.initWithContentsOfFile_byReference (files[0], true).play
  NSSound.alloc.initWithContentsOfFile_byReference (files[1], true).play
  NSSound.alloc.initWithContentsOfFile_byReference (files[2], true).play

以降は、地味だけど理解の助けになると思われる例をあげていきます。説明の
中で "# => "の右側は実行結果として標準出力される文字列です。

== Cocoaクラス

  p OSX::NSObject # => OSX::NSObject
  obj = OSX::NSObject.description
  p obj      # => #<OSX::OCObject:0x5194e8 class='NSCFString' id=A97910>
  obj = OSX::NSObject.alloc.init
  p obj      # => #<OSX::NSObject:0x51f5b4 class='NSObject' id=976D90>

RubyCocoaでは、CocoaクラスはOSXモジュール配下のクラスとして定義されて
います(0.2.0以降)。CocoaクラスはRubyのクラスであると同時にCocoaのオブ
ジェクトとしても振る舞います。


== Cocoaオブジェクトの生成

Cocoaオブジェクトの生成には、Cocoaの各クラスのメソッドをそのまま使いま
す。

  obj = OSX::NSObject.alloc.init
  str = OSX::NSString.stringWithString "hello"
  str = OSX::NSString.alloc.initWithString "world"

生成されたCocoaオブジェクトは、RubyCocoa内部でOSX::ObjcIDというクラス
のオブジェクトに包まれています。通常、OSX::ObjcIDクラスの存在を意識す
る必要はありません。


== オーナーシップとメモリ管理

OSX::ObjcIDのインスタンスはかならず自身が包んでいるCocoaオブジェクトの
オーナーシップを持ちます。オーナーシップはOSX::ObjcIDのインスタンスが
GCに掃除されるときに自動的になくなります。したがってRubyCocoaでは、オー
ナーシップなどのメモリ管理を気にする必要はありません。また、通常
OSX::ObjcIDというクラスの存在を意識する必要もありません。

  str = OSX::NSObject.stringWithString "hello"
  str = OSX::NSObject.alloc.initWithString "world"

上記２行は、Objective-Cではオーナーシップを発生させるかさせないかとい
う違いがありますが、オーナーシップを意識する必要のない RubyCocoa では
たいして違いがありません。release、autorelease、retainなどのメソッドは
基本的に呼ぶ必要はありませんし、NSAutoreleasePoolを作る必要もありませ
ん。

* Cocoaオブジェクトの生成にはCocoaクラスに対してCocoaのメソッドを使う
* Cocoaオブジェクトは作りっぱなしで良い、メモリ管理は不要

== メソッドの返す値

  nstr = OSX::NSString.description
  p nstr      # => #<OCObject:0x7233e class='NSCFString' id=687610>
  p nstr.to_s # => "NSString"

  nstr = OSX::NSString.stringWithString "Hello World !"
  p nstr      # => #<OCObject:0x71970 class='NSCFString' id=688E90>
  p nstr.to_s # => "Hello World !"

  nstr = OSX::NSString.stringWithString(`pwd`.chop)
  nary = nstr.pathComponents
  p nary      # => #<OCObject:0x6bb2e class='NSCFArray' id=3C0150>

  ary = nary.to_a
  p ary       # => [#<OCObject:0x6a9b8 class='NSCFString' id=3C2B50>,...]

  ary.map! {|i| i.to_s }
  p ary       # => ["/", "Users", "hisa", "src", "ruby", "osxobjc"]

これらの例から推測できるようにRubyCocoaでは、NSStringやNSArrayなど
Objective-Cオブジェクトを返すメソッドをCocoaオブジェクトとして返します。
積極的にRubyの対応するオブジェクト(例えばStringなど)には変換しません。
文字列と配列に関しては to_s や to_a が定義されているのでそれを使うこと
ができます。


== メソッド名の決定方法とバリエーション

  # システム音を順番に鳴らす (2)
  sndfiles.each do |path|
    snd = OSX::NSSound.alloc.initWithContentsOfFile(path, :byReference, true)
    snd.play
    sleep 0.25 while snd.isPlaying?
  end

これはさきほど示した音をならす例の別バージョンです。Objective-Cのメッ
セージセレクタと引数をRuby風に表記する別の方法を示しています。
Objective-Cの

  [obj hogeAt: a0 withParamA: a1 withParamB: a2]

に対していくつかの呼び出し方法が用意されています。基本は、メッセージセ
レクタの":"を"_"に置き換えたものがRuby側でのメソッド名となります。

  obj.hogeAt_withParamA_withParamB_ (a0, a1, a2)

ただし、このままではカッコ悪すぎなので最後の"_"は省略することができま
す。

  obj.hogeAt_withParamA_withParamB (a0, a1, a2)

また長いメソッド名の場合など、メッセージセレクタのキーワードと引数の関
係がわかりにくいため、あまり美しくありませんが、苦肉の策として次のよう
な方法も使うことができます。

  obj.hogeAt (a0, :withParamA, a1, :withParamB, a2)

BOOLを返すメソッド(述語)の場合には、メソッド名の最後に"?"を付けてくだ
さい。RubyCocoaでは、'?'の有無でメソッドが論理値を返すものかどうか判
断しています。付けない場合にはObjective-Cが返した数値(0:NO, 1:YES)が返
りますが、これらの値はRuby の論理値としてどちらも真になります。

  nary = OSX::NSMutableArray.alloc.init
  p nary.containsObject("hoge")   # => 0
  p nary.containsObject?("hoge")  # => false
  nary.addObject("hoge")
  p nary.containsObject("hoge")   # => 1
  p nary.containsObject?("hoge")  # => true


== メソッドの引数は可能な限り変換する

上の例のcontainsObjectのように、引数の値としてObjective-Cオブジェクト
をとるメソッドの場合に、Rubyオブジェクトをそのまま渡しても可能な限り変
換を試みます。


== メソッド名が重複するときに使う接頭辞 "oc_"

  klass = OSX::NSObject.class
  p klass     # => Class
  klass = OSX::NSObject.oc_class
  p klass     # => OSX::NSObject

"Object#class"のようにRubyとObjective-Cでメソッド名(セレクタ)が全く同
じ場合には、Rubyのメソッドが呼ばれます。このような場合には、メソッド名
の頭に"oc_"という接頭辞をつけると、Objective-Cオブジェクトに対してメッ
セージが送られます。"oc_" を付けてもRuby側にメソッドがある場合は？どう
しようもありません(裏技はあるのでソースを読める人はどうぞ) 。


== Cocoaクラスの派生クラスとそのインスタンス

ここまでは既存のCocoaクラスとそのインスタンスに関するトピックを扱いま
した。ここからは、RubyCocoaアプリケーションを書く場合に必要となるCocoa 
派生クラスの定義やそのインスタンスに関するトピックを扱います。Cocoaの
派生クラスはややトリッキーな実装により実現しているため、多少の制約や癖
がありますが、それも含めて見ていきましょう。


== Cocoa派生クラスの定義

Interface Builderで作成したGUI定義ファイル(nibファイル)の中で設定した
Cocoaオブジェクトのクラスなどは派生クラスとして定義します(0.2.0以降)。
例えばCocoaの入門書やチュートリアルなどで最初の方に出てくるようなMVCモ
デルのコントローラは

  class AppController < OSX::NSObject

    ib_outlets :messageField

    def btnClicked(sender)
      @messageField.setStringValue "Merry Xmas !"
    end

  end

のように定義します。RubyCocoaにおけるCocoaの派生クラス定義は、このよう
に通常のRubyでの派生クラス定義と同様に記述します。


== アウトレット

nibファイル中でクラスに設定したアウトレットは派生クラスの定義の中で

  ns_outlets :rateField, :dollerField

と書きます。ns_outletsは実際には Module#attr_writer と同じです。したがっ
て代わりに

  def rateField= (new_val)
    @rateField = new_val
  end

のように定義することもできます。ns_outlets には ib_outlets という別名
もあります。


== メソッドのオーバーライド

親クラスで定義されているメソッドをオーバーライドする場合、ns_overrides
(別名ib_overrides)を使ってオーバーライドしたことを宣言する必要がありま
す。

  class MyCustomView < OSX::NSView
    ns_overrides :drawRect_, 'mouseUp:'

    def drawRect(frame)
    end

    ...
  end

ns_overrides の引数には Objective-C のメッセージセレクタを文字列または
シンボルで表現したものを与えます。ただし「メソッド名の決定方法とバリエー
ション」で説明した末尾を省略する記法を使うことはできません。引数の数に
合わせて正確に記述する必要があります。

オーバーライドしているメソッドの定義の中でスーパークラスの同じメソッド
を呼ぶ場合にはメソッド名に "super_" 接頭辞を付けて呼びます。

  class MyCustomView < OSX::NSView

    ns_overrides :drawRect_

    def drawRect (frame)
      p frame
      super_drawRect(frame)   # NSViewのdrawRectを実行
    end

  end


== Cocoa派生クラスのインスタンス生成

Cocoa派生クラスのインスタンスをRubyスクリプト中で生成する必要がある場
合には、既存のCocoaクラスの場合と同様に

  AppController.alloc.init  # use this

のように書きます。Rubyでのもっとも一般的な書き方である

  AppController.new  # don't use this

を使うことはできません(例外を発生するようにしてあります)。これにはいろ
いろ事情があるのですが長くなるのでここでは詳しい説明は省きます。この制
約はインスタンス生成が

  * alloc (Objective-C側)
  * alloc内でRubyオブジェクト生成(ここでinitializeメソッドが呼ばれる)

という順番で行われることに深い関連があります。


== インスタンス生成時の初期化コードはどこに書くべきか?

一般にRubyではinitializeメソッドの中に初期化のコードを書きますが、
Cocoa派生クラスではどちらかいえばあまり奨められません。理由は先に述べ
たインスタンス生成時のinitializeメソッドが呼ばれるタイミングにより、そ
の時点でCocoaオブジェクトとしてはメモリが割り当てられただけで初期化さ
れていないからです。もっともCocoa側メソッドを呼ばない限りにおいてはと
くに問題は発生しないと考えられます。

nibファイルからロードされるような場合には awakeFromNib メソッドで初期
化するのがもっとも無難です。実際にCocoaの派生クラスを定義する必要があ
るのもこのケースがもっとも多いのではないでしょうか。

その他の場合には、Cocoaの流儀で "init" 接頭辞を持つメソッドに書くのが
よいでしょう。メソッドがselfを返すようにすることを忘れないでください。


== RubyCocoaアプリケーションのデバッグ

今のところ(2003-01-05)、RubyCocoaアプリケーションに対応する
ProjectBuilderのプラグインモジュールが存在しないため、ProjectBuilder上
でRubyのデバッガを使うことはできません。

しかし、RubyCocoaアプリケーションをシェルなどからオプション付きで起動
することにより、Rubyに付属のデバッガなどを使うことは可能です。Emacs使
いであれば、rubydbコマンドを使ってデバッグできます。

以下は、simpleapp(サンプル)を題材に、Ruby付属デバッガを使ってRubyCocoa 
アプリケーションをブレークさせるときの様子です。

  $ cd sample/simpleapp/
  $ pbxbuild
  $ build/SimpleApp.app/Contents/MacOS/SimpleApp -r debug
  (rdb:1) b AppController.rb:24    # ブレークポイントを設定
  Set breakpoint 1 at AppController.rb:24
  (rdb:1) c
  Breakpoint 1, aboutApp at AppController.rb:24
  AppController.rb:24:
  (rdb:1) l
  [19, 28] in AppController.rb
     19      @myView.set_alpha(@slider.floatValue)
     20      @myView.set_color(@colorWell.color)
     21    end
     22  
     23    def aboutApp (sender)
  => 24      NSApp().orderFrontStandardAboutPanelWithOptions(
     25        "Copyright" => "RubyCocoa #{RUBYCOCOA_VERSION}",
     26        "ApplicationVersion" => "Ruby #{VERSION}")
     27    end
     28  
     29    def colorBtnClicked (sender)
  (rdb:1) sender
  #<OSX::NSMenuItem:0xd439e class='NSMenuItem' id=0x3e27d0>
  (rdb:1) q
  Really quit? (y/n) y


$Date$
