# flutter_logger

## flutter日志工具，支持控制台打印，文件日志级别分类

```
main(){

init();

runApp(Widget);

}

init(){
/// 添加console日志打印
  bool isDebug = !bool.fromEnvironment("dart.vm.product");
  LogUtil.addLogger(PrintLogger(isDebug));

/// 添加debug文件日志
  LogUtil.addLogger(
      DebugLogger('dir', 'logName'));
/// 添加error文件日志
  LogUtil.addLogger(
      ErrorLogger('dir', 'logName'));

}

```