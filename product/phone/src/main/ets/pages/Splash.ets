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

import router from '@ohos.router';
import bundleManager from '@ohos.bundle.bundleManager';
import util from '@ohos.util';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { WindowManager } from '@ohos/common';
import { ApiManager } from '@ohos/common';
import { BLog } from '@ohos/common';

storageInit();

@Entry
@Component
struct Splash {
  @StorageLink('appLogDebug') appLogDebug: string = '0';
  @StorageLink('appUuid') appUuid: string = 'undefined';

  aboutToAppear() {
    let list: Array<Permissions> = [
      'ohos.permission.MEDIA_LOCATION',
      'ohos.permission.READ_MEDIA'];
    let atManager = abilityAccessCtrl.createAtManager();

    BLog.setDebug(this.appLogDebug == '1');

    if (this.appUuid == 'undefined') {
      this.appUuid = util.generateRandomUUID();
    }
    BLog.i("appUuid: " + this.appUuid);

    this.checkAccessToken(list[0]).then((grantStatus) => {
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        this.initTask();
        setTimeout(() => {
          router.replaceUrl({ url: "pages/Index" });
        }, 1000);
      } else {
        atManager.requestPermissionsFromUser(globalThis.appContext, list, (err, result) => {
          if (err) {
            BLog.e("dodo requestPermissionsFromUserError:" + JSON.stringify(err));
          } else {
            this.initTask();
            router.replaceUrl({ url: "pages/Index" });
          }
        })
      }
    });
  }

  async initTask() {
    ApiManager.getInstance().requestRecommend(1, true);
    ApiManager.getInstance().requestPopular(1);
  }

  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus;

    // 获取应用程序的accessTokenID
    let tokenId: number;
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager
        .getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      BLog.e(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (err) {
      BLog.e(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    }

    return grantStatus;
  }

  onPageShow() {
    WindowManager.setLayoutFullScreen(false, WindowManager.COLOR_WHITE,
      WindowManager.COLOR_BLACK, WindowManager.COLOR_WHITE, WindowManager.COLOR_BLACK);
  }

  build() {
    Column() {
      Image($r('app.media.bilibili'))
        .width('100%')
        .height('100%')
    }.width('100%').height('100%')
  }
}

function storageInit() {
  PersistentStorage.PersistProp('checkUpdates', '1');
  PersistentStorage.PersistProp('showDefaultKeyword', '1');
  PersistentStorage.PersistProp('showTopSearch', '1');

  PersistentStorage.PersistProp('openDanmu', '1');
  PersistentStorage.PersistProp('danmuFontSize', '1.0X');
  PersistentStorage.PersistProp('danmuOpacity', '100%');

  PersistentStorage.PersistProp('pagePlayOver', '1');
  PersistentStorage.PersistProp('videoQuality', '1080P');
  PersistentStorage.PersistProp('playSpeed', '1.0X');

  PersistentStorage.PersistProp('appLogDebug', '0');
  PersistentStorage.PersistProp('appUuid', 'undefined');
}