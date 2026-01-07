import { SongItem } from '../models/MusicModel';
import { HttpUtil } from '../utils/HttpUtil';
import promptAction from '@ohos.promptAction';

// 图标资源配置
class IconLinks {
  static readonly MENU = 'https://img.icons8.com/ios/50/333333/menu--v1.png';
  static readonly SEARCH = 'https://img.icons8.com/ios/50/999999/search--v1.png';
  static readonly MIC = 'https://img.icons8.com/ios/50/333333/microphone.png';
  static readonly PLAY = 'https://img.icons8.com/ios-filled/50/333333/play--v1.png';
  static readonly VINYL = 'https://img.icons8.com/ios-filled/100/333333/vinyl-record.png';
}

@Component
export struct tui_jian {
  // --- 1. 新增：接收父组件 Index 的导航栈 ---
  @Consume('pathStack') pathStack: NavPathStack;

  // --- 数据状态 ---
  @State recommendList: SongItem[] = [];
  @State todayDate: string = new Date().getDate().toString();

  // 搜索相关状态
  @State searchKeyword: string = '';
  @State isSearching: boolean = false;
  @State isLoading: boolean = false;

  async aboutToAppear() {
    await this.doSearch('热门华语', false);
  }

  async doSearch(keyword: string, isUserSearch: boolean) {
    if (!keyword.trim()) {
      promptAction.showToast({ message: '请输入歌曲名' });
      return;
    }

    this.isLoading = true;
    try {
      let songs = await HttpUtil.searchMusic(keyword);
      this.recommendList = [...songs];
      this.isSearching = isUserSearch;

      if (songs.length === 0) {
        promptAction.showToast({ message: '未找到相关歌曲' });
      }
    } catch (error) {
      promptAction.showToast({ message: '网络请求失败，请检查网络' });
    } finally {
      this.isLoading = false;
    }
  }

  getRealCover(originalUrl: string): string {
    if (!originalUrl) return IconLinks.VINYL;
    let secureUrl = originalUrl;
    if (secureUrl.startsWith('http:')) {
      secureUrl = secureUrl.replace('http:', 'https:');
    }
    if (!secureUrl.includes('?')) {
      secureUrl = secureUrl + '?param=200y200';
    }
    return secureUrl;
  }

  build() {
    Column() {
      this.SearchBarSection()

      if (this.isLoading) {
        Column() {
          LoadingProgress().width(50).height(50).color(Color.Red)
          Text('正在加载音乐...').fontSize(14).fontColor('#999').margin({ top: 10 })
        }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List() {
          ListItem() {
            Column({ space: 20 }) {
              if (!this.isSearching) {
                this.HorizontalCardSection()
              }

              this.VerticalListSection(
                this.isSearching ? `"${this.searchKeyword}" 的搜索结果` : "根据你喜爱的歌曲推荐",
                this.recommendList
              )

              Blank().height(80)
            }
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder SearchBarSection() {
    Row({ space: 12 }) {
      Image(IconLinks.MENU).width(24).height(24).objectFit(ImageFit.Contain)
      Row() {
        Image(IconLinks.SEARCH).width(16).height(16).margin({ right: 4 })
        TextInput({ text: this.searchKeyword, placeholder: '搜你想听的歌曲...' })
          .layoutWeight(1)
          .height(36)
          .backgroundColor(Color.Transparent)
          .placeholderColor('#999')
          .enterKeyType(EnterKeyType.Search)
          .onChange((value) => { this.searchKeyword = value; })
          .onSubmit(() => { this.doSearch(this.searchKeyword, true); })
      }
      .layoutWeight(1)
      .height(36)
      .backgroundColor('#F2F2F2')
      .borderRadius(20)
      .padding({ left: 12, right: 12 })
      .alignItems(VerticalAlign.Center)

      if (this.isSearching) {
        Text("取消")
          .fontSize(16)
          .fontColor('#333')
          .onClick(() => {
            this.searchKeyword = '';
            this.doSearch('热门华语', false);
          })
      } else {
        Image(IconLinks.MIC).width(24).height(24).objectFit(ImageFit.Contain)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 4 })
    .backgroundColor(Color.White)
  }

  @Builder HorizontalCardSection() {
    List({ space: 12 }) {
      // 在这里传递不同的标题，用于跳转后显示
      ListItem() { this.DailyRecommendCard('#FF3A3A', '每日推荐') }
      ListItem() { this.DailyRecommendCard('#8B7355', '心动模式') }
      ListItem() { this.DailyRecommendCard('#2F4F4F', '新歌首发') }
    }
    .listDirection(Axis.Horizontal)
    .width('100%')
    .height(140)
    .padding({ left: 16, right: 16 })
    .margin({ top: 10 })
  }

  @Builder DailyRecommendCard(bgColor: string, title: string) {
    Stack({ alignContent: Alignment.Center }) {
      Column().width('100%').height('100%').backgroundColor(bgColor).borderRadius(12)
      Text(this.todayDate)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ bottom: 10 })
      Text(title)
        .fontSize(14)
        .fontColor(Color.White)
        .position({ x: 12, y: 110 })
    }
    .width(130)
    .height('100%')
    .borderRadius(12)
    .clip(true)
    // --- 2. 新增：点击跳转逻辑 ---
    .onClick(() => {
      // 跳转到名为 "Ge_Dan" 的页面，并传递标题参数
      this.pathStack.pushPath({ name: "Ge_Dan", param: title })
    })
  }

  @Builder VerticalListSection(title: string, songs: SongItem[]) {
    Column() {
      Text(title).fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 12, left: 16, top: 24 })
      if (songs && songs.length > 0) {
        Column() {
          ForEach(songs, (song: SongItem) => {
            this.SongListItem(song)
          })
        }
      } else {
        Text('暂无内容').fontSize(14).fontColor('#999').margin({ left: 16, bottom: 10 })
      }
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder SongListItem(song: SongItem) {
    Row() {
      Image(this.getRealCover(song.album.picUrl)).width(50).height(50).borderRadius(6).margin({ right: 12 }).objectFit(ImageFit.Cover)
      Column({ space: 6 }) {
        Text(song.name).fontSize(16).fontWeight(FontWeight.Medium).fontColor('#333').maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(song.artists && song.artists.length > 0 ? song.artists[0].name : "未知歌手").fontSize(12).fontColor('#999').maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
      }.layoutWeight(1).alignItems(HorizontalAlign.Start)
      Image(IconLinks.PLAY).width(24).height(24).opacity(0.3)
    }
    .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 }).backgroundColor(Color.White)
    .onClick(() => {
      promptAction.showToast({ message: `开始播放: ${song.name}` });
    })
  }
}