# 基于微软 devcontainer 基础镜像（Ubuntu 22.04）
FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-22.04

ARG FLUTTER_DIR=/usr/local/flutter
ENV FLUTTER_HOME=${FLUTTER_DIR}
ENV PUB_CACHE=/workspaces/.pub-cache
ENV DEBIAN_FRONTEND=noninteractive

# 基本依赖：git/curl/unzip/xz/openjdk（Android 构建需要 Java）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip libglu1 libgl1 libx11-6 \
      procps sudo gnupg dirmngr openjdk-11-jdk-headless fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# 克隆 Flutter stable 分支（浅克隆以减小体积）
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_DIR} \
    && chmod -R a+rX ${FLUTTER_DIR}

# 将 Flutter 路径写入 /etc/profile.d，供所有 shell 使用
RUN echo "export FLUTTER_HOME=${FLUTTER_DIR}" > /etc/profile.d/flutter.sh \
    && echo "export PATH=${FLUTTER_DIR}/bin:${FLUTTER_DIR}/bin/cache/dart-sdk/bin:\$PATH" >> /etc/profile.d/flutter.sh \
    && chmod +x /etc/profile.d/flutter.sh

# 创建 pub cache 并修正权限
RUN mkdir -p ${PUB_CACHE} \
    && chown -R vscode:root ${PUB_CACHE} ${FLUTTER_DIR}

# 为非 root 的 vscode 用户设置 PATH 环境（VS Code 连接时会使用）
USER vscode
ENV PATH=${FLUTTER_DIR}/bin:${FLUTTER_DIR}/bin/cache/dart-sdk/bin:${PATH}

# 试着预热 flutter（若网络或依赖问题不会导致失败）
RUN bash -lc "if command -v flutter >/dev/null 2>&1; then flutter --version || true; fi"

EXPOSE 8080 5555
