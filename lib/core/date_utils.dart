import 'package:intl/intl.dart';

abstract final class FormatDateTime {
  static const dateFormat = 'yyyy/MM/dd';
  static const timeFormat = 'HH:mm:ss';
  static const shortTimeFormat = 'HH:mm';
  static const dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const jpDateTimeFormat = 'MM月dd日(EEE) HH時mm分';
  static const jpShortDateTimeFormat = 'MM月dd日 HH時mm分';
  static const jpDateFormat = 'yyyy年MM月dd日';
  static const jpTimeFormat = 'HH時mm分';
  static const jpMdFormat = 'MM月dd日';

  static final dateFmt = DateFormat(dateFormat);
  static final timeFmt = DateFormat(timeFormat);
  static final shortTimeFmt = DateFormat(shortTimeFormat);
  static final dateTimeFmt = DateFormat(dateTimeFormat);
  static final jpDateTimeFmt = DateFormat(jpDateTimeFormat);
  static final jpShortDateTimeFmt = DateFormat(jpShortDateTimeFormat);
  static final jpDateFmt = DateFormat(jpDateFormat);
  static final jpTimeFmt = DateFormat(jpTimeFormat);
  static final jpMdFmt = DateFormat(jpMdFormat);
}
