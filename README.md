# HTMLParser
将HTML Source String转为NSAttributedString

iOS自带的渲染HTML的`- (instancetype)initWithData:options:documentAttributes:error:`方法速度太慢，所以自己先实现一个简易的解析工具，目前只支持`<font>`和`<strike>`标签来设置字符串样式。
