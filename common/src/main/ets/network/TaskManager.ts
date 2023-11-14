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

import axios from '@ohos/retrofit';
import taskPool from '@ohos.taskpool';
import { Response, ServiceBuilder } from '@ohos/retrofit';
import { DataService } from './Api';
import { RelatedResponse } from '../model/response/RelatedResponse';
import { RecommendResponse } from '../model/response/RecommendResponse';
import { PopularResponse } from '../model/response/PopularResponse';
import { PlayUrlResponse } from '../model/response/PlayUrlResponse';
import { ReplyResponse } from '../model/response/ReplyResponse';
import { ApiConstants } from './ApiConstants';
import { RankingResponse } from '../model/response/RankingResponse';
import { SearchResponse } from '../model/response/SearchResponse';
import { VideoPartsResponse } from '../model/response/VideoPartsResponse';
import { SearchDefaultResponse } from '../model/response/SearchDefaultResponse';
import { ReplyDetailResponse } from '../model/response/ReplyDetailResponse';
import { ApiResponse, StringResponse } from '../model/response/Response';
import { ArchiveStatResponse } from '../model/response/ArchiveStatResponse';
import { CountryListResponse } from '../model/response/GenericCountryListResponse';
import { SendSmsCaptchaResponse } from '../model/response/SendSmsCaptchaResponse';
import { SmsLoginResponse } from '../model/response/SmsLoginResponse';
import { CardInfoResponse } from '../model/response/UserCardInfoResponse';

export class TaskManager {
  public static getInstance(): TaskManager {
    if (globalThis.taskManager == null) {
      globalThis.taskManager = new TaskManager();
    }
    return globalThis.taskManager;
  }

  async requestRelated(bvid: string): Promise<ApiResponse<RelatedResponse>> {
    var task = new taskPool.Task(requestRelatedTask, bvid);
    var response = await taskPool.execute(task) as ApiResponse<RelatedResponse>;
    return response
  }

  async requestRecommend(freshIdx: number): Promise<ApiResponse<RecommendResponse>> {
    var task = new taskPool.Task(requestRecommendTask, freshIdx);
    var response = await taskPool.execute(task) as ApiResponse<RecommendResponse>;
    return response
  }

  async requestPopular(pn: number): Promise<ApiResponse<PopularResponse>> {
    var task = new taskPool.Task(requestPopularTask, pn);
    var response = await taskPool.execute(task) as ApiResponse<PopularResponse>;
    return response
  }

  async requestPlayUrl(bvid: string, cid: number): Promise<ApiResponse<PlayUrlResponse>> {
    var task = new taskPool.Task(requestPlayUrlTask, bvid, cid);
    var response = await taskPool.execute(task) as ApiResponse<PlayUrlResponse>;
    return response;
  }

  async requestReply(oid: string, ps: number, next: number,
                                  type: number, sort: number): Promise<ApiResponse<ReplyResponse>> {
    var task = new taskPool.Task(requestReplyTask, oid, ps, next, type, sort);
    var response = await taskPool.execute(task) as ApiResponse<ReplyResponse>;
    return response;
  }

  async requestReplyDetail(oid: string, root: number, ps: number,
                                        pn: number, type: number): Promise<ApiResponse<ReplyDetailResponse>> {
    var task = new taskPool.Task(requestReplyDetailTask, oid, root, ps, pn, type);
    var response = await taskPool.execute(task) as ApiResponse<ReplyDetailResponse>;
    return response;
  }


  async requestDmList(oid: number, type: number, index: number): Promise<ApiResponse<Uint8Array>> {
    var task = new taskPool.Task(requestDmListTask, oid, type, index);
    var response = await taskPool.execute(task) as ApiResponse<Uint8Array>;
    return response;
  }

  async requestRanking(): Promise<ApiResponse<RankingResponse>> {
    var task = new taskPool.Task(requestRankingTask);
    var response = await taskPool.execute(task) as ApiResponse<RankingResponse>;
    return response;
  }

  async requestSearch(cookies: string, type: string,
                                   keyword: string, pn: number): Promise<ApiResponse<SearchResponse>> {
    var task = new taskPool.Task(requestSearchTask, cookies, type, keyword, pn);
    var response = await taskPool.execute(task) as ApiResponse<SearchResponse>;
    return response;
  }

  async requestPageList(bvid: string): Promise<ApiResponse<VideoPartsResponse>> {
    var task = new taskPool.Task(requestPageListTask, bvid);
    var response = await taskPool.execute(task) as ApiResponse<VideoPartsResponse>;
    return response;
  }

  async requestSearchDefault(): Promise<ApiResponse<SearchDefaultResponse>> {
    var task = new taskPool.Task(requestSearchDefaultTask);
    var response = await taskPool.execute(task) as ApiResponse<SearchDefaultResponse>;
    return response;
  }

  async requestArchiveStat(bvid: string): Promise<ApiResponse<ArchiveStatResponse>> {
    var task = new taskPool.Task(requestArchiveStatTask, bvid);
    var response = await taskPool.execute(task) as ApiResponse<ArchiveStatResponse>;
    return response;
  }

  async requestArchiveDesc(bvid: string): Promise<ApiResponse<StringResponse>> {
    var task = new taskPool.Task(requestArchiveDescTask, bvid);
    var response = await taskPool.execute(task) as ApiResponse<StringResponse>;
    return response;
  }

  async requestGenericCountryList(): Promise<ApiResponse<CountryListResponse>> {
    var task = new taskPool.Task(requestGenericCountryListTask);
    var response = await taskPool.execute(task) as ApiResponse<CountryListResponse>;
    return response;
  }

  async SendSmsCaptcha(
    cid: number, tel: number, sessionId: string, captchaToken: string,
    geeChallenge: string, geeValidate: string, geeSecCode: string, channel: string, buvid: string,
    localId: string, statistics: string): Promise<ApiResponse<SendSmsCaptchaResponse>> {
    var task = new taskPool.Task(SendSmsCaptchaTask, cid, tel, sessionId, captchaToken,
      geeChallenge, geeValidate, geeSecCode, channel, buvid, localId, statistics);
    var response = await taskPool.execute(task) as ApiResponse<SendSmsCaptchaResponse>;
    return response;
  }

  async loginViaSmsCaptcha(cid: number, tel: number, sessionId: string,
                           _code: number, captchaKey: string): Promise<ApiResponse<SmsLoginResponse>> {
    var task = new taskPool.Task(loginViaSmsTask, cid, tel, sessionId, _code, captchaKey);
    var response = await taskPool.execute(task) as ApiResponse<SmsLoginResponse>;
    return response;
  }

  async requestUserCardInfo(mid: number, photo: boolean = false): Promise<ApiResponse<CardInfoResponse>> {
    var task = new taskPool.Task(requestUserCardInfoTask, mid, photo);
    var response = await taskPool.execute(task) as ApiResponse<CardInfoResponse>;
    return response;
  }
}

async function requestRelatedTask(bvid: string): Promise<ApiResponse<RelatedResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: RelatedResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<RelatedResponse> = await dataService.getRelated(bvid);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestRecommendTask(freshIdx: number): Promise<ApiResponse<RecommendResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: RecommendResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<RecommendResponse> = await dataService.getRecommend(ApiConstants.itemNum, freshIdx);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
    console.error("OhBili err:" + err);
  }
  return new ApiResponse(result, code, message);
}

async function requestPopularTask(pn: number): Promise<ApiResponse<PopularResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: PopularResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<PopularResponse> = await dataService.getPopular(ApiConstants.itemNum, pn);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestPlayUrlTask(bvid: string, cid: number): Promise<ApiResponse<PlayUrlResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: PlayUrlResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<PlayUrlResponse> = await dataService.getPlayUrl(bvid, cid);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestReplyTask(oid: string, ps: number, next: number,
                                type: number, sort: number): Promise<ApiResponse<ReplyResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: ReplyResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<ReplyResponse> = await dataService.getReply(oid, ps, next, type, sort);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestReplyDetailTask(oid: string, root: number, ps: number,
                                      pn: number, type: number): Promise<ApiResponse<ReplyDetailResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: ReplyDetailResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<ReplyDetailResponse> = await dataService.getReplyDetail(oid, root, ps, pn, type);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}


async function requestDmListTask(oid: number, type: number, index: number): Promise<ApiResponse<Uint8Array>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: Uint8Array
  try {
    let res = await axios({
      method: "get",
      url: 'https://api.bilibili.com/x/v2/dm/list/seg.so',
      headers: { 'Content-Type': 'application/octet-stream' },
      params: {
        oid: oid,
        type: type,
        segment_index: index
      }
    });
    result = new Uint8Array(res.data);
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestRankingTask(): Promise<ApiResponse<RankingResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: RankingResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.appBase)
      .build(DataService);
    let resp: Response<RankingResponse> = await dataService.getRanking();
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestSearchTask(cookies: string, type: string,
                                 keyword: string, pn: number): Promise<ApiResponse<SearchResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: SearchResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<SearchResponse> = await dataService.getSearch(cookies, type, keyword, pn);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestPageListTask(bvid: string): Promise<ApiResponse<VideoPartsResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: VideoPartsResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<VideoPartsResponse> = await dataService.getPageList(bvid);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestSearchDefaultTask(): Promise<ApiResponse<SearchDefaultResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: SearchDefaultResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<SearchDefaultResponse> = await dataService.getSearchDefault();
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestArchiveStatTask(bvid: string): Promise<ApiResponse<ArchiveStatResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: ArchiveStatResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<ArchiveStatResponse> = await dataService.getArchiveStat(bvid);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestArchiveDescTask(bvid: string): Promise<ApiResponse<StringResponse>> {
  "use concurrent"
  let code: number = 0
  let message: string = ""
  let result: StringResponse
  try {
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<StringResponse> = await dataService.getArchiveDesc(bvid);
    code = resp.code();
    message = resp.message();
    result = resp.result;
  } catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function requestGenericCountryListTask(): Promise<ApiResponse<CountryListResponse>> {
  "use concurrent"
  let code: number = 0;
  let result: CountryListResponse;
  let message: string = "0";
  try{
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.loginBase)
      .build(DataService);
    let resp: Response<CountryListResponse> = await dataService.getGenericCountryList();
    code = resp.code();
    result = resp.result;
  }catch (err) {
    code = -1;
    message = err + "";
  }
  return new ApiResponse(result, code, message);
}

async function SendSmsCaptchaTask(
  cid: number, tel: number, sessionId: string, captchaToken: string,
  geeChallenge: string, geeValidate: string, geeSecCode: string, channel: string, buvid: string,
  localId: string, statistics: string
): Promise<ApiResponse<SendSmsCaptchaResponse>> {
  "use concurrent"
  let code: number = 0;
  let result: SendSmsCaptchaResponse;
  let message: string = "";
  try{
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.loginBase)
      .build(DataService);
    let resp: Response<SendSmsCaptchaResponse> = await dataService.sendSmsCaptcha(
      cid, tel, sessionId, captchaToken, geeChallenge, geeValidate, geeSecCode, channel, buvid,
      localId, statistics);
    code = resp.code();
    result = resp.result;
  }catch(err){
    code = -1;
    message = err+"";
  }
  return new ApiResponse(result, code, message);
}

async function loginViaSmsTask(
  cid: number, tel: number, sessionId: string,
  _code: number, captchaKey: string
): Promise<ApiResponse<SmsLoginResponse>> {
  "use concurrent"
  let code: number = 0;
  let result: SmsLoginResponse;
  let message: string = "";
  try{
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.loginBase)
      .build(DataService);
    let resp: Response<SmsLoginResponse> = await dataService.loginViaSmsCaptcha(
      cid, tel, sessionId, _code, captchaKey
    );
    code = resp.code();
    result = resp.result;
  }catch (err) {
    code = -1;
    message = err+"";
  }
  return new ApiResponse(result, code, message);
}

async function requestUserCardInfoTask(mid: number, photo: boolean = false): Promise<ApiResponse<CardInfoResponse>> {
  "use concurrent"
  let code: number = 0;
  let result: CardInfoResponse;
  let message: string = "";
  try{
    let dataService = new ServiceBuilder()
      .setEndpoint(ApiConstants.apiBase)
      .build(DataService);
    let resp: Response<CardInfoResponse> = await dataService.getUserCardInfo(mid, photo);
    code = resp.code();
    result = resp.result;
  }catch (err) {
    code = -1;
    message = err+"";
  }
  return new ApiResponse(result, code, message);
}