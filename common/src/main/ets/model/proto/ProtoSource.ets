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

import { IDataSource } from '@ohos/danmakuflamemaster'
//import { bilibili } from './danmaku';
import { DanmakuItem } from './DanmakuItem';
import { Long } from '@ohos/protobufjs';
import { ResUtils } from '../../utils/ResUtils';

export class ProtoSource implements IDataSource<[]> {
  private mArray: DanmakuItem[] = [];

  //constructor(reply: bilibili.community.service.dm.v1.DmSegMobileReply) {
  constructor(reply: any) {
    if (reply != null && reply.elems.length > 0) {
      reply.elems.forEach((elem) => {
        var item = new DanmakuItem();
        item.index = elem.id as Long ? (elem.id as Long).low : elem.id as number;
        item.DanmakuType = elem.mode;
        item.textSize = elem.fontsize;
        item.textColor = elem.color;
        item.textShadowColor = ResUtils.getShadowColor(elem.color);
        item.text = elem.content;
        item.time = elem.progress;
        if (elem.mode == 7) {
          item.alphaDuration = 4500;
          item.beginAlpha = 249;
          item.beginX = 1;
          item.beginY = 500;
          item.duration = 4500;
          item.endAlpha = 25;
          item.endX = 40;
          item.endY = 268;
          item.rotationY = 360;
          item.rotationZ = 360;
          item.translationDuration = 500;
        }
        this.mArray.push(item);
      });
    }
  }

  public release() {
    this.mArray = null;
  }

  public data() {
    return this.mArray
  }
}