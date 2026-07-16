# 新能源充电桩大数据项目本地部署说明

本文档用于帮助其他同学或老师从 GitHub 拉取项目后，在本地或虚拟机中把项目跑起来。项目完整链路为：

```text
CSV 数据集
  -> HDFS
  -> Hadoop MapReduce 七个分析任务
  -> MySQL 结果库 enger
  -> Datart 数据源 / SQL View / 图表 / 仪表板
```

如果只想查看最终可视化，只需要启动 MySQL 和 Datart；如果要证明项目全流程可运行，需要启动 Hadoop，并重新运行 MapReduce。

## 1. 推荐部署环境

建议使用 Linux 虚拟机部署，课程实训环境可以使用 VirtualBox / VMware + Ubuntu。

| 类型 | 推荐版本 | 作用 |
|---|---|---|
| 操作系统 | Ubuntu 18.04 / 20.04 / 22.04 | Hadoop、MySQL、Datart 运行环境 |
| JDK | JDK 8 | 编译和运行 Hadoop MapReduce 程序 |
| Hadoop | 2.7.x 或 3.x | HDFS 存储与 MapReduce 计算 |
| MySQL | 5.7 或 8.0 | 保存 MapReduce 统计结果，供 Datart 查询 |
| Datart | 1.x 或课程环境已安装版本 | BI 可视化平台 |
| Git | 任意较新版本 | 拉取项目代码 |
| Maven | 可选 | 如果后续改造成 Maven 项目，可用于打包 |

本项目仓库不包含虚拟机镜像、数据库密码、Datart 管理员密码等本地敏感信息。

## 2. 拉取项目

```bash
cd ~
git clone https://github.com/chenzzz948/charging-pile-datart-project.git
cd charging-pile-datart-project
```

项目主要目录：

```text
data/                 原始 CSV 数据集
hadoop_mr/            Java MapReduce 源码、运行日志、HDFS输出证明
results/              分析结果文件
reference_images/     可视化参考图
import_project.sql    MySQL 建库建表与结果导入脚本
datart_views.sql      Datart SQL View 查询语句
README.md             项目说明
DEPLOYMENT.md         本部署说明
```

数据集文件：

```text
data/dsv13r2.csv
data/nvv2t.csv
data/nvv2t_md.csv
```

## 3. 安装 JDK

Ubuntu 示例：

```bash
sudo apt update
sudo apt install -y openjdk-8-jdk
```

检查：

```bash
java -version
javac -version
```

配置环境变量，编辑 `~/.bashrc`：

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

使配置生效：

```bash
source ~/.bashrc
```

说明：

- Hadoop 课程环境通常使用 JDK 8 最稳。
- 如果系统实际 JDK 路径不同，用 `readlink -f $(which java)` 查看后调整 `JAVA_HOME`。

## 4. 安装并配置 Hadoop 伪分布式环境

### 4.1 下载和解压 Hadoop

示例路径使用 `/usr/local/hadoop`：

```bash
cd /usr/local
sudo tar -zxvf ~/Downloads/hadoop-*.tar.gz
sudo mv hadoop-* hadoop
sudo chown -R $USER:$USER /usr/local/hadoop
```

配置环境变量，编辑 `~/.bashrc`：

```bash
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
```

生效：

```bash
source ~/.bashrc
```

检查：

```bash
hadoop version
```

### 4.2 配置 Hadoop 的 JAVA_HOME

编辑：

```bash
vim /usr/local/hadoop/etc/hadoop/hadoop-env.sh
```

设置：

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

### 4.3 配置 core-site.xml

编辑：

```bash
vim /usr/local/hadoop/etc/hadoop/core-site.xml
```

写入：

```xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/usr/local/hadoop/tmp</value>
  </property>
</configuration>
```

### 4.4 配置 hdfs-site.xml

编辑：

```bash
vim /usr/local/hadoop/etc/hadoop/hdfs-site.xml
```

写入：

```xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/usr/local/hadoop/tmp/dfs/name</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/usr/local/hadoop/tmp/dfs/data</value>
  </property>
</configuration>
```

### 4.5 配置 mapred-site.xml

如果没有该文件，先复制模板：

```bash
cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml
```

编辑：

```bash
vim /usr/local/hadoop/etc/hadoop/mapred-site.xml
```

写入：

```xml
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```

### 4.6 配置 yarn-site.xml

编辑：

```bash
vim /usr/local/hadoop/etc/hadoop/yarn-site.xml
```

写入：

```xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
```

### 4.7 配置 SSH 免密登录

Hadoop 启动脚本需要通过 SSH 启动本机服务。

```bash
sudo apt install -y openssh-server
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh localhost
```

第一次连接输入 `yes`。

### 4.8 初始化 HDFS

只在第一次部署时执行：

```bash
hdfs namenode -format
```

注意：不要反复执行 `hdfs namenode -format`，否则可能清空 HDFS 元数据。

### 4.9 启动 Hadoop

```bash
start-dfs.sh
start-yarn.sh
```

检查进程：

```bash
jps
```

正常应看到：

```text
NameNode
DataNode
SecondaryNameNode
ResourceManager
NodeManager
```

如果执行 `hdfs dfs -ls /` 报 `Connection refused`，通常表示 `NameNode` 没有启动成功，需要先检查 `jps`。

## 5. 上传项目数据到 HDFS

进入项目目录：

```bash
cd ~/charging-pile-datart-project
```

创建 HDFS 目录：

```bash
hdfs dfs -mkdir -p /Car
```

上传数据：

```bash
hdfs dfs -put -f data/*.csv /Car/
```

检查：

```bash
hdfs dfs -ls /Car
hdfs dfs -cat /Car/dsv13r2.csv | head
```

本项目 MapReduce 主输入路径在代码中配置为：

```text
/Car/dsv13r2.csv
```

因此至少要保证 HDFS 中存在：

```text
/Car/dsv13r2.csv
```

## 6. 编译 MapReduce 程序

进入源码目录：

```bash
cd ~/charging-pile-datart-project/hadoop_mr
```

本项目核心源码：

```text
ChargingPileJobs.java
```

主类：

```text
com.neu.datapro.ChargingPileJobs
```

如果没有现成 jar 包，可以用 Hadoop 自带 classpath 编译：

```bash
mkdir -p build/classes
javac -encoding UTF-8 -classpath "$(hadoop classpath)" -d build/classes ChargingPileJobs.java
jar -cvf charging-pile-mr.jar -C build/classes .
```

检查：

```bash
ls charging-pile-mr.jar
```

## 7. 运行 7 个 MapReduce 任务

```bash
cd ~/charging-pile-datart-project/hadoop_mr
```

依次运行：

```bash
for task in v1 v2 v3 v4 v5 v6 v7
do
  hadoop jar charging-pile-mr.jar com.neu.datapro.ChargingPileJobs $task
done
```

7 个任务说明：

| 任务 | HDFS 输出目录 | 分析内容 | MySQL 表 |
|---|---|---|---|
| v1 | /Car/v1 | 平均总电压、平均充电电流 | t_enger1 |
| v2 | /Car/v2 | 单体最高/最低电压 | t_enger2 |
| v3 | /Car/v3 | 最高/最低温度 | t_enger3 |
| v4 | /Car/v4 | 平均能量、平均容量 | t_enger4 |
| v5 | /Car/v5 | 平均/最大充电电流 | t_enger5 |
| v6 | /Car/v6 | 电压电流变化指标 | t_enger6 |
| v7 | /Car/v7 | 电池状态温度分布指标 | t_enger7 |

查看输出：

```bash
for task in v1 v2 v3 v4 v5 v6 v7
do
  echo "===== $task ====="
  hdfs dfs -cat /Car/$task/part-r-00000
done
```

说明：

- Mapper 读取 CSV 行数据，按小时或状态输出 key-value。
- Shuffle 将相同 key 的数据聚合到同一个 Reducer。
- Reducer 计算平均值、最大值、最小值等指标。
- 输出目录为 `/Car/v1` 到 `/Car/v7`。

## 8. 安装和配置 MySQL

Ubuntu 示例：

```bash
sudo apt update
sudo apt install -y mysql-server
sudo service mysql start
```

进入 MySQL：

```bash
sudo mysql
```

如果需要设置 root 密码，可按本机情况配置。课程环境中也可以使用已有 MySQL 账号。

导入项目数据库：

```bash
cd ~/charging-pile-datart-project
mysql -uroot -p < import_project.sql
```

检查：

```bash
mysql -uroot -p
```

进入 MySQL 后执行：

```sql
SHOW DATABASES;
USE enger;
SHOW TABLES;
SELECT * FROM t_enger1 LIMIT 5;
SELECT * FROM t_enger7 LIMIT 5;
```

正常应看到以下表：

```text
t_enger1
t_enger2
t_enger3
t_enger4
t_enger5
t_enger6
t_enger7
t_session_summary
t_platform_sessions
t_weekday_sessions
```

说明：

- `enger` 是本项目的业务结果库。
- `t_enger1` 到 `t_enger7` 对应 7 个 MapReduce 分析结果。
- `t_session_summary`、`t_platform_sessions`、`t_weekday_sessions` 用于补充充电会话、平台和星期分布统计。

## 9. 安装和配置 Datart

Datart 是本项目的 BI 可视化工具。它需要连接 MySQL。

这里要区分两个数据库：

```text
datart：Datart 平台自己的应用数据库，用来保存用户、图表、仪表板等配置。
enger：本项目的业务结果数据库，用来保存充电桩分析结果。
```

### 9.1 创建 Datart 应用数据库

进入 MySQL：

```bash
mysql -uroot -p
```

执行：

```sql
CREATE DATABASE IF NOT EXISTS datart DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### 9.2 配置 Datart

进入 Datart 安装目录，编辑：

```bash
vim config/datart.conf
```

示例配置：

```properties
datasource.ip=127.0.0.1
datasource.port=3306
datasource.database=datart
datasource.username=root
datasource.password=你的MySQL密码

server.port=8080
server.address=0.0.0.0

datart.address=http://127.0.0.1:8080
datart.send-mail=false
datart.webdriver-path=http://127.0.0.1:4444/wd/hub
```

启动 Datart：

```bash
cd ~/datart
./bin/datart-server.sh start
```

如果实际目录不同，以自己的安装路径为准。

浏览器访问：

```text
http://localhost:8080
```

### 9.3 在 Datart 中连接本项目 MySQL 数据库

在 Datart 页面中创建数据源：

```text
名称：enger_mysql
类型：JDBC / MySQL
连接地址：jdbc:mysql://localhost:3306/enger?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8
用户名：你的MySQL用户名
密码：你的MySQL密码
```

连接成功后，按照 `datart_views.sql` 创建 SQL View：

```sql
SELECT * FROM enger.t_enger1;
SELECT * FROM enger.t_enger2;
SELECT * FROM enger.t_enger3;
SELECT * FROM enger.t_enger4;
SELECT * FROM enger.t_enger5;
SELECT * FROM enger.t_enger6;
SELECT * FROM enger.t_enger7;
```

然后创建图表和仪表板：

```text
图表目录：Charging Pile Charts
仪表板：Charging Pile Big Data Dashboard
```

建议图表：

| 数据视图 | 推荐图表 |
|---|---|
| t_enger1 | 折线图：电压电流趋势 |
| t_enger2 | 柱状图：单体电压极值 |
| t_enger3 | 折线图：温度趋势 |
| t_enger4 | 折线图：能量容量趋势 |
| t_enger5 | 折线图：充电电流统计 |
| t_enger6 | 折线图：电压电流变化指标 |
| t_enger7 | 柱状图：电池状态温度分布 |

## 10. 启动顺序

### 10.1 完整计算流程

需要重新从 CSV 跑一遍分析时：

```bash
start-dfs.sh
start-yarn.sh
jps

sudo service mysql start

cd ~/charging-pile-datart-project/hadoop_mr
for task in v1 v2 v3 v4 v5 v6 v7
do
  hadoop jar charging-pile-mr.jar com.neu.datapro.ChargingPileJobs $task
done

cd ~/datart
./bin/datart-server.sh start
```

### 10.2 只查看可视化

如果 MySQL 中已经有结果表，只需要：

```bash
sudo service mysql start
cd ~/datart
./bin/datart-server.sh start
```

原因：

- Hadoop 负责离线计算。
- MySQL 保存计算后的结果。
- Datart 查询 MySQL 并展示图表。
- 只看图表时不需要重新启动 Hadoop；重新计算时才需要 Hadoop。

## 11. 验证项目是否部署成功

### 11.1 验证 Hadoop

```bash
jps
hdfs dfs -ls /Car
hdfs dfs -ls /Car/v1
```

能看到 Hadoop 进程和 HDFS 输出目录，说明 Hadoop 部分正常。

### 11.2 验证 MapReduce

```bash
hdfs dfs -cat /Car/v1/part-r-00000
hdfs dfs -cat /Car/v7/part-r-00000
```

能看到统计结果，说明 MapReduce 任务已经跑通。

### 11.3 验证 MySQL

```sql
USE enger;
SHOW TABLES;
SELECT COUNT(*) FROM t_enger1;
SELECT COUNT(*) FROM t_enger7;
```

能查到表和数据，说明结果库正常。

### 11.4 验证 Datart

浏览器访问：

```text
http://localhost:8080
```

检查：

- 能登录 Datart。
- `enger_mysql` 数据源连接成功。
- SQL View 能预览数据。
- 图表和仪表板能显示。

## 12. 常见问题

### 12.1 hdfs dfs 报 Connection refused

原因：NameNode 没有启动。

处理：

```bash
start-dfs.sh
jps
```

看到 `NameNode` 和 `DataNode` 后再执行 HDFS 命令。

### 12.2 /Car 目录不存在

处理：

```bash
hdfs dfs -mkdir -p /Car
hdfs dfs -put -f data/*.csv /Car/
```

### 12.3 MapReduce 输出目录已存在

本项目代码中会自动删除对应输出目录。如果手动运行其他程序出现该问题，可执行：

```bash
hdfs dfs -rm -r /Car/v1
```

其他任务把 `v1` 改为对应目录。

### 12.4 MySQL 导入失败

检查 MySQL 是否启动：

```bash
sudo service mysql start
```

检查账号密码：

```bash
mysql -uroot -p
```

再导入：

```bash
mysql -uroot -p < import_project.sql
```

### 12.5 Datart 页面打不开

检查端口和服务：

```bash
cd ~/datart
./bin/datart-server.sh start
```

如果 8080 被占用，可以修改 `config/datart.conf` 中的：

```properties
server.port=8081
```

然后重新启动 Datart。

### 12.6 Datart 图表没有数据

按顺序检查：

1. MySQL 是否启动。
2. `enger` 数据库是否存在。
3. `t_enger1` 到 `t_enger7` 是否有数据。
4. Datart 数据源连接是否成功。
5. SQL View 是否选择了正确的数据源。

## 13. 参考资料

- Datart GitHub：https://github.com/running-elephant/datart
- Datart 官方部署文档：https://running-elephant.github.io/datart-docs/docs/

