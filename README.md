# zenjiro-bot-oci
Oracle Cloudで動かすTwitterボット
# インストール
- 必須: nkf, jq
- Python 実行環境は uv を推奨（run-all.sh は `uv run truncate.py` を使用）

```
# Ubuntu/Debian
sudo apt update
sudo apt install -y nkf jq curl

# uv のインストール（公式推奨）
curl -LsSf https://astral.sh/uv/install.sh | sh
# もしくは https://github.com/astral-sh/uv の手順に従ってください

# 依存関係の同期（uv プロジェクトがある場合）
# プロジェクトに pyproject.toml がある場合
# uv sync

# または requirements.txt を使う場合（uv pip を使用）
uv pip install -r requirements.txt
```

注意: truncate.py は twitter-text-python に依存します。uv の分離環境で実行されるため、依存が見つからない場合は、以下のいずれかで対応してください。
- プロジェクトを uv 管理（pyproject.toml を用意し `uv sync` 実行）
- 実行時に明示指定: `uv run --with twitter-text-python truncate.py`
- あるいは system 環境に導入して `uv run --system truncate.py` を使用

# 実行
$ export $(xargs < environment) && ./run-all.sh

## cron設定
ボットを定期的に実行するため、cronで以下のコマンドを設定してください：
```
cd /path/to/directory && export $(xargs < environment) && ./run-all.sh
```

# コードフォーマット
シェルスクリプトのフォーマットを統一するため、shfmtを使用します。
tweet.shは除外してフォーマットを実行してください。

```
$ find . -name "*.sh" -not -name "tweet.sh" -exec shfmt -w {} +
```
