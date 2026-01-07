import { Song } from "./Song"

export class SongSearchResult{
  songs:Song[]
  hasMore:boolean
  songCount:number

  constructor(songs: Song[], hasMore: boolean, songCount: number) {
    this.songs = songs
    this.hasMore = hasMore
    this.songCount = songCount
  }



}