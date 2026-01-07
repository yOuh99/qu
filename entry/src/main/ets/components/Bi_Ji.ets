@Component
export struct Bi_Ji{
  build() {

      Column(){
        Row({space:20}){
          SymbolGlyph($r('sys.symbol.sort')).fontSize(22)
          Blank()
          Text('关注')
          Column(){
            Text('推荐')
            Line().backgroundColor(Color.Black).width(22).height(1)
          }
          Blank()
          SymbolGlyph($r('sys.symbol.magnifyingglass')).fontSize(22)
          SymbolGlyph($r('sys.symbol.plus_square')).fontSize(22)
        }.width('100%').backgroundColor("#FFFFFF").height(40)


        Grid(){
          GridItem(){
            Column(){
              Image($r("app.media.biji1")).height(220).width('100%')
              Text('JJ晒出和女友一起陪妈妈庆生的温馨合照，正式官宣恋情～').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx1")).width(30).height(30).borderRadius(20)
                Text('quit').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('2.5W').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){
            Column(){
              Image($r("app.media.biji2")).height(220).width('100%')
              Text('Taylor Swift！').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx2")).width(30).height(30).borderRadius(20)
                Text('hello').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('386').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){
            Column(){
              Image($r("app.media.biji3")).height(220).width('100%')
              Text('少听点one last kiss吧...').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx3")).width(30).height(30).borderRadius(20)
                Text('are you ok').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('8144').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){
            Column(){
              Image($r("app.media.biji4")).height(220).width('100%')
              Text('那年的今日，方大同在干嘛。').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx4")).width(30).height(30).borderRadius(20)
                Text('hey').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('3.8W').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){
            Column(){
              Image($r("app.media.biji5")).height(220).width('100%')
              Text('发现女友出轨后，我连夜查手机收集证据。').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx5")).width(30).height(30).borderRadius(20)
                Text('what').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('2467').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){
            Column(){
              Image($r("app.media.biji6")).height(220).width('100%')
              Text('脱粉DOUDOU了………………').width('100%').fontSize(12).height(40).fontWeight(FontWeight.Bold)
              Row(){
                Image($r("app.media.tx6")).width(30).height(30).borderRadius(20)
                Text('the').fontSize(10)
                Blank()
                SymbolGlyph($r("sys.symbol.hand_thumbsup_fill")).width(20).height(20)
                Text('39W').fontSize(10)
              }.width('100%').height(40)
            }
          }.backgroundColor(Color.White).width('50%').height(300).margin(3).borderRadius(10)
          GridItem(){}.height(100)

        }
        .columnsTemplate('1fr 1fr')
        .width('100%')
        .padding(2)
        .scrollBar(BarState.Off)//隐藏滑动条

      }.backgroundColor("#F2F5F8").width('100%').height('100%')

  }
}