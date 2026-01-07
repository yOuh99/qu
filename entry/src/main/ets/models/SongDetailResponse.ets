import { SongDetail } from "./SongDetail"

export  class SongDetailResponse{
  songs:SongDetail[]
  code: number

  constructor(songs: SongDetail[], code: number) {
    this.songs = songs
    this.code = code
  }

}