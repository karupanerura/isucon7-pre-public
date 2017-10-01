# 負荷分析

とりあえず悪いことは言わないから`sudo -i`とかでrootになっておこう。
この下の操作は全部rootです。

標語: 推測するな、計測せよ

## CPUネックかIOネックかを切り分ける

大局的にどの方向性の改善が効きそうかを切り分けます。
dstatやiostatなどでみるのがいいでしょう。

```
dstat -tam 10
iostat -d -x -t 2
```

勘所:

* CPU
  * User+Sysが100%に近い状態が続くorスパイクのタイミングで来るなら間違いなくCPUネック
    * Userが多い場合はアプリケーションの処理そのものが重い可能性が高い
    * Sysが多い場合はシステムコールの呼び出し回数などが多い可能性が高い
  * IO Waitが高ければIOも負荷が高い可能性がある
  * 25%など `100/N` な値に張り付いている場合は遊んでいるコアがいてうまく複数のCPUが活用できていない可能性がある
* メモリ
  * Free領域がゼロに近ければswapを使っている可能性が高い
  * Buffer/Cache が少ない場合はIO性能が悪くなる場合がある
  * Swap In/Outが高い場合はIO性能/メモリアクセス性能に影響が出る場合があるので要注意
* ネットワーク
  * どれくらいトラフィックが出ているのか要観察
  * どこかでサチる場合は帯域制限を疑う
* I/O
  * Writeが多いかReadが多いかで対策が変わる

## どのプロセスが悪そうか切り分ける

IO/CPUどちらが問題として大きいかが分かったら、その原因がどのプロセスにありそうか突き止めよう。
topであたりを付けつつ細かい値はpidstatでみるとよい。

```
top -d1
pidstat -d -t -p $PID 2 # IO
pidstat -s -t -p $PID 2 # CPU
pidstat -u -t -p $PID 2 # STACK
pidstat -r -t -p $PID 2 # MEMORY
pidstat -v -t -p $PID 2 # KERNEL
```

勘所:

* 一時的に詰まるという場合もあるのでしばらく観察することがだいじ

mysqlとかアプリとかworkerとか何かしらあやしいポイントが見えてくるはずです。

## プロファイリング

原因が見えてきたあとはpt-query-digest/mysqldumpslow/alpなどを適宜活用しましょう。
調べ方がよくわからないときは、相談！

```
alp -f /tmp/nginx.access.log
alp -f /tmp/nginx.access.log --sum
alp -f /tmp/nginx.access.log --cnt
alp -f /tmp/nginx.access.log --start-time "11:45:39+09:00"
alp -f /tmp/nginx.access.log --start-time-duration 2m
alp -f /tmp/nginx.access.log --aggregates "/diary/entry/\d+"
```
