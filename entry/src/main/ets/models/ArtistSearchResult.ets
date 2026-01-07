import { Artist } from "./Artist"

export class ArtistSearchResult{
  hasMore:string
    artistCount:number
  hlWords:string[]
    artists:Artist[]
  searchQcReminder:string

  constructor(hasMore: string, artistCount: number, hlWords: string[], artists: Artist[], searchQcReminder: string) {
    this.hasMore = hasMore
    this.artistCount = artistCount
    this.hlWords = hlWords
    this.artists = artists
    this.searchQcReminder = searchQcReminder
  }

}