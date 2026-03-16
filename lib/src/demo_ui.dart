import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

import 'demo_data.dart';
import 'demo_models.dart';

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_picker_plus 联动示例')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeIntroCard(),
              const SizedBox(height: 20),
              Text(
                '示例导航',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (final definition in pickerDemoDefinitions) ...[
                DemoOverviewCard(definition: definition),
                const SizedBox(height: 16),
              ],
              const _ArticleSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoOverviewCard extends StatelessWidget {
  const DemoOverviewCard({super.key, required this.definition});

  final LinkageDemoDefinition definition;

  @override
  Widget build(BuildContext context) {
    final previewNodes = resolveSelection(
      definition.defaultSelecteds,
      definition.data,
    );
    final previewLabels = previewNodes
        .map((node) => node.label)
        .toList(growable: false);
    final levelLabel = '${previewLabels.length} 级联动';

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: definition.chipColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(definition.icon, color: definition.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  definition.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: definition.chipColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  levelLabel,
                  style: TextStyle(
                    color: definition.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            definition.overview,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4B635E),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _KeyValueRow(label: '默认路径', value: previewLabels.join(' / ')),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: definition.highlights
                .take(3)
                .map(
                  (item) => _TagChip(
                    text: item,
                    backgroundColor: definition.chipColor,
                    foregroundColor: definition.accentColor,
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DemoDetailPage(definition: definition),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(definition.homeButtonText),
                  style: FilledButton.styleFrom(
                    backgroundColor: definition.accentColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemoDetailPage extends StatelessWidget {
  const DemoDetailPage({super.key, required this.definition});

  final LinkageDemoDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(definition.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailLeadCard(definition: definition),
              const SizedBox(height: 16),
              LinkageDemoPanel(definition: definition),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkageDemoPanel extends StatefulWidget {
  const LinkageDemoPanel({super.key, required this.definition});

  final LinkageDemoDefinition definition;

  @override
  State<LinkageDemoPanel> createState() => _LinkageDemoPanelState();
}

class _LinkageDemoPanelState extends State<LinkageDemoPanel> {
  late final List<PickerItem<LinkageNode>> _pickerItems;
  late List<int> _selectedIndexes;
  late List<LinkageNode> _selectedNodes;

  @override
  void initState() {
    super.initState();
    _pickerItems = buildPickerItems(widget.definition.data);
    _selectedIndexes = List<int>.from(widget.definition.defaultSelecteds);
    _selectedNodes = resolveSelection(
      widget.definition.defaultSelecteds,
      widget.definition.data,
    );
  }

  void _showPicker() {
    final pickerHeight = _pickerHeight(context);

    Picker(
      adapter: PickerDataAdapter<LinkageNode>(data: _pickerItems),
      title: Text(widget.definition.pickerTitle),
      selecteds: List<int>.from(_selectedIndexes),
      height: pickerHeight,
      itemExtent: 46,
      changeToFirst: true,
      looping: widget.definition.looping,
      columnFlex: widget.definition.columnFlex,
      cancelText: '取消',
      confirmText: '确定',
      textStyle: const TextStyle(color: Color(0xFF5E746F), fontSize: 16),
      selectedTextStyle: TextStyle(
        color: widget.definition.accentColor,
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
      _selectedIndexes = List<int>.from(widget.definition.defaultSelecteds);
      _selectedNodes = resolveSelection(
        widget.definition.defaultSelecteds,
        widget.definition.data,
      );
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.definition.chipColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.definition.icon,
                  color: widget.definition.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.definition.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.definition.overview,
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
                    backgroundColor: widget.definition.chipColor,
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
                  icon: Icon(widget.definition.icon),
                  label: Text(widget.definition.pickerButtonText),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.definition.accentColor,
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
                    foregroundColor: widget.definition.accentColor,
                    side: BorderSide(color: widget.definition.accentColor),
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
          for (final item in widget.definition.highlights)
            _FeatureLine(text: item, color: widget.definition.accentColor),
        ],
      ),
    );
  }

  double _pickerHeight(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (screenHeight * 0.32).clamp(220.0, 280.0);
  }
}

class _HomeIntroCard extends StatelessWidget {
  const _HomeIntroCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '灵活强大的适配器模式，轻松构建任意层级联动选择器',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '首页现在只负责导航和文章导读。点击任意卡片后，会进入单独的示例详情页，'
            '更适合截图、写文章分节引用，以及后续继续扩展示例库。',
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

class _DetailLeadCard extends StatelessWidget {
  const _DetailLeadCard({required this.definition});

  final LinkageDemoDefinition definition;

  @override
  Widget build(BuildContext context) {
    final previewLabels = resolveSelection(
      definition.defaultSelecteds,
      definition.data,
    ).map((node) => node.label).join(' / ');

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: definition.chipColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(definition.icon, color: definition.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '当前页面只展示这一组联动示例',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '默认回显路径：$previewLabels。你可以直接打开选择器体验联动，再截图用于文章配图。',
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
            '为什么要拆成独立页面',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _FeatureLine(text: '文章引用时可以一节对应一页，不需要在长页面里反复裁图'),
          const _FeatureLine(text: '首页导航适合做仓库入口，详情页适合做示例说明和交互演示'),
          const _FeatureLine(text: '后续再加第五个、第六个示例时，只需要继续追加定义和页面入口'),
          const _FeatureLine(text: '共用数据结构和共用示例面板仍然保留，避免页面拆开后重复写逻辑'),
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
  const _FeatureLine({
    required this.text,
    this.color = const Color(0xFF0F766E),
  });

  final String text;
  final Color color;

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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
