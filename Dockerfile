FROM node:18-slim

# Install necessary packages for Puppeteer
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    fonts-dejavu-core \
    fonts-noto-core \
    fonts-noto-color-emoji \
    fonts-ipafont-gothic \
    fonts-ipafont-mincho \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Configure font priorities for Japanese
RUN echo '<?xml version="1.0"?>' > /etc/fonts/local.conf && \
    echo '<!DOCTYPE fontconfig SYSTEM "fonts.dtd">' >> /etc/fonts/local.conf && \
    echo '<fontconfig>' >> /etc/fonts/local.conf && \
    echo '  <alias>' >> /etc/fonts/local.conf && \
    echo '    <family>sans-serif</family>' >> /etc/fonts/local.conf && \
    echo '    <prefer>' >> /etc/fonts/local.conf && \
    echo '      <family>IPAexGothic</family>' >> /etc/fonts/local.conf && \
    echo '      <family>Liberation Sans</family>' >> /etc/fonts/local.conf && \
    echo '      <family>DejaVu Sans</family>' >> /etc/fonts/local.conf && \
    echo '    </prefer>' >> /etc/fonts/local.conf && \
    echo '  </alias>' >> /etc/fonts/local.conf && \
    echo '  <alias>' >> /etc/fonts/local.conf && \
    echo '    <family>serif</family>' >> /etc/fonts/local.conf && \
    echo '    <prefer>' >> /etc/fonts/local.conf && \
    echo '      <family>IPAexMincho</family>' >> /etc/fonts/local.conf && \
    echo '      <family>Liberation Serif</family>' >> /etc/fonts/local.conf && \
    echo '      <family>DejaVu Serif</family>' >> /etc/fonts/local.conf && \
    echo '    </prefer>' >> /etc/fonts/local.conf && \
    echo '  </alias>' >> /etc/fonts/local.conf && \
    echo '  <alias>' >> /etc/fonts/local.conf && \
    echo '    <family>monospace</family>' >> /etc/fonts/local.conf && \
    echo '    <prefer>' >> /etc/fonts/local.conf && \
    echo '      <family>IPAGothic</family>' >> /etc/fonts/local.conf && \
    echo '      <family>Liberation Mono</family>' >> /etc/fonts/local.conf && \
    echo '      <family>DejaVu Sans Mono</family>' >> /etc/fonts/local.conf && \
    echo '    </prefer>' >> /etc/fonts/local.conf && \
    echo '  </alias>' >> /etc/fonts/local.conf && \
    echo '</fontconfig>' >> /etc/fonts/local.conf

# Tell Puppeteer to use chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]