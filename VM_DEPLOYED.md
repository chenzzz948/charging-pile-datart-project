# 虚拟机部署说明

本项目已在本地 VirtualBox 虚拟机中验证运行，核心环境如下：

```text
Hadoop: pseudo-distributed mode
MySQL: stores MapReduce result tables
Datart: BI dashboard and charts
```

## Hadoop

建议环境变量：

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
```

检查进程：

```bash
jps
```

应包含：

```text
NameNode
DataNode
SecondaryNameNode
ResourceManager
NodeManager
```

HDFS 输入：

```text
/Car/dsv13r2.csv
```

HDFS 输出：

```text
/Car/v1
/Car/v2
/Car/v3
/Car/v4
/Car/v5
/Car/v6
/Car/v7
```

查看输出：

```bash
for task in v1 v2 v3 v4 v5 v6 v7; do
  echo "===== $task ====="
  hdfs dfs -cat "/Car/$task/part-r-00000"
done
```

## MapReduce

源码：

```text
hadoop_mr/ChargingPileJobs.java
```

运行方式示例：

```bash
for task in v1 v2 v3 v4 v5 v6 v7; do
  hadoop jar target/charging-pile-mr.jar com.neu.datapro.ChargingPileJobs "$task"
done
```

## MySQL

导入结果表：

```bash
mysql -u<user> -p<password> < import_project.sql
```

查看表：

```sql
USE enger;
SHOW TABLES;
SELECT * FROM t_enger1 LIMIT 5;
```

## Datart

Datart 安装后创建 MySQL 数据源：

```text
name: enger_mysql
type: JDBC / MySQL
url: jdbc:mysql://localhost:3306/enger?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8
user: <your_mysql_user>
password: <your_mysql_password>
```

然后按 `datart_views.sql` 创建 7 个 SQL View，并创建 7 张图表与 1 个仪表板：

```text
Charging Pile Charts
Charging Pile Big Data Dashboard
```

## 安全说明

公开仓库不包含真实密码。请不要把虚拟机登录密码、数据库密码、Datart 管理员密码提交到公开仓库。

