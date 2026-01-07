import { Playlist } from "./Playlist"

export  class PlaylistSearchResult{
  playlists:Playlist[]
  hasMore:boolean
  hlWords:string[]
  playlistCount:number

  constructor(playlists: Playlist[], hasMore: boolean, hlWords: string[], playlistCount: number) {
    this.playlists = playlists
    this.hasMore = hasMore
    this.hlWords = hlWords
    this.playlistCount = playlistCount
  }



}