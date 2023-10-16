#!/bin/bash
# DATE 2023-10-15
# VERSION 2.0
# DESC sysbench tool benchmark
# 测试参数的默认值
# 并发线程32
# 表的个数32
# 表的行数100万
# 注意事项：
# sysbenc连接到数据库的账户的认证方式需采用本地验证！！！
# 防止生产大量的日志文件，建议关闭慢查询日志
# 存储sysbench_db信息的表
mysql_host=172.17.139.180
sysbench_db_info_table=${mysql_db:=sysbench_test_db}_info_table
mkdir /sysbench_log_dir &>/dev/null
sysbench_log="/sysbench_log_dir/sysbench_log_$(date +%H%M).log"
echo -e "\n\n$(date)\nsysbech 工具功能列表\n \
#1.准备数据 \n \
2.综合读写TPS\n \
3.只读性能\n \
4.写入性能\n \
5.删除性能\n \
6.更新索引字段性能 \n \
7.更新非索引字段性能\n \
8.清除数据">>${sysbench_log}
# num0 请输入要执行的操作
function mysql_cmd(){
	mysql -u${mysql_user:='admin'}  -p${mysql_password:='!QAZ2wsx'} -h${mysql_host} -P${mysql_port:=3307}  -Nse "$1" >>${sysbench_log} 2>&1
}
function sysbench_run(){
	num0=$1
	case $num0 in 
	1)
	#	mysql -u${mysql_user:='admin'}  -p${mysql_password:='!QAZ2wsx'} -h${mysql_host} -P${mysql_port:=3307}  <<eof
	#create database if not exists ${mysql_db:=sysbench_test_db};
	# set global slow_query_log=off;
	#exit
	#eof
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307} --mysql-user=${mysql_user:='admin'} --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3} --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_read_write --mysql-ignore-errors=all prepare >> ${sysbench_log}
		;;
	2)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'} --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_read_write --mysql-ignore-errors=all run >> ${sysbench_log}
		;;
	3)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_read_only  --mysql-ignore-errors=all run >> ${sysbench_log}
		;;
	4)
		
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_write_only --mysql-ignore-errors=all run >> ${sysbench_log}
		;;
	5)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_delete  --mysql-ignore-errors=all run >> ${sysbench_log}
		;;
	6)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_update_index --mysql-ignore-errors=all  run >> ${sysbench_log}
		;;
	7)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_update_non_index --mysql-ignore-errors=all  run >> ${sysbench_log}
		;;
	8)
		sysbench --db-driver=mysql  --mysql-host=${mysql_host} --mysql-port=${mysql_port:=3307}  --mysql-user=${mysql_user:='admin'}  --mysql-password=${mysql_password:='!QAZ2wsx'} --mysql-db=${mysql_db:=sysbench_test_db} --db-ps-mode=disable --threads=${threads:=32}  --time=${test_time:=60} --report-interval=${report_interval:=3}  --tables=${tables:=32} --table_size=${table_size:=1000000} oltp_read_write  cleanup >> ${sysbench_log}
		;;
	*)
		echo "Please check the num0 variable value!" >> ${sysbench_log}
		exit 5
		;;
	esac
}

mysql_cmd "create database if not exists ${mysql_db:=sysbench_test_db};"
mysql_cmd "create table if not exists ${mysql_db:=sysbench_test_db}.${sysbench_db_info_table} (id int primary key,tables int,table_size int);"
if [ $? -ne 0 ];then
	echo "mysql执行SQL失败!!!请检查" >>${sysbench_log}
	exit 1
fi
# 检查参数是否为1个且为整数，并在1-8之间
if [ $# -eq 1 ] && [[ $1 =~ ^[2-8]$ ]]; then
	if [[ $1 =~ ^[2-7]$ ]];then
	    echo "参数传入为$1,验证测试端是否有数据存在...">>${sysbench_log}
			sysbench_test_db_info=$(mysql -u${mysql_user:='admin'}  -p${mysql_password:='!QAZ2wsx'} -h${mysql_host} -P${mysql_port:=3307}  -Nse "select * from ${mysql_db:=sysbench_test_db}.${sysbench_db_info_table};")
			echo $sysbench_test_db_info
			if [ -z "$sysbench_test_db_info" ];then
				echo "${mysql_db:=sysbench_test_db}.${sysbench_db_info_table}信息为空，开始写入数据..." >>${sysbench_log}
				sysbench_run 1
				if [ $? -eq 0 ];then 
					mysql_cmd "insert into ${mysql_db:=sysbench_test_db}.${sysbench_db_info_table} (id,tables,table_size) values (1,${tables},${table_size});"
					if [ $? -eq 0 ];then
						sysbench_run $1
					else
						echo "插入测试数据失败!!!" >>${sysbench_log}
						exit 2
					fi
				else
					echo "记录测试数据信息失败!!!" >>${sysbench_log}
					exit 3
				fi
			else
				tables=$(echo "${sysbench_test_db_info}" | awk '{print $2}')
				table_size=$(echo "${sysbench_test_db_info}" | awk '{print $3}')
				sysbench_run $1
			fi
	else 
	    echo "参数传入为$1,执行功能列表第${1}项操作..." >> ${sysbench_log}
		mysql_cmd "delete from ${mysql_db:=sysbench_test_db}.${sysbench_db_info_table} where id = 1;"
		sysbench_run $1
	fi
else
  echo -e "请输入2-8的整数..数值说明请查看$0功能列表">>${sysbench_log}
  exit 4
fi


