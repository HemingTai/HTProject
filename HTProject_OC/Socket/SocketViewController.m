//
//  SocketViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/27.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "SocketViewController.h"
#import "HTSocketManager.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <Masonry.h>

/************************ 网络协议：TCP/IP、SOCKET、HTTP ************************************************
 * 网络七层由下往上分别为物理层、数据链路层、网络层、传输层、会话层、表示层和应用层。
 * 其中物理层、数据链路层和网络层通常被称作媒体层，是网络工程师所研究的对象。
 * 传输层、会话层、表示层和应用层则被称作主机层，是用户所面向和关心的内容。
 * HTTP协议对应于应用层，TCP协议对应于传输层，IP协议对应于网络层，三者本质上没有可比性。
 * HTTP协议是基于TCP连接的。
 * TCP/IP是传输层协议，主要解决数据如何在网络中传输；而HTTP是应用层协议，主要解决如何包装数据。
 * 我们在传输数据时，可以只使用传输层（TCP/IP），但是那样的话，由于没有应用层，便无法识别数据内容，
 * 如果想要使传输的数据有意义，则必须使用应用层协议，应用层协议很多，有HTTP、FTP、TELNET等等，也可以自己定义应用层协议。
 * WEB使用HTTP作传输层协议，以封装HTTP文本信息，然后使用TCP/IP做传输层协议将它发送到网络上。
 * Socket是对TCP/IP协议的封装，Socket本身并不是协议，而是一个调用接口（API），通过Socket，我们才能使用TCP/IP协议。
 *****************************************************************************************************/

/************************ 建立一个TCP连接需要经过“三次握手” **********************************************
 * 第一次握手：客户端发送syn包(syn=j)到服务器，并进入SYN_SEND状态，等待服务器确认；
 * 第二次握手：服务器收到syn包，必须确认客户的SYN（ack=j+1），同时自己也发送一个SYN包（syn=k），即SYN+ACK包，此时服务器进入SYN_RECV状态；
 * 第三次握手：客户端收到服务器的SYN＋ACK包，向服务器发送确认包ACK(ack=k+1)，此包发送完毕，客户端和服务器进入ESTABLISHED状态，完成三次握手。
 * 握手过程中传送的包里不包含数据，三次握手完毕后，客户端与服务器才正式开始传送数据。
 * 理想状态下，TCP连接一旦建立，在通信双方中的任何一方主动关闭连接之前，TCP连接都将被一直保持下去。
 * 断开连接时服务器和客户端均可以主动发起断开TCP连接的请求，断开过程需要经过“四次握手”（就是服务器和客户端交互，最终确定断开）
 *****************************************************************************************************/

/************************ 建立一个HTTP连接 *************************************************************
 * HTTP协议即超文本传送协议(HypertextTransferProtocol )是Web联网的基础，HTTP协议是建立在TCP协议之上的一种应用。
 * HTTP连接最显著的特点是客户端发送的每次请求都需要服务器回送响应，在请求结束后，会主动释放连接。
 * 从建立连接到关闭连接的过程称为“一次连接”。
 * 由于HTTP在每次请求结束后都会主动释放连接，因此HTTP连接是一种“短连接”，要保持客户端程序的在线状态，需要不断地向服务器发起连接请求。
 * 通常的做法是即使不需要获得任何数据，客户端也保持每隔一段固定的时间向服务器发送一次“保持连接”的请求，
 * 服务器在收到该请求后对客户端进行回复，表明知道客户端“在线”。若服务器长时间无法收到客户端的请求，则认为客户端“下线”，
 * 若客户端长时间无法收到服务器的回复，则认为网络已经断开。
 *****************************************************************************************************/

/************************ 建立一个SOCKET连接 ***********************************************************
 * 建立Socket连接至少需要一对套接字，其中一个运行于客户端，称为ClientSocket，另一个运行于服务器端，称为ServerSocket。
 * 套接字之间的连接过程分为三个步骤：服务器监听，客户端请求，连接确认。
 * 服务器监听：服务器端套接字并不定位具体的客户端套接字，而是处于等待连接的状态，实时监控网络状态，等待客户端的连接请求。
 * 客户端请求：指客户端的套接字提出连接请求，要连接的目标是服务器端的套接字。
 * 为此，客户端的套接字必须首先描述它要连接的服务器的套接字，指出服务器端套接字的地址和端口号，然后就向服务器端套接字提出连接请求。
 * 连接确认：当服务器端套接字监听到或者说接收到客户端套接字的连接请求时，就响应客户端套接字的请求，建立一个新的线程，
 * 把服务器端套接字的描述发给客户端，一旦客户端确认了此描述，双方就正式建立连接。
 * 而服务器端套接字继续处于监听状态，继续接收其他客户端套接字的连接请求。
 *****************************************************************************************************/

/************************ SOCKET连接与TCP连接 *********************************************************
 * 创建Socket连接时，可以指定使用的传输层协议，Socket可以支持不同的传输层协议（TCP或UDP），
 * 当使用TCP协议进行连接时，该Socket连接就是一个TCP连接。
 *****************************************************************************************************/

/************************ Socket ***********************
 * 三要素：ip地址，端口号，传输协议（TCP、UDP）
 * 目的：基于ip地址上的某个端口号来进行点对点的通讯
 * 本质：是一组API，供应用层来操作传输层，本身是没有协议的
 *******************************************************/

@interface SocketViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SocketIOClient *socket;
@property (nonatomic, assign) int clientSocket;
@property (nonatomic, assign) BOOL flag;

@end

@implementation SocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSubviews];
    
//    self.socket = [HTSocketManager shared].socket;
//    [self addSockethandlers];
//    [self.socket connect];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self connectSocket];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self disconnectSocket];
}

- (void)initializeSubviews {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"ChatRoom";
    
    _textView = [[UITextView alloc] init];
    _textView.textColor = UIColor.whiteColor;
    _textView.backgroundColor = UIColor.blackColor;
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.font = [UIFont systemFontOfSize:20];
    _textView.editable = NO;
    _textView.text = @"Welcome!";
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(400);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    [send setTitle:@"send" forState:UIControlStateNormal];
    send.backgroundColor = UIColor.orangeColor;
    [send addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:send];
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.textField);
    }];
}

- (void)connectSocket {
    // 1. 创建ClientSocket
    // int socket(int domain, int type, int protocol);
    // domain 协议域， 常用AF_INET，指定IPv4
    // type socket类型. SOCK_STREAM 流式， SOCK_DGRAM 数据报
    // protocol IPPROTO_TCP TCP方式，可以设置为0，根据第二参数来自动确定第二个参数
    // 返回值，如果创建成功返回的是socket的描述符，失败返回-1
    _clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    // 2. 连接服务器
    // int connect(int sockfd, struct sockaddr *serv_addr, int addrlen);
    // sockfd 套接字描述符
    // serv_addr 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
    // addrlen 参数二serv_addr的长度，可以通过sizeof(struct sockaddr)获取
    // 成功返回0 失败返回非0
    // 创建结构体
    struct sockaddr_in addr;
    // 指定IPv4地址
    addr.sin_family = AF_INET;
    // 指定IP地址
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    // 指定端口，如果要模拟服务器，可在终端执行 nc -l 9909 即可
    addr.sin_port = htons(9909);
    // 连接
    int result = connect(_clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    
    // 判断是否连接成功
    if (0 == result) {
        // 打开本机模拟服务器端口
        // 打开Netcat模拟服务器
        // nc -lk 12345
        // nc-->Netcat终端下用于调试和检查网络的工具
        NSLog(@"成功");
    } else {
        // 服务器未打开时连接失败
        NSLog(@"失败");
        return;
    }
    
    // 3. 发送消息
    // ssize_t send(int s, const void *msg, size_t len, int flags);
    // s 套接字id
    // msg 发送的消息
    // len 发送的消息的大小,不是字节数，而是字符数
    // flags 阻塞或者不阻塞，一般填0
    // 返回值，成功返回发送出去的字节数，失败返回-1
//    const char *msg = "Hello socket!\n";
//    ssize_t sendCount = send(_clientSocket, msg, strlen(msg), 0);
//    NSLog(@"发送的字节数 %zd", sendCount);
    
    // 4. 接收服务器返回的数据
    // ssize_t recv(int s, void *buffer, size_t len, int flags);
    // s 套接字id
    // buffer 字符数组
    // len 字符长度
    // flags 阻塞或者不阻塞，一般填0
    // 返回值是实际接受的字节个数
    //这里加上异步子线程死循环是为了能够保持连接
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            uint8_t buffer[1024];
            ssize_t recvCount = recv(self->_clientSocket, buffer, 1024, 0);
            NSLog(@"接收的字节数 %zd", recvCount);
            
            // 把字节数组转换成字符串
            NSData *data = [NSData dataWithBytes:buffer length:recvCount];
            NSString *recvMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"收到的消息 : %@", recvMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [self.textView.text stringByAppendingString:@"\n"];
                self.textView.text = [self.textView.text stringByAppendingString:recvMsg];
            });
        };
    });
}

- (void)disconnectSocket {
    // 5. 关闭连接
    close(_clientSocket);
}

- (void)sendMessageAction {
    //断言是符合条件才继续往下执行，否则抛出异常
    NSParameterAssert(self.textField.text.length);
    [self sendMessageByClientSocket:_clientSocket withMessage:self.textField.text];
    self.textView.text = [self.textView.text stringByAppendingString:@"\n"];
    self.textView.text = [self.textView.text stringByAppendingString:self.textField.text];
    self.textField.text = nil;
}

- (void)sendMessageByClientSocket:(int)socket withMessage:(NSString *)message {
    const char *msg = [[message stringByAppendingString:@"\n"] UTF8String];
    ssize_t sendCount = send(socket, msg, strlen(msg), 0);
    NSLog(@"发送的字节数 %zd", sendCount);
}

- (void)addSockethandlers {
    //客户端事件-正在连接
    [self.socket on:@"connecting" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"正在连接");
    }];
    //客户端事件-连接成功
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"连接成功");
    }];
    //自定义事件-初始化数据
    [self.socket on:@"joinInit" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"--初始化数据--%@", data);
    }];
    //自定义事件-接收数据
    [self.socket on:@"stream" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"--接收数据--%@", data);
    }];
    //自定义事件-心跳ping
    [self.socket on:@"ping" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"--心跳ping--%@", data);
    }];
    //自定义事件-心跳pong
    [self.socket on:@"pong" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"--心跳pong--%@", data);
    }];
    //客户端事件-断开连接
    [self.socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"断开连接");
    }];
    //客户端事件-连接失败
    [self.socket on:@"connect_failed" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"连接失败");
    }];
    //客户端事件-正在重新连接
    [self.socket on:@"reconnecting" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"正在重新连接");
    }];
    //客户端事件-连接成功
    [self.socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"重新连接成功");
    }];
    //客户端事件-重新连接失败
    [self.socket on:@"reconnect_failed" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"重新连接失败");
    }];
    //客户端事件-message事件
    [self.socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"同服务器端message事件");
    }];
    //客户端事件-anything事件
    [self.socket on:@"anything" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"同服务器端anything事件");
    }];
    //客户端事件-连接出错
    [self.socket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"错误发生，并且无法被其他事件类型所处理");
    }];
    //所有事件都会走这个回调
    [self.socket onAny:^(SocketAnyEvent* event) {
        NSLog(@"%@", event);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.flag) {
        //向服务端发送数据
        [self.socket emit:@"join" with:@[@"3cu"]];
        self.flag = YES;
    } else {
        [self.socket emit:@"leave" with:@[@"3cu"]];
        //断开连接
        [self.socket disconnect];
    }
}

@end
