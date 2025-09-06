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

# 依存関係の同期（uv 推奨）
# プロジェクトに pyproject.toml / uv.lock が含まれているため、まず同期
uv sync

# または requirements.txt を使う場合（uv pip を使用）
uv pip install -r requirements.txt
```

注意: truncate.py は twitter-text-parser に依存します。uv 環境で確実に動かすには、以下のいずれかを実施してください。
- プロジェクトを uv 管理し `uv sync`（pyproject.toml/uv.lock に依存を定義済み）
- 実行時に明示指定: `uv run --with twitter-text-parser --with setuptools truncate.py`
- あるいは system 環境に導入して `uv run --system truncate.py` を使用（setuptools が必要）

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
