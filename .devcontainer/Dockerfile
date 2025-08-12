# 使用一个稳定的基础镜像
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# 设置环境变量，避免安装过程中出现交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础的系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip ca-certificates wget sudo \
    libglu1-mesa fonts-liberation openjdk-11-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 克隆 Flutter 的 stable 分支
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /usr/local/flutter

# 【关键修复1】立刻把文件夹的所有权交给 codespace 用户，避免后续的“权限不足”问题
RUN chown -R codespace:codespace /usr/local/flutter

# 设置 Flutter 相关的环境变量
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# 注意：最后一行 WORKDIR 已经被我们删除了