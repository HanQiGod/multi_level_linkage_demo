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
      home: const PickerExamplesPage(),
    );
  }
}

class PickerExamplesPage extends StatelessWidget {
  const PickerExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_picker_plus 使用例子')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IntroCard(),
              SizedBox(height: 16),
              LinkageDemoSection(
                sectionTitle: '例子一：商品分类三级联动',
                description:
                    '对应文章里的核心示例。使用 PickerItem 构建“商品大类 / 中类 / 小类”树形数据，'
                    '借助 changeToFirst 在父级变化时自动重置子级索引。',
                pickerTitle: '请选择商品分类',
                buttonText: '打开商品分类选择器',
                buttonIcon: Icons.shopping_bag_outlined,
                accentColor: Color(0xFF0F766E),
                chipColor: Color(0xFFD9EFEA),
                data: _categoryTree,
                defaultSelecteds: [0, 0, 0],
                highlights: [
                  '使用 PickerItem 构建任意层级树形数据',
                  '使用 PickerDataAdapter 解耦数据与界面',
                  '通过 selecteds 设置默认选中项',
                  '通过 changeToFirst 实现联动后自动回到首项',
                ],
              ),
              SizedBox(height: 16),
              LinkageDemoSection(
                sectionTitle: '例子二：省 / 市 / 区地址联动',
                description:
                    '这是更贴近移动端表单的场景。这里仍然使用同一套适配器模式，只是把业务数据换成地址树，'
                    '同时在确定回调里直接拿到原始 value 对象用于回填。',
                pickerTitle: '请选择收货地址',
                buttonText: '打开地址选择器',
                buttonIcon: Icons.location_on_outlined,
                accentColor: Color(0xFFB45309),
                chipColor: Color(0xFFFBE3CC),
                data: _addressTree,
                defaultSelecteds: [1, 1, 0],
                highlights: [
                  '同一个 Picker 组件可以复用到完全不同的数据结构',
                  'getSelectedValues() 直接返回 value，不必再从文本反查业务对象',
                  '默认索引可以精准回显到指定的省、市、区',
                  '特别适合地址、组织架构、渠道分类这类表单场景',
                ],
              ),
              SizedBox(height: 16),
              _ArticleSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkageDemoSection extends StatefulWidget {
  const LinkageDemoSection({
    super.key,
    required this.sectionTitle,
    required this.description,
    required this.pickerTitle,
    required this.buttonText,
    required this.buttonIcon,
    required this.accentColor,
    required this.chipColor,
    required this.data,
    required this.defaultSelecteds,
    required this.highlights,
  });

  final String sectionTitle;
  final String description;
  final String pickerTitle;
  final String buttonText;
  final IconData buttonIcon;
  final Color accentColor;
  final Color chipColor;
  final List<LinkageNode> data;
  final List<int> defaultSelecteds;
  final List<String> highlights;

  @override
  State<LinkageDemoSection> createState() => _LinkageDemoSectionState();
}

class _LinkageDemoSectionState extends State<LinkageDemoSection> {
  late final List<PickerItem<LinkageNode>> _pickerItems;
  late List<int> _selectedIndexes;
  late List<LinkageNode> _selectedNodes;

  @override
  void initState() {
    super.initState();
    _pickerItems = _buildPickerItems(widget.data);
    _selectedIndexes = List<int>.from(widget.defaultSelecteds);
    _selectedNodes = _resolveSelection(widget.defaultSelecteds, widget.data);
  }

  void _showPicker() {
    Picker(
      adapter: PickerDataAdapter<LinkageNode>(data: _pickerItems),
      title: Text(widget.pickerTitle),
      selecteds: List<int>.from(_selectedIndexes),
      itemExtent: 46,
      changeToFirst: true,
      cancelText: '取消',
      confirmText: '确定',
      textStyle: const TextStyle(color: Color(0xFF5E746F), fontSize: 16),
      selectedTextStyle: TextStyle(
        color: widget.accentColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      onConfirm: (Picker picker, List<int> selecteds) {
        final selectedValues = picker
            .getSelectedValues()
            .whereType<LinkageNode>()
            .toList(growable: false);

        setState(() {
          _selectedIndexes = List<int>.from(selecteds);
          _selectedNodes = selectedValues;
        });

        final labels = selectedValues.map((node) => node.label).join(' / ');
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('已更新为：$labels')));
      },
    ).showModal(context);
  }

  void _resetSelection() {
    setState(() {
      _selectedIndexes = List<int>.from(widget.defaultSelecteds);
      _selectedNodes = _resolveSelection(widget.defaultSelecteds, widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = _selectedNodes
        .map((node) => node.label)
        .toList(growable: false);
    final codes = _selectedNodes.map((node) => node.code).join(' / ');

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.chipColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.buttonIcon, color: widget.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.sectionTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4B635E),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: labels
                .map(
                  (label) => Chip(
                    label: Text(label),
                    backgroundColor: widget.chipColor,
                    side: BorderSide.none,
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          _KeyValueRow(label: '路径文本', value: labels.join(' / ')),
          const SizedBox(height: 8),
          _KeyValueRow(label: '原始 value', value: codes),
          const SizedBox(height: 8),
          _KeyValueRow(label: '默认索引', value: _selectedIndexes.join(', ')),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _showPicker,
                  icon: Icon(widget.buttonIcon),
                  label: Text(widget.buttonText),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                  ),
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
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.accentColor,
                    side: BorderSide(color: widget.accentColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '这个例子演示了什么',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          for (final item in widget.highlights) _FeatureLine(text: item),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
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
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '这个项目现在包含两个可直接运行的 flutter_picker_plus 示例。'
            '你可以把它们看成文章里“商品分类”和“地址选择”两类典型场景的落地实现。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4B635E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleSummaryCard extends StatelessWidget {
  const _ArticleSummaryCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '适配器模式在这里解决了什么问题',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _FeatureLine(text: '界面层只关心 Picker，本身不需要知道业务数据来自商品、地址还是组织树'),
          const _FeatureLine(text: '数据层只要能转成 PickerItem 树，就能接入任意层级联动'),
          const _FeatureLine(text: '同一套页面结构可以快速复制出第三个、第四个联动场景'),
          const _FeatureLine(text: '如果后续需要四级、五级联动，只要继续补 children 即可'),
        ],
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
  const _FeatureLine({required this.text});

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

class LinkageNode {
  const LinkageNode({
    required this.code,
    required this.label,
    this.children = const [],
  });

  final String code;
  final String label;
  final List<LinkageNode> children;
}

const List<LinkageNode> _categoryTree = [
  LinkageNode(
    code: '1000',
    label: '电子产品',
    children: [
      LinkageNode(
        code: '1100',
        label: '手机通讯',
        children: [
          LinkageNode(code: '1110', label: '智能手机'),
          LinkageNode(code: '1120', label: '对讲机'),
        ],
      ),
      LinkageNode(
        code: '1200',
        label: '电脑办公',
        children: [
          LinkageNode(code: '1210', label: '笔记本电脑'),
          LinkageNode(code: '1220', label: '台式电脑'),
          LinkageNode(code: '1230', label: '平板电脑'),
        ],
      ),
    ],
  ),
  LinkageNode(
    code: '2000',
    label: '服装服饰',
    children: [
      LinkageNode(
        code: '2100',
        label: '男装',
        children: [
          LinkageNode(code: '2110', label: '上衣'),
          LinkageNode(code: '2120', label: '裤子'),
          LinkageNode(code: '2130', label: '外套'),
        ],
      ),
      LinkageNode(
        code: '2200',
        label: '女装',
        children: [
          LinkageNode(code: '2210', label: '连衣裙'),
          LinkageNode(code: '2220', label: '半身裙'),
        ],
      ),
    ],
  ),
];

const List<LinkageNode> _addressTree = [
  LinkageNode(
    code: '330000',
    label: '浙江省',
    children: [
      LinkageNode(
        code: '330100',
        label: '杭州市',
        children: [
          LinkageNode(code: '330106', label: '西湖区'),
          LinkageNode(code: '330108', label: '滨江区'),
          LinkageNode(code: '330110', label: '余杭区'),
        ],
      ),
      LinkageNode(
        code: '330200',
        label: '宁波市',
        children: [
          LinkageNode(code: '330203', label: '海曙区'),
          LinkageNode(code: '330205', label: '江北区'),
        ],
      ),
    ],
  ),
  LinkageNode(
    code: '440000',
    label: '广东省',
    children: [
      LinkageNode(
        code: '440100',
        label: '广州市',
        children: [
          LinkageNode(code: '440106', label: '天河区'),
          LinkageNode(code: '440111', label: '白云区'),
        ],
      ),
      LinkageNode(
        code: '440300',
        label: '深圳市',
        children: [
          LinkageNode(code: '440305', label: '南山区'),
          LinkageNode(code: '440304', label: '福田区'),
          LinkageNode(code: '440303', label: '罗湖区'),
        ],
      ),
    ],
  ),
  LinkageNode(
    code: '510000',
    label: '四川省',
    children: [
      LinkageNode(
        code: '510100',
        label: '成都市',
        children: [
          LinkageNode(code: '510104', label: '锦江区'),
          LinkageNode(code: '510107', label: '武侯区'),
        ],
      ),
      LinkageNode(
        code: '510700',
        label: '绵阳市',
        children: [
          LinkageNode(code: '510703', label: '涪城区'),
          LinkageNode(code: '510704', label: '游仙区'),
        ],
      ),
    ],
  ),
];

List<PickerItem<LinkageNode>> _buildPickerItems(List<LinkageNode> nodes) {
  return nodes
      .map(
        (node) => PickerItem<LinkageNode>(
          text: Text(node.label),
          value: node,
          children: _buildPickerItems(node.children),
        ),
      )
      .toList(growable: false);
}

List<LinkageNode> _resolveSelection(List<int> indexes, List<LinkageNode> tree) {
  final selection = <LinkageNode>[];
  var currentLevel = tree;

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
