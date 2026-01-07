import { PlaylistSearchResult } from "./PlaylistSearchResult"

export  class PlaylistSearchResponse{
  result:PlaylistSearchResult
  code:number

  constructor(result:PlaylistSearchResult, code: number) {
    this.result = result
    this.code = code
  }
}