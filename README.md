# sysbench_test

===docker file===

docker file 使用apline

docker build命令:docker build -t sysbench-alpine:v2.0 -f ./sysbench.dockerfile .

===k8s yaml文件===

k8s使用镜像需要以下传入参数(带*号为必填项)：

1)MySQL地址*

mysql_host="172.17.139.180"

2)MySQL端口(默认值"16310")

mysql_port="16310"

3)MySQL用户(默认值"admin")

mysql_user="admin"

4)MySQL密码(默认值"!QAZ2wsx")

mysql_password="!QAZ2wsx"

5)压测时间(默认值60s)

test_time=60

6)输出信息间隔时间(默认值3秒)

report_interval=3

7)并发线程数量(默认值32个)

threads=32

8)测试表数量(默认值32个)

tables=32

9)测试表行数(默认值100万行)

table_size=1000000

===docker镜像===

sysbech工具功能列表

1.准备数据(1已注释,使用2-7功能默认造数)

2.综合读写TPS

3.只读性能

4.写入性能

5.删除性能

6.更新索引字段性能

7.更新非索引字段性能

8.清除数据

任选一项列表功能传入/sysbench/sysbench.sh脚本

镜像运行命令：sh /sysbench/sysbench.sh 2

日志打印在镜像/sysbench_log_dir目录下，需要映射到本地查看

创建的测试库名称为:sysbench_test_db

测试库中sysbench_test_db__info_table表，存储表数量和行数量
