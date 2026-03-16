import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: '多级联动选择器示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF4F7F5),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const CategoryPickerDemoPage(),
    );
  }
}

class CategoryPickerDemoPage extends StatefulWidget {
  const CategoryPickerDemoPage({super.key});

  @override
  State<CategoryPickerDemoPage> createState() => _CategoryPickerDemoPageState();
}

class _CategoryPickerDemoPageState extends State<CategoryPickerDemoPage> {
  static const List<int> _defaultSelecteds = [0, 0, 0];

  final List<PickerItem<CategoryNode>> _categoryItems = _buildPickerItems(
    _categoryTree,
  );

  late List<int> _selectedIndexes = List<int>.from(_defaultSelecteds);
  late List<CategoryNode> _selectedNodes = _resolveSelection(_defaultSelecteds);

  void _showCategoryPicker() {
    Picker(
      adapter: PickerDataAdapter<CategoryNode>(data: _categoryItems),
      title: const Text('请选择商品分类'),
      selecteds: _selectedIndexes,
      itemExtent: 46,
      changeToFirst: true,
      selectedTextStyle: const TextStyle(
        color: Color(0xFF0F766E),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      onConfirm: (Picker picker, List<int> selecteds) {
        final selectedValues = picker
            .getSelectedValues()
            .whereType<CategoryNode>()
            .toList(growable: false);

        setState(() {
          _selectedIndexes = List<int>.from(selecteds);
          _selectedNodes = selectedValues;
        });
      },
    ).showModal(context);
  }

  void _resetSelection() {
    setState(() {
      _selectedIndexes = List<int>.from(_defaultSelecteds);
      _selectedNodes = _resolveSelection(_defaultSelecteds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = _selectedNodes.map((node) => node.label).toList();
    final ids = _selectedNodes.map((node) => node.id.toString()).join(' / ');

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_picker_plus 使用例子')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/images/multi_level_linkage_demo.gif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '灵活强大的适配器模式，轻松构建任意层级联动选择器',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '这个示例对应文章里的商品分类三级联动场景：使用 PickerItem 构建树形数据，'
                      '通过 PickerDataAdapter 接入 Picker，并用 changeToFirst 保证父级变化后子级自动归位。',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B635E),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前选中结果',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: labels
                          .map(
                            (label) => Chip(
                              label: Text(label),
                              backgroundColor: const Color(0xFFD9EFEA),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 12),
                    _KeyValueRow(label: '路径文本', value: labels.join(' / ')),
                    const SizedBox(height: 8),
                    _KeyValueRow(label: '原始 value', value: ids),
                    const SizedBox(height: 8),
                    _KeyValueRow(
                      label: '默认索引',
                      value: _selectedIndexes.join(', '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _showCategoryPicker,
                      icon: const Icon(Icons.tune),
                      label: const Text('打开商品分类选择器'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetSelection,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('恢复默认选中'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '示例覆盖的文章要点',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FeatureLine('使用 PickerItem 构建任意层级树形数据'),
                    const _FeatureLine('使用 PickerDataAdapter 解耦数据与界面'),
                    const _FeatureLine('通过 selecteds 设置默认选中项'),
                    const _FeatureLine('通过 changeToFirst 实现联动后自动回到首项'),
                    const _FeatureLine('通过 getSelectedValues 拿到 value 对象并回填页面'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E8E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120B3B31),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5E746F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 7, right: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0F766E),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4B635E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryNode {
  const CategoryNode({
    required this.id,
    required this.label,
    this.children = const [],
  });

  final int id;
  final String label;
  final List<CategoryNode> children;
}

const List<CategoryNode> _categoryTree = [
  CategoryNode(
    id: 1000,
    label: '电子产品',
    children: [
      CategoryNode(
        id: 1100,
        label: '手机通讯',
        children: [
          CategoryNode(id: 1110, label: '智能手机'),
          CategoryNode(id: 1120, label: '对讲机'),
        ],
      ),
      CategoryNode(
        id: 1200,
        label: '电脑办公',
        children: [
          CategoryNode(id: 1210, label: '笔记本电脑'),
          CategoryNode(id: 1220, label: '台式电脑'),
          CategoryNode(id: 1230, label: '平板电脑'),
        ],
      ),
    ],
  ),
  CategoryNode(
    id: 2000,
    label: '服装服饰',
    children: [
      CategoryNode(
        id: 2100,
        label: '男装',
        children: [
          CategoryNode(id: 2110, label: '上衣'),
          CategoryNode(id: 2120, label: '裤子'),
          CategoryNode(id: 2130, label: '外套'),
        ],
      ),
      CategoryNode(
        id: 2200,
        label: '女装',
        children: [
          CategoryNode(id: 2210, label: '连衣裙'),
          CategoryNode(id: 2220, label: '半身裙'),
        ],
      ),
    ],
  ),
];

List<PickerItem<CategoryNode>> _buildPickerItems(List<CategoryNode> nodes) {
  // 将业务数据转换为 PickerItem 树，适配 flutter_picker_plus 的数据源。
  return nodes
      .map(
        (node) => PickerItem<CategoryNode>(
          text: Text(node.label),
          value: node,
          children: _buildPickerItems(node.children),
        ),
      )
      .toList(growable: false);
}

List<CategoryNode> _resolveSelection(List<int> indexes) {
  final selection = <CategoryNode>[];
  var currentLevel = _categoryTree;

  for (final rawIndex in indexes) {
    if (currentLevel.isEmpty) {
      break;
    }

    final index = rawIndex < 0
        ? 0
        : rawIndex >= currentLevel.length
        ? currentLevel.length - 1
        : rawIndex;

    final node = currentLevel[index];
    selection.add(node);
    currentLevel = node.children;
  }

  return selection;
}
