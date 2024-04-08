# ダウンロードは初回のみでよい
# curl -sO http://localhost:8080/jnlpJars/agent.jar

# スクリプト実行時のカレントディレクトでagent.jarを探してしまうので、jarファイルは絶対パスに直す必要がある
java -jar /home/user/Documents/jenkins_slave/agent.jar -url http://localhost:8080/ -secret <シークレットコード> -name wsl -workDir "/home/user/Documents/jenkins_slave/jenkins_home"

