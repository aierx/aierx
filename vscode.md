> [链接](https://gist.github.com/wxingheng/e3fc8bb470db102bc12c3cfcaabdcfae)

| Command                         | macos              | windows             |
|---------------------------------|--------------------|---------------------|
| Quick Fix                       | cmd + .            | alt + enter         |
| Go Back                         | ctrl + -           | alt + leftArrow     |
| Go Forward                      | ctrl + shift + -   |                     |
| Go To Symbol In Accessible View | shift + cmd + o    | ctrl + shift + o    |
| Go to  symbol in workspace      | cmd + t            | ctrl + t            |
| Trigger Parameter Hints         | shift + cmd + space|                     |
| flod all                        | cmd + k , cmd + 0  | ctrl + k , ctrl + 0 |
| unfold all                      | cmd + k , cmd + j  | ctrl + k , ctrl + j |
| fold                            | opt + cmd + [      |                     |
| unfold                          | opt + cmd + ]      |                     |
| format                          | opt + shift + f    |                     |
| Collapse Folders in Explores    | opt + shift + c    |                     |
| Toggle primary side bar         | cmd + b            |                     |
| Toggle panel                    | cmd + j            |                     |
| Toggle secondary side bar       | opt + cmd + b      |                     |


vscode 调试配置

debug时局部变量展示配置

inline values  default auto

参数名称镶嵌显示

inlay hint on



settings.json

```json
{
	"java.configuration.updateBuildConfiguration": "automatic",
	"java.compile.nullAnalysis.mode": "automatic",
}
```

launch.json

```json
{
	"version": "0.2.0",
	"configurations": [
		{
			"type": "java",
			"name": "Launch Java Program",
			"request": "launch",
			"mainClass": "com.example.agent.App",
			"preLaunchTask": "build",
			"vmArgs": "-Dspring.output.ansi.enabled=ALWAYS"
		},
		{
			"type": "java",
			"name": "Launch",
			"request": "attach",
			"hostName": "localhost",
			"port": 44399,
			"projectName": "agent",
			"preLaunchTask": "aaa"
		},
		{
			"type": "java",
			"name": "Spring Boot-App<agent>",
			"request": "launch",
			"cwd": "${workspaceFolder}",
			"mainClass": "com.example.agent.App",
			"projectName": "agent",
			"args": "",
			"vmArgs": "-Dspring.output.ansi.enabled=always",
			"envFile": "${workspaceFolder}/.env"
		}
	]
}
```


tasks.json

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"label": "aaa",
			"type": "shell",
			"command": "./run.sh",
			"windows":{
				"command": "./run.cmd"
			}
		},
		{
			"label": "build",
			"type": "shell",
			"windows":{
				"command": "mvn compile"
			}
		}
	]
}
```
