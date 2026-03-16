import 'package:flutter_test/flutter_test.dart';

import 'package:multi_level_linkage_demo/main.dart';

void main() {
  testWidgets('renders category picker demo home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('flutter_picker_plus 使用例子'), findsOneWidget);
    expect(find.text('打开商品分类选择器'), findsOneWidget);
    expect(find.text('电子产品'), findsOneWidget);
    expect(find.text('手机通讯'), findsOneWidget);
    expect(find.text('智能手机'), findsOneWidget);
  });
}
