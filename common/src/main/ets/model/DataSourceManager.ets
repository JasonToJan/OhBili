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

import { VideoDataSource } from './VideoDataSource';
import { ReplyDataSource } from './ReplyDataSource';
import { SearchDataSource } from './SearchDataSource';

export class DataSourceManager {
  public static initData() {
    globalThis.recommendSource = new VideoDataSource();
    globalThis.popularSource = new VideoDataSource();
    globalThis.relatedMapSource = new Map<string, VideoDataSource>();
    globalThis.replyMapSource = new Map<string, ReplyDataSource>();
    globalThis.replyDetailSource = new ReplyDataSource();
    globalThis.searchSource = new SearchDataSource();
  }

  public static getRecommendSource(): VideoDataSource {
    if (globalThis.recommendSource != undefined) {
      return globalThis.recommendSource;
    }
    return new VideoDataSource();
  }

  public static getPopularSource(): VideoDataSource {
    if (globalThis.popularSource != undefined) {
      return globalThis.popularSource;
    }
    return new VideoDataSource();
  }

  public static setRelatedMapSource(key: string) {
    if (globalThis.relatedMapSource != undefined) {
      globalThis.relatedMapSource.set(key, new VideoDataSource());
    }
  }

  public static deleteRelatedMapSource(key: string) {
    if (globalThis.relatedMapSource != undefined) {
      globalThis.relatedMapSource.delete(key);
    }
  }

  public static getRelatedSource(key?: string): VideoDataSource {
    if (key != null && globalThis.relatedMapSource != undefined &&
    globalThis.relatedMapSource.has(key)) {
      return globalThis.relatedMapSource.get(key);
    }
    return new VideoDataSource();
  }

  public static setReplyMapSource(key: string) {
    if (globalThis.replyMapSource != undefined) {
      globalThis.replyMapSource.set(key, new ReplyDataSource());
    }
  }

  public static deleteReplyMapSource(key: string) {
    if (globalThis.replyMapSource != undefined) {
      globalThis.replyMapSource.delete(key);
    }
  }

  public static getReplySource(key?: string): ReplyDataSource {
    if (key != null && globalThis.replyMapSource != undefined &&
    globalThis.replyMapSource.has(key)) {
      return globalThis.replyMapSource.get(key);
    }
    return new ReplyDataSource();
  }

  public static getReplyDetailSource(): ReplyDataSource {
    if (globalThis.replyDetailSource != undefined) {
      return globalThis.replyDetailSource;
    }
    return new ReplyDataSource();
  }

  public static getSearchSource(): SearchDataSource {
    if (globalThis.searchSource != undefined) {
      return globalThis.searchSource;
    }
    return new SearchDataSource();
  }
}