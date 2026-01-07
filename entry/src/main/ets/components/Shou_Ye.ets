import { tui_jian } from './tui_jian'
import { yin_yue } from './yin_yue'

interface NavItem {
  title: string
  content?:object // 可选，对应内容组件
}

@Component
export struct Shou_Ye {

  @StorageProp("widthBreakpoint")wbp:WidthBreakpoint = WidthBreakpoint.WIDTH_SM
  // 导航栏数据：标题 + 对应内容页面组件
  private navItems: NavItem[] = [
    { title: '推荐', content: tui_jian },
    { title: '音乐', content: yin_yue },
  ];

  // 当前选中的导航索引（默认选中“推荐”）
  @State activeIndex: number = 3;

  build() {
    Column() {
      // 顶部导航栏：左侧图标（固定）+ 文字滑动区 + 右侧图标（固定）
      Flex() {
        // 左侧图标（固定，不随滑动移动）
        SymbolGlyph($r('sys.symbol.list_square'))
          .fontWeight(FontWeight.Normal)
          .fontColor([Color.Black])
          .fontSize(25)
          .margin({left:15,right:5})

        // 中间文字滑动区（仅这里可左右滑动）
        Scroll() {
          Row({ space: 18}) {
            ForEach(this.navItems,(item:NavItem, index) => {
              Text(item.title)
                .width(this.wbp===WidthBreakpoint.WIDTH_SM ? 37:100)
                .fontSize(18)
                .fontWeight(this.activeIndex === index ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.activeIndex === index ? Color.Black : Color.Gray)
                .decoration({
                  type: this.activeIndex === index ? TextDecorationType.Underline : TextDecorationType.None,
                  color: Color.Black
                })
                .onClick(() => {
                  this.activeIndex = index;
                });
            },
              (item:NavItem, index) => index.toString()
            )
          }.width('100%')
          .height('100%')
          .padding({left:10,right:10,bottom:20})
        }.scrollable(ScrollDirection.Horizontal)

        // 右侧图标（固定，不随滑动移动）
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontWeight(FontWeight.Normal)
          .fontColor([Color.Black])
          .fontSize(25)
          .margin({right:15})
      }.width('100%')
      .height(50)
      .backgroundColor(Color.White)
      .shadow({ radius: 2 })

      // 中间内容区域（根据选中项切换）
      Column() {
        ForEach(this.navItems,(item:NavItem, index) => {
          if (this.activeIndex === index) {
            if (item.content === tui_jian) {
              tui_jian() // 渲染推荐组件
            } else if (item.content === yin_yue) {
              yin_yue() // 渲染音乐组件
            } else {
              Text('暂无页面内容')
                .fontSize(20)
                .fontColor(Color.Black)
                .margin({ top: 40 })
            }
          }
        })
      }.width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .height('100%')
    .width('100%')
  }
}