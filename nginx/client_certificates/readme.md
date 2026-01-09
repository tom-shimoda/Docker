# クライアント証明書の発行手順
[参考元](https://qiita.com/tarosaiba/items/9fa3320b633e0f5e87b5)

## セキュリティの観点から手順1、2は別のマシンにて実行したほうがよい 
(今回はconoha-certbot:~/Documents/for_conoha-dev/client_certificates/で行った)

## 1. CA側
### 1-1. CAの鍵を作成
```sh
openssl genrsa -des3 -out ca.key 4096
```
password設定が求められるので、任意のパスワードを設定

→ ca.keyが作成される


### 1-2. CA 証明書を作成
```sh
openssl req -new -x509 -days 365 -key ca.key -out ca.crt
```
- 質問は以下のように設定
Country Name : JP
State : Tokyo
Locality Name : Osaki
Organization Name : AAAA
Organization Unit Name : 空
Common Name : 空
Email Address : 空
- 注意

→ ca.crtが作成される

---

## 2 クライアント証明書の作成
### 2-1. クライアント証明書用の鍵
```sh
openssl genrsa -des3 -out user.key 4096
```
password設定が求められるので、任意のパスワードを設定

→ user.keyが作成される


### 2-2. 署名
```sh
openssl req -new -key user.key -out user.csr
```
- 質問は以下のように設定
Country Name : JP
State : Tokyo
Locality Name : Osaki
Organization Name : BBBB
Organization Unit Name : 空
Common Name : 空
Email Address : 空
- 注意
※Organization Name は 1-2 手順で設定した、AAAAとは異なるものにする [参考](https://stackoverflow.com/questions/45628601/client-authentication-using-self-signed-ssl-certificate-for-nginx)

→ user.csrが作成される


### 2-3. CSRを署名
```sh
openssl x509 -req -days 365 -in user.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out user.crt
```

→ user.crtが作成される


### 2-4. PKCS #12 (PFX)の作成
```sh
openssl pkcs12 -export -out user.pfx -inkey user.key -in user.crt -certfile ca.crt
```
クライアント側でインポートする際に必要なパスワードを指定 (空でもOK)

→ user.pfxが作成される

---

## 3. Nginx側の設定
- ca.crtをNginxのバインドしたclient_certificatesフォルダに配置
- /etc/conf.d/nginx.confのserver{}スコープ内に以下を追加し、クライアント証明書の認証を有効化
```
ssl_client_certificate "/etc/nginx/client_certificates/ca.crt";
ssl_verify_client on;
```
nginx再起動

---

## 4. user.pfxをクライアントに渡して各ブラウザに設定


## Tips
- macの登録済みクライアント証明書の確認方法
1. キーチェインアクセス.appを開き、キーチェインアクセスを開くを選択
2. 左のタブよりiCloudタブを選択した後、ログインタブを再度選択 (不具合なのか一度別のタブに切り替えないと表示されない)

