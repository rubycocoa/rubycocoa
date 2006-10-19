# -*-rd-*-

== RubyCocoaとは？

RubyCocoaは、((<Mac OS X|URL:http://www.apple.co.jp/macosx/>))のアプリケーション環境((<Cocoa|URL:http://developer.apple.com/cocoa/>))ベースのソフトウェアを、オブジェクト指向スクリプト言語((<Ruby|URL:http://www.ruby-lang.org/>))で記述できるようにするフレームワークです。

RubyCocoaを使って、CocoaアプリケーションをRubyで書いたり、Rubyスクリプトで
Cocoaオブジェクトを生成して機能を利用することができます。
Cocoaアプリケーションでは、RubyとObjective-Cのソースが混在するCocoa
アプリケーションを作ることも可能です。

次のようなときにRubyCocoaを使えます:

  * irbで対話的にCocoaオブジェクトの性質を探求
  * Cocoaアプリケーションのブロトタイピング・開発
  * RubyとObjective-C双方の長所を活かしたCocoaアプリケーション
  * RubyスクリプトにMac OS X風のユーザインターフェースをかぶせる


== スクリーンショット

RubyスクリプトとInterface BuilderのNibファイルのみで書かれたRubyCocoa
アプリケーションが動作しているところのスクリーンショットです。
<<< img_simpleapp

== スクリプト例

以下の例はシステムの音を順番に鳴らすスクリプトです。

  require 'osx/cocoa'
  snd_files =`ls /System/Library/Sounds/*.aiff`.split
  snd_files.each do |path|
    snd = OSX::NSSound.alloc.
      initWithContentsOfFile_byReference (path, true)
    snd.play
    sleep 0.5
  end

以下の例はマックにテキストを読み上げさせるスクリプトです(OSX 10.2以降用)。

  require 'osx/cocoa'
  include OSX
  def speak (str)
    str.gsub! (/"/, '\"')
    src = %(say "#{str}")
    NSAppleScript.alloc.initWithSource(src).executeAndReturnError(nil)
  end
  speak "Hello World!"
  speak "Kon nich Wah. Ogan key desu ka?" # "Hi. How are you." in Japanese
  speak "Fuji Yamah, Nin Jya, Sukiyaki, Ten pora, Sushi."

以下の例はインターフェースビルダーで作成したnibファイル内のクラスと関
連づけられたクラス定義のサンプルです。

  require 'osx/cocoa'

  class AppCtrl < OSX::NSObject

    ib_outlets :monthField, :dayField, :mulField

    def awakeFromNib
      @monthField.setIntValue  Time.now.month
      @dayField.setIntValue Time.now.day
      convert
    end

    def convert (sender = nil)
      val = @monthField.intValue * @dayField.intValue
      @mulField.setIntValue (val)
      @monthField.selectText (self)
    end

    def windowShouldClose (sender = nil)
      OSX.NSApp.stop (self)
      true
    end    

  end

== ライセンス

((<GNU Lesser General Public License version 2. LGPL
|URL:http://www.gnu.org/licenses/lgpl.html>)) またはRubyライセンス


== 歴史

[2001年秋] 藤本尚邦がNSClassFromStringとNSObjectをラップするRuby拡張モジュールを実装。
[2001年10月] InterfaceBuilder+ProjectBuilderとの統合。
[2001年11月] RubyCocoa公開。
[2002年2月ごろ] SourceForge にプロジェクトを登録(((<URL:http://rubycocoa.sourceforge.net/>)))。Chris Thomas、コミッタに参加。
[2002年5月] Chris ThomasによるRubyCocoa解説記事"Examining RubyCocoa"が雑誌((<'Dr. Dobbs Journal, May 2002'|URL:http://www.ddj.com/articles/2002/0205/>)) に掲載された。
[2003年] 木村渡、コミッタに参加。
[2006年2月] Jonathan Paisley、コミッタに参加。
[2006年] Tim BurksによるRubyCocoa情報サイト ((<rubycocoa.com|URL:http://www.rubycocoa.com/>))。
[2006年5月] Laurent Sansonetti、コミッタに参加。
[2006年8月] Tim Burks、コミッタに参加。
[2006年8月] Apple WWDCにてLeopardへの搭載が公表。


== コンタクト

* ((<URL:http://http://sourceforge.net/projects/rubycocoa/>)) (((<URL:http://www.macosforge.org/>))に移動予定)
* hisa at sourceforge.net (暫定、Mac OS Forge に移動予定)


RubyCocoa Project $Date$
