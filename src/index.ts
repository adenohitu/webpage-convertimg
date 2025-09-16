import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import puppeteer from 'puppeteer'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.post('/screenshot', async (c) => {
  try {
    const body = await c.req.json()
    const { url, width = 1920, height = 1080 } = body

    if (!url) {
      return c.json({ error: 'URL is required' }, 400)
    }

    const browser = await puppeteer.launch()
    const page = await browser.newPage()

    await page.setViewport({ width: parseInt(width), height: parseInt(height) })
    await page.goto(url, { waitUntil: 'networkidle2' })

    const screenshot = await page.screenshot({ type: 'png' })
    await browser.close()

    return new Response(Buffer.from(screenshot), {
      headers: { 'Content-Type': 'image/png' }
    })
  } catch (error) {
    return c.json({ error: 'Failed to take screenshot' }, 500)
  }
})

serve({
  fetch: app.fetch,
  port: 3000
}, (info) => {
  console.log(`Server is running on http://localhost:${info.port}`)
})
