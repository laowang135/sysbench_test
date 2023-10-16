# sysbench_test

===docker file===
docker file 使用apline
docker build命令:docker build -t sysbench-alpine:v2.0 -f ./sysbench.dockerfile .

===k8s yaml文件===

k8s使用镜像需要以下传入参数(带*号为必填项)：
1)MySQL地址*
mysql_host="172.17.139.180"
2)MySQL端口*
mysql_port="3307"
3)MySQL用户*
mysql_user="admin"
4)MySQL密码*
mysql_password="!QAZ2wsx"
5)压测时间(不传参时，默认60s)
test_time=30
6)输出信息间隔时间(不传参时，默认3秒)
report_interval=3
7)并发线程数量(不传参时，默认128个)
threads=128
8)测试表数量(不传参时，默认128个)
tables=128 
9)测试表行数(不传参时，默认500万行)
table_size=5000

===docker镜像===
sysbech工具功能列表
1.准备数据(已注释,使用2-7功能默认造数)
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
