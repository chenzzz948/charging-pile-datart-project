# 新能源充电桩大数据项目实训

这是一个基于 Hadoop 伪分布式、Java MapReduce、MySQL 和 Datart 的新能源充电桩数据分析与 BI 可视化项目。

项目内容按实训教案完成：

- 使用 Hadoop 伪分布式环境处理充电桩数据。
- 编写并运行 7 个 MapReduce 分析任务。
- 将分析结果导入 MySQL。
- 使用真实 Datart 连接 MySQL，创建数据视图、数据图表和仪表板。
- 可视化风格参考 `reference_images/` 中的作业截图。

## 目录结构

```text
.
├── data/                 # 原始 CSV 数据
├── results/              # MapReduce/MySQL 结果表 CSV
├── hadoop_mr/            # MapReduce 源码、HDFS 输出和运行日志
├── reference_images/     # 作业参考图
├── import_project.sql    # MySQL 建表和结果导入脚本
├── datart_views.sql      # Datart SQL View 对应查询
└── VM_DEPLOYED.md        # 虚拟机部署说明
```

## 数据集

使用的数据文件：

```text
data/dsv13r2.csv
data/nvv2t.csv
data/nvv2t_md.csv
```

其中 `dsv13r2.csv` 用于 Hadoop MapReduce 的 7 个任务分析。

## 7 个 MapReduce 任务

源码：

```text
hadoop_mr/ChargingPileJobs.java
```

任务输出：

```text
/Car/v1  电压电流趋势
/Car/v2  电芯电压极值
/Car/v3  温度趋势
/Car/v4  能量与容量趋势
/Car/v5  充电电流统计
/Car/v6  电压电流变化率
/Car/v7  电池状态温度分布
```

运行结果证明保存在：

```text
hadoop_mr/MAPREDUCE_RUN_PROOF.md
hadoop_mr/hdfs_outputs_v1.txt ... hdfs_outputs_v7.txt
hadoop_mr/run_logs_v1.log ... run_logs_v7.log
```

## MySQL

导入脚本：

```bash
mysql -u<user> -p<password> < import_project.sql
```

导入后数据库为：

```text
enger
```

结果表：

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

## Datart

Datart 使用真实服务部署，不是静态截图页面。

Datart 中应创建：

```text
数据源：enger_mysql
图表目录：Charging Pile Charts
仪表板：Charging Pile Big Data Dashboard
```

SQL View 对应关系见：

```text
datart_views.sql
```

图表配置：

```text
Voltage Current Trend              line-chart
Cell Voltage Extremes              cluster-column-chart
Temperature Trend                  line-chart
Energy Capacity Trend              line-chart
Charge Current Statistics          line-chart
Voltage Current Change Rate        line-chart
Battery Temperature Distribution   cluster-column-chart
```

## 注意

这是公开仓库版本，未提交本机虚拟机账号、MySQL 密码、Datart 管理员密码等敏感信息。实际运行时请在自己的虚拟机或服务器中设置账号密码，并在 Datart 数据源中填写本地 MySQL 连接信息。

