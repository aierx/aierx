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
