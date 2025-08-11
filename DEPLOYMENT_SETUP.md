# Oracle Cloud VM デプロイ設定ガイド

## 概要
このガイドでは、GitHub ActionsからOracle Cloud VMへの自動デプロイを設定する手順を説明します。

## 必要なGitHubシークレット

GitHubリポジトリの Settings > Secrets and variables > Actions で以下のシークレットを設定してください：

### 必須シークレット

1. **OCI_SSH_PRIVATE_KEY**
   - Oracle Cloud VMにSSH接続するための秘密鍵
   - 形式: Ed25519秘密鍵（-----BEGIN OPENSSH PRIVATE KEY----- で始まる）
   - 取得方法: `ssh-keygen -t ed25519 -C "github-actions"`で生成

2. **OCI_VM_HOST**
   - Oracle Cloud VMのパブリックIPアドレスまたはホスト名
   - 例: `123.456.789.012` または `vm.example.com`

3. **OCI_VM_USER**
   - SSH接続に使用するユーザー名
   - Oracle Cloudのデフォルト: `opc`
   - Ubuntu VMの場合: `ubuntu`

### オプションシークレット

4. **OCI_BOT_DIRECTORY** (オプション)
   - VMでのボットプロジェクトのディレクトリパス
   - デフォルト: `/home/opc/zenjiro-bot-oci`
   - 例: `/home/ubuntu/bots/zenjiro-bot-oci`

## Oracle Cloud VM側の準備

### 1. SSH公開鍵の設定
```bash
# VMにSSH接続して公開鍵を追加
mkdir -p ~/.ssh
echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 2. 必要なソフトウェアのインストール
```bash
# Ubuntu/Debian の場合
sudo apt update
sudo apt install -y git nkf jq python3 python3-pip curl

# Oracle Linux の場合
sudo yum update -y
sudo yum install -y git python3 python3-pip curl
# nkf と jq は追加でインストールが必要な場合があります
```

### 3. プロジェクトのクローン
```bash
cd /home/opc  # または適切なディレクトリ
git clone https://github.com/YOUR_USERNAME/zenjiro-bot-oci.git
cd zenjiro-bot-oci
```

### 4. Python依存関係のインストール
```bash
pip3 install -r requirements.txt --user
```

### 5. 環境変数ファイルの設定
```bash
# environment ファイルを作成してTwitter API認証情報を設定
cp environment.example environment  # もしサンプルファイルがあれば
nano environment
```

### 6. 実行権限の設定
```bash
chmod +x *.sh
```

## セキュリティ考慮事項

### ファイアウォール設定
- SSH (ポート22) のみを許可
- 不要なポートは閉じる
- 可能であればGitHub ActionsのIPレンジのみ許可

### SSH設定の強化
```bash
# /etc/ssh/sshd_config の推奨設定
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

## トラブルシューティング

### よくある問題

1. **SSH接続エラー**
   - 公開鍵が正しく設定されているか確認
   - ファイアウォールでSSHポートが開いているか確認
   - known_hostsの問題: `ssh-keyscan -H YOUR_VM_IP`

2. **権限エラー**
   - SSH鍵のファイル権限を確認 (600)
   - スクリプトの実行権限を確認 (755)

3. **依存関係エラー**
   - nkf, jq, python3-pip がインストールされているか確認
   - requirements.txt の依存関係が正しくインストールされているか確認

4. **Git関連エラー**
   - VMでgit configが設定されているか確認
   - リポジトリの権限問題がないか確認

## デプロイフロー

1. mainブランチにコードをpush
2. GitHub Actionsが自動的にトリガー
3. VMにSSH接続
4. 現在のバージョンをバックアップ
5. 最新コードをpull
6. デプロイ結果を確認

## 手動デプロイ

GitHub ActionsのUIから「Run workflow」ボタンでも手動実行可能です。
