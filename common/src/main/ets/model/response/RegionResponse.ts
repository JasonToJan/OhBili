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

import { BaseResponse, BaseVideo } from './Response';

export interface RegionResponse extends BaseResponse<Region> {

}

export interface Region {
    page: RegionPage
    archives: RegionArchives[]
}

export interface RegionPage {
    num: number
    size: number
    count: number
}

export interface RegionArchives extends BaseVideo {
    aid: number
    videos: number
    tid: number
    tname: string
}