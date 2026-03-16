import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

import 'demo_models.dart';

const List<LinkageNode> categoryTree = [
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

const List<LinkageNode> addressTree = [
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

const List<LinkageNode> organizationTree = [
  LinkageNode(
    code: 'hq',
    label: '总部',
    children: [
      LinkageNode(
        code: 'rd_center',
        label: '研发中心',
        children: [
          LinkageNode(
            code: 'client_platform',
            label: '客户端平台部',
            children: [
              LinkageNode(code: 'ios_team', label: 'iOS 组'),
              LinkageNode(code: 'flutter_team', label: 'Flutter 组'),
              LinkageNode(code: 'android_team', label: 'Android 组'),
            ],
          ),
          LinkageNode(
            code: 'backend_platform',
            label: '服务端平台部',
            children: [
              LinkageNode(code: 'gateway_team', label: '网关组'),
              LinkageNode(code: 'data_team', label: '数据服务组'),
            ],
          ),
        ],
      ),
      LinkageNode(
        code: 'product_center',
        label: '产品中心',
        children: [
          LinkageNode(
            code: 'consumer_product',
            label: 'C 端产品部',
            children: [
              LinkageNode(code: 'growth_team', label: '增长组'),
              LinkageNode(code: 'member_team', label: '会员组'),
            ],
          ),
          LinkageNode(
            code: 'merchant_product',
            label: 'B 端产品部',
            children: [
              LinkageNode(code: 'supply_team', label: '供应链组'),
              LinkageNode(code: 'crm_team', label: 'CRM 组'),
            ],
          ),
        ],
      ),
    ],
  ),
  LinkageNode(
    code: 'regional_business',
    label: '区域事业群',
    children: [
      LinkageNode(
        code: 'east_region',
        label: '华东大区',
        children: [
          LinkageNode(
            code: 'hangzhou_branch',
            label: '杭州分部',
            children: [
              LinkageNode(code: 'channel_team', label: '渠道组'),
              LinkageNode(code: 'ops_team', label: '运营组'),
            ],
          ),
          LinkageNode(
            code: 'shanghai_branch',
            label: '上海分部',
            children: [
              LinkageNode(code: 'ka_team', label: 'KA 组'),
              LinkageNode(code: 'retail_team', label: '零售组'),
            ],
          ),
        ],
      ),
      LinkageNode(
        code: 'south_region',
        label: '华南大区',
        children: [
          LinkageNode(
            code: 'guangzhou_branch',
            label: '广州分部',
            children: [
              LinkageNode(code: 'brand_team', label: '品牌组'),
              LinkageNode(code: 'service_team', label: '服务组'),
            ],
          ),
          LinkageNode(
            code: 'shenzhen_branch',
            label: '深圳分部',
            children: [
              LinkageNode(code: 'ecosystem_team', label: '生态组'),
              LinkageNode(code: 'expansion_team', label: '拓展组'),
            ],
          ),
        ],
      ),
    ],
  ),
];

const int birthdayStartYear = 1980;
const int birthdayEndYear = 2030;

final List<LinkageNode> birthdayTree = buildBirthdayTree(
  startYear: birthdayStartYear,
  endYear: birthdayEndYear,
);

final List<int> birthdayDefaultSelecteds = findBirthdaySelecteds(
  year: 2000,
  month: 2,
  day: 29,
);

final List<LinkageDemoDefinition> pickerDemoDefinitions = [
  const LinkageDemoDefinition(
    title: '例子一：商品分类三级联动',
    overview:
        '对应文章里的基础示例。使用 PickerItem 构建“商品大类 / 中类 / 小类”树形数据，'
        '适合解释适配器模式如何承接静态层级结构。',
    pickerTitle: '请选择商品分类',
    homeButtonText: '查看商品分类页面',
    pickerButtonText: '打开商品分类选择器',
    icon: Icons.shopping_bag_outlined,
    accentColor: Color(0xFF0F766E),
    chipColor: Color(0xFFD9EFEA),
    data: categoryTree,
    defaultSelecteds: [0, 0, 0],
    highlights: [
      '使用 PickerItem 构建任意层级树形数据',
      '使用 PickerDataAdapter 解耦数据与界面',
      '通过 selecteds 设置默认选中项',
      '通过 changeToFirst 实现联动后自动回到首项',
    ],
  ),
  const LinkageDemoDefinition(
    title: '例子二：省 / 市 / 区地址联动',
    overview:
        '这是更贴近移动端表单的场景。这里仍然使用同一套适配器模式，只是把业务数据换成地址树，'
        '同时在确定回调里直接拿到原始 value 对象用于回填。',
    pickerTitle: '请选择收货地址',
    homeButtonText: '查看地址页面',
    pickerButtonText: '打开地址选择器',
    icon: Icons.location_on_outlined,
    accentColor: Color(0xFFB45309),
    chipColor: Color(0xFFFBE3CC),
    data: addressTree,
    defaultSelecteds: [1, 1, 0],
    highlights: [
      '同一个 Picker 组件可以复用到完全不同的数据结构',
      'getSelectedValues() 直接返回 value，不必再从文本反查业务对象',
      '默认索引可以精准回显到指定的省、市、区',
      '特别适合地址、组织架构、渠道分类这类表单场景',
    ],
  ),
  LinkageDemoDefinition(
    title: '例子三：生日年 / 月 / 日联动',
    overview:
        '这一组数据不是手写常量，而是通过代码动态生成。年份列加宽，月份和日期列启用循环滚动，'
        '适合展示适配器模式对运行时层级数据的承载能力。',
    pickerTitle: '请选择生日',
    homeButtonText: '查看生日页面',
    pickerButtonText: '打开生日选择器',
    icon: Icons.cake_outlined,
    accentColor: const Color(0xFFBE123C),
    chipColor: const Color(0xFFF9D7E2),
    data: birthdayTree,
    defaultSelecteds: birthdayDefaultSelecteds,
    highlights: const [
      '联动数据可以来自运行时代码生成，而不一定是固定常量',
      '2 月天数会跟随年份自动变化，能覆盖闰年场景',
      '通过 columnFlex 让年份列比月份、日期列更宽',
      '通过 looping 让月、日滚动体验更接近移动端原生选择器',
    ],
    columnFlex: const [2, 1, 1],
    looping: true,
  ),
  const LinkageDemoDefinition(
    title: '例子四：组织架构四级联动',
    overview:
        '这个例子把层级扩展到四级，用来验证 PickerItem 的 children 可以继续向下嵌套。'
        '非常适合展示总部 / 中心 / 部门 / 小组这一类组织架构或渠道体系。',
    pickerTitle: '请选择组织架构',
    homeButtonText: '查看组织架构页面',
    pickerButtonText: '打开组织架构选择器',
    icon: Icons.account_tree_outlined,
    accentColor: Color(0xFF1D4ED8),
    chipColor: Color(0xFFDCE9FF),
    data: organizationTree,
    defaultSelecteds: [0, 0, 0, 1],
    highlights: [
      '同一个适配器模式可以自然扩展到四级联动',
      '默认索引可以精确回显到第四层的小组节点',
      '非常适合组织架构、经销渠道、品类树这类深层级场景',
      '如果要继续扩成五级，只需要继续追加 children',
    ],
    columnFlex: [2, 2, 2, 1],
  ),
];

List<PickerItem<LinkageNode>> buildPickerItems(List<LinkageNode> nodes) {
  return nodes
      .map(
        (node) => PickerItem<LinkageNode>(
          text: Text(node.label),
          value: node,
          children: buildPickerItems(node.children),
        ),
      )
      .toList(growable: false);
}

List<LinkageNode> resolveSelection(List<int> indexes, List<LinkageNode> tree) {
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

List<LinkageNode> buildBirthdayTree({
  required int startYear,
  required int endYear,
}) {
  return List<LinkageNode>.generate(endYear - startYear + 1, (yearIndex) {
    final year = startYear + yearIndex;
    return LinkageNode(
      code: '$year',
      label: '$year年',
      children: List<LinkageNode>.generate(12, (monthIndex) {
        final month = monthIndex + 1;
        final dayCount = daysInMonth(year, month);
        return LinkageNode(
          code: pad2(month),
          label: '${pad2(month)}月',
          children: List<LinkageNode>.generate(dayCount, (dayIndex) {
            final day = dayIndex + 1;
            return LinkageNode(code: pad2(day), label: '${pad2(day)}日');
          }),
        );
      }),
    );
  });
}

List<int> findBirthdaySelecteds({
  required int year,
  required int month,
  required int day,
}) {
  final safeYear = year.clamp(birthdayStartYear, birthdayEndYear);
  final safeMonth = month.clamp(1, 12);
  final safeDay = day.clamp(1, daysInMonth(safeYear, safeMonth));

  return [safeYear - birthdayStartYear, safeMonth - 1, safeDay - 1];
}

int daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

String pad2(int value) {
  return value.toString().padLeft(2, '0');
}
