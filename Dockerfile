FROM ubuntu:24.04
ARG TARGETARCH 

# 1. Install EVERYTHING (Build tools + Runtime tools)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    wget \
    ca-certificates \
    python3 \
    nano \
    less \
    git \
    libxml2 \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Install srcML (Runtime and Dev headers together)
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      wget https://github.com/srcML/srcML/releases/download/v1.1.0/srcml_1.1.0-1_ubuntu24.04_amd64.deb \
      && wget https://github.com/srcML/srcML/releases/download/v1.1.0/srcml-dev_1.1.0-1_ubuntu24.04_amd64.deb; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      wget https://github.com/srcML/srcML/releases/download/v1.1.0/srcml_1.1.0-1_ubuntu24.04_arm64.deb \
      && wget https://github.com/srcML/srcML/releases/download/v1.1.0/srcml-dev_1.1.0-1_ubuntu22.04_arm64.deb; \
    else \
      echo "Unsupported arch: $TARGETARCH" && exit 1; \
    fi && \
    apt-get update && apt-get install -y ./*.deb && rm -f ./*.deb

# 3. Build and install srcSAX (Force standard paths so nameCollector finds it)
RUN mkdir -p /srcSAX \
    && wget -O /tmp/srcSAX.tar.gz https://github.com/srcML/srcSAX/archive/refs/heads/master.tar.gz \
    && tar -xzf /tmp/srcSAX.tar.gz -C /srcSAX --strip-components=1 \
    && rm /tmp/srcSAX.tar.gz
WORKDIR /srcSAX
RUN cmake -B build -G Ninja \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_INCLUDEDIR=include \
    && cd build \
    && ninja install

# 4. Build nameCollector
RUN mkdir -p /nameCollector \
    && wget -O /tmp/nameCollector.tar.gz https://github.com/srcML/nameCollector/archive/refs/heads/main.tar.gz \
    && tar -xzf /tmp/nameCollector.tar.gz -C /nameCollector --strip-components=1 \
    && rm /tmp/nameCollector.tar.gz
WORKDIR /nameCollector
RUN cmake -B build -G Ninja && cd build && ninja

# 5. Set default directory straight to the compiled binary
WORKDIR /nameCollector/build/bin