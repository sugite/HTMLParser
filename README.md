# HTMLParser
将HTML Source String转为NSAttributedString

iOS自带的渲染HTML的`- (instancetype)initWithData:options:documentAttributes:error:`方法速度太慢，所以自己先实现一个简易的解析工具，目前只支持`<font>`和`<strike>`标签来设置字符串样式。

1. 需要在header search paths里添加`/usr/include/libxml2`
2. 需要在二进制库里添加 libxml2.tbd

##Usage:

```objective-c
    NSString *htmlString = @"<font color='#00ff00' bgcolor='#00ffff'>bai<font size='24' color='#ff00ff'>This <strike>is aaa</strike> some text!</font>bai</font><font color='#000000'>价格：</font><font color='#00ffff'>33.4</font><font color='#00ff00'>bai<font size='24' color='#ff00ff'>This <strike>is aaa</strike> some text!</font>bai</font><font color='#000000'>价格：</font><font color='#00ffff'>33.4</font><font color='#00ff00'>bai<font size='24' color='#ff00ff'>This <strike>is aaa</strike> some text!</font>bai</font><font color='#000000'>价格：</font><font color='#00ffff'>33.4</font><font color='#00ff00'>bai<font size='24' color='#ff00ff'>This <strike>is aaa</strike> some text!</font>bai</font><font color='#000000'>价格：</font><font color='#00ffff'>33.4</font><font color='#00ff00'>bai<font size='24' color='#ff00ff'>This <strike>is aaa</strike> some text!</font>bai</font><font color='#000000'>价格：</font><font color='#00ffff'>33.4</font>";
    
    label.attributedText = [[HTMLParser sharedInstance] parseHTMLWithString:htmlString error:nil];
```