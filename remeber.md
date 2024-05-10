# jacoco
java -jar jacococli.jar dump --address 127.0.0.1 --port 6300 --destfile ./jacoco-demo.exec  
java -jar jacococli.jar report ./jacoco-demo.exec --classfiles /Users/leiwenyong/mini/c1/target/classes/com --sourcefiles /Users/leiwenyong/mini/c1/src/main/java --html report --xml report.xml  
# git
假定未变更  
git ls-files -v|grep "^h"  
打开假定未变更  
git update-index --assume-unchanged  
关闭假定未变更  
git update-index --no-assume-unchanged  
文件标识    描述  
H    缓存，正常跟踪文件  
S    skip-worktree文件  
h    assume-unchanged文件  
M    unmerged, 未合并  
R    removed/deleted  
C    modified/changed修改  
K    to be killed  
?    other，忽略文件 
