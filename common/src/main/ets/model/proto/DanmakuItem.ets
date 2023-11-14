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

export class DanmakuItem {
  DanmakuType: number = 0;
  alphaDuration: number = 0;
  beginAlpha: number = 0;
  beginX: number = 0;
  beginY: number = 0;
  duration: number = 0;
  endAlpha: number = 0;
  endX: number = 0;
  endY: number = 0;
  index: number = 0;
  isQuadraticEaseOut: boolean = false;
  rotationY: number = 0;
  rotationZ: number = 0;
  text: string = "";
  textColor: number = 0;
  textShadowColor: number = 0;
  textSize: number = 0;
  time: number = 0;
  timeOffset: number = 0;
  translationDuration: number = 0;
  translationStartDelay: number = 0;
}