FROM buildpack-deps:jessie-scm

# Can't use existing mono image since it's on wheezy and chrome needs libstdc++.so.6 >= 4.8.0

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV MONO_VERSION 4.8.1.0

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF  \
    && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
    && echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/$MONO_VERSION main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
    && apt-get update \
    && apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl mono-complete \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update \
      && apt-get install wget -y \
      && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
      && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
      && apt-get update \
      && apt-get install xvfb unzip google-chrome-stable -y \
      && wget https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip \
      && unzip -d /usr/local/bin chromedriver_linux64.zip

WORKDIR /app
COPY . .

# WHY sh? I DON'T EVEN KNOW
# xvfb-run doesn't seemt to be like being called from ENTRYPOINT
ENTRYPOINT ["sh","-c", "xvfb-run -a fsharpi canopy.fsx"]
