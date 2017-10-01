# install

devサーバーでは最初から入れてある。

```bash
brew install ansible
```

# ホスト情報を更新

初回のみ。 `FILL ME` とコメントされてるところにIPを改行区切りで書けばOK。

```bash
$EDITOR hosts
git commit -m 'set hosts' hosts
```

# run

## 初回構築

```bash
ansible-playbook -i hosts playbook.yaml --tags init
```

## nginx

```bash
ansible-playbook -i hosts playbook.yaml --tags nginx
```

## mysql

```bash
ansible-playbook -i hosts playbook.yaml --tags mysql
```

## supervisor

```bash
ansible-playbook -i hosts playbook.yaml --tags supervisor
```

## h2o

```bash
ansible-playbook -i hosts h2o.yaml --tags build
```

### 設定のみ

```bash
ansible-playbook -i hosts h2o.yaml --tags configute
```
