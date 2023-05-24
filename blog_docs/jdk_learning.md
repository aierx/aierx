## jdk模式
- 混合模式  -Xmixed           mixed mode execution (default)
- 解释模式  -Xint             interpreted mode execution only
- 编译模式  -Xcomp            compiled mode execution only


## jdk GC对比

### yong generation
- ①、serial
- ②、ParNew
- ③、Parallel Scavenge

### tenured genertion
- ④、CMS
- ⑤、Serial Old（MSC）
- ⑥、Parallel Old

###  组合
![组合模式](https://s2.loli.net/2023/05/25/E1kShr7PD2iqY6y.png)

java -XX:+UseSerialGC -XX:+PrintGCDetails -version （①和⑤）

java -XX:+UseParNewGC -XX:+PrintGCDetails -version （②和⑤）

java -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:+PrintGCDetails -version  （③和⑥、jdk8默认是开启的. -XX:+UseParallelGC -XX:+UseParallelOldGC使用一个，另外一个也会生效）

java -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -version （ParNew + CMS + Serial Old收集器组合进行回收，Serial Old收集器将作为CMS收集器出现“Concurrent Mode Failure“失败后的后备收集器使用）

java -XX:+UseG1GC -XX:+PrintGCDetails -version
