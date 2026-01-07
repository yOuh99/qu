import sendableColorSpaceManager from '@ohos.graphics.sendableColorSpaceManager'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { JSON } from '@kit.ArkTS'
import { SongSearchResponse } from '../models/SongSearchResponse'
import { Song } from '../models/Song'
import { AudioPlayerUtil } from '../utils/AudioPlayerUtil'
import { Playlist } from '../models/Playlist'
import { PlaylistSearchResponse } from '../models/PlaylistSearchResponse'
import { Album } from '../models/Album'
import { AlbumSearchResponse } from '../models/AlbumSearchResponse'
import { tag } from '@kit.ConnectivityKit'
import { ArtistSearchResponse } from '../models/ArtistSearchResponse'
import { Artist } from '../models/Artist'


@Builder
function SearchPageBuilder() {
  SearchPage()
}


@Component
struct SearchPage {
  pathStack: NavPathStack | undefined
  @State isShowSearchResult: boolean = false
  @State keyWord: string = ""
  @State songList: Song[] = []
  @State playlists: Playlist[] = []
  @State albums: Album[] = []
  @State artists: Artist[] = []
  @StorageProp("currentIndex") currentIndex: number = -1
  @StorageProp("avplayerState") avplayerState: string = ""

  build() {
    NavDestination() {
      Column() {
        Row() {
          SymbolGlyph($r("sys.symbol.chevron_left"))
            .fontColor([$r("app.color.theme_color_gray")])
            .fontSize(30)
            .onClick(() => {
              this.pathStack?.pop()
              AppStorage.setOrCreate("playBarOffset", -56)
            })

          Search({ placeholder: "歌曲/歌手/歌曲名", value: $$this.keyWord })
            .width('80%')
            .height(30)
            .onSubmit(() => {
              this.doSearchMusic()
            })


          Text('搜索').width('10%').onClick(() => {
            this.doSearchMusic()
          })

        }
        .width('100%')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .justifyContent(FlexAlign.SpaceBetween)

        //内容
        if (this.isShowSearchResult) {
          this.SearchResultView()
        } else {
          this.DefaultView()
        }

      }.width('100%')
      .height('100%')

    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .onReady(context => {
      this.pathStack = context.pathStack

      AppStorage.setOrCreate("playBarOffset", 0)
    })
  }

  @Builder
  SearchResultView() {
    Tabs() {
      TabContent() {
        Column() {
          List() {
            ForEach(this.songList, (item: Song, index: number) => {
              ListItem() {
                Row() {
                  Column({ space: 6 }) {
                    Text(item.name).fontSize(16).fontColor("rgb(20,21,39)").width('100%')
                    Row({ space: 5 }) {
                      if (item.fee != 0 && item.fee != 8) {
                        Text("VIP").fontSize(12).fontColor(Color.White).backgroundColor(Color.Red).padding(3)
                      }
                      Text(item.artists[0].name).fontSize(14).fontColor("rgb(86,125,167)")
                      Text("-")
                      Text(item.album.name).fontSize(13).fontColor("rgb(110,100,110)")
                    }.width('100%')
                  }.width('90%')
                  .alignItems(HorizontalAlign.Start)

                  if (index === this.currentIndex && this.avplayerState === "playing") {
                    SymbolGlyph($r('sys.symbol.pause_fill')).fontSize(20)
                      .onClick(() => {
                        AudioPlayerUtil.avPlayer?.pause()
                      })
                  } else {
                    if (item.fee == 0 || item.fee === 8) {
                      SymbolGlyph($r('sys.symbol.play_fill')).fontSize(20)
                        .onClick(() => {
                          if (index == this.currentIndex) {
                            AudioPlayerUtil.avPlayer?.play()
                          } else {
                            AudioPlayerUtil.playSong(item)
                            AppStorage.setOrCreate("currentIndex", index)
                          }
                        })
                    } else {
                      SymbolGlyph($r('sys.symbol.play_fill')).fontSize(20).fontColor([Color.Gray])
                    }
                  }

                }.width('100%').padding({ left: 10, right: 10, top: 8, bottom: 8 })
              }

            })
            ListItem() {
            }.height(100)
          }
        }.width('100%')
        .height('100%')
      }.tabBar('单曲')

      TabContent() {
        List() {
          ForEach(this.playlists, (item: Playlist, index: number) => {
            ListItem() {
              Row() {
                Image(item.coverImgUrl).width(55).height(55).borderRadius(5)
                Column() {
                  Text(item.name).fontSize(16)
                  Row() {
                    Text(item.bookCount + '首')
                    ForEach(item.officialTags, (tag: string) => {
                      Text(tag)
                    })
                  }.width('100%')
                }.width(285).alignItems(HorizontalAlign.Start)
              }.width('100%').padding(5)
            }
          })
        }
      }.tabBar('歌单')

      TabContent() {
        List() {
          ForEach(this.albums, (item: Album, index: number) => {
            ListItem() {
              Row() {
                Image(item.picUrl).width(55).height(55).borderRadius(5)
                Column() {
                  Text(item.name).fontSize(16).width('100%')
                  Text(item.artist.name + "·" + item.publishTime + "").width('100%')
                }.width('100%')
              }.width('100%').padding(5)
            }
          })
        }

      }.tabBar('专辑')

      TabContent() {
        List() {
          ForEach(this.artists, (item: Artist, index: number) => {
            ListItem() {
              Row() {
                Image(item.img1v1Url).width(55).height(55).borderRadius(50)
                Column() {
                  Text(item.name).fontSize(16)
                  Text(item.albumSize + "" + "·" + item.musicSize + "首")
                }.width(225).alignItems(HorizontalAlign.Start)

                Text("关注")
                  .width(55)
                  .height(40)
                  .borderRadius(20)
                  .backgroundColor(Color.White)
                  .border({ width: 1, color: '#eeeeee', style: BorderStyle.Solid })
                  .margin({ right: 10 })
                  .fontSize(12)
                  .padding({ left: 15 })
              }.width('100%').padding(5)
            }
          })
        }

      }.tabBar('歌手')
    }
    .scrollable(false)
    .onChange(index => {
      if (index === 0) {
        this.doSearchMusic()
      } else if (index === 1) {
        this.doSearchPlaylist()
      } else if (index === 2) {
        this.doSearchAlbum()
      } else if (index === 3) {
        this.doSearchArtist()
      }
    })
  }

  // 修改了这里：将之前的图标栏替换为了歌手网格
  @Builder
  DefaultView() {
    Column() {
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

        // 底部留白，防止遮挡
        GridItem() {
        }.height(130)

      }
      .columnsTemplate('1fr 1fr')
      .width('100%')
      .padding(2)
      .scrollBar(BarState.Off)

    }
    .width('100%')
    .height('100%')
  }

  doSearchMusic() {
    let httpRequest = http.createHttp()
    let url: string = "http://music.163.com/api/search/get"
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      extraData: {
        type: "1",
        limit: "20",
        s: this.keyWord
      }
    }
    httpRequest.request(url, options)
      .then((response) => {
        //let jsonStr = JSON.stringify(response)
        //console.log(jsonStr)
        let jsonStr = response.result as string
        let obj: SongSearchResponse = JSON.parse(jsonStr) as SongSearchResponse
        console.log(obj.code + "~~~~~")
        if (obj.code == 200) {
          this.songList = obj.result.songs

          AppStorage.setOrCreate("songList", this.songList)

          this.isShowSearchResult = true
        }
      })
      .catch((err: BusinessError) => {
        console.log(err.message)
      })
  }

  doSearchPlaylist() {
    let httpRequest = http.createHttp()
    let url: string = "http://music.163.com/api/search/get"
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      extraData: {
        type: "1000",
        limit: "20",
        s: this.keyWord
      }
    }
    httpRequest.request(url, options)
      .then((response) => {
        //let jsonStr = JSON.stringify(response)
        //console.log(jsonStr)
        let jsonStr = response.result as string
        let obj: PlaylistSearchResponse = JSON.parse(jsonStr) as PlaylistSearchResponse
        console.log(obj.code + "~~~~~")
        if (obj.code == 200) {
          this.playlists = obj.result.playlists
          this.isShowSearchResult = true
        }
      })
      .catch((err: BusinessError) => {
        console.log(err.message)
      })
  }

  doSearchAlbum() {
    let httpRequest = http.createHttp()
    let url: string = "http://music.163.com/api/search/get"
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      extraData: {
        type: "10",
        limit: "20",
        s: this.keyWord
      }
    }
    httpRequest.request(url, options)
      .then((response) => {
        //let jsonStr = JSON.stringify(response)
        //console.log(jsonStr)
        let jsonStr = response.result as string
        let obj: AlbumSearchResponse = JSON.parse(jsonStr) as AlbumSearchResponse
        console.log(obj.code + "~~~~~")
        if (obj.code == 200) {
          this.albums = obj.result.albums
          this.isShowSearchResult = true
        }
      })
      .catch((err: BusinessError) => {
        console.log(err.message)
      })
  }

  doSearchArtist() {
    let httpRequest = http.createHttp()
    let url: string = "http://music.163.com/api/search/get"
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      extraData: {
        type: "100",
        limit: "20",
        s: this.keyWord
      }
    }
    httpRequest.request(url, options)
      .then((response) => {
        //let jsonStr = JSON.stringify(response)
        //console.log(jsonStr)
        let jsonStr = response.result as string
        let obj: ArtistSearchResponse = JSON.parse(jsonStr) as ArtistSearchResponse
        console.log(obj.code + "~~~~~")
        if (obj.code == 200) {
          this.artists = obj.result.artists
          this.isShowSearchResult = true
        }
      })
      .catch((err: BusinessError) => {
        console.log(err.message)
      })
  }
}