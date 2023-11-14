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

import { UserHeadView } from '@ohos/common';
import { UserStateView } from '@ohos/common';
import { MineOptView } from '@ohos/common';
import { MoreServerView } from '@ohos/common';

@Component
export struct MineView {
  build() {
    Column() {
      UserHeadView()
      UserStateView()
      MineOptView()
      MoreServerView()
    }.width('100%').height('100%')
    .justifyContent(FlexAlign.Start)
  }
}