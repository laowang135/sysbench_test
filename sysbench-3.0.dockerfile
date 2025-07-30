# 第一阶段：编译 Sysbench
FROM docker.m.daocloud.io/alpine:latest as builder

# 更新包管理器并安装必要的构建工具和依赖项
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk --no-cache update && \
    apk --no-cache add build-base automake autoconf libtool pkgconfig mariadb-dev openssl-dev mysql-client

# 下载和解压 Sysbench 源代码
COPY sysbench-1.0.20.tar.gz /sysbench-1.0.20.tar.gz
RUN tar -xf /sysbench-1.0.20.tar.gz

# 进入 Sysbench 源代码目录
WORKDIR /sysbench-1.0.20

# 生成配置文件
RUN ./autogen.sh

# 运行配置脚本
RUN ./configure

# 编译 Sysbench
RUN make

# 第二阶段：创建最终镜像
FROM docker.m.daocloud.io/alpine:latest

# 复制第一阶段中编译好的 Sysbench 可执行文件到最终镜像中
COPY --from=builder /sysbench-1.0.20/src/sysbench /usr/bin/mysql /usr/local/bin/
COPY sysbench-1.0.20.tar.gz sysbench-3.0.sh /
COPY --from=builder /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6.0.28  /usr/lib/libncursesw.so.6 /lib/
# 清理不需要的文件和依赖项
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk --no-cache add mariadb-connector-c openssl libgcc  && \
    rm -rf /var/cache/apk/* && \
    tar -xf /sysbench-1.0.20.tar.gz && \
    rm -f /sysbench-1.0.20.tar.gz && \
    mkdir /script && \
    mv /sysbench-3.0.sh /script/sysbench.sh && \
    ln -s /sysbench-1.0.20 /sysbench && \
    ln -s /script/sysbench.sh /sysbench/sysbench.sh

# 进入 Sysbench 源代码目录
WORKDIR /sysbench-1.0.20

# RUN 
# 指定默认命令，可以在容器中运行 Sysbench
#ENTRYPOINT ["sh","/sysbench-1.0.20/sysbench.sh"]
CMD ["sh","/sysbench/sysbench.sh"]
