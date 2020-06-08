# flutter_logger

A new Flutter package.

## Getting Started
```

main(){

init();
runApp(Widget);

}

init(){
/// 添加console日志打印
  bool isDebug = !bool.fromEnvironment("dart.vm.product");
  LogUtil.addLogger(PrintLogger(isDebug));

  Directory extDir = await getApplicationDocumentsDirectory();

  DateTime dateTime = DateTime.now();
  String time = DateUtil.getDateStrByDateTime(dateTime,
      format: DateFormat.YEAR_MONTH_DAY, dateSeparate: "-");
/// 添加debug文件日志
  LogUtil.addLogger(
      DebugLogger('${extDir.path}/logs/', '${time}-debug.log'));
/// 添加error文件日志
  LogUtil.addLogger(
      ErrorLogger('${extDir.path}/logs/', '${time}-error.log'));

}

```