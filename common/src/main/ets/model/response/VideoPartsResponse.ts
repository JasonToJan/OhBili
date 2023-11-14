import { BaseResponse } from './Response';

export interface VideoPartsResponse extends BaseResponse<VideoParts[]> {}

export interface VideoParts {
  cid: number
  page: number
  from: string
  datumPart: string
  duration: number
  vid: string
  weblink: string
  dimension: Dimension
  firstFrame: string
}

export interface Dimension {
  width: number
  height: number
  rotate: number
}