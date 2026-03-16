import 'package:flutter_test/flutter_test.dart';

import 'package:multi_level_linkage_demo/main.dart';

void main() {
  testWidgets('renders home page and navigates to detail page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('flutter_picker_plus 联动示例'), findsOneWidget);
    expect(find.text('查看商品分类页面'), findsOneWidget);
    expect(find.text('查看地址页面'), findsOneWidget);
    expect(find.text('查看生日页面'), findsOneWidget);
    expect(find.text('查看组织架构页面'), findsOneWidget);
    expect(find.text('打开组织架构选择器'), findsNothing);

    await tester.ensureVisible(find.text('查看组织架构页面'));
    await tester.tap(find.text('查看组织架构页面'));
    await tester.pumpAndSettle();

    expect(find.text('打开组织架构选择器'), findsOneWidget);
    expect(find.text('总部'), findsOneWidget);
    expect(find.text('研发中心'), findsOneWidget);
    expect(find.text('客户端平台部'), findsOneWidget);
    expect(find.text('Flutter 组'), findsOneWidget);
  });
}
