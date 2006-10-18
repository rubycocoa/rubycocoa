# -*-rd-*-
= RubyCocoaリファレンス

== OSX::ObjcIDクラス

Objective-Cオブジェクトのラッパー。ある一つのObjective-Cオブジェクトの
オーナーとなりそれを包みます。通常、このクラスの存在を意識する必要はあ
りません。

=== OSX::ObjcIDクラスのインスタンスメソッド

--- OSX::ObjcID#inspect

      オブジェクトの情報を表す文字列を返します。

--- OSX::ObjcID#__ocid__

      包んでいるObjective-Cオブジェクトのidの値を整数で返します。

--- OSX::ObjcID#__inspect__

      OSX::ObjcID#inspectと同じです。


== OSX::OCObjWrapperモジュール

Objective-Cオブジェクトに対してメッセージ送信(メソッド呼び出し)を行う
機能を実装したミックスインモジュールです。RubyCocoaでは、Cocoaオブジェ
クトにこのモジュールを装着しているために、Cocoaオブジェクトに対するメッ
セージ送信が可能となっています。

このモジュールを装着するオブジェクトは、操作の対象となるObjective-Cオ
ブジェクトを特定するために、次のいずれかの条件を満たしている必要があり
ます。

  * ((<OSX::ObjcIDクラス>))のインスタンスである
  * ((<OSX::ObjcID#__ocid__>))と同じ仕様のメソッドを実装している

通常、このモジュールの存在自体を意識する必要はありませんが、メッセージ
送信のメカニズムなどRubyCocoaの動きを理解する上では最も重要な部分でも
あります。


=== Objective-Cオブジェクトへメッセージを送信する仕組み

OSX::OCObjWrapperモジュールはオブジェクトが処理できなかったメソッド呼
び出しが((|method_missing|))に回って来る仕組みを利用して、操作対象の
Objective-Cオブジェクトに対してメッセージを送信しています。

=== Rubyメソッド名からObjective-Cメッセージセレクタへの変換

Rubyの世界でのメッセージ送信(メソッド呼び出し)をObjective-Cの世界での
メッセージ送信にマップするためには、Rubyのメソッド名をObjective-Cのメッ
セージセレクタに変換する必要があります。

「メッセージセレクタの':'を'_'に置き換えたものがRubyでのメソッド名」

これが変換の基本ルールです。例えば、メッセージセレクタ 
'doSomething:with:with:' のメッセージを送信する場合、Rubyでのメソッド
名は 'doSomething_with_with_' となります。

実際には基本ルールの他に、見た目を良くするため以下に示すような表現のバ
リエーションが存在します。

  (1) 末尾の'_'を省略する
  (2) 引数の中にキーワードを混ぜる

これだけでは理解できないと思いますが、説明するのも難しいので具体例で示
します。

  [rcv doSomething: a with: b with: c]      // Objective-Cの場合
  rcv.doSomething_with_with_ (a, b, c)      # 基本ルール
  rcv.doSomething_with_with (a, b, c)       # バリエーション(1)
  rcv.doSomething (a, :with, b, :with, c)   # バリエーション(2)


=== メソッド名接頭辞 "oc_"

名前が"oc_"で始まるメソッドは直接、操作対象のObjective-Cオブジェクトへ
メッセージ送信されます。主として、Ruby側とObjective-C側の両方に同名の
メソッドが存在する場合に使います。


=== メソッド名接尾辞 "?"

名前の最後に "?" をつけて送信したメッセージは、返ってきた値が0であるか
調べて真偽値を返します。これは真偽値を返すメソッド呼び出しのときに使い
ます。

Objective-Cのメソッドは真偽値を単なる数値(0なら偽、その他は真の意)で返
してくるので、Rubyではその値の意味が数値なのかあるいは真偽値なのかを判
断できません。さらにRubyでは0も1も真のように振る舞うので、そのまま使う
と論理が崩れてしまいます。したがって真偽値を返すメソッドを呼び出すとき
には "?"接尾辞を使う必要があります。


=== OSX::OCObjWrapperモジュールのインスタンスメソッド

--- OSX::OCObjWrapper#to_s

      操作対象のObjective-CオブジェクトのRuby文字列による表現を返しま
      す。

--- OSX::OCObjWrapper#to_a

      操作対象のObjective-CオブジェクトのRuby配列による表現を返します。

--- OSX::OCObjWrapper#to_i

      操作対象のObjective-Cオブジェクトの整数値による表現を返します。

--- OSX::OCObjWrapper#to_f

      操作対象のObjective-Cオブジェクトの実数値による表現を返します。

--- OSX::OCObjWrapper#objc_methods(inherit=true)
--- OSX::OCObjWrapper#objc_class_methods(inherit=true)
--- OSX::OCObjWrapper#objc_instance_methods(inherit=true)

      操作対象のObjective-Cオブジェクトのメソッド名の一覧を返します。

--- OSX::OCObjWrapper#objc_method_type (name)
--- OSX::OCObjWrapper#objc_class_method_type (name)
--- OSX::OCObjWrapper#objc_instance_method_type (name)

      操作対象のObjective-Cオブジェクトのメソッドの型を返します。

--- OSX::OCObjWrapper#ocm_responds? (name)

      操作対象のObjective-Cオブジェクトが、引数((|name|))で指定された
      メソッドに応答可能かどうかを示す真偽値を返します。((|name|))はメッ
      セージセレクタそのものか基本ルールに従ったものでなければなりませ
      ん。通常、このメソッドを使う必要はありません。

--- OSX::OCObjWrapper#ocm_send (name ...)

      操作対象のObjective-Cオブジェクトに対して、引数((|name|))で指定
      されたメソッドを残りの引数とともに送信します。((|name|))はメッセー
      ジセレクタそのものか基本ルールに従ったものでなければなりません。
      通常、このメソッドを使う必要はありません。


== OSX::OCObjectクラス

汎用のObjective-Cオブジェクトラッパー。OSXモジュール以下に定義されてい
るどのCocoaクラスにも属さないObjective-Cオブジェクトは、このクラスのイ
ンスタンスとして生成されます。通常、このクラスのインスタンスを明示的に
生成したり、派生クラスを定義する必要はありません。

=== スーパークラス
((<OSX::ObjcIDクラス>))

=== インクルードしているモジュール
((<OSX::OCObjWrapperモジュール>))


== Cocoaクラス

((|NSObject, NSString, NSApplication|))など全てのCocoaクラスは、
((|OSX::NSObject, OSX::NSString, OSX::NSApplication|)) のようにOSXモ
ジュールに属するRubyのクラスとして定義されています。

Cocoaクラス自体にもCocoaオブジェクトとして((<OSX::OCObjWrapperモジュー
ル>))が装着されています。

=== インクルードしているモジュール
((<OSX::OCObjWrapperモジュール>))

=== 装着しているモジュール
((<OSX::OCObjWrapperモジュール>))

=== Cocoaクラスのクラスメソッド

--- Cocoaクラス.__ocid__

      Cocoaクラスオブジェクトのidの値を整数で返します。


== Cocoa派生クラス

Cocoaクラスの派生クラス。

=== Cocoa派生クラスのクラスメソッド

--- Cocoa派生クラス.ns_outlets (...)

      アウトレットを宣言します。実際には((|attr_writer|))を呼んでいる
      だけです。

--- Cocoa派生クラス.ib_outlets (...)

      ns_outlets の別名

=== インスタンスメソッド接頭辞 "super_"

オーバーライドしたメソッドに関して、スーパークラスでの実装を使いたい場合には 
"super_" を付けたメソッド名で呼び出すことができます。

  def drawRect (frame)
    super_drawRect (frame)   # invoke SuperClass#drawRect
  end


== OSX::OCExceptionクラス

Objective-Cの世界で、Objective-Cオブジェクトへのメソッド呼び出しによっ
て例外((|NSException|))が発生した場合、このクラスの例外が発生します。


=== OSX::OCExceptionクラスのインスタンスメソッド

--- OSX::OCException#name

      例外名(NSException#name)を返します。

--- OSX::OCException#reason

      例外の理由文字列(NSException#reason)を返します。

--- OSX::OCException#userInfo

      ユーザ情報(NSException#userInfo)を返します。

--- OSX::OCException#nsexception

      NSExceptionを返します。



== OSX::NSPointクラス

Foundationフレームワークで定義されているデータ型((|NSPoint|))をRuby世
界で扱うためのクラスです。

=== OSX::NSPointクラスのクラスメソッド

--- OSX::NSPoint.new(x,y)

=== OSX::NSPointクラスのインスタンスメソッド

--- OSX::NSPoint#x
--- OSX::NSPoint#y
--- OSX::NSPoint#x= (val)
--- OSX::NSPoint#y= (val)

--- OSX::NSPoint#to_a

      配列((|[x, y]|))を返します。


== OSX::NSSizeクラス

Foundationフレームワークで定義されているデータ型((|NSSize|))をRuby世界
で扱うためのクラスです。

=== OSX::NSSizeクラスのクラスメソッド

--- OSX::NSSize.new(width, height)

=== OSX::NSSizeクラスのインスタンスメソッド

--- OSX::NSSize#width
--- OSX::NSSize#height
--- OSX::NSSize#width= (val)
--- OSX::NSSize#height= (val)

--- OSX::NSSize#to_a

      配列((|[width, height]|))を返します。


== OSX::NSRectクラス

Foundationフレームワークで定義されているデータ型((|NSRect|))をRuby世界
で扱うためのクラスです。

=== OSX::NSRectクラスのクラスメソッド

--- OSX::NSRect.new(origin, size)
--- OSX::NSRect.new(x, y, width, height)

=== OSX::NSRectクラスのインスタンスメソッド

--- OSX::NSRect#origin
--- OSX::NSRect#size
--- OSX::NSRect#origin= (val)
--- OSX::NSRect#size= (val)

--- OSX::NSRect#to_a

      配列((|[[x, y], [width, height]]|))を返します。


== OSX::NSRangeクラス

Foundationフレームワークで定義されているデータ型((|NSRange|))をRuby世
界で扱うためのクラスです。

=== OSX::NSRangeクラスのクラスメソッド

--- OSX::NSRange.new(range)
--- OSX::NSRange.new(location, length)

=== OSX::NSRangeクラスのインスタンスメソッド

--- OSX::NSRect#location
--- OSX::NSRect#length
--- OSX::NSRect#location= (val)
--- OSX::NSRect#length= (val)

--- OSX::NSRect#to_a

      ((|[ location, length ]|))を返します。

--- OSX::NSRect#to_range

      RubyのRangeオブジェクトを返します。


$Date$
$Revision$
