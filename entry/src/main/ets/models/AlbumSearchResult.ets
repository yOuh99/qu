import { Album } from "./Album"

export class AlbumSearchResult{
  hlWords:string[]
  albums:Album[]
  albumCount:number

  constructor(hlWords: string[], albums: Album[], albumCount: number) {
    this.hlWords = hlWords
    this.albums = albums
    this.albumCount = albumCount
  }

}