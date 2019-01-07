![CocoaPods Compatible](https://img.shields.io/badge/pod-0.0.8-blue.svg) ![Build status](https://img.shields.io/badge/build-passing-brightgreen.svg) ![Platform](https://img.shields.io/badge/platform-iOS-blue.svg) ![Email](https://img.shields.io/badge/email-devfalme@163.com-red.svg)
## 更新内容
大改，有空在写文档
## 安装
推荐使用cocoapods
``` Ruby
pod 'Router_t', '~> 0.0.8'
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
//版本大改，有空添加用法
```

新增方法
``` objective-c
//版本大改，有空添加用法
```

## 反馈

有问题或者觉得方法不够齐全等都可以直接issues或者联系邮箱
