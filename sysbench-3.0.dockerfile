# 第一阶段：编译 Sysbench
FROM docker.m.daocloud.io/alpine:latest as builder

# 更新包管理器并安装必要的构建工具和依赖项
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk --no-cache update && \
    apk --no-cache add curl build-base automake autoconf libtool pkgconfig mariadb-dev openssl-dev mysql-client

# 下载和解压 Sysbench 源代码
RUN curl -O https://gitee.com/wy135575/sysbench_test/raw/main/sysbench-1.0.20.tar.gz && \
    tar -xf /sysbench-1.0.20.tar.gz

# 进入 Sysbench 源代码目录
WORKDIR /sysbench-1.0.20

# 生成配置文件
RUN sh ./autogen.sh

# 运行配置脚本
RUN ./configure --prefix=/sysbench

# 编译 Sysbench
RUN make -j$(nproc) && \
    make install


# 第二阶段：创建最终镜像
FROM docker.m.daocloud.io/alpine:latest

# 复制第一阶段中编译好的 Sysbench 可执行文件到最终镜像中
COPY --from=builder /sysbench /sysbench
COPY --from=builder /usr/bin/mysql  /sysbench/bin
COPY sysbench-3.0.sh /sysbench.sh
# 清理不需要的文件和依赖项
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk --no-cache add mariadb-connector-c openssl libgcc libstdc++ ncurses-libs && \
    rm -rf /var/cache/apk/* && \
    ln -s /sysbench/bin/sysbench /usr/local/bin

ENV PATH="/sysbench/bin:$PATH"

# 进入 Sysbench 源代码目录
WORKDIR /sysbench

# RUN 
# 指定默认命令，可以在容器中运行 Sysbench
#ENTRYPOINT ["sh","/sysbench/sysbench.sh"]
CMD ["sh","/sysbench.sh"]
