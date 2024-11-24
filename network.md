# 前言
近期学习了Windows平台下Socket开发的2中模式和5种I/O模型，以下是介绍这几种开发模式所要使用接口的核心示例，示例只有一个功能，客户端发送输入的字符串，服务接收后转为大写发送给客户端。

# Socket基础
我理解的Socket是：如果以五层传输协议为基础，Socket就是应用层访问传输层的接口。
服务器流程：WSAStartup->Create Socket->bind->listen->accept->recv/send->close
客户端流程：WSAStartup->Create Socket->connect->recv/send->close
流程上很简单，但为什么Windows要提供那么多种开发模式楠。我们以recv为例，在调用recv的时候大致会有2个过程：1.内核等待数据；2.将数据复制到用户空间。这2个过程可以是同步或异步的，要实现高效的访问，需要你根据自己的设计选取不同的接口。所以核心是需要考虑accept，connect，recv，send这些接口是使用同步还是异步的。

# 阻塞模式

> 套接字在执行操作时，调用函数在没有完成操作之前不会立即返回的工作模式。

## 客户端
 这里只提供一个客户端示例，均可以同所有的服务器示例配合使用。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <WinSock2.h> 
 #include <list> 
 #include <thread> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 SOCKET mHost;
 char mInputBuf[BUF_SIZE];	//接收数据缓冲区
 unsigned short mSendHeader;//包头 
 char mSendPacket[BUF_SIZE];//包体 
  
 unsigned short mRecvHeader;//包头 
 char mRecvPacket[BUF_SIZE];//包体 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mHost) 
 	{ 
 		closesocket(mHost); 
 	} 
 	WSACleanup(); 
 } 
  
 int main() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (WSAStartup(MAKEWORD(2, 2), &mWsd) != 0) 
 	{ 
 		printf("WSAStartup failed!!!\n"); 
 		return -1; 
 	} 
 	//初始化socket 
 	mHost = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mHost) 
 	{ 
 		printf_s("new socket error : %d\n", WSAGetLastError()); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
 	//链接服务器 
 	SOCKADDR_IN	servAddr; 
 	servAddr.sin_family = AF_INET; 
 	servAddr.sin_addr.s_addr = inet_addr("127.0.0.1"); 
 	servAddr.sin_port = htons((short)21234); 
 	int nServAddlen = sizeof(servAddr); 
 	if (INVALID_SOCKET == connect(mHost, (LPSOCKADDR)&servAddr, sizeof(servAddr))) 
 	{ 
 		printf_s("new socket connect error : %d\n", WSAGetLastError()); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
 #pragma endregion 
  
 #pragma region 发送接收循环 
 	while (true) 
 	{ 
 		//reset 
 		ZeroMemory(mInputBuf, sizeof(mInputBuf)); 
 		ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
 		ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
  
 		//输入 
 		printf_s("Input:\n"); 
 		gets_s(mInputBuf); 
  
 		if (mInputBuf[0] == '/' && mInputBuf[1] == '/' && mInputBuf[2] == 'q') 
 		{ 
 			CleanUpEnvironment(); 
 			return 1; 
 		} 
  
 		int endIndex = 0; 
 		for (int m = 0;m < sizeof(mInputBuf);++m) 
 		{ 
 			if (mInputBuf[m] == '\0') 
 			{ 
 				endIndex = m; 
 				break; 
 			} 
 		} 
 		memcpy(mSendPacket, mInputBuf, endIndex); 
  
 		//发送包头 
 		mSendHeader = endIndex; 
 		int retVal = send(mHost, (char*)&mSendHeader, sizeof(mSendHeader), 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("send header failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		//发送包体 
 		retVal = send(mHost, mSendPacket, mSendHeader, 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("send pack failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		//接收包头 
 		retVal = recv(mHost, (char*)&mRecvHeader, sizeof(mRecvHeader), 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("recv header failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		//接收包体 
 		retVal = recv(mHost, mRecvPacket, mRecvHeader, 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("recv pack failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		printf_s("Output :\n%s\n", mRecvPacket); 
 	} 
 #pragma endregion 
 	return 1; 
 }
 ```
 
## 单线程服务器
 只能维护一个连接。

 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 SOCKET	mListenSocket;//监听套接字 
  
 unsigned short mSendHeader;//包头 
 char mSendPacket[BUF_SIZE];//包体 
  
 unsigned short mRecvHeader;//包头 
 char mRecvPacket[BUF_SIZE];//包体 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 int main() 
 { 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return -1; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
  
 	//接受客户端链接 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 	if (SOCKET_ERROR == clientSocket) 
 	{ 
 		printf_s("server socket accept failed!\n"); 
 		CleanUpEnvironment(); 
 		return -1; 
 	} 
 	printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
  
 	while (true) 
 	{ 
 		//reset 
 		ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
 		ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
  
 		//接收包头 
 		int retVal = recv(clientSocket, (char*)&mRecvHeader, sizeof(mRecvHeader), 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("recv header failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		//接收包体 
 		retVal = recv(clientSocket, mRecvPacket, mRecvHeader, 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("recv pack failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		int endIndex = 0; 
 		for (int m = 0;m < sizeof(mRecvPacket);++m) 
 		{ 
 			if (mRecvPacket[m] == '\0') 
 			{ 
 				endIndex = m; 
 				break; 
 			} 
 		} 
 		std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
  
 		//发送包头 
 		mSendHeader = endIndex; 
 		retVal = send(clientSocket, (char*)&mSendHeader, sizeof(mSendHeader), 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("send header failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		//发送包体 
 		retVal = send(clientSocket, mSendPacket, mSendHeader, 0); 
 		if (INVALID_SOCKET == retVal) 
 		{ 
 			printf_s("send pack failed!!!\n"); 
 			CleanUpEnvironment(); 
 			break; 
 		} 
  
 		printf_s("send success : %s\n", mSendPacket); 
 	} 
  
 	return 1; 
 }
 ```
 
## 通过为每个连接开启一个线程来维护多个链接。
 
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
  
 void InputThreadCmd(); 
 void acceptThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//设置监听套接字为非阻塞模式 
 	u_long ulUnBlocking = 1; 
 	int ret = ioctlsocket(mListenSocket, FIONBIO, &ulUnBlocking); 
 	if (SOCKET_ERROR == ret) 
 	{ 
 		printf("server socket ioctlsocket failed\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(acceptThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s) 
 	{ 
 		std::thread handleCmd(HandleCmd, this); 
 		handleCmd.detach(); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	static void HandleCmd(Client* client) 
 	{ 
 		while (!mTerminated) 
 		{ 
 			//reset 
 			ZeroMemory(client->mSendPacket, sizeof(client->mSendPacket)); 
 			ZeroMemory(client->mRecvPacket, sizeof(client->mRecvPacket)); 
  
 			int retVal, errorCode; 
 			//接收包头 
 			while (true) 
 			{ 
 				retVal = recv(client->mSocket, (char*)&client->mRecvHeader, sizeof(client->mRecvHeader), 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("recv header failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			//接收包体 
 			while (true) 
 			{ 
 				retVal = recv(client->mSocket, client->mRecvPacket, client->mRecvHeader, 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("recv pack failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			int endIndex = 0; 
 			for (int m = 0; m < sizeof(client->mRecvPacket); ++m) 
 			{ 
 				if (client->mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
 			std::transform(client->mRecvPacket, client->mRecvPacket + endIndex, client->mSendPacket, towupper); 
  
 			//发送包头 
 			client->mSendHeader = endIndex; 
 			while (true) 
 			{ 
 				retVal = send(client->mSocket, (char*)&client->mSendHeader, sizeof(client->mSendHeader), 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("send header failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			//发送包体 
 			while (true) 
 			{ 
 				retVal = send(client->mSocket, client->mSendPacket, client->mSendHeader, 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("send pack failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			printf_s("send success : %s\n", client->mSendPacket); 
 		} 
 	} 
  
 	SOCKET mSocket; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
 }; 
  
 //接收客户端链接线程 
 void acceptThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	while (!mTerminated) 
 	{ 
 		SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 		if (SOCKET_ERROR != clientSocket) 
 		{ 
 			Client * client = new Client(clientSocket); 
 			mClientSockets.push_back(client); 
 			printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 		} 
  
 		SleepEx(100, true); 
 	} 
  
 	while (mClientSockets.size() > 0) 
 	{ 
 		delete mClientSockets.front(); 
 		mClientSockets.pop_front(); 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```

# 非阻塞模式
 > 套接字在执行操作时，调用函数不管操作是否完成都会立即返回的工作模式。通过接口ioctlsocket设置socket为非阻塞模式。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
  
 void InputThreadCmd(); 
 void acceptThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//设置监听套接字为非阻塞模式 
 	u_long ulUnBlocking = 1; 
 	int ret = ioctlsocket(mListenSocket, FIONBIO, &ulUnBlocking); 
 	if (SOCKET_ERROR == ret) 
 	{ 
 		printf("server socket ioctlsocket failed\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(acceptThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s) 
 	{ 
 		std::thread handleCmd(HandleCmd, this); 
 		handleCmd.detach(); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	static void HandleCmd(Client* client) 
 	{ 
 		while (!mTerminated) 
 		{ 
 			//reset 
 			ZeroMemory(client->mSendPacket, sizeof(client->mSendPacket)); 
 			ZeroMemory(client->mRecvPacket, sizeof(client->mRecvPacket)); 
  
 			int retVal, errorCode; 
 			//接收包头 
 			while (true) 
 			{ 
 				retVal = recv(client->mSocket, (char*)&client->mRecvHeader, sizeof(client->mRecvHeader), 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("recv header failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			//接收包体 
 			while (true) 
 			{ 
 				retVal = recv(client->mSocket, client->mRecvPacket, client->mRecvHeader, 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("recv pack failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			int endIndex = 0; 
 			for (int m = 0; m < sizeof(client->mRecvPacket); ++m) 
 			{ 
 				if (client->mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
 			std::transform(client->mRecvPacket, client->mRecvPacket + endIndex, client->mSendPacket, towupper); 
  
 			//发送包头 
 			client->mSendHeader = endIndex; 
 			while (true) 
 			{ 
 				retVal = send(client->mSocket, (char*)&client->mSendHeader, sizeof(client->mSendHeader), 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("send header failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			//发送包体 
 			while (true) 
 			{ 
 				retVal = send(client->mSocket, client->mSendPacket, client->mSendHeader, 0); 
 				if (INVALID_SOCKET == retVal) 
 				{ 
 					errorCode = WSAGetLastError(); 
 					if (WSAEWOULDBLOCK == errorCode) 
 					{ 
 						continue; 
 					} 
 					else 
 					{ 
 						printf_s("send pack failed!!!\n"); 
 						CleanUpEnvironment(); 
 						return; 
 					} 
 				} 
 				break; 
 			} 
  
 			printf_s("send success : %s\n", client->mSendPacket); 
 		} 
 	} 
  
 	SOCKET mSocket; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
 }; 
  
 //接收客户端链接线程 
 void acceptThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	while (!mTerminated) 
 	{ 
 		SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 		if (SOCKET_ERROR != clientSocket) 
 		{ 
 			Client * client = new Client(clientSocket); 
 			mClientSockets.push_back(client); 
 			printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 		} 
  
 		SleepEx(100, true); 
 	} 
  
 	while (mClientSockets.size() > 0) 
 	{ 
 		delete mClientSockets.front(); 
 		mClientSockets.pop_front(); 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```
## Select I/O模型
 > 通过Select接口可以最多同时管理64个链接，多余的链接需要新开线程处理。Select接口是阻塞的并且数据拷贝到用户空间也是阻塞的。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
  
 void InputThreadCmd(); 
 void selectThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(selectThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s), 
 		mRecvType(Head), 
 		mRecvHeader(0), 
 		mSendType(None), 
 		mSendHeader(0) 
 	{ 
 		ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 		ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	enum MsgType 
 	{ 
 		None, 
 		Head, 
 		Pack 
 	}; 
  
 	void handleRecv() 
 	{ 
 		if (Head == mRecvType) 
 		{ 
 			recv(mSocket, (char*)&mRecvHeader, sizeof(mRecvHeader), 0); 
 			mRecvType = Pack; 
 		} 
 		else if(Pack == mRecvType) 
 		{ 
 			ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 			recv(mSocket, mRecvPacket, mRecvHeader, 0); 
  
 			int endIndex = 0; 
 			for (int m = 0; m < sizeof(mRecvPacket); ++m) 
 			{ 
 				if (mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
 			std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
 			mSendHeader = endIndex; 
  
 			mRecvType = None; 
 			mSendType = Head; 
 		} 
 	} 
  
 	void handleSend() 
 	{ 
 		if (Head == mSendType) 
 		{ 
 			send(mSocket, (char*)&mSendHeader, sizeof(mSendHeader), 0); 
 			mSendType = Pack; 
 		} 
 		else if(Pack == mSendType) 
 		{ 
 			send(mSocket, mSendPacket, mSendHeader, 0); 
  
 			printf_s("send success : %s\n", mSendPacket); 
  
 			ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
  
 			mSendType = None; 
 			mRecvType = Head; 
 		} 
 	} 
  
 	SOCKET mSocket; 
 	MsgType mRecvType; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	MsgType mSendType; 
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
 }; 
  
 void selectThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	 
 	FD_SET allSocket_fd; 
 	FD_ZERO(&allSocket_fd); 
 	FD_SET(mListenSocket, &allSocket_fd); 
  
 	FD_SET readSocket_fd; 
 	FD_SET writeSocket_fd; 
  
 	while (!mTerminated) 
 	{ 
 		FD_ZERO(&readSocket_fd); 
 		FD_ZERO(&writeSocket_fd); 
  
 		readSocket_fd = allSocket_fd; 
 		writeSocket_fd = allSocket_fd; 
  
 		int retVal = select(0, &readSocket_fd, &writeSocket_fd, NULL, NULL); 
 		if (retVal > 0) 
 		{ 
 			for (int m = 0;m < allSocket_fd.fd_count;++m) 
 			{ 
 				if (FD_ISSET(allSocket_fd.fd_array[m], &readSocket_fd)) 
 				{ 
 					//accept 
 					if (allSocket_fd.fd_array[m] == mListenSocket) 
 					{ 
 						sockaddr_in addrClient; 
 						int addrClientlen = sizeof(addrClient); 
 						SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 						if (SOCKET_ERROR != clientSocket) 
 						{ 
 							Client * client = new Client(clientSocket); 
 							mClientSockets.push_back(client); 
 							printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
  
 							FD_SET(clientSocket, &allSocket_fd); 
 						} 
 					} 
 					//recv 
 					else 
 					{ 
 						std::list<Client*>::iterator iter = mClientSockets.begin(); 
 						std::list<Client*>::iterator end = mClientSockets.end(); 
 						for (; iter != end; ++iter) 
 						{ 
 							if ((*iter)->mSocket == allSocket_fd.fd_array[m]) 
 							{ 
 								(*iter)->handleRecv(); 
 							} 
 						} 
 					} 
 				} 
  
 				//send 
 				if (FD_ISSET(allSocket_fd.fd_array[m], &writeSocket_fd)) 
 				{ 
 					std::list<Client*>::iterator iter = mClientSockets.begin(); 
 					std::list<Client*>::iterator end = mClientSockets.end(); 
 					for (; iter != end; ++iter) 
 					{ 
 						if ((*iter)->mSocket == allSocket_fd.fd_array[m]) 
 						{ 
 							(*iter)->handleSend(); 
 						} 
 					} 
 				} 
 			} 
 		} 
  
 		Sleep(100); 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```
 
## WSAAsyncSelect I/O模型
 > 通过Win窗口的消息机制实现非阻塞调用，但数据复制到用户空间是阻塞的。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define WM_SOCKET (WM_USER+1) 
 #define BUF_SIZE 128 
  
 HWND hWnd; 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	WSAAsyncSelect(mListenSocket, hWnd, WM_SOCKET, FD_ACCEPT | FD_CLOSE); 
  
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 	char s[128]; 
 	MSG msg; 
 	while (::GetMessage(&msg, NULL, 0, 0) && !mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		::TranslateMessage(&msg);//转化键盘消息 
 		::DispatchMessage(&msg);//将消息发送到相应窗口函数 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s), 
 		mRecvType(Head), 
 		mRecvHeader(0), 
 		mSendType(None), 
 		mSendHeader(0) 
 	{ 
 		ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 		ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	enum MsgType 
 	{ 
 		None, 
 		Head, 
 		Pack 
 	}; 
  
 	void handleRecv() 
 	{ 
 		if (Head == mRecvType) 
 		{ 
 			recv(mSocket, (char*)&mRecvHeader, sizeof(mRecvHeader), 0); 
 			mRecvType = Pack; 
 		} 
 		else if (Pack == mRecvType) 
 		{ 
 			ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 			recv(mSocket, mRecvPacket, mRecvHeader, 0); 
  
 			int endIndex = 0; 
 			for (int m = 0; m < sizeof(mRecvPacket); ++m) 
 			{ 
 				if (mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
 			std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
 			mSendHeader = endIndex; 
  
 			mRecvType = None; 
 			mSendType = Head; 
  
 			handleSend(); 
 		} 
 	} 
  
 	void handleSend() 
 	{ 
 		if (Head == mSendType) 
 		{ 
 			int retVal = send(mSocket, (char*)&mSendHeader, sizeof(mSendHeader), 0); 
 			mSendType = Pack; 
 		} 
 		if (Pack == mSendType) 
 		{ 
 			send(mSocket, mSendPacket, mSendHeader, 0); 
  
 			printf_s("send success : %s\n", mSendPacket); 
  
 			ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
  
 			mSendType = None; 
 			mRecvType = Head; 
 		} 
 	} 
  
 	SOCKET mSocket; 
 	MsgType mRecvType; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	MsgType mSendType; 
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
 }; 
  
 LRESULT CALLBACK WinProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) 
 { 
 	switch (uMsg) 
 	{ 
 		case WM_SOCKET: 
 		{ 
 			SOCKET socket = wParam; 
 			if (WSAGETSELECTERROR(lParam)) 
 			{ 
 				::closesocket(socket); 
 				return 0; 
 			} 
 			switch (WSAGETSELECTEVENT(lParam)) 
 			{ 
 				case FD_ACCEPT: 
 					{ 
 						sockaddr_in addrClient; 
 						int addrClientlen = sizeof(addrClient); 
 						SOCKET clientSocket = accept(socket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 						if (SOCKET_ERROR != clientSocket) 
 						{ 
 							Client * client = new Client(clientSocket); 
 							mClientSockets.push_back(client); 
 							::WSAAsyncSelect(clientSocket, hWnd, WM_SOCKET, FD_READ | FD_WRITE | FD_CLOSE); 
 							printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 						} 
 					} 
 				break; 
 					case FD_WRITE: 
 					{ 
 						 
 					} 
 				break; 
 					case FD_READ: 
 					{ 
 						std::list<Client*>::iterator iter = mClientSockets.begin(); 
 						std::list<Client*>::iterator end = mClientSockets.end(); 
 						for (; iter != end; ++iter) 
 						{ 
 							if ((*iter)->mSocket == socket) 
 							{ 
 								(*iter)->handleRecv(); 
 							} 
 						} 
 					} 
 				break; 
 					case FD_CLOSE: 
 					{ 
 						std::list<Client*>::iterator iter = mClientSockets.begin(); 
 						std::list<Client*>::iterator end = mClientSockets.end(); 
 						for (; iter != end; ++iter) 
 						{ 
 							if ((*iter)->mSocket == socket) 
 							{ 
 								delete *iter; 
 								mClientSockets.erase(iter); 
 								break; 
 							} 
 						} 
 					} 
 				break; 
 			} 
 		} 
 	} 
  
 	//不处理的消息交给系统默认处理 
 	return ::DefWindowProc(hWnd, uMsg, wParam, lParam); 
 } 
  
 int main() 
 { 
 #pragma region 创建窗口 
 	char szClassName[] = "SocketDemo"; 
 	WNDCLASSEX wndclass; 
 	wndclass.cbSize = sizeof(wndclass); 
 	wndclass.style = CS_HREDRAW | CS_VREDRAW; 
 	wndclass.lpfnWndProc = WinProc; 
 	wndclass.cbWndExtra = 0; 
 	wndclass.cbClsExtra = 0; 
 	wndclass.hInstance = NULL; 
 	wndclass.hIcon = ::LoadIcon(NULL, IDI_APPLICATION); 
 	wndclass.hCursor = ::LoadCursor(NULL, IDC_ARROW); 
 	wndclass.hbrBackground = (HBRUSH)::GetStockObject(WHITE_BRUSH); 
 	wndclass.lpszMenuName = NULL; 
 	wndclass.lpszClassName = szClassName; 
 	wndclass.hIconSm = NULL; 
 	::RegisterClassEx(&wndclass); 
  
 	hWnd = ::CreateWindowEx(0, szClassName, "WSAAsyncSelect", WS_OVERLAPPEDWINDOW, 
 		CW_USEDEFAULT, 
 		CW_USEDEFAULT, 
 		CW_USEDEFAULT, 
 		CW_USEDEFAULT, 
 		NULL, 
 		NULL, 
 		NULL, 
 		NULL); 
  
 	if (hWnd == NULL) 
 	{ 
 		::MessageBox(NULL, "创建窗口出错！", "error", MB_OK); 
 		return -1; 
 	} 
 #pragma endregion 
  
 	mainThread(); 
  
 	return 1; 
 }
 ```
 
## WSAEventSelect I/O模型
 > 通过事件通知实现非阻塞调用，但数据复制到用户空间是阻塞的。并且一个WSAWaitForMultipleEvents接口最多管理64个事件，其余的需要新开线程。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
  
 SOCKET	mAllSocket[WSA_MAXIMUM_WAIT_EVENTS]; 
 int mTotalEvent(0); 
 WSAEVENT mAllEvent[WSA_MAXIMUM_WAIT_EVENTS]; 
  
 class Client; 
 std::list<Client*> mClientSockets; 
  
 void InputThreadCmd(); 
 void eventSelectThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	mAllSocket[mTotalEvent] = mListenSocket; 
 	mAllEvent[mTotalEvent] = WSACreateEvent(); 
 	WSAEventSelect(mAllSocket[mTotalEvent], mAllEvent[mTotalEvent], FD_ACCEPT | FD_CLOSE); 
 	mTotalEvent++; 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(eventSelectThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s), 
 		mRecvType(Head), 
 		mRecvHeader(0), 
 		mSendType(None), 
 		mSendHeader(0) 
 	{ 
 		ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 		ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	enum MsgType 
 	{ 
 		None, 
 		Head, 
 		Pack 
 	}; 
  
 	void handleRecv() 
 	{ 
 		if (Head == mRecvType) 
 		{ 
 			recv(mSocket, (char*)&mRecvHeader, sizeof(mRecvHeader), 0); 
 			mRecvType = Pack; 
 		} 
 		else if (Pack == mRecvType) 
 		{ 
 			ZeroMemory(mRecvPacket, sizeof(mRecvPacket)); 
 			recv(mSocket, mRecvPacket, mRecvHeader, 0); 
  
 			int endIndex = 0; 
 			for (int m = 0; m < sizeof(mRecvPacket); ++m) 
 			{ 
 				if (mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
 			std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
 			mSendHeader = endIndex; 
  
 			mRecvType = None; 
 			mSendType = Head; 
  
 			handleSend(); 
 		} 
 	} 
  
 	void handleSend() 
 	{ 
 		if (Head == mSendType) 
 		{ 
 			int retVal = send(mSocket, (char*)&mSendHeader, sizeof(mSendHeader), 0); 
 			mSendType = Pack; 
 		} 
 		if (Pack == mSendType) 
 		{ 
 			send(mSocket, mSendPacket, mSendHeader, 0); 
  
 			printf_s("send success : %s\n", mSendPacket); 
  
 			ZeroMemory(mSendPacket, sizeof(mSendPacket)); 
  
 			mSendType = None; 
 			mRecvType = Head; 
 		} 
 	} 
  
 	SOCKET mSocket; 
 	MsgType mRecvType; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	MsgType mSendType; 
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
 }; 
  
 //接收客户端链接线程 
 void eventSelectThreadCmd() 
 { 
 	while (!mTerminated) 
 	{ 
 		DWORD dwIndex = WSAWaitForMultipleEvents(mTotalEvent, mAllEvent, false, 100, false); 
 		if (WSA_WAIT_FAILED == dwIndex) 
 		{ 
 			printf_s("server WSAWaitForMultipleEvents failed!!!\n"); 
 			continue; 
 		} 
 		if (WSA_WAIT_TIMEOUT == dwIndex) 
 		{ 
 			Sleep(100); 
 			continue; 
 		} 
 		WSANETWORKEVENTS networkEvents; 
 		if (SOCKET_ERROR == WSAEnumNetworkEvents(mAllSocket[dwIndex - WSA_WAIT_EVENT_0], mAllEvent[dwIndex - WSA_WAIT_EVENT_0], &networkEvents)) 
 		{ 
 			printf_s("server WSAEnumNetworkEvents failed!!!\n"); 
 			continue; 
 		} 
  
 		//accept 
 		if (networkEvents.lNetworkEvents & FD_ACCEPT) 
 		{ 
 			sockaddr_in addrClient; 
 			int addrClientlen = sizeof(addrClient); 
 			SOCKET clientSocket = accept(mAllSocket[dwIndex - WSA_WAIT_EVENT_0], (sockaddr FAR*)&addrClient, &addrClientlen); 
 			if (SOCKET_ERROR != clientSocket) 
 			{ 
 				mAllSocket[mTotalEvent] = clientSocket; 
 				mAllEvent[mTotalEvent] = WSACreateEvent(); 
 				WSAEventSelect(mAllSocket[mTotalEvent], mAllEvent[mTotalEvent], FD_READ | FD_WRITE | FD_CLOSE); 
 				mTotalEvent++; 
  
 				Client * client = new Client(clientSocket); 
 				mClientSockets.push_back(client); 
 				printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 			} 
 		} 
  
 		//read 
 		if (networkEvents.lNetworkEvents & FD_READ) 
 		{ 
 			std::list<Client*>::iterator iter = mClientSockets.begin(); 
 			std::list<Client*>::iterator end = mClientSockets.end(); 
 			for (; iter != end; ++iter) 
 			{ 
 				if ((*iter)->mSocket == mAllSocket[dwIndex - WSA_WAIT_EVENT_0]) 
 				{ 
 					(*iter)->handleRecv(); 
 				} 
 			} 
 		} 
  
 		//write 
 		if (networkEvents.lNetworkEvents & FD_WRITE) 
 		{ 
 			//当收到第一个FD_WRITE时便认为可以send；send失败返回WSAEWOULDBLOCKE时，则需要再一次收到FD_WRITE才能send； 
 			//send这里就简单处理为recv后直接send 
 		} 
  
 		//close 
 		if (networkEvents.lNetworkEvents & FD_CLOSE) 
 		{ 
 			std::list<Client*>::iterator iter = mClientSockets.begin(); 
 			std::list<Client*>::iterator end = mClientSockets.end(); 
 			for (; iter != end; ++iter) 
 			{ 
 				if ((*iter)->mSocket == mAllSocket[dwIndex - WSA_WAIT_EVENT_0]) 
 				{ 
 					delete *iter; 
 					mClientSockets.erase(iter); 
 					WSACloseEvent(mAllEvent[dwIndex - WSA_WAIT_EVENT_0]); 
 					for (int m = dwIndex - WSA_WAIT_EVENT_0;m < mTotalEvent - 1;++m) 
 					{ 
 						mAllEvent[m] = mAllEvent[m + 1]; 
 						mAllSocket[m] = mAllSocket[m + 1]; 
 					} 
 					mTotalEvent--; 
 					break; 
 				} 
 			} 
 		} 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```

## Overlapped I/O模型

 > 非阻塞调用，通过windows的重叠I/O机制实现数据复制到用户空间为非阻塞行为。
  
### 以完成例程实现
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
 std::list<Client*> mNewSockets; 
 std::mutex mtx; 
  
 void InputThreadCmd(); 
 void acceptThreadCmd(); 
 void HandleThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2,2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = WSASocket(AF_INET, SOCK_STREAM, 0, NULL, 0, WSA_FLAG_OVERLAPPED); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//设置监听套接字为非阻塞模式 
 	u_long ulUnBlocking = 1; 
 	int ret = ioctlsocket(mListenSocket, FIONBIO, &ulUnBlocking); 
 	if (SOCKET_ERROR == ret) 
 	{ 
 		printf("server socket ioctlsocket failed\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
 	 
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(acceptThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread handleThread(HandleThreadCmd); 
 	handleThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s) 
 	{ 
 		ZeroMemory(&mRecvOverLapped,sizeof(mRecvOverLapped)); 
 		ZeroMemory(&mSendOverLapped, sizeof(mSendOverLapped)); 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	void RecvHeader() 
 	{ 
 		ZeroMemory(&mRecvOverLapped,sizeof(mRecvOverLapped)); 
 		mRecvOverLapped.hEvent = WSAEVENT(this); 
  
 		mRecvHeader = 0; 
  
 		WSABUF wsaRecv; 
 		wsaRecv.buf = (char*)&mRecvHeader; 
 		wsaRecv.len = sizeof(mRecvHeader); 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvOverLapped, RecvRoutine); 
 	} 
  
 	void RecvPacket() 
 	{ 
 		ZeroMemory(&mRecvOverLapped, sizeof(mRecvOverLapped)); 
 		mRecvOverLapped.hEvent = WSAEVENT(this); 
  
 		ZeroMemory(mRecvPacket, BUF_SIZE); 
 		WSABUF wsaRecv; 
 		wsaRecv.buf = mRecvPacket; 
 		wsaRecv.len = mRecvHeader; 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvOverLapped, RecvRoutine); 
 	} 
  
 	void Send() 
 	{ 
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		ZeroMemory(&mSendOverLapped, sizeof(mSendOverLapped));	//重叠结构 
 		mSendOverLapped.hEvent = WSAEVENT(this); 
  
 		WSABUF wsaSendBuf[2];				//WSABUF结构数组 
 		 
 		//数据包头 
 		wsaSendBuf[0].buf = (char*)&mSendHeader; 
 		wsaSendBuf[0].len = sizeof(mSendHeader); 
  
 		//数据包体 
 		wsaSendBuf[1].buf = mSendPacket; 
 		wsaSendBuf[1].len = mSendHeader; 
  
 		WSASend(mSocket, wsaSendBuf, 2, &dwBytesRecved, dwFlags, &mSendOverLapped, SendRoutine); 
 	} 
  
 	static void CALLBACK RecvRoutine(DWORD error,DWORD BytesTransferred, LPWSAOVERLAPPED Overlapped, DWORD InFlags) 
 	{ 
 		if (0 != error || 0 == BytesTransferred) 
 		{ 
 			return; 
 		} 
 		Client* client = (Client*)Overlapped->hEvent; 
 		if (0 != client->mRecvHeader)//接收包体 
 		{ 
 			client->RecvPacket(); 
 			client->mRecvHeader = 0; 
 		} 
 		else 
 		{ 
 			int endIndex = 0; 
 			for (int m = 0;m < BUF_SIZE;++m) 
 			{ 
 				if (client->mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
  
 			client->mSendHeader = endIndex; 
 			ZeroMemory(client->mSendPacket, BUF_SIZE); 
 			std::transform(client->mRecvPacket, client->mRecvPacket + endIndex, client->mSendPacket, towupper); 
 			client->Send(); 
 		} 
 	} 
  
 	static void CALLBACK SendRoutine(DWORD error, DWORD BytesTransferred, LPWSAOVERLAPPED Overlapped, DWORD InFlags) 
 	{ 
 		if (0 != error || 0 == BytesTransferred) 
 		{ 
 			return; 
 		} 
 		Client* client = (Client*)Overlapped->hEvent; 
 		printf_s("send success : %s\n", client->mSendPacket); 
  
 		client->RecvHeader(); 
 	} 
 	 
 	SOCKET mSocket; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
  
 	WSAOVERLAPPED mRecvOverLapped; 
 	WSAOVERLAPPED mSendOverLapped; 
 }; 
  
 //接收客户端链接线程 
 void acceptThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	while (!mTerminated) 
 	{ 
 		SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 		if (SOCKET_ERROR != clientSocket) 
 		{ 
 			Client * client = new Client(clientSocket); 
 			mClientSockets.push_back(client); 
 			mtx.lock(); 
 			mNewSockets.push_back(client); 
 			mtx.unlock(); 
 			printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 		} 
  
 		SleepEx(100, true); 
 	} 
  
 	while (mClientSockets.size() > 0) 
 	{ 
 		delete mClientSockets.front(); 
 		mClientSockets.pop_front(); 
 	} 
 } 
  
 //收发线程 
 void HandleThreadCmd() 
 { 
 	while (!mTerminated) 
 	{ 
 		mtx.lock(); 
 		while (mNewSockets.size() > 0) 
 		{ 
 			mNewSockets.front()->RecvHeader(); 
 			mNewSockets.pop_front(); 
 		} 
 		mtx.unlock(); 
 		SleepEx(100, true); 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```

### 以事件实现
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <list> 
 #include <map> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
 std::map<WSAEVENT, WSAOVERLAPPED*> mAllClientOverlappedEvent; 
 std::map<WSAEVENT, Client*> mEventSockets; 
 int mEventIndex = 0; 
 WSAEVENT mAllEvent[WSA_MAXIMUM_WAIT_EVENTS]; 
  
 void InputThreadCmd(); 
 void acceptThreadCmd(); 
 void HandleThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = WSASocket(AF_INET, SOCK_STREAM, 0, NULL, 0, WSA_FLAG_OVERLAPPED); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//设置监听套接字为非阻塞模式 
 	u_long ulUnBlocking = 1; 
 	int ret = ioctlsocket(mListenSocket, FIONBIO, &ulUnBlocking); 
 	if (SOCKET_ERROR == ret) 
 	{ 
 		printf("server socket ioctlsocket failed\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		return; 
 	} 
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	for (int m = 0;m < WSA_MAXIMUM_WAIT_EVENTS;++m) 
 	{ 
 		mAllEvent[m] = NULL; 
 	} 
  
 	std::thread acceptThread(acceptThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread handleThread(HandleThreadCmd); 
 	handleThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s) 
 	{ 
 		ZeroMemory(&mRecvOverLapped, sizeof(mRecvOverLapped)); 
 		mRecvEvent = WSACreateEvent(); 
 		mRecvOverLapped.hEvent = mRecvEvent; 
  
 		ZeroMemory(&mSendOverLapped, sizeof(mSendOverLapped)); 
 		mSendEvent = WSACreateEvent(); 
 		mSendOverLapped.hEvent = mSendEvent; 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	void RecvHeader() 
 	{ 
 		mRecvHeader = 0; 
  
 		WSABUF wsaRecv; 
 		wsaRecv.buf = (char*)&mRecvHeader; 
 		wsaRecv.len = sizeof(mRecvHeader); 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvOverLapped, NULL); 
 	} 
  
 	void RecvPacket() 
 	{ 
 		ZeroMemory(mRecvPacket, BUF_SIZE); 
 		WSABUF wsaRecv; 
 		wsaRecv.buf = mRecvPacket; 
 		wsaRecv.len = mRecvHeader; 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvOverLapped, NULL); 
 	} 
  
 	void Send() 
 	{ 
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSABUF wsaSendBuf[2];				//WSABUF结构数组 
  
 											//数据包头 
 		wsaSendBuf[0].buf = (char*)&mSendHeader; 
 		wsaSendBuf[0].len = sizeof(mSendHeader); 
  
 		//数据包体 
 		wsaSendBuf[1].buf = mSendPacket; 
 		wsaSendBuf[1].len = mSendHeader; 
  
 		WSASend(mSocket, wsaSendBuf, 2, &dwBytesRecved, dwFlags, &mSendOverLapped, NULL); 
 	} 
  
 	void RecvHandleEvent() 
 	{ 
 		if (0 != mRecvHeader)//接收包体 
 		{ 
 			RecvPacket(); 
 			mRecvHeader = 0; 
 		} 
 		else 
 		{ 
 			int endIndex = 0; 
 			for (int m = 0;m < BUF_SIZE;++m) 
 			{ 
 				if (mRecvPacket[m] == '\0') 
 				{ 
 					endIndex = m; 
 					break; 
 				} 
 			} 
  
 			mSendHeader = endIndex; 
 			ZeroMemory(mSendPacket, BUF_SIZE); 
 			std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
 			Send(); 
 		} 
 	} 
  
 	void SendHandleEvent() 
 	{ 
 		printf_s("send success : %s\n", mSendPacket); 
  
 		RecvHeader(); 
 	} 
  
 	SOCKET mSocket; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
  
 	WSAOVERLAPPED mRecvOverLapped; 
 	WSAEVENT mRecvEvent; 
  
 	WSAOVERLAPPED mSendOverLapped; 
 	WSAEVENT mSendEvent; 
 }; 
  
 //接收客户端链接线程 
 void acceptThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	while (!mTerminated) 
 	{ 
 		SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 		if (SOCKET_ERROR != clientSocket) 
 		{ 
 			Client * client = new Client(clientSocket); 
 			mClientSockets.push_back(client); 
  
 			mEventSockets[client->mRecvEvent] = client; 
 			mEventSockets[client->mSendEvent] = client; 
  
 			mAllEvent[mEventIndex++] = client->mRecvEvent; 
 			mAllClientOverlappedEvent[client->mRecvEvent] = &client->mRecvOverLapped; 
  
 			mAllEvent[mEventIndex++] = client->mSendEvent; 
 			mAllClientOverlappedEvent[client->mSendEvent] = &client->mSendOverLapped; 
  
 			printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 			client->RecvHeader(); 
 		} 
  
 		SleepEx(100, true); 
 	} 
  
 	while (mClientSockets.size() > 0) 
 	{ 
 		delete mClientSockets.front(); 
 		mClientSockets.pop_front(); 
 	} 
 } 
  
 //收发线程 
 void HandleThreadCmd() 
 { 
 	DWORD dwIndex;				//返回值 
 	DWORD dwFlags;				//标志 
 	DWORD dwBytesTraned;		//实际传输的数据 
  
 	while (!mTerminated) 
 	{ 
 		if(0 == mEventIndex) 
 			continue; 
 		 
 		//等待事件 
 		if ((dwIndex = WSAWaitForMultipleEvents(mEventIndex, mAllEvent, FALSE, 100, TRUE)) == WSA_WAIT_FAILED) 
 		{ 
 			printf("WSAWaitForMultipleEvents 失败 %d\n", WSAGetLastError()); 
 			continue; 
 		} 
 		if (WSA_WAIT_TIMEOUT == dwIndex) 
 		{ 
 			continue; 
 		} 
  
 		WSAEVENT handleEvent = mAllEvent[dwIndex - WSA_WAIT_EVENT_0]; 
 		Client* client = mEventSockets[handleEvent]; 
  
 		//重置事件 
 		WSAResetEvent(handleEvent); 
  
 		WSAOVERLAPPED* overlapped = mAllClientOverlappedEvent[handleEvent]; 
  
 		//检查操作完成状态 
 		BOOL bRet = WSAGetOverlappedResult(client->mSocket, overlapped, &dwBytesTraned, TRUE, &dwFlags); 
 		if (bRet != FALSE && dwBytesTraned != 0)//发生错误 
 		{ 
 			if (&client->mRecvOverLapped == overlapped) 
 			{ 
 				client->RecvHandleEvent(); 
 			} 
 			else if (&client->mSendOverLapped == overlapped) 
 			{ 
 				client->SendHandleEvent(); 
 			} 
 		} 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```
 
## 完成端口 I/O模型
 > 完成端口对象的并发线程会等待系统的I/Ocompletion packet，接收后会唤醒服务线程池中上一个执行的线程处理。
 > 理解完成端口需要理解2个线程数量。[1]完成端口并发线程数；[2]服务线程数。这些线程数同CPU核心相关，一般[1]为CPU核心数，[2]为CPU核心数的2倍。那么理论上提高CPU核心就可以直接提高效率。
 ```cpp
 #define _WINSOCK_DEPRECATED_NO_WARNINGS 
  
 #include <cstdio> 
 #include <iostream> 
 #include <string> 
 #include <algorithm> 
 #include <WinSock2.h> 
 #include <thread> 
 #include <mutex> 
 #include <list> 
  
 #pragma comment(lib, "WS2_32.lib") 
  
 #define BUF_SIZE 128 
  
 bool mTerminated = false; 
  
 SOCKET	mListenSocket;//监听套接字 
 class Client; 
 std::list<Client*> mClientSockets; 
  
 HANDLE mIOCompletion;//完成端口 
  
 void InputThreadCmd(); 
 void acceptThreadCmd(); 
 void ServeThreadCmd(); 
  
 void CleanUpEnvironment() 
 { 
 	if (INVALID_SOCKET != mListenSocket) 
 	{ 
 		closesocket(mListenSocket); 
 	} 
 	WSACleanup(); 
 } 
  
 void mainThread() 
 { 
 #pragma region 初始化网络环境 
 	//初始化socket动态库 
 	WSADATA	mWsd; 
 	if (0 != WSAStartup(MAKEWORD(2, 2), &mWsd)) 
 	{ 
 		printf_s("WSAStartup failed!\n"); 
 		return; 
 	} 
 	//初始化服务器socket 
 	mListenSocket = WSASocket(AF_INET, SOCK_STREAM, 0, NULL, 0, WSA_FLAG_OVERLAPPED); 
 	if (INVALID_SOCKET == mListenSocket) 
 	{ 
 		printf_s("init server socket failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	//绑定服务器socket 
 	SOCKADDR_IN mServerAddr; 
 	mServerAddr.sin_family = AF_INET; 
 	mServerAddr.sin_port = htons(21234); 
 	mServerAddr.sin_addr.s_addr = INADDR_ANY; 
 	if (SOCKET_ERROR == bind(mListenSocket, (LPSOCKADDR)&mServerAddr, sizeof(SOCKADDR_IN))) 
 	{ 
 		printf_s("server socket bind failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
 	//监听 
 	if (SOCKET_ERROR == listen(mListenSocket, SOMAXCONN)) 
 	{ 
 		printf_s("server socket listen failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 	mIOCompletion = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0); 
 	if (NULL == mIOCompletion) 
 	{ 
 		printf_s("server CreateIoCompletionPort failed!\n"); 
 		CleanUpEnvironment(); 
 		return; 
 	} 
  
 #pragma endregion 
  
 #pragma region 开启线程 
 	printf_s("server star success!!!\n"); 
  
 	std::thread acceptThread(acceptThreadCmd); 
 	acceptThread.detach(); 
  
 	std::thread inputThread(InputThreadCmd); 
 	inputThread.detach(); 
  
 #pragma endregion 
  
 #pragma region 完成端口 服务线程 
 	SYSTEM_INFO info; 
 	GetSystemInfo(&info); 
 	for (int m = 0;m < info.dwNumberOfProcessors * 2;++m) 
 	{ 
 		std::thread serveThread(ServeThreadCmd); 
 		serveThread.detach(); 
  
 	} 
 #pragma endregion 
  
 	char s[128]; 
 	while (!mTerminated) 
 	{ 
 		sprintf_s(s, "OnLine: %d\n", mClientSockets.size()); 
 		::SetConsoleTitle(s); 
  
 		std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
 	} 
 } 
  
 void InputThreadCmd() 
 { 
 	while (true) 
 	{ 
 		std::string cmdLine; 
 		if (getline(std::cin, cmdLine)) 
 		{ 
 			if (cmdLine == "//q") 
 			{ 
 				mTerminated = true; 
 			} 
 		} 
 	} 
 } 
  
 enum MsgType 
 { 
 	None, 
 	RecvHead, 
 	RecvPack, 
 	SendData, 
 }; 
  
 struct ClientIOData 
 { 
 	OVERLAPPED mRecvOverLapped; 
 	MsgType mType; 
 }; 
  
 class Client 
 { 
 public: 
 	Client(SOCKET s) 
 		:mSocket(s) 
 	{ 
 		 
 	} 
  
 	~Client() 
 	{ 
 		closesocket(mSocket); 
 	} 
  
 	void RecvHeader() 
 	{ 
 		ZeroMemory(&mRecvIOData, sizeof(ClientIOData)); 
 		mRecvIOData.mType = RecvHead; 
  
 		mRecvHeader = 0; 
  
 		WSABUF wsaRecv; 
 		wsaRecv.buf = (char*)&mRecvHeader; 
 		wsaRecv.len = sizeof(mRecvHeader); 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvIOData.mRecvOverLapped, NULL); 
 	} 
  
 	void RecvPacket() 
 	{ 
 		ZeroMemory(&mRecvIOData, sizeof(ClientIOData)); 
 		mRecvIOData.mType = RecvPack; 
  
 		ZeroMemory(mRecvPacket, BUF_SIZE); 
 		WSABUF wsaRecv; 
 		wsaRecv.buf = mRecvPacket; 
 		wsaRecv.len = mRecvHeader; 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		WSARecv(mSocket, &wsaRecv, 1, &dwBytesRecved, &dwFlags, &mRecvIOData.mRecvOverLapped, NULL); 
 	} 
  
 	void Send() 
 	{ 
 		int endIndex = 0; 
 		for (int m = 0;m < BUF_SIZE;++m) 
 		{ 
 			if (mRecvPacket[m] == '\0') 
 			{ 
 				endIndex = m; 
 				break; 
 			} 
 		} 
  
 		mSendHeader = endIndex; 
 		ZeroMemory(mSendPacket, BUF_SIZE); 
 		std::transform(mRecvPacket, mRecvPacket + endIndex, mSendPacket, towupper); 
  
 		DWORD	dwBytesRecved;				//接收字节数 
 		DWORD	dwFlags = 0;				//标志 
  
 		ZeroMemory(&mSendIOData, sizeof(ClientIOData)); 
 		mSendIOData.mType = SendData; 
  
 		WSABUF wsaSendBuf[2];				//WSABUF结构数组 
  
 											//数据包头 
 		wsaSendBuf[0].buf = (char*)&mSendHeader; 
 		wsaSendBuf[0].len = sizeof(mSendHeader); 
  
 		//数据包体 
 		wsaSendBuf[1].buf = mSendPacket; 
 		wsaSendBuf[1].len = mSendHeader; 
  
 		WSASend(mSocket, wsaSendBuf, 2, &dwBytesRecved, dwFlags, &mSendIOData.mRecvOverLapped, NULL); 
 	} 
  
 	SOCKET mSocket; 
 	unsigned short mRecvHeader;//包头 
 	char mRecvPacket[BUF_SIZE];//包体 
  
 	unsigned short mSendHeader;//包头 
 	char mSendPacket[BUF_SIZE];//包体 
  
 	ClientIOData mRecvIOData; 
 	ClientIOData mSendIOData; 
 }; 
  
 //接收客户端链接线程 
 void acceptThreadCmd() 
 { 
 	printf_s("server begin accept client...\n"); 
 	sockaddr_in addrClient; 
 	int addrClientlen = sizeof(addrClient); 
 	while (!mTerminated) 
 	{ 
 		SOCKET clientSocket = accept(mListenSocket, (sockaddr FAR*)&addrClient, &addrClientlen); 
 		if (SOCKET_ERROR != clientSocket) 
 		{ 
 			Client * client = new Client(clientSocket); 
 			//将socket和完成端口关联起来 
 			if (NULL == CreateIoCompletionPort((HANDLE)clientSocket, mIOCompletion, (DWORD)client, 0)) 
 			{ 
 				continue; 
 			} 
 			mClientSockets.push_back(client); 
 			printf_s("accept new client,IP : %s		Port : %d\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port)); 
 			client->RecvHeader(); 
 		} 
  
 		SleepEx(100, true); 
 	} 
  
 	while (mClientSockets.size() > 0) 
 	{ 
 		delete mClientSockets.front(); 
 		mClientSockets.pop_front(); 
 	} 
 } 
  
 void ServeThreadCmd() 
 { 
 	DWORD mIOSize; 
 	Client*	mClient; 
 	LPOVERLAPPED mOverlapped; 
  
 	while (!mTerminated) 
 	{ 
 		mIOSize = 0; 
 		mClient = NULL; 
 		mOverlapped = NULL; 
  
 		bool retVal = GetQueuedCompletionStatus(mIOCompletion, &mIOSize, (PULONG_PTR)&mClient, &mOverlapped, INFINITE); 
 		if (retVal && NULL != mClient && NULL != mOverlapped && mIOSize > 0) 
 		{ 
 			ClientIOData* ioData = CONTAINING_RECORD(mOverlapped, ClientIOData, mRecvOverLapped); 
 			if (ioData->mType == RecvHead) 
 			{ 
 				mClient->RecvPacket(); 
 			} 
 			else if (ioData->mType == RecvPack) 
 			{ 
 				mClient->Send(); 
 			} 
 			else if (ioData->mType == SendData) 
 			{ 
 				printf_s("send success : %s\n", mClient->mSendPacket); 
  
 				mClient->RecvHeader(); 
 			} 
 		} 
 	} 
 } 
  
 int main() 
 { 
 	mainThread(); 
  
 	return 1; 
 }
 ```

# 总结
 通过学习Socket网络编程，我认为要开发高效的网络库应该需要注意阻塞，循环调用，线程数量，链接数，IO。这些在接下来学习商业开源网络库的时候需要重点关注。