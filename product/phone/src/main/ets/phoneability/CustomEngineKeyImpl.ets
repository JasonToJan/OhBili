/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { EngineKeyFactories, EngineKeyInterface, RequestOption } from '@ohos/imageknife'

export class CustomEngineKeyImpl implements EngineKeyInterface {
  redefineUrl: (loadSrc: string) => string;
  addOtherInfo: string = "Version=1.0.0;"

  constructor() {
    this.redefineUrl = this.urlNeedClearToken.bind(this);
  }
  // request只读
  generateMemoryCacheKey(loadSrc: string, size: string, transformed: string, dontAnimate: boolean): string {
    return EngineKeyFactories.createMemoryCacheKey(loadSrc, size, transformed, dontAnimate, this.redefineUrl, this.addOtherInfo);
  }

  generateTransformedDiskCacheKey(loadSrc: string, size: string, transformed: string, dontAnimate: boolean): string {
    return EngineKeyFactories.createTransformedDiskCacheKey(loadSrc, size, transformed, dontAnimate, this.redefineUrl, this.addOtherInfo);
  }

  generateOriginalDiskCacheKey(loadSrc: string): string {
    return EngineKeyFactories.createOriginalDiskCacheKey(loadSrc, this.redefineUrl, this.addOtherInfo);
  }


  // 需求场景: 请求图片可能 请求中存在token需要清除， 可以把输入的url清除token后作为key的一部分，这样token发生变化也能命中缓存。
  urlNeedClearToken(url: string): string {
    if (this.isHttpRequest(url)) {
      return this.clearToken(url)
    } else {
      return url;
    }
  }


  isHttpRequest(loadSrc: string) {
    if (typeof loadSrc == "string" && loadSrc.toLowerCase().startsWith("http")) {
      return true;
    }
    return false;
  }

  // 清除url里面中携带的token
  clearToken(url: string): string {
    let retUrl = url.replace(this.findTokenParam(url), "")
    return retUrl;
  }

  // 网络图片加载 可能因为Token问题导致缓存失效
  findTokenParam(url: string): string {
    let tokenParam = "";
    let tokenKeyIndex = url.indexOf("?token=") >= 0 ? url.indexOf("?token=") : url.indexOf("&token=");
    if (tokenKeyIndex != -1) {
      let nextAndIndex = url.indexOf("&", tokenKeyIndex + 1);
      if (nextAndIndex != -1) {
        tokenParam = url.substring(tokenKeyIndex + 1, nextAndIndex + 1);
      } else {
        tokenParam = url.substring(tokenKeyIndex);
      }
    }
    return tokenParam;
  }
}
