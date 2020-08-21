import 'package:logging/logging.dart';

final ILog logger = Log();

abstract class ILog {
  void i(dynamic message);
  void d(dynamic message);
  void e(dynamic message, [Object error, StackTrace stackTrace]);
}

class Log implements ILog {
  Logger _logger;

  Log() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    });
    _logger = Logger('Pokemon');
  }

  @override
  i(dynamic message) {
    _logger.info(message);
  }

  @override
  d(dynamic message) {
    _logger.shout(message);
  }

  @override
  e(dynamic message, [Object error, StackTrace stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
}
