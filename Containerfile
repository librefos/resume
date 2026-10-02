FROM debian:bookworm-slim AS fonts

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && mkdir -p /opt/fonts/cormorant \
    && wget -q -O /opt/fonts/cormorant/CormorantGaramond-Regular.ttf https://raw.githubusercontent.com/CatharsisFonts/Cormorant/master/fonts/ttf/CormorantGaramond-Regular.ttf \
    && wget -q -O /opt/fonts/cormorant/CormorantGaramond-Italic.ttf https://raw.githubusercontent.com/CatharsisFonts/Cormorant/master/fonts/ttf/CormorantGaramond-Italic.ttf \
    && wget -q -O /opt/fonts/cormorant/CormorantGaramond-Bold.ttf https://raw.githubusercontent.com/CatharsisFonts/Cormorant/master/fonts/ttf/CormorantGaramond-Bold.ttf \
    && wget -q -O /opt/fonts/cormorant/CormorantGaramond-BoldItalic.ttf https://raw.githubusercontent.com/CatharsisFonts/Cormorant/master/fonts/ttf/CormorantGaramond-BoldItalic.ttf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

ARG VCS_REF="unknown"
ARG BUILD_DATE="unknown"
ARG VERSION="latest"

LABEL org.opencontainers.image.title="texlive-resume" \
      org.opencontainers.image.description="Lightweight XeLaTeX environment for resume PDF compilation" \
      org.opencontainers.image.authors="Thiago C. Silva" \
      org.opencontainers.image.url="https://github.com/librefos/resume" \
      org.opencontainers.image.source="https://github.com/librefos/resume" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.vendor="librefos" \
      org.opencontainers.image.base.name="debian:bookworm-slim" \
      org.opencontainers.image.ref.name="${VERSION}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

COPY --from=fonts /opt/fonts/cormorant /usr/local/share/fonts/cormorant

RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    texlive-fonts-recommended \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-lang-portuguese \
    texlive-xetex \
    && fc-cache -f \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh

CMD ["build.sh"]
