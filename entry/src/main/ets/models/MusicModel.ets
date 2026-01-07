export class Artist {
  id: number = 0;
  name: string = '未知歌手';
  img1v1Url: string = '';
  picUrl: string = '';
}

export class Album {
  id: number = 0;
  name: string = '未知专辑';
  picUrl: string = '';
  artist: Artist = new Artist();
}

export class PlaylistItem {
  id: number = 0;
  name: string = '';
  coverImgUrl: string = '';
  trackCount: number = 0;
  creator: string = '';
  playCount: number = 0;
}

export class SongItem {
  id: number = 0;
  name: string = '';
  artists: Array<Artist> = [];
  album: Album = new Album();
  duration: number = 0;
  recommendReason: string = '';
}