# -*-rd-*-
= RubyCocoaを入手する

== バイナリ配付

=== for Mac OS X 10.4

バイナリ配付に含まれているRubyCocoaは、Mac OS X 10.4に付属する
Ruby 1.8.2 に合わせて構築しています。

((<ファイル一覧|URL:http://sourceforge.net/project/showfiles.php?group_id=44114>)).
の中から
((<RubyCocoa-0.5.0-OSX10.4universal.dmg|URL:http://prdownloads.sourceforge.net/rubycocoa/RubyCocoa-0.5.0-OSX10.4universal.dmg?download>))
をダウンロードしてください。

RubyCocoaのライブラリ・サンプルコード・ドキュメント・
Xcodeテンプレートなどが含まれています。実行・開発に必要な
ライブラリ類は'.pkg'形式のパッケージになっていて、簡単にインストール
できます。

バイナリパッケージにより以下のものがインストールされます。

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoaフレームワーク (本体)

: /usr/lib/ruby/site_ruby/1.8/osx/ の中
  RubyCocoaライブラリ (stub)

: /usr/lib/ruby/site_ruby/1.8/[powerpc|i386]-darwin8.0/rubycocoa.bundle
  RubyCocoa拡張ライブラリ (stub)

: '/Library/Application Support/Apple/Developer Tools' の中
  Xcodeのテンプレート

: '/Library/BridgeSupport/'
  ブリッジ機能サポート用のメタデータ (xml)

: /Developer/Documentation/RubyCocoa
  ドキュメント (HTML)

: /Developer/Examples/RubyCocoa
  サンプルプログラム

インストールが完了したら、((<「付属サンプルを試してみる」
|URL:trysamples.ja.html>)) を参考にRubyCocoaで書かれたサンプルプログラ
ムを動かしてみるとよいでしょう。

== ソース配付

((<ファイル一覧|URL:http://rubycocoa.sourceforge.net/files/>))
の中から
((<rubycocoa-0.5.0.tgz|URL:http://prdownloads.sourceforge.net/rubycocoa/rubycocoa-0.5.0.tgz?download>))
をダウンロードしてください。

((<「RubyCocoaをソースから構築・インストールする」|URL:build.ja.html>))
を参考に構築・インストールしてください。


== Subversionサーバから開発途上のソースを入手する

((<Subversionサーバ|URL:http://sourceforge.net/svn/?group_id=44114>))から最新
の(あるいは最古の)ソースを入手したり、
(((<Subversionリポジトリを見る|URL:http://rubycocoa.svn.sourceforge.net/viewvc/rubycocoa/trunk/src/>))
ことができます。シェルで

  $ svn co https://rubycocoa.svn.sourceforge.net/svnroot/rubycocoa/trunk/src rubycocoa 

と入力すると、'rubycocoa'というディレクトリにRubyCocoaのソース一式が
ダウンロードされます。Subversionの性質上、ダウンロードしたタイミングにより
構築できないこともあります。


== MacPorts (DarwinPorts)

((<MacPorts|URL:http://www.macports.org/>))では、"rb-cocoa"という
名前でRubyCocoa(0.4.3d2)のportが提供されています。

このportをインストールするには、MacPortsのバージョン1.1以降が必要です。
次のコマンドでMacPortsをアップデートすることができます。

  $ sudo port -d selfupdate


== PINEAPPLE RPMパッケージ

((<Project PINEAPPLE(日本語)
|URL:http://sacral.c.u-tokyo.ac.jp/~hasimoto/Pineapple/>))にRPM形式の
バイナリ(0.2.x)があります。


$Date$
