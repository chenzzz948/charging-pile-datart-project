# Hadoop MapReduce 运行证明

本目录为新能源充电桩大数据实训的 Hadoop/MapReduce 部分。

## 环境

- Hadoop: `/usr/local/hadoop`
- HDFS: `hdfs://localhost:9000`
- YARN: ResourceManager + NodeManager
- 输入数据: `/Car/dsv13r2.csv`
- 程序 Jar: `/home/hadoop/charging_pile_hadoop_mr/target/charging-pile-mr.jar`

## 七个任务

- V1: 按小时统计平均电池包电压和平均充电电流，输出 `/Car/v1`
- V2: 按小时统计单体电压最大值和最小值，输出 `/Car/v2`
- V3: 按小时统计最高/最低温度，输出 `/Car/v3`
- V4: 按小时统计平均可用能量和平均可用容量，输出 `/Car/v4`
- V5: 按小时统计平均充电电流和最大充电电流，输出 `/Car/v5`
- V6: 按小时统计电压/电流指标，输出 `/Car/v6`
- V7: 按小时统计平均最高/最低温度，输出 `/Car/v7`

运行日志位于 `run_logs/v1.log` 到 `run_logs/v7.log`。
HDFS 输出已汇总到 `hdfs_outputs/v1.txt` 到 `hdfs_outputs/v7.txt`。
