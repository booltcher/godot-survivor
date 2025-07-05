# 幸存者

- 创建角色
- 创建场景
- 添加角色移动
- 创建摄像机并跟随角色移动
- 创建敌人
- 添加敌人移动
- 创建能力 - 剑
- 实现剑根据玩家位置 自动生成，剑是一个场景，剑生成的逻辑是另一个场景 sword_ability_controller
- 实现剑的动画
- 实现剑根据怪物位置 自动生成
- 实现剑和怪物的碰撞
- 实现怪物自动生成
- 记录游戏时间
- 添加敌人掉落经验瓶
- 实现拾取经验瓶加经验
- 实现角色血条和健康组件
- 实现怪物死亡掉落以及掉落率
- 将伤害和受伤组件独立出去
- 制作经验条
- 添加升级功能
- 添加ui升级界面
- 实现点击卡片功能（数据）
- 添加角色死亡
- 实现随时间增加难度（可以加快敌人生成速度，通过降低Timer的间隔来实现）
- 完善tilemap
- 避免敌人在map之外生成
- 添加死亡组件DeathComponent
- 添加速度组件，控制速度的变化，可复用于多个对象
- 添加新的敌人
- 创建权重表来概率生成敌人
- 制作小瓶飞向玩家效果
- 创建敌人受伤效果 闪光+文字，应该附着在hurtbox_component上，受伤时显示
- 闪光使用shader实现，创建hit_flash_component
- 添加新的升级选项
- 实现能力伤害提升
- 优化升级卡片样式（主题）和动画
- 创建卡片弹出动画
- 添加卡片悬停动画，因为同时只能播放一个动画，如果在弹出时悬停就会打断弹出动画，所以应该再创建一个AnimationPlayer来分开做动画
- 使用mouse_over在做动画时发现不停触发，是因为卡片的不同子节点都能触发这个信号，所以应把下层节点的mouse filter改成ignore只保留根节点为pass
- 优化经验条和结束页面样式和动画
- 添加角色移动速度升级选项
- 添加角色受伤屏幕闪烁效果
- 完善UI 暂停界面 主菜单 设置界面
- 实现场景间过渡
- 实现升级能力(持久化元数据)

## 实现怪物自动生成

需要在玩家视线之外的随机区域生成，以玩家为中心画一个圆，圆之外生成

- 视线是多大？就是项目设置中的 viewport 尺寸
- 随机区域是如何实现？其实是随机方向(角度) * 指定距离，圆的半径(viewport一半 再多一些安全距离)，那最终的位置就是 玩家位置 + 随机角度 * 指定半径
- 使用定时器 不断实例化怪物场景 记得一定打开定时器的自动开启

## 增加敌人掉落经验

注意幸存者一般可以调整拾取范围，所以拾取的碰撞不应和角色碰撞是同一个

拾取层应和收集物的物理层对应

## 死亡掉落

可以实现为组件：VialDropComponent

如何控制掉率，在组件中定义 drop_percent 再在掉落逻辑中判断

```python
	if randf() > drop_percent: # randf 会生成0 - 1的浮点数
		return
```

## 为什么剑要两个场景

sword_ability 负责基本的样式，链接hitbox和controller，因为controller里计算好的伤害值要由hitbox来应用

sword_ability_controller 负责伤害的设置，升级等等

因为剑是动态生成的，通过controller来控制生成和伤害加成等逻辑

## 随时间增加难度

默认难度 0

因为游戏是倒计时，希望每过5s难度+1则有以下规律：

60s 难度0

55s 难度1

50s 难度2

所以得出公式：

```python
arena_diffculty = ((timer.wait_time - timer.left_time)) / 5 - 1
// or
timer.left_time = timer.wait_time - ((arena_diffculty + 1) * 5)
```

即在每一帧判断时间：left_time

left_time ≤ timer.wait_time - ((arena_diffculty + 1) * 5)

就是该增加难度了

## 实现怪物不在区域外生成

利用射线，在人物和怪物位置之间创建一条射线，并与场景相交，看看有没有碰撞，没有说明中间没有地形阻挡，有的话就吧生成的方向旋转90度，最多再试3次肯定有不在区域外的。

```jsx
var raycast_instance = PhysicsRayQueryParameters2D.create(player_node.global_position, spawn_position, 1)
var raycase_result = get_tree().root.world_2d.direct_space_state.intersect_ray(raycast_instance)
```

## 实现升级能力(持久化元数据

- 实现基本脚本和资源
- 实现读写到本地硬盘
- 添加升级卡片
- 添加升级面板
- 添加升级后回调，应用buff等