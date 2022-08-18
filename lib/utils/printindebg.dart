import 'dart:developer';

import 'package:flutter/foundation.dart';

dbg(String s) {
  if (!kReleaseMode) {
    log(s);
  }
}
