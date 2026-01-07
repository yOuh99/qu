import { http } from "@kit.NetworkKit"
import { Playlist } from "../models/Playlist"
import { PlaylistSearchResponse } from "../models/PlaylistSearchResponse"

@Component
export struct yin_yue {
  @StorageProp("widthBreakpoint") wbp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM
  @StorageProp("heightBreakpoint") hbp: HeightBreakpoint = HeightBreakpoint.HEIGHT_MD
  @Consume pathStack: NavPathStack
  @State playlists: Playlist[] = []

  aboutToAppear(): void {
    this.getPlaylists()
  }

  //查询歌单列表//
  getPlaylists() {
    let arr = ["中文流行", "欧美流行", "林俊杰", "Charlie Puth"]
    let index = Math.floor(Math.random() * arr.length)
    let keyword = arr[index]
    let httpRequest = http.createHttp()
    let url = "http://music.163.com/api/search/get"
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      extraData: {
        s: keyword,
        limit: "20",
        type: "1000"
      }
    }
    httpRequest.request(url, options)
      .then((response) => {
        let jsonStr = response.result as string
        let playlistSearchResponse = JSON.parse(jsonStr) as PlaylistSearchResponse
        if (playlistSearchResponse.code === 200) {
          this.playlists = playlistSearchResponse.result.playlists
        }
      })
  }

  imgList: ResourceStr[] = [
    $r("app.media.lunbotu1"),
    $r("app.media.lunbotu2"),
    $r("app.media.lunbotu3"),
    $r("app.media.lunbotu4")
  ]

  build() {
    Scroll() {
      Column({ space: 6 }) {
        // --- 轮播图区域 Start ---
        Swiper() {
          ForEach(this.imgList, (item: ResourceStr) => {
            Image(item)
              .border({
                color: "#f1f3f5",
                width: 1,
                style: BorderStyle.Solid
              })
              .borderRadius(5)
          })
        }
        .displayCount(this.wbp === WidthBreakpoint.WIDTH_SM ? 1 : (this.wbp === WidthBreakpoint.WIDTH_MD ? 2 : 3))
        .width('96%')
        .height(160)
        .autoPlay(true)
        .interval(2000)
        .loop(true)
        .indicator(
          new DotIndicator()
            .itemWidth(10)
            .itemHeight(10)
            .selectedItemWidth(20)
            .selectedItemHeight(10)
            .color(Color.White)
            .selectedColor(Color.Red)
        )
        .index(3)
        // --- 轮播图区域 End ---

        // --- 排行榜区域 ---

        // --- 甄选歌单区域 ---
        Row({ space: 8 }) {
          Text("甄选歌单").fontSize(16).fontWeight(FontWeight.Bold)
        }.width('100%').margin({ left: 20 })

        Grid() {
          ForEach(this.playlists, (item: Playlist, index: number) => {
            GridItem() {
              Column({ space: 4 }) {
                Image(item.coverImgUrl).width(90).height(90).borderRadius(5)
                Text(item.name)
                  .fontSize(15)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }.width(100).height(140)
            }
          })
        }.width('100%')
        .height(280)
        .rowsTemplate("1fr 1fr")
        .scrollBar(BarState.Off)

      }
      .width('100%')
    }.scrollBar(BarState.Off)
  }
}