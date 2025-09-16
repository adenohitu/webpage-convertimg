# WebPage Screenshot API

WebページのスクリーンショットをPNG形式で撮影するシンプルなAPIサーバーです。

## 機能

- 指定したURLのWebページのスクリーンショットを撮影
- ウィンドウサイズをカスタマイズ可能
- Docker環境で安定した動作
- 日本語フォント対応

## セットアップ

### ローカル環境

```bash
npm install
npm run dev
```

サーバーが `http://localhost:3000` で起動します。

### Docker環境（推奨）

#### ローカルビルド

```bash
docker compose up -d
```

#### GitHub Container Registry（GHCR）のイメージを使用

```bash
docker run -d -p 3000:3000 ghcr.io/ri/webpage-convertimg:latest
```

または、docker-compose.ymlを以下のように変更：

```yaml
services:
  screenshot-api:
    image: ghcr.io/ri/webpage-convertimg:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
```

Docker環境では安定したChromium環境とフォントが利用できます。

## API使用方法

### エンドポイント

`POST /screenshot`

### リクエストパラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|---|---|---|---|---|
| `url` | string | ✓ | - | スクリーンショットを撮影するWebページのURL |
| `width` | number | - | 1920 | ウィンドウの幅（px） |
| `height` | number | - | 1080 | ウィンドウの高さ（px） |

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

#### JavaScript/Node.jsでの使用例

```javascript
const response = await fetch('http://localhost:3000/screenshot', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    url: 'https://example.com',
    width: 1280,
    height: 720
  })
});

const buffer = await response.arrayBuffer();
const fs = require('fs');
fs.writeFileSync('screenshot.png', Buffer.from(buffer));
```

## レスポンス

成功時はPNG形式の画像データを返します（Content-Type: image/png）。

エラー時はJSONでエラーメッセージを返します：

```json
{
  "error": "URL is required"
}
```

## 停止方法

### ローカル環境

`Ctrl + C`でプロセスを停止

### Docker環境

```bash
docker compose down
```

## Docker Image

### 利用可能なタグ

- `latest`: 最新版
- `v1.0.0`, `1.0.0`, `1.0`, `1`: セマンティックバージョニング対応

### イメージの場所

GitHub Container Registry: `ghcr.io/ri/webpage-convertimg`

### リリース方法

新しいバージョンをリリースするには、以下のようにタグを作成：

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actionsが自動的にマルチアーキテクチャ（AMD64/ARM64）のDockerイメージをビルドし、GHCRにプッシュします。

## 技術仕様

- **フレームワーク**: Hono
- **ブラウザエンジン**: Puppeteer (Chromium)
- **対応フォント**: Noto、Liberation、DejaVu、日本語フォント
- **出力形式**: PNG
- **サポートアーキテクチャ**: AMD64、ARM64
