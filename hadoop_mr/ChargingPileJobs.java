package com.neu.datapro;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

public class ChargingPileJobs {
    static final String INPUT = "/Car/dsv13r2.csv";

    static String[] fields(Text value) {
        String line = value.toString().replace("\uFEFF", "").trim();
        if (line.isEmpty() || line.startsWith("esd,")) return null;
        String[] f = line.split(",", -1);
        return f.length >= 11 ? f : null;
    }

    static String hour(String recordTime) {
        String t = recordTime.trim();
        return t.length() >= 10 ? t.substring(8, 10) : "NA";
    }

    static double d(String s) {
        return Double.parseDouble(s.trim());
    }

    static void runJob(
            Configuration conf,
            String name,
            Class<? extends Mapper> mapper,
            Class<? extends Reducer> reducer,
            String output
    ) throws Exception {
        Job job = Job.getInstance(conf, name);
        job.setJarByClass(ChargingPileJobs.class);
        job.setMapperClass(mapper);
        job.setReducerClass(reducer);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        Path in = new Path(INPUT);
        Path out = new Path(output);
        FileInputFormat.addInputPath(job, in);
        FileOutputFormat.setOutputPath(job, out);
        FileSystem fs = FileSystem.get(conf);
        if (fs.exists(out)) fs.delete(out, true);
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }

    public static class V1Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[3] + "," + f[4]));
        }
    }
    public static class V1Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double pack = 0, current = 0; int n = 0;
            for (Text v : values) { String[] f = v.toString().split(","); pack += d(f[0]); current += d(f[1]); n++; }
            ctx.write(key, new Text((pack / n) + "," + (current / n)));
        }
    }

    public static class V2Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[5] + "," + f[6]));
        }
    }
    public static class V2Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double maxCell = -Double.MAX_VALUE, minCell = Double.MAX_VALUE;
            for (Text v : values) { String[] f = v.toString().split(","); maxCell = Math.max(maxCell, d(f[0])); minCell = Math.min(minCell, d(f[1])); }
            ctx.write(key, new Text(maxCell + "," + minCell));
        }
    }

    public static class V3Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[7] + "," + f[8]));
        }
    }
    public static class V3Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double maxTemp = -Double.MAX_VALUE, minTemp = Double.MAX_VALUE;
            for (Text v : values) { String[] f = v.toString().split(","); maxTemp = Math.max(maxTemp, d(f[0])); minTemp = Math.min(minTemp, d(f[1])); }
            ctx.write(key, new Text(maxTemp + "," + minTemp));
        }
    }

    public static class V4Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[9] + "," + f[10]));
        }
    }
    public static class V4Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double energy = 0, capacity = 0; int n = 0;
            for (Text v : values) { String[] f = v.toString().split(","); energy += d(f[0]); capacity += d(f[1]); n++; }
            ctx.write(key, new Text((energy / n) + "," + (capacity / n)));
        }
    }

    public static class V5Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[4]));
        }
    }
    public static class V5Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double sum = 0, max = -Double.MAX_VALUE; int n = 0;
            for (Text v : values) { double x = d(v.toString()); sum += x; max = Math.max(max, x); n++; }
            ctx.write(key, new Text((sum / n) + "," + max));
        }
    }

    public static class V6Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[3] + "," + f[4]));
        }
    }
    public static class V6Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double pack = 0, current = 0; int n = 0;
            for (Text v : values) { String[] f = v.toString().split(","); pack += d(f[0]); current += d(f[1]); n++; }
            ctx.write(key, new Text((pack / n) + "," + (current / n)));
        }
    }

    public static class V7Mapper extends Mapper<LongWritable, Text, Text, Text> {
        public void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
            String[] f = fields(value);
            if (f == null) return;
            ctx.write(new Text(hour(f[1])), new Text(f[7] + "," + f[8]));
        }
    }
    public static class V7Reducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context ctx) throws IOException, InterruptedException {
            double maxTemp = 0, minTemp = 0; int n = 0;
            for (Text v : values) { String[] f = v.toString().split(","); maxTemp += d(f[0]); minTemp += d(f[1]); n++; }
            ctx.write(key, new Text((maxTemp / n) + "," + (minTemp / n)));
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("Usage: ChargingPileJobs <v1|v2|v3|v4|v5|v6|v7>");
            System.exit(2);
        }
        Configuration conf = new Configuration();
        String task = args[0].toLowerCase();
        if ("v1".equals(task)) runJob(conf, "V1 avg voltage/current by hour", V1Mapper.class, V1Reducer.class, "/Car/v1");
        if ("v2".equals(task)) runJob(conf, "V2 cell voltage max/min by hour", V2Mapper.class, V2Reducer.class, "/Car/v2");
        if ("v3".equals(task)) runJob(conf, "V3 temperature max/min by hour", V3Mapper.class, V3Reducer.class, "/Car/v3");
        if ("v4".equals(task)) runJob(conf, "V4 average energy/capacity by hour", V4Mapper.class, V4Reducer.class, "/Car/v4");
        if ("v5".equals(task)) runJob(conf, "V5 current avg/max by hour", V5Mapper.class, V5Reducer.class, "/Car/v5");
        if ("v6".equals(task)) runJob(conf, "V6 voltage/current metric by hour", V6Mapper.class, V6Reducer.class, "/Car/v6");
        if ("v7".equals(task)) runJob(conf, "V7 average status temperature by hour", V7Mapper.class, V7Reducer.class, "/Car/v7");
        System.err.println("Unknown task: " + args[0]);
        System.exit(2);
    }
}
