import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_frame_controller.g.dart';

@riverpod
class SelectedIndex extends _$SelectedIndex {
  @override
  int build() => 0;

  Future<void> updateIndex(int newIndex) async {
    state = newIndex;
  }
}
