import { http } from '@kit.NetworkKit';
// 【注意】请根据你实际存放 MusicModel.ts 的文件夹名称修改下面这行
// 如果你的文件夹叫 models，请改为 '../models/MusicModel'
import { SongItem, Artist, Album } from '../models/MusicModel';

export class HttpUtil {
  static async searchMusic(keyword: string): Promise<SongItem[]> {
    try {
      let searchUrl = `http://music.163.com/api/search/get?s=${encodeURIComponent(keyword)}&type=1&limit=15`;
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(searchUrl, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.OBJECT
      });

      let basicSongs: SongItem[] = [];
      if (response.responseCode === 200) {
        // ArkTS 严格模式要求：必须将结果断言为具体的对象类型，不能由系统推断
        let result = response.result as Record<string, Object>;
        let data = result['result'] as Record<string, Object>;

        if (!data || !data['songs']) {
          return [];
        }

        // 显式指定 map 回调参数的类型
        let rawSongs = data['songs'] as Array<Record<string, Object>>;
        basicSongs = rawSongs.map((item: Record<string, Object>): SongItem => {
          let song = new SongItem();
          song.id = Number(item['id']);
          song.name = String(item['name']);
          song.duration = Number(item['duration']);

          if (item['artists']) {
            let rawArtists = item['artists'] as Array<Record<string, Object>>;
            song.artists = rawArtists.map((rawArtist: Record<string, Object>): Artist => {
              let artist = new Artist();
              artist.name = String(rawArtist['name']);
              return artist;
            });
          }

          if (item['album']) {
            let rawAlbum = item['album'] as Record<string, Object>;
            let album = new Album();
            album.id = Number(rawAlbum['id']);
            album.name = String(rawAlbum['name']);
            song.album = album;
          }
          return song;
        });
      }

      if (basicSongs.length === 0) {
        return [];
      }

      // 获取封面详情
      try {
        let ids: number[] = basicSongs.map((s: SongItem): number => s.id);
        let idStr = ids.join(',');
        let detailUrl = `http://music.163.com/api/song/detail/?id=${idStr}&ids=[${idStr}]`;
        let detailReq = http.createHttp();
        let detailResp = await detailReq.request(detailUrl, {
          method: http.RequestMethod.GET,
          expectDataType: http.HttpDataType.OBJECT
        });

        if (detailResp.responseCode === 200) {
          let detailResult = detailResp.result as Record<string, Object>;
          let detailSongs = detailResult['songs'] as Array<Record<string, Object>>;

          if (detailSongs && detailSongs.length > 0) {
            let coverMap = new Map<number, string>();
            detailSongs.forEach((ds: Record<string, Object>) => {
              let dId = Number(ds['id']);
              let dAlbum = ds['album'] as Record<string, Object>;
              if (dAlbum && dAlbum['picUrl']) {
                coverMap.set(dId, String(dAlbum['picUrl']));
              }
            });

            basicSongs.forEach((s: SongItem) => {
              if (coverMap.has(s.id)) {
                let album = new Album();
                album.picUrl = coverMap.get(s.id) || '';
                // 保留原有的专辑名，如果没有则使用默认
                album.name = s.album.name || '未知专辑';
                s.album = album;
              }
            });
          }
        }
      } catch (detailError) {
        // 忽略详情获取失败，只返回基本信息
      }
      return basicSongs;
    } catch (error) {
      return [];
    }
  }

  static async getLyricContent(songId: number): Promise<string> {
    try {
      let url = `http://music.163.com/api/song/lyric?id=${songId}&lv=-1&kv=-1&tv=-1`;
      let req = http.createHttp();
      let resp = await req.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.OBJECT
      });
      if (resp.responseCode === 200) {
        let result = resp.result as Record<string, Object>;
        if (result['lrc']) {
          let lrcObj = result['lrc'] as Record<string, Object>;
          return lrcObj['lyric'] ? String(lrcObj['lyric']) : '';
        }
      }
    } catch (e) {
      // 错误处理
    }
    return '[00:00.000]暂无歌词';
  }
}