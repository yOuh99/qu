@Component
export struct Wo_De{
  build() {
    Column(){
      Row({space:20}){
        SymbolGlyph($r('sys.symbol.sort')).fontSize(22).fontColor([Color.White])
        Blank()
        Text('+添加状态').fontSize(12).fontColor(Color.White)
        Blank()
        SymbolGlyph($r('sys.symbol.magnifyingglass')).fontSize(22).fontColor([Color.White])
        SymbolGlyph($r('sys.symbol.dot_grid_1x2')).fontSize(22).fontColor([Color.White])
      }.width('100%').backgroundColor("#8C8887").height(40)

      Row(){
        Image($r("app.media.touxiang")).borderRadius(50).width(100).height(100).objectFit(ImageFit.Cover)
      }.width('100%').backgroundColor("#8C8887").height(160).justifyContent(FlexAlign.Center)

      Row(){
        Text('yOu_').height(40).fontSize(25).fontWeight(FontWeight.Bold).backgroundColor("#8C8887").fontColor(Color.White)
      }.justifyContent(FlexAlign.Center).backgroundColor("#8C8887").width('100%')


      Row(){
        Text('23').fontColor(Color.White).fontSize(12).padding({left:70}).fontWeight(FontWeight.Bold)
        Text('关注').fontColor(Color.White).fontSize(8)
        Blank().width(30)
        Text('17').fontColor(Color.White).fontSize(12).fontWeight(FontWeight.Bold)
        Text('粉丝').fontColor(Color.White).fontSize(8)
        Blank().width(30)
        Text('Lv.7').fontColor(Color.White).fontSize(12).fontWeight(FontWeight.Bold)
        Blank().width(30)
        Text('1356').fontColor(Color.White).fontSize(12).fontWeight(FontWeight.Bold)
        Text('小时').fontColor(Color.White).fontSize(8)
      }.width('100%').backgroundColor("#8C8887").height(35).justifyContent(FlexAlign.Center)



      Row(){
        Column(){
          Text('音乐').fontColor(Color.Black).fontSize(15).fontWeight(FontWeight.Bold)
          Line()
            .width(30)
            .height(1)
            .backgroundColor(Color.Red)
        }
        Text('播客').fontColor(Color.Black).fontSize(15).fontWeight(FontWeight.Bold)
        Text('笔记').fontColor(Color.Black).fontSize(15).fontWeight(FontWeight.Bold)
      }.width('75%').backgroundColor(Color.White).height(50).justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Text('近期').fontColor(Color.Black).fontSize(15).padding({left:10})
        Blank().width(18)
        Text('创建').fontColor(Color.Black).fontSize(15)
        Blank().width(18)
        Text('收藏').fontColor(Color.Black).fontSize(15)
        Blank()
        SymbolGlyph($r("sys.symbol.rectangle_and_arrowshape_turn_up_right")).fontColor([Color.Black]).fontSize(17)
        Blank().width(15)
        SymbolGlyph($r("sys.symbol.dot_grid_1x2")).fontColor([Color.Black]).fontSize(17)
      }.width('100%').backgroundColor(Color.White).height(50).justifyContent(FlexAlign.Center)

      List(){
        ListItem(){
          Row({space:6}){
            Image($r("app.media.woxihuan")).width(70).height(60).borderRadius(2).padding({left:8})
            Column(){
              Text('我喜欢的音乐').fontColor(Color.Black).fontSize(15)
              Text('214首|5777次播放').fontColor(Color.Gray).fontSize(11)
            }.width(100).height(60).justifyContent(FlexAlign.Center)

            Blank()
            Row({space:5}){
              SymbolGlyph($r("sys.symbol.heart_fill")).fontColor([Color.Red])
              Text('心动模式').fontSize(12)
            }.backgroundColor("#E9EDEF").borderRadius(20).width(80).height(40).justifyContent(FlexAlign.Center).margin({right:8})
          }.width('100%')
        }.backgroundColor(Color.White).width('100%').height(100)

      }



    }.width('100%').height('100%')

  }
}