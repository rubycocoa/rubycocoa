# -*-rd-*-
= 変更点

== 0.4.0 からのおもな変更点 (0.4.1d9)

: ruby 1.8.0 対応

  ruby 1.8.0 で出るようになったいくつかの警告やエラーを修正しました。

== 0.4.0 からのおもな変更点 (0.4.1d8)

: RubyCocoa.frameworkを組み込み可能にした

  RubyCocoaがインストールされていない環境で、RubyCocoaアプリケーション
  を動作可能にするため、RubyCocoa.frameworkのビルト設定を変更しました。
  RubyCocoaアプリケーション自体にRubyCocoa.frameworkを組み込んで使うこ
  とができます。

: WebKit.framework対応

  kimura wataru さんによって書かれた WebKit.framework 用のライブラリを
  追加しました。((- WebKit対応について、kimura wataruさんと s.sawada さ
  んの取り組みに感謝します。-))

: initメソッドをns_overrideすると例外があがるバグを修正

  ns_overrideしたinitメソッドの定義の中で、super_initを呼ぶと例外が発生
  するバグを、修正しました。

: その他

  RCDataAttachmentモジュールを定義。NSData, NSStrng クラスにいくつかの
  クラスメソッドを定義。

== 0.3.2 からのおもな変更点 (0.4.0)

: Ruby 1.8に対応

  Ruby 1.8との組合せで使えるようになりました。
  '-w'付きで実行したときに発生していた、メソッドの引数に関する警告が
  なくなるように修正しました。

: RubyCocoa.frameworkが復活

  Rubyで書かれている部分も含めて、基本実装のすべてをRubyCocoaフレームワーク
  の中にまとめました。バイナリ配付ではlibruby自身もRubyCocoaフレームワーク
  に静的リンクしています。
  これによりRubyCocoaアプリケーションが配付しやすくなったはずです。

: 拡張ライブラリ名を変更

  拡張ライブラリの名前をosx_objc.bundleからrubycocoa.bundleに変更しました。
  この拡張ライブラリは、rubyコマンドやirbコマンドからRubyCocoaフレームワーク
  を利用するためのstubライブラリになりました。

: ライブラリを移動

  osx/objcディレクトリに含まれていたライブラリは、ディレクトリごと全て
  フレームワーク側に移動しました。
  また、osxディレクトリ以下のRubyCocoaライブラリは、rubyコマンドや
  irbコマンドからRubyCocoaを使うためのstubライブラリになりました。


== 0.3.1 からのおもな変更点 (0.3.2)

=== AddressBook.framework 用のライブラリを追加

使用例:

  require 'osx/addressbook'
  ab = OSX::ABAddressBook.sharedAddressBook
  ab.people.to_a.each {|i| puts i.compositeName.to_s.toeuc }


== 0.3.0 からのおもな変更点 (0.3.1)

=== Objective-Cオブジェクトに対するリフレクション機能の改良

OCObjWrapper#objc_methods, OCObjWrapper#objc_method_type を定義。

=== 例外メッセージの改良

Objective-C オブジェクトに対するメソッド呼出しに関連して発生させた例外
のメッセージ内容にメソッド名・関数名などを含めるようにした。

NS関数呼出し時に発生した NSException を OSX::OCException に変換して例
外を発生させるようにした。

=== GC 関連バグの修正

NIB ファイル内でインスタンス化された Ruby オブジェクトなどが GC によっ
て掃除されてしまうバグを修正。

=== スレッド切替えに関する変更

osx_objc.bundle のロード時にスレッド切替えを開始するようにした
(ruby_thread_switcher_start)。スレッド切替えは NSTimer を使って実装し
ているため NSRunLoop が回っていないときには機能しない。

=== rb_main.rb の変更

バンドルリソース内の .rb ファイルをすべてロードするようにした。
RubyCocoa アプリケーション開発時に rb_main.rb を変更する必要はなくなっ
た。


== 0.2.7からのおもな変更点

=== [INPROVE] Jaguar (Mac OS X 10.2)に対応。

* Jaguar付属のRuby 1.6.7のみで実行可能
* Jabuar付属のDeveloper Toolsのみでソースからの構築が可能
* LibRuby.frameworkを廃棄
* RubyCocoa.frameworkを廃棄
* Ruby構築時に "--enabled-shared" の指定は不要

(注) 正常に動作するドキュメントベースアプリケーションを作るためには 
libruby.a が必要です。ソース配付には含まれていません。rubyのソースから
自分で作るか ((<libruby.a.gz|URL:../rubyosx/files/libruby.a.gz>)) をダ
ウンロードしてください。

=== [IMPROVE] NS定数,NS関数wrapper生成スクリプトを改良(cpp3使用)。

NS定数,NS関数の未実装が減った。

=== [IMPROVE] Cポインタの引数や戻り値を扱う手段を実装

* OSX::ObjcPtr というクラスを導入
* 関数・メソッドの戻り値がCポインタの場合 OSX::ObjcPtr のインスタンスを返す
* 引数がCポインタの場合 OSX::ObjcPtr または String で渡たす

この機能はCのポインタやアドレスに直接アクセスすることの意味を理解しな
いで使うと危険ですので注意してください。戻り値のCポインタの示す先が 
NSAutoreleasePool#release などによって既に壊されているため事実上 Ruby 
レベルでは使えないケースもあります。
(NSString#availableStringEncodingsなど)

=== [IMPROVE] NSDictionary 引数

関数・メソッドの引数が NSDictionary の場合 Hash が渡せるようになった。

=== その他 Jaguar 関連

以前は irb で使うときに Bus Error が多発していましたがかなり安定して使
えるようになりました。

Jaguar ではコマンドラインからアプリケーションバンドルなしで GUI アプリ
を実行できるようになっているようです。

  % cd {RubyCocoa sample}/Hokoiri-Musume
  % ruby rb_main.rb

で箱入り娘のウィンドウが開いてパズルで遊べます。


== 0.2.6からのおもな変更点

[CHANGES] NS関数・定数の Mac OS X 10.2 対応。NSAppleScriptなど。

[CHANGES] NSSoundを使っているサンプルの Mac OS X 10.2 対応。

[BUGFIX] TOPレベル以外で定義したCocoaの派生クラスのインスタンスを作る
ことができない問題を解決した。

  module MyModule
    class AppController < OSX::NSObject
    end
  end

[BUGFIX] NSStringとの文字列変換のとき、中間に\0を含む文字列を正しく処
理するようにした。

[CHANGES] Objective-CとRubyの間でのオブジェクト変換ができなかったとき
場合、例外OSX::OCDataConvExceptionを発生させるようにした。


== 0.2.5からのおもな変更点

[BUGFIX] BOOLを返すオーバライドメソッドが正常に動いてなかった(はず)の
バグを修正。

[IMPROVE] Cocoaのグローバル関数変数のラッバー自動生成スクリプトを改良。
その結果"not implemented"なCocoaのグローバル関数変数が減少。新しくサポー
トしたものにはNSGenericException系列,NSUnionRange系列などが含まれる。

[IMPROVE] ドキュメントベースアプリケーション用のProjectBuilderテンプレー
トを追加。

[CHANGE] ProjectBuilderテンプレートの名前を変更。

[CHANGE] 純粋なRubyのオブジェクトを引数として使う場合のために、
Objective-Cメソッドの引数の型がObjective-Cオブジェクトの場合の振る舞い
を変更。

[IMPROVE] シートパネル対応を改良。Callbuckされるメソッドには
"_returnCode_contextInfo"で終る名前をつける必要がある。

[IMPROVE] ローカライズ文字列用のモジュール関数を定義

  OSX::NSLocalizedStringFromTableInBundle
  OSX::NSLocalizedStringFromTable
  OSX::NSLocalizedString

[IMPROVE] セレクタ名が'_'で始まるメソッド(例えば"_transparency")の呼び
出しに対応

[IMPROVE] バージョン情報のサポート

  OSX::RUBYCOCOA_VERSION
  OSX::RUBYCOCOA_RELEASE_DATE


== 0.2.4からのおもな変更点

[BUGFIX] NSString.availableStringEncodingsが落ちるバグを修正

[BUGFIX] スーパークラスに存在しないメソッドをns_overridesの引数に与え
たときに落ちるバグを修正

[IMPROVE] NSOpenPanel, NSSavePanel, NSPrintPanel のシートパネルに対応

[CHANGE] テンプレートにPureEmptyApp.appを追加。これはEmptyApp.appから
NIBファイルに関する内容を取り除いたもの。


== 0.2.3からのおもな変更点

[BUGFIX] オーバーライドしたメソッドの引数の扱いに関するバグを修正。
(Chrisさんありがとう)

[BUGFIX] オーバーライドしたメソッドから((|self|))を返すコードなどがう
まく動かないバグを修正した。次のようなコードが期待どおり動くようになっ
た。

  class MyView < OSX::NSView

    ns_overrides :initWithFrame_
    
    def initWithFrame (frame)
      suuper_initWithFrame (frame)
      self
    end


== 0.2.2からのおもな変更点

[BUGFIX] オブジェクト生成時にメモリを4バイト破壊していたバグを修正。
(Chrisさんありがとう)

[CHANGE] Rubyスレッド切り替え(OSX.ruby_thread_switcher_start)を改良。


== 0.2.1からのおもな変更点

0.2.1 のインストールスクリプトの重大なバグを修正

[CHANGE] RubyCocoaフレームワークをインストールするディレクトリの指定方
法を以下のように変更

  % ruby install.rb config --frameworks=/Network/Library/Frameworks

== 0.2.0からのおもな変更点

[IMPROVE] RubyCocoaアプリケーションでRubyスレッドを切替えるための仕組
みをテスト的に実装。

[IMPROVE] オーバーライドしたメソッド定義の中でスーパークラスの同メソッ
ドを呼ぶ機能をテスト的に実装。

  def drawRect (frame)
    super_drawRect (frame)
  end

[BUGFIX] オーバーライドメソッドの戻り値に関する小バグを修正。

[IMPROVE] RubyCocoaフレームワークのインストール先をオプションで指定で
きるようにした。

  % ruby install.rb config -- --frameworks=/Network/Library/Frameworks


== 0.1.3からのおもな変更点

=== 仕様/実装

[CHANGE] OSX::OCObject は裏方になった。

[CHANGE] Cocoa クラスを Ruby のクラスとして定義。

  OSX::NSObject.is_a? Class # => true
  OSX::NSObject.name        # => "OSX::NSObject"

[CHANGE] OSX::OCObject#ib_loadable を廃止。Cocoa クラスの派生クラスの
定義を、Ruby の派生クラスの定義と同様の方法で書けるように変更。

  class Hoge < OSX::NSView
    ns_outlets   :hoge
    ns_overrides :drawRect_
    ...
  end

[CHANGE] Cocoa派生クラス#ns_overrides の引数にシンボルを使用可。ただし
引数に対応する"_"の省略はできない。(上記例のdrawRect)

[CHANGE] 上記変更の基盤として OSX::ObjcID クラス、OSX::OCObjWrapperモ
ジュールを追加 (通常これらは直接使うものではない)

[CHANGE] lib/osx/objcディレクトリを作り、Ruby側ライブラリの本体はその
中に置くようにした。

[CHANGE] C側ライブラリ名を"osxobjc.bundle"から"osx_objc.bundle"に変更。
RubyAEOSAと統一。

=== ドキュメント

リファレンスマニュアルを加えました。使い方にクラス定義に関する記述を加
えました。


== 0.1.2からのおもな変更点

=== 実装

[IMPROVE] コンパイル速度が大幅アップ (Chrisさんどうも)

[IMPROVE] Cocoaオブジェクトのメソッド実行時に発生した例外をRubyの例外
として発生させる機能を実装 (Chrisさんどうも)

=== その他

FAQに数項目追加


== 0.1.1からのおもな変更点

=== 実装

[BUGFIX] ib_loadalbeの中でObjective-Cのクラスを動的生成するさいのメモ
リ割り当てに関するバグを修正。

[CHANGE] 0.1.0の「(({ib_lodable}))なクラス定義の初期化メソッド
(({initialize})) に引数を渡す仕組み」を廃止。Ruby側のinitializeには
ObjC側のinitXXXの引数は渡りません。

[IMPROVE] NSRange(Cocoa)とRange(Ruby)の変換をサポート(Chrisさんどうも)

=== その他

サンプルにmultinibを追加 (Lucさんどうも)


== 0.1.0からのおもな変更点

=== 実装

[IMPROVE] 必要なときにRubyのNumericからCocoaのNSDecimalNumberへの変換
を行う。(「Learning Cocoa CH.9」対応)

[IMPROVE] (0.1.2で廃止) (({ib_lodable}))なクラス定義の初期化メソッド
(({initialize})) に引数を渡す仕組みを準備。実際に使っているのは 
(({ib_loadable :NSView})) のときのみ。

=== その他

サンプルdotviewを"Lerning Cocoa"の8章を読みながら書き直した。

"Lerning Cocoa"に相当するサンプルExpenses.appを追加。

テンプレート類をサンプルディレクトリからテンプレートディレクトリに移動。

Empty.app をテンプレートに追加。これをコピーして使えば、make や
pbxbuildを使わず、Rubyスクリプティングとnibファイルなどの変更のみで
Cocoaアプリケーションを作成可能。

$Date$
$Revision$
