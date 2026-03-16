# multi_level_linkage_demo

Flutter 多级联动选择器示例项目，对应文章《灵活强大的适配器模式，轻松构建任意层级联动选择器》。

项目基于 `flutter_picker_plus` 实现，核心目标是演示：

- 如何用 `PickerItem` 构建树形数据
- 如何通过 `PickerDataAdapter` 接入选择器
- 如何在同一套页面结构中复用不同业务场景
- 如何从三级联动自然扩展到四级联动

## 依赖

`pubspec.yaml` 中使用的核心依赖：

```yaml
dependencies:
  flutter_picker_plus: ^1.5.5
```

当前锁定版本见 `pubspec.lock`。

## 项目内置示例

首页目前包含 4 个可直接运行的联动示例：

1. 商品分类三级联动
2. 省 / 市 / 区地址联动
3. 生日年 / 月 / 日联动
4. 组织架构四级联动

### 商品分类三级联动

对应文章里的基础示例，演示：

- `PickerItem` 的树形嵌套
- `changeToFirst` 的联动效果
- `selecteds` 默认选中回显
- `getSelectedValues()` 获取原始 `value`

### 省 / 市 / 区地址联动

更贴近移动端表单场景，演示：

- 地址数据如何映射成树结构
- 确定回调后如何回填当前选中结果
- 同一套组件如何复用于另一种业务数据

### 生日年 / 月 / 日联动

这个例子不是手写常量树，而是运行时代码生成的数据，演示：

- 动态构造多级联动数据
- 闰年 2 月天数变化
- `columnFlex` 控制列宽
- `looping` 提升滚动体验

### 组织架构四级联动

这个例子用于证明“任意层级联动”不是停留在概念里，演示：

- 四级联动数据结构
- 默认选中到第四层节点
- 总部 / 中心 / 部门 / 小组这类组织树场景
- 深层级结构继续复用同一个 `LinkageDemoSection`

## 运行方式

安装依赖：

```bash
flutter pub get
```

启动项目：

```bash
flutter run
```

运行测试：

```bash
flutter test
flutter analyze
```

## 代码位置

主要实现都在 `lib/main.dart`：

- `PickerExamplesPage`：示例首页
- `LinkageDemoSection`：通用联动示例卡片
- `LinkageNode`：统一的数据模型
- `_buildPickerItems()`：将业务树转换为 `PickerItem`
- `_resolveSelection()`：根据索引回推当前选中路径

## 展示图

![展示图](assets/images/multi_level_linkage_demo.gif)
