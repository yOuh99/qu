import { SongSearchResult } from "./SongSearchResult"
import { SongSearchTrp } from "./SongSearchTrp"

export class SongSearchResponse{
  result:SongSearchResult
  code:number
  trp:SongSearchTrp

  constructor(result: SongSearchResult, code: number, trp: SongSearchTrp) {
    this.result = result
    this.code = code
    this.trp = trp
  }

}