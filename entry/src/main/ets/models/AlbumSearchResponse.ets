import { AlbumSearchResult } from "./AlbumSearchResult"

export class AlbumSearchResponse{
  result:AlbumSearchResult
  code:number

  constructor(result: AlbumSearchResult, code: number) {
    this.result = result
    this.code = code
  }

}