# ついたら

## 開発環境のセットアップ

- `./anchoko/create_gcloud_instance.sh $NAME`

---

# レギュレーション確認・動作確認

- 読む、見る
- 大事なところは声に出して認識をすり合わせる
- とりあえずベンチ回してみる
- 方針を軽く相談

---

# はじめにやること

セットアップ組とコード読む組に分かれると吉。

## 1. ソースコードを push
- https://github.com/karupanerura/isucon7-pre/ に push

```bash
# isuconユーザーに俺はなる
sudo -i sudo -u isucon -i

# ssh-keyの作成
mkdir -m 0700 ~/.ssh
cat <<'SSH_PRIV_KEY_END' > ~/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
DUMMY DUMMY DUMMY
-----END RSA PRIVATE KEY-----
SSH_PRIV_KEY_END

# gitの設定
git config --global user.name isucon7-pre-server
git config --global user.email root@`hostname`
git config --global alias.st status
git config --global alias.df diff

# リポジトリのpush (DIR=たぶんwebapp)
cd $DIR
git init
git remote add origin git@github.com:karupanerura/isucon7-pre.git
git fetch
git checkout master
git add .
git status # 余計なバイナリとか謎の巨大ファイルとかをうっかり含んでないか確認 && あったら内容を確認しつつ不要なものを.gitignoreで排除
git commit -am 'added codes'
git push -u origin master
```

## 2. 初期データのバックアップ

- 基本は[mysqldump](https://github.com/karupanerura/isucon7-pre/tree/master/anchoko#mysqldump)で持ってく
- SimpleHTTPServer とかで雑にサーブしたら、開発サーバで wget
  - !! さクラウドで使用ポート（8000）が開いているか確認
- 量が多い場合はテーブル絞るなりする
- 逆に少なければ /var/lib/mysql を zip しちゃう

容量を確認:

```bash
du -sh /var/lib/mysql
```

### tarでかためる場合

```bash
mkdir ~/serve
cd ~/serve
sudo tar zcf mysql.tar.gz /var/lib/mysql
sudo chown isucon:isucon mysql.tar.gz
python -m SimpleHTTPServer
```

ダウンロードする:

```bash
wget $URL
tar zxvf mysql.tar.gz
sudo systemctl stop mysql
sudo mv /var/lib/mysql{,.bak}
sudo mv .data /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo systemctl start mysql
```

## 3. 競技サーバ初期セットアップ（Ansible）

* [Ansible](https://github.com/karupanerura/isucon7-pre-public/blob/master/ansible/README.md)

- [ ] hosts(ansible inventory)を設定
- [ ] nginxやmysqlの設定を変更
- [ ] LTSVのログが出ること
- [ ] slow query logなどが出るようになっていること

## 4.コードを読む
- isu6final のように理解するべきロジックが複数ある場合は、コード読む組を更に班分けする
- スペース入れた PR を出して、修正方針を残すコメントを書けるようにしておく

---

# セットアップが完了したら

## ベンチマーク回す
- [負荷分析](./FUKABUNSEKI.md)
  - dstat, alp などを準備してから回す

nginxの設定などが変わったことでスコアに影響が出るかもしれませんが気になさらず。
FAILしたら…頑張りましょう…。

---

# 作戦会議

これを踏まえて作戦会議をしましょう。
未来は君たちの手にかかっている！✨

