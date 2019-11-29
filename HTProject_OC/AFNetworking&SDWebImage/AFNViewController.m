//
//  AFNViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/4/8.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "AFNViewController.h"
#import "HTURLProtocol.h"
#import "HTNetworking.h"

@interface AFNViewController ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) YYAnimatedImageView *imgView3;

@end

@implementation AFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor getColorFromHexString:@"#ffffff"];
    /****************************************** AFNetworking源码解析 ************************************************
     * 1> AFN的优点: 1.原有基础NSURLSession上封装了一层，在传参方面更灵活；回调更友好，支持返回数据序列化；支持文件上传，断点下载
     *              2.自带多线程，防死锁
     *              3.运用锁机制，保证线程安全
     *              4.
     *              5.处理了Https证书流程，节省移动端开发
     *              6.支持网络状态判断
     *              7.可以获取到当前的所有tasks（包括dataTasks, uploadTasks, downloadTasks），也可以单独获取dataTasks, uploadTasks, downloadTasks，方便管理
     * 2> AFN使用了NSOperationQueue和信号量
     * 3> 关于AFN的底层解析请看博客：https://juejin.im/post/5dc289eb5188255fc535215d
     ***************************************************************************************************************/
    
    //状态栏旋转菊花
//    AFNetworkActivityIndicatorManager *activity = [AFNetworkActivityIndicatorManager sharedManager];
//    activity.enabled = YES;
    //加载旋转菊花
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    av.center = self.view.center;
    av.backgroundColor = UIColor.blackColor;
    [self.view addSubview:av];

    NSURLSessionDataTask *task = [[HTNetworking sharedManager] GET:@"https://www.apiopen.top/journalismApi"
                                                        parameters:nil
                                                          progress:nil
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                               NSLog(@"%@", responseObject);
                                                           }
                                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                               NSLog(@"%@", error);
                                                           }];
    [av setAnimatingWithStateOfTask:task];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 100, 150)];
    [self.view addSubview:self.imgView];
    self.imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 170, 100, 150)];
    [self.view addSubview:self.imgView2];
    self.imgView3 = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(100, 320, 100, 150)];
    [self.view addSubview:self.imgView3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /******************************** AFNetworking加载图片源码解析 ********************************
     * AFN提供了一系列加载网络图片的方法，但是最终都会调用setImageWithURLRequest:placeholderImage:success:failure:这个方法，源码分析如下
     * 1> 内部会先判断URL是否为空，如果为空，则设置image=placeholderImage，同时回调failure，最后return
     * 2> 如果URL不为空，再判断当前活跃的task对应的URL是不是和请求的URL相同，如果相同，则return
     * 3> 如果当前活跃的task对应的URL和请求的URL不相同，则先取消当前活跃的下载task，同时创建一个图片下载器，并根据当前的URLRequest去下载器中的缓存池里去取缓存
     * 4> 如果取到缓存，则回调success并清除当前下载信息，如果没有success，则设置image=缓存图片并清除当前下载信息
     * 5> 如果取不到缓存，则设置image=placeholderImage，同时创建下载任务进行下载
     * 6> 创建任务下载时，第一步：如果任务已存在，则把成功和失败回调添加到已经存在的任务回调数组里并return
     * 7> 第二步：如果任务不存在，判断缓存策略如果允许读取缓存，则尝试从缓存读取图片，如果读取到缓存则回调success
     * 8> 第三步：如果没有缓存则创建下载任务，下载任务完成回调中，先判断是否需要设置缓存，如果需要则缓存，否则直接回调responseHandlers数组中所有的handler
     * 9> 第四步：把创建的任务和回调保存下来以便完成时回调
     * 10> 第五步：判断当前活跃的task数是否超出最大值，没超出则开始下载，否则根据队列特性加入队列等待下载
     * 11> 图片下载完成则回调success，并设置image=responseObject，同时清除下载任务
     */
    
    /******************************** AFNetworking下载及缓存图片源码解析 ********************************
     * 1> 创建AFImageDownloader时，提供了初始化的配置，默认请求缓存(NSURLCache)使用了内存缓存20MB和磁盘缓存150MB，
     *    默认图片下载策略使用了先进先出策略，最大并发下载数是4个任务，默认图片缓存(ImageCache)使用了内存缓存100MB，磁盘缓存60MB
     * 2> 下载图片时会根据缓存策略先查找缓存，每一张图片缓存对应的key使用的是图片的URL再加additionalIdentifier，
     *    再根据这个key去缓存查找，如果找到缓存则直接返回主队列(注意：下载图片使用的是串行队列线程，为了保证下载策略先进先出)
     * 3> 如果没有找到缓存，则创建下载任务
     * 4> 开始下载同时使活跃的任务数加1，下载完成时先判断是否需要缓存，如果需要缓存则添加缓存
     * 5> 添加缓存时(使用GCD栅栏函数)，
     *    第一步：创建缓存的AFCachedImage对象，该对象包含了图片的大小和缓存时间，再获取之前缓存的图片，
     *           如果之前缓存的图片存在，使当前的内存缓存减去之前缓存图片的大小，否则缓存当前图片并使内存缓存加上当前图片的大小
     *    第二步：判断如果当前的内存缓存超过初始化时的100MB，则将当前缓存减去清除后缓存大小(60MB)从而计算出要清除缓存的大小，
     *           然后按图片的缓存时间升序排列，再遍历取图片统计出要清除的图片总大小是否大于要清除的大小，一旦大于则停止遍历，然后使当前内存减去要清除的图片总大小
     * 6> 完成缓存时，回调所有success，同时使活跃的任务数减1，如果有后续任务，则继续下载
     * 7> AFN不支持Gif图片
     */
    
    /******************************** NSURLCache ********************************
     * NSURLCache提供的是内存以及磁盘的综合缓存机制,默认就已经设置好了512KB的内存缓存空间，以及10MB的磁盘缓存空间
     * NSURLCache只会对你的GET请求进行缓存
     * NSURLRequestCachePolicy缓存策略：
     * NSURLRequestUseProtocolCachePolicy 使用协议缓存策略（http协议） 默认值
     * NSURLRequestReloadIgnoringLocalCacheData 重新请求不使用本地缓存
     * NSURLRequestReturnCacheDataElseLoad 无论缓存是否过期都使用缓存，没有缓存就进行网络请求
     * NSURLRequestReturnCacheDataDontLoad 无论缓存是否过期都使用缓存，没有缓存也不进行网络请求
     *
     * 服务器返回的响应头中会有这样的字段：Cache-Control: max-age or Cache-Control: s- maxage
     * 通过Cache-Control来指定缓存策略，max-age来表示过期时间，根据这些字段缓存机制再采用如下策略：
     * 如果本地没有缓存数据，则进行网络请求。
     * 如果本地有缓存，并且缓存没有失效，则使用缓存。
     * 如果缓存已经失效，则询问服务器数据是否改变，如果没改变，依然使用缓存，如果改变了则请求新数据。
     * 如果没有指定是否失效，那么系统将自己判断缓存是否失效。（通常认为是6-24小时的有效时间）
     * Cache-Control: no-cache 表示不使用缓存，但是会缓存，no-store表示是不进行缓存
     */
    NSLog(@"--%lu--%lu",(unsigned long)[NSURLCache sharedURLCache].diskCapacity,[NSURLCache sharedURLCache].memoryCapacity);
    
    //AFNetworking下的加载图片框架
    [self.imgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img.52z.com/upload/news/image/20180621/20180621055734_59936.jpg"]]
                        placeholderImage:nil
                                 success:nil
                                 failure:nil];
    
    /******************************** SDWebImage加载图片源码解析 ********************************
     * SDWebImage提供了加载图片的一系列方法，但是最终内部都会调用sd_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:这个方法，源码解析如下：
     * 1> 先获取当前操作的key，然后根据这个key去取消当前key对应的下载任务
     * 2> 通过options(默认传0)和SDWebImageDelayPlaceholder做与运算得出是否在加载图片时先加载占位图
     * 3> 判断url是否有效，如果有效，再判断是有设置progress回调，如果有，先置0；接着判断是否设置指示器，如果有z，则开启指示器
     * 4> 创建一个SDWebImageManager；创建一个SDImageLoaderProgressBlock，根据这个progressBlock去设置用户自定义的progressBlock，并且更新指示器；
     *    创建一个SDWebImageOperation(内部校验了completedBlock和url不能为空，使用了信号量锁等)，
     *    尝试从缓存加载图片(内部会先检测是否需要查询缓存，如果需要查缓存，则先检测内存缓存，
     *    再检测磁盘缓存<在检测磁盘缓存时，还需检测是否同步查询磁盘>,然后如果内存缓存中查到了图片但是需要磁盘数据则diskImage = image并回调，
     *    如果内存缓存miss，则解码磁盘数据转换成diskImage并回调，同时判断是否需要再缓存到内存中去)，如果不需要查缓存则直接开始下载
     * 5> 如果缓存查找到则回调，并移除当前任务，否则开始下载，下载时先判断是否需要下载，再判断是都提供了SDWebImageRefreshCached，
     *    如果提供刷新缓存选项，则重新下载，下载使用了信号量锁和NSOperationQueue
     * 6> SDWebImage的磁盘缓存默认周期为1周，磁盘缓存大小默认为0，即无限制，除非用户手动设置，如果设置了磁盘缓存大小，则超出缓存大小时
     *    会优先清除过期缓存；内存缓存大小默认也为0，即无限制，除非用户手动设置；
     * 7> SDWebImage的下载器默认配置了并发数6个任务，超时时间15s，下载队列策略为FIFO
     * 8> SDWebImage支持加载Gif图片
     */
    
    //SDWebImage下的加载图片框架
    [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574920132472&di=f2d644b6a0ec3b52b0685441c783cdc5&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Flarge%2F85cc5ccbgy1fi7fxvxk81g20lv0jrjsp.jpg"]
                    placeholderImage:nil];
    
    /******************************** YYImage加载图片源码解析 ********************************
     * YYImage提供了加载图片的一系列方法，但是最终内部都会调用setImageWithURL:placeholder:options:manager:progress:transform:completion:这个方法，源码解析如下：
     * 1> 如果没有传入mananger，则创建一个默认的manager，该manager内部创建了YYImageCache对象(初始化缓存时设置了过期时间是12小时，内存缓存大小默认是无限制的，且内存缓存过期时间也是无限制的，磁盘缓存设置了单个文件存储方式，依据单个文件大小超过20KB则以文件形式存储，否则存入sqlite，缓存大小是无限制的，过期时间也是无限制的)，设置超时时间为15s，设置请求头Accept
     * 2> 如果当前url对应的下载任务已存在，则先取消(YYImage也使用了信号量锁，NSOperationQueue,此外还使用了原子操作)
     * 3> 设置占位图，然后尝试先从内存缓存中读取图片，如果取到缓存则回调
     * 4> 没取到缓存则开始下载，下载完成后设置image再回调
     * 5> YYImage支持Gif图，但是得使用YYAnimatedImageView这个类
     */
    
    //YYImage下的加载图片框架
    [self.imgView3 setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574920132472&di=f2d644b6a0ec3b52b0685441c783cdc5&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Flarge%2F85cc5ccbgy1fi7fxvxk81g20lv0jrjsp.jpg"]
                       placeholder:nil
                           options:0
                           manager:nil
                          progress:nil
                         transform:nil
                        completion:nil];
    
    /******************************** AFNetworking&SDWebImage&YYImage加载图片框架对比 ********************************
     * 1、AFN不支持Gif图片，SDWebImage、YYImage支持加载Gif图片(YYImage需要使用YYAnimatedImageView这个类才能显示gif)
     * 2、AFN设置了默认的内存缓存和磁盘缓存大小以及有效期为7天，SDWebImage没有设置内存缓存和磁盘缓存大小，默认都为0，
     *    也没有设置过期时间，YYImage设置了内存缓存时间12小时，没有设置内存缓存和磁盘缓存大小
     * 3、AFN对于磁盘缓存只提供了清除所有以及某张图片的方法，SDWebImage、YYImage提供了很多关于磁盘清理缓存的方法
     * 4、AFN不支持图片的编解码操作，但是SDWebImage和YYImage支持图片的编解码
     ******************************** ********************************/
}

@end
