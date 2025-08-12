# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip ca-certificates wget sudo \
    libglu1-mesa fonts-liberation openjdk-11-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 克隆 Flutter stable（浅克隆加速）
# ... (前面的内容不变) ...

# 克隆 Flutter stable（浅克隆加速）
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /usr/local/flutter

# ！！！新增下面这行，把文件夹所有权交给 codespace 用户！！！
RUN chown -R codespace:codespace /usr/local/flutter

# 环境变量（把 flutter 和 dart 加入 PATH）
ENV FLUTTER_HOME=/usr/local/flutter

# ... (后面的内容不变) ...

# 环境变量（把 flutter 和 dart 加入 PATH）
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# 预缓存 web 支持（可选，加快后续 flutter run web）
RUN flutter precache --web || true

# 在构建期间运行一次检查（不会阻塞失败）
RUN flutter doctor -v || true

# codespace 工作目录（不必改）
WORKDIR /workspace
