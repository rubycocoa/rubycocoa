# -*-rd-*-
= RubyCocoa FAQ

== インストール

=== Q: RubyCocoaを"dl file"というフォルダにダウンロードしてインストー
ルしたら失敗しました。

==== A: 間にスペースを含むディレクトリに入れて展開するとconfigの途中で
エラーが出るようです。今までMacオンリーできた方は特にご注意ください。
(sawada さんどうも)


== インストール完了後

=== Q: インストールが完了してサンプルスクリプトを実行しようとすると

  % ruby fontnames.rb
  dyld: ruby Undefined symbols:
  _init_NSDistributedNotificationCenter
  _init_NSScriptStandardSuiteCommands

というエラーが起こり、osx/cocoa が require できません。

==== A: RubyCocoaのtgzファイルをStuffItで展開しましたか？

RubyCocoaのtgzファイルをStuffItで展開した場合、ソースファイルに含まれ
る31文字を越える長いファイル名が切り詰められてしまい、RubyCocoaを正し
く作ることができません。インストールのドキュメントの手順どおりにシェル
(Terminalアプリケーション)からtarコマンドを使って

  % tar zxf rubycocoa-0.1.0.tgz

と入力してtgzファイルを展開しRubyCocoaを作り直してください。

(志村さん、情報どうも)


== その他

=== Q: ABAddressBookのようにNSで始まらないクラスには対応してないのですか? (2002-09-30)

==== A: 

まず確認しておくべきこととして、RubyCocoa はデフォルトでは Foundation 
と AppKit 以外のフレームワークに入ってるクラスを import していません。
このようなクラスを使うためには OSX::NSBundle を使ってフレームワークを
ロードし OSX.ns_import でクラスをインポートします。

AddressBook.framework に関しては 0.3.2 では

  require 'osx/cocoa'
  require 'osx/addressbook'
  abook = OSX::ABAddressBook.sharedAddressBook

で使用可能になります。それ以前のバージョンでは以下のように使うことがで
きます。

  require 'osx/cocoa'
  OSX::NSBundle.bundleWithPath("/System/Library/Frameworks/AddressBook.framework").load
  OSX.ns_import :ABAddressBook
  abook = OSX::ABAddressBook.sharedAddressBook


== 過去のFAQ (2002-12-23現在)

=== Q: Cocoaアプリ実行時にConsoleにmallocに関する警告が出ます

Cocoaアプリ実行時、Consoleにメモリアロケーションに関する以下のような警
告メッセージが出るときがあります。

  malloc[2461]: Deallocation of a pointer not malloced: 0x2718b20;
  This could be a double free(), or free() called with the middle of
  an allocated block; Try setting environment variable MallocHelp to
  see tools to help debug

==== A: 原因不明でまだ未解決です (2002-01-08)

リリース 0.1.2で解決したつもりでしたが、まだ発生します。「このパターン
で必ず発生する」など何か参考になりそうな情報があれば知らせてください。


=== Q: スレッドを使うとうまく動かないようです。

==== A: 0.2.1 以降を使っていますか?

リリース 0.2.1 から RubyCocoa アプリケーションで Ruby スレッドを動かす
ための仕組みを実装しています。0.2.1 以前用に作った RubyCocoa アプリで 
Rubyスレッドを使いたい場合には、rb_main.rb の ns_app_main を以下のよう
に修正してください。

  def ns_app_main
    OSX.ruby_thread_switcher_start (0.05)  # switching interval sec
    app = OSX::NSApplication.sharedApplication
    OSX::NSBundle.loadNibNamed_owner (BUNDLE_NAME.to_s, app)
    OSX.NSApp.run
  end

=== Q: 「アプリケーションは予期せぬ動作のため終了」ダイアログが出ます

fontname.rb や sndplay.rb は動いたのですが、サンプルのRubyCocoaアプリ
を実行すると「アプリケーションは予期せぬ動作のため終了しました」という
ダイアログが表示されます。コンソールを見ると

  dyld: /Users/kazusan/rubycocoa-0.1.1/sample/SimpleApp1.app/
  Contents/MacOS/SimpleApp1 Undefined symbols:
  _dlclose
  _dlerror
  _dlopen
  _dlsym

というエラーメッセージが出ています。

==== A: EasyPackageなどでUNIX系ソフトをインストールしたことはありますか？

古いEasyPackageをインストールしていた場合などに /usr/local/lib に 
libdl*.bundle という名前で共有ライブラリをリンクするための関数を持つラ
イブラリが入っていて、そちらにリンクされたりして問題が起きるようです。
解決方法としては

* /usr/local/lib ディレクトリから libdl*.bundle ファイルを削除
* それぞれのPBプロジェクトやMakefileのリンカオプションに"-ldl"を指定

などがあります。

"otool -L"コマンドを使ってRubyCocoaアプリケーションのバイナリがどの共
有ライブラリを必要とするか確認することができるので問題が発生するような
ら確認してみてください。

((<[ruby-talk:29708](英語)
|URL:http://www.ruby-talk.com/cgi-bin/scat.rb/ruby/ruby-talk/29708>)) 
も解決の参考になるかもしれません。

=== Q: Project Builderの新規プロジェクトでRubyCocoaアプリケーション

用のプロジェクトを選びたいのですが？

==== A: templateディレクトリ内の名前が"tmpl_pb_"で始まるディレクトリ

を"/Developer/ProjectBuilder Extras/Project Templates/Application/"の
下にコピーして"RubyCocoa Application"というような名前に変えてください。

  % cd "/Developer/ProjectBuilder Extras/Project Templates/Application"
  % cp -R {rubycocoa srcdir}/template/tmpl_pb_RubyCocoaApp "RubyCocoa Application"
  % cp -R {rubycocoa srcdir}/template/tmpl_pb_RubyCocoaDocApp "RubyCocoa Doc Application"
  % cd "../../File Templates"
  % cp -R {rubycocoa srcdir}/template/tmpl_pb_RubyFiles Ruby

(志村さん、情報どうも)


$Date$
$Revision$
