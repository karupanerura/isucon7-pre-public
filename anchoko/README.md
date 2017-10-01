# ISUCON7あんちょこ

* [Ansible](https://github.com/karupanerura/isucon7-pre/blob/master/ansible/README.md)
* [スタートダッシュ](https://github.com/karupanerura/isucon7-pre/blob/master/anchoko/START-DASH.md)
* [負荷分析](https://github.com/karupanerura/isucon7-pre/blob/master/anchoko/FUKABUNSEKI.md)

## スロークエリログの分析

設定は [config/mysqld.cnf](https://github.com/karupanerura/isucon7-pre/blob/master/config/mysqld.cnf) を確認すること
基本的には `/tmp/mysql-slow.log` に出るはず。

### 時間順に出す

```bash
sudo mysqldumpslow -s t /tmp/mysql-slow.log
```

### 回数順に出す

```bash
sudo mysqldumpslow -s c /tmp/mysql-slow.log
```

### digest

```bash
sudo pt-query-digest /tmp/mysql-slow.log
```

## アクセスログの分析

https://github.com/tkuchiki/alp

```bash
alp -f /tmp/nginx.access.log
alp -f /tmp/nginx.access.log --sum
alp -f /tmp/nginx.access.log --cnt
alp -f /tmp/nginx.access.log --start-time "11:45:39+09:00"
alp -f /tmp/nginx.access.log --start-time-duration 2m
alp -f /tmp/nginx.access.log --aggregates "/diary/entry/\d+"
```

## ログのローテート

```bash
sudo -H logrotate.pl nginx /var/log/nginx/access.log
sudo -H logrotate.pl mysql /tmp/mysql-slow.log
```

## コンフィグテスト

```bash
sudo nginx -t
sudo h2o -c /etc/h2o/h2o.conf -t
```

## nginx

```bash
systemctl restart nginx
```

## h2o

```bash
systemctl restart h2o
```

## mysql

```bash
systemctl restart mysql
```

## gzip圧縮

```bash
gzip -r js css
gzip -k index.html
```

## netstat

```bash
sudo netstat -tlnp
sudo netstat -tnp | grep ESTABLISHED
```

## ss

```bash
sudo ss -nlp
```

## ip

```bash
sudo ip addr show
sudo ip route show
sudo ip tunnel show
```

## lsof

```bash
sudo lsof -nP -i4TCP -sTCP:LISTEN
sudo lsof -nP -i4TCP -sTCP:ESTABLISHED
```

## iostat

```bash
sudo iostat -d -x -t 2
```

## dstat

```bash
sudo dstat -tam 10
```

## ss

```bash
sudo ss -nlp
```

## top

```bash
sudo top -d1
```

## pidstat

```bash
sudo pidstat -d -t -p $PID 2 # IO
sudo pidstat -s -t -p $PID 2 # CPU
sudo pidstat -u -t -p $PID 2 # STACK
sudo pidstat -r -t -p $PID 2 # MEMORY
sudo pidstat -v -t -p $PID 2 # KERNEL
```

## strace

```bash
sudo strace -p $PID
```

## systemd
### 起動系を直す

```
sudo -H systemctl stop SERVICE
sudo -H systemctl disable SERVICE
sudo -H systemctl enable SERVICE
```

### アプリ

```
sudo -H systemctl start SERVICE
sudo -H systemctl stop SERVICE
sudo -H systemctl restart SERVICE
```

### 設定ファイル

```
cat /etc/systemd/system/SERVICE.service
```

## mysqldump
```
mysqldump -u$MYSQL_USER -p$MYSQL_PASS $DATABASE $TABLE1 $TABLE2 --single-transaction > isucon7.dump
```

## 開発環境の mysql setup
```
echo 'CREATE USER $MYSQL_USER IDENTIFIED BY $MYSQL_PASS; GRANT ALL PRIVILEGES ON ${DATABASE}.*' | mysql -uroot'
```

## バイブル

http://blog.father.gedow.net/2012/10/23/linux-command-for-trouble/
