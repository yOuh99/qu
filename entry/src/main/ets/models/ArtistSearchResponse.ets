import { ArtistSearchResult } from "./ArtistSearchResult"

export class ArtistSearchResponse{
  result:ArtistSearchResult
  code:number

  constructor(result: ArtistSearchResult, code: number) {
    this.result = result
    this.code = code
  }

}