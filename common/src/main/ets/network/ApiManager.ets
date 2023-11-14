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

import protobuf from '@ohos/protobufjs'
import { PlayUrlResponse } from '../model/response/PlayUrlResponse';
import { ProtoSource } from '../model/proto/ProtoSource'
import { RankingResponse } from '../model/response/RankingResponse';
import { VideoPartsResponse } from '../model/response/VideoPartsResponse';
import { DataSourceManager } from '../model/DataSourceManager';
import { TaskManager } from './TaskManager';
import { BLog } from '../utils/BLog';
import { ReplyCursor } from '../model/response/ReplyResponse';
import { ReplyPage } from '../model/response/ReplyDetailResponse';
import { ArchiveStatResponse } from '../model/response/ArchiveStatResponse';
import { ApiConstants } from './ApiConstants';
import { CountryList, CountryListResponse } from '../model/response/GenericCountryListResponse';
import { SmsLoginResponse } from '../model/response/SmsLoginResponse';
import { SendSmsCaptchaResponse } from '../model/response/SendSmsCaptchaResponse';
import { CardInfoResponse } from '../model/response/UserCardInfoResponse';

export class ApiManager {
  private constructor() {
    DataSourceManager.initData();
  }

  public static getInstance(): ApiManager {
    if (globalThis.instance == null) {
      globalThis.instance = new ApiManager();
    }
    return globalThis.instance;
  }

  async requestRelated(bvid: string): Promise<boolean> {
    BLog.d(`requestRelated bvid: ${bvid}`);
    var response = await TaskManager.getInstance().requestRelated(bvid);
    if (response.code == -1 ) {
      BLog.e("requestRelated err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestRelated result: " + JSON.stringify(response.result));
      DataSourceManager.getRelatedSource(bvid).addAllData(response.result.data);
    }
    return response.code != -1;
  }

  async requestRecommend(freshIdx: number, isFresh: boolean): Promise<boolean> {
    BLog.d(`requestRecommend freshIdx: ${freshIdx}, isFresh: ${isFresh}`);
    var response = await TaskManager.getInstance().requestRecommend(freshIdx);
    if (response.code == -1 ) {
      BLog.e("requestRecommend err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestRecommend result: " + JSON.stringify(response.result));
      if (isFresh) {
        DataSourceManager.getRecommendSource().setData(response.result.data.item);
      } else {
        DataSourceManager.getRecommendSource().addAllData(response.result.data.item);
      }
    }
    return response.code != -1;
  }

  async requestPopular(pn: number): Promise<boolean> {
    BLog.d(`requestPopular pn: ${pn}`);
    var response = await TaskManager.getInstance().requestPopular(pn);
    if (response.code == -1 ) {
      BLog.e("requestPopular err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestPopular result: " + JSON.stringify(response.result));
      if (pn == 1) {
        DataSourceManager.getPopularSource().setData(response.result.data.list);
      } else {
        DataSourceManager.getPopularSource().addAllData(response.result.data.list);
      }
    }
    return response.code != -1;
  }

  async requestPlayUrl(bvid: string, cid: number): Promise<PlayUrlResponse> {
    BLog.d(`requestPlayUrl bvid: ${bvid}, cid: ${cid}`);
    var response = await TaskManager.getInstance().requestPlayUrl(bvid, cid);
    if (response.code == -1 ) {
      BLog.e("requestPlayUrl err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestPlayUrl result: " + JSON.stringify(response.result));
    }
    return response.result
  }

  async requestReply(oid: string, next: number,
                      type: number, sort: number): Promise<ReplyCursor> {
    BLog.d(`requestReply oid: ${oid}, next: ${next}, type: ${type}, sort: ${sort}`);
    var response = await TaskManager.getInstance().requestReply(oid, ApiConstants.itemNum, next, type, sort);
    if (response.code == -1 ) {
      BLog.e("requestReply err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestReply result: " + JSON.stringify(response.result));
      if (next == 0) {
        DataSourceManager.getReplySource(oid).setData(response.result.data.replies);
      } else {
        DataSourceManager.getReplySource(oid).addAllData(response.result.data.replies);
      }
      return response.result.data.cursor;
    }
    return null;
  }

  async requestReplyDetail(oid: string, root: number, pn: number,
                      type: number): Promise<ReplyPage> {
    BLog.d(`requestReplyDetail oid: ${oid}, root: ${root}, pn: ${pn}, type: ${type}`);
    var response = await TaskManager.getInstance().requestReplyDetail(oid, root, ApiConstants.itemNum, pn, type);
    if (response.code == -1 ) {
      BLog.e("requestReplyDetail err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestReplyDetail result: " + JSON.stringify(response.result));
      DataSourceManager.getReplyDetailSource().addAllData(response.result.data.replies);
      return response.result.data.page;
    }
    return null;
  }

  async requestDmList(oid: number, type: number, index: number): Promise<ProtoSource> {
    BLog.d(`requestDmList oid: ${oid}, type: ${type}, index: ${index}`);
    var response = await TaskManager.getInstance().requestDmList(oid, type, index);
    if (response.code == -1 ) {
      BLog.e("requestDmList err=" + response.message);
    }
    BLog.i('requestDmList Result byteLength:' + response.result.byteLength);
    var builder = await protobuf.loadProtoFile('danmaku.proto', null, null, globalThis.resourceMana);
    // @ts-ignore
    var DmSegMobileReply = builder.build("bilibili.community.service.dm.v1.DmSegMobileReply");
    var reply = DmSegMobileReply.decode(response.result);
    BLog.i('requestDmList Result elems length:' + reply.elems.length);
    return new ProtoSource(reply);
  }

  async requestRanking(): Promise<RankingResponse> {
    BLog.d(`requestRanking`);
    var response = await TaskManager.getInstance().requestRanking();
    if (response.code == -1 ) {
      BLog.e("requestRanking err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestRanking result: " + JSON.stringify(response.result));
    }
    return response.result;
  }

  async requestSearch(keyword: string, pn: number): Promise<boolean> {
    BLog.d(`requestSearch keyword: ${keyword}, pn: ${pn}`);
    let cookies = 'b_ut=7;i-wanna-go-back=-1;b_nut=1689340641;buvid3=D1834A0C-8619-E71F-A594-05F6B806551041895infoc;innersign=0';
    var response = await TaskManager.getInstance().requestSearch(cookies, "video", keyword, pn);
    if (response.code == -1 ) {
      BLog.e("requestSearch err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestSearch result: " + JSON.stringify(response.result));
      if (pn == 1) {
        DataSourceManager.getSearchSource().setData(response.result.data.result);
      } else {
        DataSourceManager.getSearchSource().addAllData(response.result.data.result);
      }
    }
    return response != null;
  }

  async requestPageList(bvid: string): Promise<VideoPartsResponse> {
    BLog.d(`requestPageList bvid: ${bvid}`);
    var response = await TaskManager.getInstance().requestPageList(bvid);
    if (response.code == -1 ) {
      BLog.e("requestPageList err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestPageList result: " + JSON.stringify(response.result));
    }
    return response.result;
  }

  async requestSearchDefault(): Promise<string> {
    BLog.d("requestSearchDefault");
    var response = await TaskManager.getInstance().requestSearchDefault();
    if (response.code == -1 ) {
      BLog.e("requestSearchDefault err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestSearchDefault result: " + JSON.stringify(response.result));
      return response.result.data.name;
    }
    return "OpenHarmony";
  }

  async requestArchiveStat(bvid: string): Promise<ArchiveStatResponse> {
    BLog.d(`requestArchiveStat bvid: ${bvid}`);
    var response = await TaskManager.getInstance().requestArchiveStat(bvid);
    if (response.code == -1 ) {
      BLog.e("requestArchiveStat err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestArchiveStat result: " + JSON.stringify(response.result));
    }
    return response.result;
  }

  async requestArchiveDesc(bvid: string): Promise<string> {
    BLog.d(`requestArchiveDesc bvid: ${bvid}`);
    var response = await TaskManager.getInstance().requestArchiveDesc(bvid);
    if (response.code == -1 ) {
      BLog.e("requestArchiveDesc err=" + response.message);
    }
    if (response.result != null) {
      BLog.d("requestArchiveDesc result: " + JSON.stringify(response.result));
      return response.result.data;
    }
    return "";
  }

  async requestGenericCountryList(): Promise<CountryList> {
    BLog.d("requestGenericCountryList");
    var response = await TaskManager.getInstance().requestGenericCountryList();
    if(response.code == -1){
      BLog.e("requestGenericCountryList err=" + response.message);
    }
    if(response.result != null) {
      BLog.d("requestGenericCountryList result:" + JSON.stringify(response.result));
      return response.result.data;
    }
    return {
      common: [],
      others: []
    };
  }

  async sendSmsCaptcha(
    cid: number, tel: number, sessionId: string, captchaToken: string,
    geeChallenge: string, geeValidate: string, geeSecCode: string, channel: string, buvid: string,
    localId: string, statistics: string
  ): Promise<SendSmsCaptchaResponse> {
    BLog.d("sendSmsCaptcha");
    var response = await TaskManager.getInstance().SendSmsCaptcha(
      cid,tel,sessionId,captchaToken,geeChallenge,geeValidate,geeSecCode,channel,buvid,localId,statistics
    );
    if(response.code == -1) {
      BLog.e("sendSmsCaptcha err=" + response.message);
    }
    if(response.result != null) {
      BLog.d("sendSmsCaptcha result:" + JSON.stringify(response.result));
    }
    return response.result;
  }

  async loginViaSmsCaptcha(cid: number, tel: number, sessionId: string,
                           _code: number, captchaKey: string): Promise<SmsLoginResponse> {
    BLog.d("loginViaSmsCaptcha");
    var response = await TaskManager.getInstance().loginViaSmsCaptcha(cid, tel, sessionId,
    _code, captchaKey);
    if(response.code == -1){
      BLog.e("loginViaSmsCaptcha err=" + response.message);
    }
    if(response.result !== null) {
      BLog.d("loginViaSmsCaptcha result:" + JSON.stringify(response.result));
    }
    return response.result;
  }

  async requestUserCardInfo(mid: number, photo: boolean = false): Promise<CardInfoResponse> {
    BLog.d("requestUserCardInfo");
    var response = await TaskManager.getInstance().requestUserCardInfo(mid, photo);
    if(response.code == -1) {
      BLog.e("requestUserCardInfo err=" + response.message);
    }
    if(response.result !== null) {
      BLog.d("requestUserCardInfo result:" + JSON.stringify(response.result));
    }
    return response.result;
  }
}