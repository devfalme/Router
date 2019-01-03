![CocoaPods Compatible](https://img.shields.io/badge/pod-0.0.6-blue.svg) ![Build status](https://img.shields.io/badge/build-passing-brightgreen.svg) ![Platform](https://img.shields.io/badge/platform-iOS-blue.svg) ![Email](https://img.shields.io/badge/email-devfalme@163.com-red.svg)
## 更新内容
1. 去掉了失败的回调，改为错误打印
2. 更改了方法的使用
3. 增加模态方式
4. 增加了未知URL的处理方式，需要绑定一个自定义的webview以供打开，不绑定则忽略未知URL

## 安装
推荐使用cocoapods
``` Ruby
pod 'Router_t', '~> 0.0.6'
```
或者直接把Router文件夹这个拖入工程
## 怎么使用
首先在程序启动时调用路由的start方法

``` objective-c
RouterStart;
//或者
[Router_t start];
```

然后为控制器绑定URL

``` objective-c
//可以为控制器实现RouterProtocol协议里对应的方法
//或者直接使用宏
//ROUTER_PATH(path)
//ROUTER_STORYBOARD(sName, identifier)
//注：使用宏的话URL会自动拼接默认前缀，在跳转的时候就需要使用Router_API(path)来进行URL匹配
//如果是使用协议的话，可以采用自定义前缀，或者使用默认的Router_API(path)
//一定要确保跳转的时候输入的URL和绑定的一致
```

跳转
``` objective-c
//跳转有两种方式
[Router post:URL parameters:par type:push/present];
//例如
[Router post:Router_API(@"Controller1") parameters:@{@"key":@"value"} type:RouterTypePush];
//或
[Router get:URL type:push/present];
//例如
[Router get:Router_API(@"Controller1?key=value") type:RouterTypePush];
//传值跳转一举搞定
```

新增方法
``` objective-c
//新增搜索控制器方法
[Router search:URL parameters:par];
//会根据提供的地址和参数实例化一个对应的控制器
```

## 反馈

有问题或者觉得方法不够齐全等都可以直接issues或者联系邮箱
