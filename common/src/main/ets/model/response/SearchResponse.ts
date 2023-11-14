/**
 * Copyright (c) 2023 Wathinst <wxz@xkzhineng.com>
 * OhBili is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 * http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

import { BaseResponse, BaseVideo, Stat, Owner } from './Response';

export interface SearchResponse extends BaseResponse<Search> {}

export interface Search {
  page: number
  pagesize: number
  numResults: number
  numPages: number
  result: SearchVideo[]
}

export interface SearchVideo {
  bvid: string
  title: string
  description: string
  pic: string
  pubdate: number
  play: number
  like: number
  danmaku: number
  video_review: number
  favorites: number
  duration: string
  author: string
  mid: number
  upic: string
}

export function SearchVideoToBaseVideo(searchVideo: SearchVideo): BaseVideo {
  let owner: Owner = {
    mid: searchVideo.mid,
    name: searchVideo.author,
    face: searchVideo.upic
  }
  let stat: Stat = {
    view: searchVideo.play,
    like: searchVideo.like,
    danmaku: searchVideo.danmaku,
    reply: undefined,
    favorite: undefined,
    coin: undefined,
    share: undefined
  }
  let baseVideo: BaseVideo = {
    cid: 0,
    bvid: searchVideo.bvid,
    title: searchVideo.title,
    desc: searchVideo.description,
    pic: "https:" + searchVideo.pic,
    pubdate: searchVideo.pubdate,
    duration: searchVideo.duration,
    owner: owner,
    stat: stat
  };
  return baseVideo;
}


