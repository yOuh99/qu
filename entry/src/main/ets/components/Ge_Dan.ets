@Component
export struct Ge_Dan {
  @Consume('pathStack') pathStack: NavPathStack;
  @State title: string = "歌单详情";

  build() {
    NavDestination() {
      Column() {
        // 顶部导航栏
        Row() {
          Text("< 返回")
            .fontSize(16)
            .onClick(() => {
              this.pathStack.pop();
            })
          Blank()
          Text(this.title).fontSize(18).fontWeight(FontWeight.Bold)
          Blank()
          Text("   ") // 占位
        }
        .width('100%')
        .padding(15)
        .backgroundColor(Color.White)

        // 这里可以放你的歌单列表内容
        Text(`这里是 ${this.title} 的歌曲列表`)
          .margin({ top: 50 })
          .fontSize(20)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      // 获取传递过来的参数 (例如 "每日推荐")
      this.title = context.pathInfo.param as string;
    })
  }
}