# WebPage Screenshot API

Web ページのスクリーンショットを PNG 形式で撮影するシンプルな API サーバーです。

## 機能

- 指定した URL の Web ページのスクリーンショットを撮影
- ウィンドウサイズをカスタマイズ可能
- Docker 環境で安定した動作
- 日本語フォント対応

## セットアップ

### ローカル環境

```bash
npm install
npm run dev
```

サーバーが `http://localhost:3000` で起動します。

### Docker 環境（推奨）

#### ローカルビルド

```bash
docker compose up -d
```

#### GitHub Container Registry（GHCR）のイメージを使用

```bash
docker run -d -p 3000:3000 ghcr.io/adenohitu/webpage-convertimg:latest
```

または、docker-compose.yml を以下のように変更：

```yaml
services:
  screenshot-api:
    image: ghcr.io/adenohitu/webpage-convertimg:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
```

Docker 環境では安定した Chromium 環境とフォントが利用できます。

## API 使用方法

### エンドポイント

`POST /screenshot`

### リクエストパラメータ

| パラメータ | 型     | 必須 | デフォルト | 説明                                          |
| ---------- | ------ | ---- | ---------- | --------------------------------------------- |
| `url`      | string | ✓    | -          | スクリーンショットを撮影する Web ページの URL |
| `width`    | number | -    | 1920       | ウィンドウの幅（px）                          |
| `height`   | number | -    | 1080       | ウィンドウの高さ（px）                        |

### 使用例

#### デフォルトサイズ（1920x1080）でスクリーンショット

```bash
curl -X POST http://localhost:3000/screenshot \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}' \
  --output screenshot.png
```

#### カスタムサイズでスクリーンショット

```bash
curl -X POST http://localhost:3000/screenshot \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "width": 800, "height": 600}' \
  --output screenshot.png
```

#### JavaScript/Node.js での使用例

```javascript
const response = await fetch("http://localhost:3000/screenshot", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    url: "https://example.com",
    width: 1280,
    height: 720,
  }),
});

const buffer = await response.arrayBuffer();
const fs = require("fs");
fs.writeFileSync("screenshot.png", Buffer.from(buffer));
```

## レスポンス

成功時は PNG 形式の画像データを返します（Content-Type: image/png）。

エラー時は JSON でエラーメッセージを返します：

```json
{
  "error": "URL is required"
}
```

## 停止方法

### ローカル環境

`Ctrl + C`でプロセスを停止

### Docker 環境

```bash
docker compose down
```

## Docker Image

### 利用可能なタグ

- `latest`: 最新版
- `v1.0.0`, `1.0.0`, `1.0`, `1`: セマンティックバージョニング対応

### イメージの場所

GitHub Container Registry: `ghcr.io/adenohitu/webpage-convertimg`

### リリース方法

新しいバージョンをリリースするには、以下のようにタグを作成：

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions が自動的にマルチアーキテクチャ（AMD64/ARM64）の Docker イメージをビルドし、GHCR にプッシュします。

## 技術仕様

- **フレームワーク**: Hono
- **ブラウザエンジン**: Puppeteer (Chromium)
- **対応フォント**: Noto、Liberation、DejaVu、日本語フォント
- **出力形式**: PNG
- **サポートアーキテクチャ**: AMD64、ARM64
