import { Lrc } from "./Lrc"

export class LrcSearchResponse{
  lrc:Lrc
  code:number

  constructor(lrc: Lrc, code: number) {
    this.lrc = lrc
    this.code = code
  }

}