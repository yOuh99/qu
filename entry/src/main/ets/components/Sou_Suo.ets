@Component
export struct Sou_Suo {
  @Consume pathStack: NavPathStack

  build() {
    Column() {
      // 1. 顶部搜索栏区域
      GridRow({
        columns: { sm: 4, md: 12 }
      }) {
        GridCol({
          span: { sm: 4, md: 6 }
        }) {
          Row({ space: 30 }) {
            SymbolGlyph($r("sys.symbol.sort")).fontSize(22)
            Search()
              .height(35)
              .width('55%')
              .focusable(false)
              .onClick(() => {
                this.pathStack.pushPath({
                  name: "SearchPage"
                })
              })
            SymbolGlyph($r("sys.symbol.line_viewfinder")).fontSize(20)
            SymbolGlyph($r("sys.symbol.mic")).fontSize(20)
          }
          .width('100%').height(35).padding({ left: 10, right: 10 })
        }
      }



      // 2. 下方的歌手图片网格
      Grid() {
        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.chenyixun")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("陈奕迅").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.dengziqi")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("邓紫棋").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.xuezhiqian")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("薛之谦").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.xusong")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("许嵩").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.caixukun")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("蔡徐坤").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.wanglihong")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("王力宏").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.linjunjie")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("林俊杰").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.lironghao")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("李荣浩").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.zhangxinzhe")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("张信哲").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
          Column() {
            Stack() {
              Image($r("app.media.zhouchuanxiong")).width('100%').height("100%").borderRadius(10)
              Column() {
                Blank()
                Text("周传雄").fontWeight(FontWeight.Bold).fontSize(20).width('100%').fontColor(Color.White)
                Text("").fontSize(15).width('100%').fontColor(Color.White)
              }.width('100%').height('100%')
            }
          }.width('100%').height('100%')
        }.width('45%').height('25%').margin(3).borderRadius(10).backgroundColor(Color.Red)

        GridItem() {
        }.height(130)

      }.columnsTemplate('1fr 1fr')
      .width('100%')
      .padding(2)
      .scrollBar(BarState.Off)

    }.width('100%').height('100%')
  }
}