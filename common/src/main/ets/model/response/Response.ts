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

export class ApiResponse<T> {
    code: number = 0
    message: string = ""
    result: T

    constructor(result?: T, code?: number , message?: string) {
        if (result != null) {
            this.result = result
        }
        if (code != undefined) {
            this.code = code
        }
        if (message != null) {
            this.message = message
        }
    }
}

export interface BaseResponse<T> {
    data: T
    message?: string
    code: number
    ttl: number
}

export interface EmptyResponse extends BaseResponse<any> {

}

export interface StringResponse extends BaseResponse<string> {

}

export interface BaseVideo {
    cid: number
    bvid?: string
    title?: string
    desc?: string
    pic?: string
    pubdate: number
    duration: string | number
    owner?: Owner
    stat?: Stat
}

export interface Stat {
    view: number
    like: number
    danmaku: number
    reply: number
    favorite: number
    coin: number
    share: number
}

export interface Owner {
    mid: number
    name?: string
    face?: string
}

export function EmptyStat(): Stat {
    let stat: Stat = {
        view: 0,
        like: 0,
        danmaku: 0,
        reply: 0,
        favorite: 0,
        coin: 0,
        share: 0
    }
    return stat;
}

export function EmptyBaseVideo(bvid: string): BaseVideo {
    let owner: Owner = {
        mid: 0,
        name: "",
        face: ""
    }
    let stat: Stat = EmptyStat()
    let baseVideo: BaseVideo = {
        cid: 0,
        bvid: bvid,
        title: "",
        desc: "",
        pic: "",
        pubdate: 0,
        duration: 0,
        owner: owner,
        stat: stat
    };
    return baseVideo;
}