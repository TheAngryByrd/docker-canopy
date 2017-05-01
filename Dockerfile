FROM fsharp:4.1.0.1

ENV CHROME_DRIVER_VERSION 2.29

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
      && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
      && apt-get update \
      && apt-get install xvfb unzip google-chrome-stable -y \
      && wget https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
      && unzip -d /usr/local/bin chromedriver_linux64.zip

WORKDIR /app
COPY . .

# WHY sh? I DON'T EVEN KNOW
# xvfb-run doesn't seemt to be like being called from ENTRYPOINT
ENTRYPOINT ["sh","-c", "xvfb-run -a fsharpi canopy.fsx"]
