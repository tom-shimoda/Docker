# nginx 特定IPアドレス以外からのアクセスにクライアント認証をかける
[参考](https://zoo200.net/nginx-client-verify/)


- geoipモジュールは公式Dockerイメージにすでに組み込まれている

- /etc/nginx/conf.d/*.confではload_moduleを使用できないので、/etc/nginx/nginx.confに記述する必要がある
[参考](https://stackoverflow.com/questions/75926469/nginx-load-module-directive-is-not-allowed-here)
