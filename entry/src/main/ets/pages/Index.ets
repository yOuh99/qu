import { Bi_Ji } from '../components/Bi_Ji'
import { Shou_Ye } from '../components/Shou_Ye'
import { Sou_Suo } from '../components/Sou_Suo'
import { Wo_De } from '../components/Wo_De'
// 【新增 1】引入歌单详情页组件 (确保你已创建 Ge_Dan.ets)
import { Ge_Dan } from '../components/Ge_Dan'

import { Artist } from '../models/Artist'
import { Song } from '../models/Song'
import { SongDetail } from '../models/SongDetail'
import { AudioPlayerUtil } from '../utils/AudioPlayerUtil'

@Entry
@Component
struct Index {

    // 核心导航栈，提供给子组件使用
    @Provide pathStack: NavPathStack = new NavPathStack()

    @State currentIndex: number = 0
    @State isShowPlayList: boolean = false
    @State isShowPlayPage: boolean = false

    @StorageProp("widthBreakpoint") wbp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM
    @StorageProp("heightBreakpoint") hbp: HeightBreakpoint = HeightBreakpoint.HEIGHT_MD
    @StorageProp("playBarOffset") playBarOffset: number = -56
    @StorageProp("currentSongDetail") currentSongDetail: SongDetail | undefined = undefined
    @StorageProp("avplayerState") avplayerState: string = "idle"
    @StorageProp("duration") duration: number = 100
    @StorageProp("currentTime") currentTime: number = 0
    @StorageProp("songList") songList: Song[] = []
    @StorageProp("currentIndex") currentPlaySongIndex: number = -1
    @StorageProp("lyric") lyric: string = ""

    // 【新增 2】路由映射表：告诉导航器不同的名字对应哪个组件
    @Builder PageMap(name: string) {
        if (name === "Ge_Dan") {
            Ge_Dan()
        }
        // 如果以后有其他页面跳转，可以在这里继续加 if
    }

    build() {
        Stack() {
            Navigation(this.pathStack) {
                Tabs({
                    barPosition: this.wbp === WidthBreakpoint.WIDTH_SM ? BarPosition.End : BarPosition.Start
                }) {
                    TabContent() {
                        Shou_Ye()
                    }.tabBar(this.TabNavBar(0, "首页"))
                    TabContent() {
                        Sou_Suo()
                    }.tabBar(this.TabNavBar(1, "搜索"))
                    TabContent() {
                        Bi_Ji()
                    }.tabBar(this.TabNavBar(2, "笔记"))
                    TabContent() {
                        Wo_De()
                    }.tabBar(this.TabNavBar(3, "我的"))
                }
                .vertical(this.wbp === WidthBreakpoint.WIDTH_SM ? false : true)
                .barHeight(this.wbp === WidthBreakpoint.WIDTH_SM ? 54 : 400)
                .onChange((i) => {
                    this.currentIndex = i
                })
            }
            .hideTitleBar(true)
            .hideToolBar(true)
            .mode(NavigationMode.Stack)
            .navDestination(this.PageMap) // 【新增 3】必须绑定路由映射，否则跳转无效

            this.PlayControlBar()

        }
        .width('100%')
        .height('100%')
        .alignContent(Alignment.Bottom)
        .bindContentCover($$this.isShowPlayPage, this.PlayPageView())
    }

    // --- 以下保持原样 ---

    @Builder
    PlayPageView() {
        Column() {
            this.PlayPageTitleBar()
            Swiper() {
                Column() {
                    this.PlayPageAlbumImage()
                    this.PlayPageSongInfo()
                    Blank()
                    this.PlayPageProgressBar()
                    this.PlayPageControllerBar()

                }.width('100%').height('100%')

                Column() {
                    Row() {
                        Column() {
                            this.PlayPageAlbumImage()
                        }.width('20%')
                        Column() {
                            this.PlayPageSongInfo()
                        }.width('80%').padding({ top: 10 })
                    }.width('100%')

                    this.PlayPageLrc()

                    Blank()
                    this.PlayPageProgressBar()
                    this.PlayPageControllerBar()
                }.width('100%').height('100%')
            }.height('100%')
            .padding({ bottom: 50 })
            .indicator(false)
        }.width('100%')
        .height('100%')
        .padding({ top: 36 })
        .backgroundColor("#3E5778")
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
    }

    @Builder
    PlayPageLrc() {
        Column({ space: 10 }) {
            Text(this.lyric).fontColor("#f1f3f5").fontSize(20)
        }.width('100%')
        .height(300)
        .padding(15)
    }

    @Builder
    PlayPageTitleBar() {
        Row() {
            SymbolGlyph($r("sys.symbol.chevron_down")).fontColor(['#f1f3f5']).fontSize(20)
                .onClick(() => {
                    this.isShowPlayPage = false
                })
            Blank()
            SymbolGlyph($r("sys.symbol.share")).fontColor(['#f1f3f5']).fontSize(20)
        }.width('100%')
        .padding(10)
    }

    @Builder
    PlayPageAlbumImage() {
        Row() {
            Image(this.currentSongDetail?.album.picUrl)
                .width('85%')
                .borderRadius(10)
                .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({
            top: 30,
            bottom: 15
        })
    }

    @Builder
    PlayPageSongInfo() {
        Column() {
            Row({ space: 20 }) {
                Text(this.currentSongDetail?.name).fontSize(20).fontColor(Color.White).textOverflow({ overflow: TextOverflow.Ellipsis }).width('50%')
                Blank()
                SymbolGlyph($r("sys.symbol.heart_slash")).fontColor([Color.White]).fontSize(20)
                SymbolGlyph($r("sys.symbol.heart_fill")).fontColor([Color.White]).fontSize(20)
            }.width('85%')

            Row({ space: 10 }) {
                ForEach(this.currentSongDetail?.artists, (item: Artist, index: number) => {
                    Text(item.name).fontSize(16).fontColor('#cccccc').textOverflow({ overflow: TextOverflow.Ellipsis })
                })
            }.width('85%')
            .padding(10)
        }.width('100%')
    }

    @Builder
    PlayPageProgressBar() {
        Column() {
            Row() {
                Slider({
                    max: this.duration,
                    value: this.currentTime,
                }).selectedColor(Color.White)
                    .onChange((v) => {
                        AudioPlayerUtil.avPlayer?.seek(v)
                    })
            }.width('90%')
            Row() {
                Text(Math.floor(Math.round(this.currentTime / 1000) / 60) + ":" + Math.round(this.currentTime / 1000) % 60).fontSize(13).fontColor('#cccccc')
                Blank()
                Text(Math.floor(Math.round(this.duration / 1000) / 60) + ":" + Math.round(this.duration / 1000) % 60).fontSize(13).fontColor('#cccccc')
            }.width('90%').padding({ left: 5, right: 5 })
        }.width('100%')
    }

    @Builder
    PlayPageControllerBar() {
        Row() {
            SymbolGlyph($r("sys.symbol.repeat")).fontColor([Color.White]).fontSize(25)
            SymbolGlyph($r("sys.symbol.backward_end_fill")).fontColor([Color.White]).fontSize(30)
                .onClick(() => {
                    AudioPlayerUtil.playPrevSong()
                })
            if (this.avplayerState == "playing") {
                SymbolGlyph($r("sys.symbol.pause_round_triangle_fill")).fontColor([Color.White]).fontSize(50)
                    .onClick(() => {
                        AudioPlayerUtil.avPlayer?.pause()
                    })
            } else {
                SymbolGlyph($r("sys.symbol.play_round_triangle_fill")).fontColor([Color.White]).fontSize(50)
                    .onClick(() => {
                        AudioPlayerUtil.avPlayer?.play()
                    })
            }
            SymbolGlyph($r("sys.symbol.forward_end_fill")).fontColor([Color.White]).fontSize(30)
                .onClick(() => {
                    AudioPlayerUtil.playNextSong()
                })
            SymbolGlyph($r("sys.symbol.music_note_list")).fontColor([Color.White]).fontSize(25)
                .bindSheet($$this.isShowPlayList, this.PlaylistView(), {
                    height: 600,
                    title: {
                        title: `当前播放：第${this.currentPlaySongIndex + 1}首`
                    }
                })
                .onClick(() => {
                    this.isShowPlayList = true
                })
        }.width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 20, bottom: 20 })
    }



    @Builder
    TabNavBar(index: number, title: string) {
        Column() {
            Text(title)
                .fontColor(index == this.currentIndex ? "rgba(0, 0, 0, 1.00)" : "rgb(131,141,151)")
                .fontSize("16fp")
                .margin({ top: 20 })
        }.width('100%').height(56)
    }

    @Builder
    PlayControlBar() {
        Row({ space: 10 }) {
            if (this.currentSongDetail == undefined) {
                Image($r("app.media.cp")).width(48).height(48).borderRadius(24)
            } else {
                Image(this.currentSongDetail.album.picUrl).width(48).height(48).borderRadius(24)
                    .onClick(() => {
                        this.isShowPlayPage = true
                    })
            }

            Text(this.currentSongDetail?.name).fontSize(16).fontWeight(FontWeight.Bold).maxLines(1).textOverflow({ overflow: TextOverflow.MARQUEE }).width(100)
            Text(this.currentSongDetail?.artists[0].name).fontSize(13).fontColor(Color.Gray).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width(70)
            Blank()

            Stack() {
                Progress({
                    type: ProgressType.Ring,
                    total: this.duration,
                    value: this.currentTime
                }).width(30).height(30).color(Color.Red).style({ strokeWidth: 2 })

                if (this.avplayerState == "playing") {
                    SymbolGlyph($r("sys.symbol.pause_fill")).fontSize(15)
                        .onClick(() => {
                            AudioPlayerUtil.avPlayer?.pause()
                        })
                } else {
                    SymbolGlyph($r("sys.symbol.play_fill")).fontSize(15)
                        .onClick(() => {
                            AudioPlayerUtil.avPlayer?.play()
                        })
                }
            }.width(30).height(30)

            SymbolGlyph($r("sys.symbol.list_interrupt"))
                .fontSize(24)
                .margin({ right: 20 })
                .bindSheet($$this.isShowPlayList, this.PlaylistView(), {
                    height: 600,
                    title: {
                        title: `当前播放：第${this.currentPlaySongIndex + 1}首`
                    }
                })
                .onClick(() => {
                    this.isShowPlayList = true
                })

        }.width('96%').height(50).backgroundColor(Color.White)
        .offset({ x: 0, y: this.playBarOffset })
        .border({ width: 1, color: '#eeeeee', style: BorderStyle.Solid })
        .borderRadius(22)
    }

    @Builder
    PlaylistView() {
        Column() {
            Row({ space: 10 }) {
                Row({ space: 5 }) {
                    SymbolGlyph($r("sys.symbol.redo")).fontSize(15)
                    Text('列表循环').fontSize(13)
                }.height(30)
                .width(80)
                .borderRadius(20)
                .backgroundColor("#F9F7F7")
                .border({ width: 1, color: '#eeeeee', style: BorderStyle.Solid })

                Row({ space: 5 }) {
                    SymbolGlyph($r("sys.symbol.rectangle_on_rectangle")).fontSize(15)
                    Text('智能过渡').fontSize(13)
                }.height(30)
                .width(80)
                .borderRadius(20)
                .backgroundColor("#F9F7F7")
                .border({ width: 1, color: '#eeeeee', style: BorderStyle.Solid })
                Blank().width(50)
                SymbolGlyph($r("sys.symbol.arrowshape_down_to_line_fill")).fontSize(20)
                SymbolGlyph($r("sys.symbol.folder_badge_plus")).fontSize(20)
                SymbolGlyph($r("sys.symbol.trash")).fontSize(20)
            }
            List() {
                ForEach(this.songList, (item: Song, index: number) => {
                    ListItem() {
                        Row({ space: 5 }) {
                            Text(item.name).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width(150)
                            Text(item.artists[0].name).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width(120)
                            Blank()
                            SymbolGlyph($r("sys.symbol.xmark")).fontSize(20).fontColor([Color.Gray])
                        }.width('100%').padding(10)
                    }
                })
            }

        }.height('100%').width('100%').backgroundColor(Color.White)
    }
}