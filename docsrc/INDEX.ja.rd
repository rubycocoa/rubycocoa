# -*-rd-*-

== RubyCocoaとは？

RubyCocoaは、
オブジェクト指向スクリプト言語((<Ruby|URL:http://www.ruby-lang.org/>))での
((<Cocoa|URL:http://developer.apple.com/cocoa/>))プログラミングを可能とする、
((<Mac OS X|URL:http://www.apple.co.jp/macosx/>))のフレームワークです。

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

以下の例はマックにテキストを読み上げさせるスクリプトです(OSX 10.2用)。

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
|URL:http://www.gnu.org/licenses/lgpl.html>))


== 謝辞

まずChris Thomasさん、Luc "lucsky" Heinrichさん、S.Sawadaさんに感謝いたします。

さらに

Gesse Gam, Hiroyuki Shimura, John Platte, kimura wataru, Masaki Yatsu,
Masatoshi Seki, Michael Miller, Ogino Junya, Ralph Broom, Rich Kilmer,
Shirai Kaoru, Tetsuhumi Takaishi, Tosh, Matthew Fero

をはじめとする多くの方々に感謝いたします。


== コンタクト

バグリポート、こんなアイコン作りました、コメントなどお気軽に
お寄せください。

作者は仕事を探しています。

* RubyCocoaの開発・応用開発・サポート活動の支援・事業化
* RubyCocoaのスポンサーになりたい
* RubyCocoaベースの開発ツールの開発
* その他なんでも (RubyCocoaじゃなくても)
* 何か仕事を依頼したい

などに関心のある企業・団体・個人の方がいらっしゃれば、お気軽に 
((<こちら|URL:mailto:contact.rubycocoa@fobj.com>)) 
までご連絡ください。

藤本尚邦, <hisa at fobj.com>, $Date$
