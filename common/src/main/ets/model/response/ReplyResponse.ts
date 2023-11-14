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

import { BaseResponse } from './Response';

export interface ReplyResponse extends BaseResponse<Reply> {

}

export interface Reply {
    cursor: ReplyCursor
    replies?: ReplyItem[]
}

export interface ReplyCursor {
    is_begin: boolean
    prev: number
    next: number
    is_end: boolean
    mode: number
    mode_text: string
    all_count: number
}

export interface ReplyItem {
    rpid: number
    mid: number
    count: number
    rcount: number
    like: number
    ctime: number
    member: ReplyItemMember
    content: MemberContent
    replies?: ReplyItem[]
}

export interface ReplyItemMember {
    uname: string
    mid: string
    avatar: string
    level_info: MemberLevel
    vip: MemberVip
}

export interface MemberLevel {
    current_level: number
}

export interface MemberVip {
    vipType: number
    vipStatus: number
}

export interface MemberContent {
    message: string
    max_line: number
}