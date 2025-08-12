# .devcontainer/Dockerfile

# 使用 Ubuntu 作为基础镜像
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

# 合并并优化安装系统依赖的命令，减少镜像层数
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip ca-certificates wget sudo \
    libglu1-mesa fonts-liberation openjdk-11-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 使用 ARG 定义 Flutter 版本，方便后续修改
ARG FLUTTER_VERSION="stable"

# 克隆 Flutter SDK 到指定目录，并把所有权交给 codespace 用户
RUN git clone --depth 1 -b ${FLUTTER_VERSION} https://github.com/flutter/flutter.git /usr/local/flutter && \
    chown -R codespace:codespace /usr/local/flutter

# 设置环境变量，确保 Flutter 和 Dart 命令可用
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# 预缓存 web 支持（可选，加快后续 flutter run web）
# 使用 USER codespace 切换到非 root 用户执行，更安全
USER codespace
RUN flutter precache --web || true

# 在构建期间运行一次检查，不会因失败而阻塞构建
RUN flutter doctor -v || true

# 设置 codespace 工作目录
WORKDIR /workspace
