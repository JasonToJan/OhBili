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

import {
  BaseService,
  ServiceBuilder,
  GET,
  POST,
  DELETE,
  PUT,
  UrlPath,
  Body,
  BasePath,
  Response,
  Header,
  Headers,
  Query
} from '@ohos/retrofit';
import { ArchiveStatResponse } from '../model/response/ArchiveStatResponse';
import { CountryListResponse } from '../model/response/GenericCountryListResponse';
import { PlayUrlResponse } from '../model/response/PlayUrlResponse';
import { PopularResponse } from '../model/response/PopularResponse';
import { RankingResponse } from '../model/response/RankingResponse';
import { RecommendResponse } from '../model/response/RecommendResponse';
import { RegionResponse } from '../model/response/RegionResponse';
import { RelatedResponse } from '../model/response/RelatedResponse';
import { ReplyDetailResponse } from '../model/response/ReplyDetailResponse';
import { ReplyResponse } from '../model/response/ReplyResponse';
import { StringResponse } from '../model/response/Response';
import { SearchDefaultResponse } from '../model/response/SearchDefaultResponse';
import { SearchResponse } from '../model/response/SearchResponse';
import { SendSmsCaptchaResponse } from '../model/response/SendSmsCaptchaResponse';
import { SmsLoginResponse } from '../model/response/SmsLoginResponse';
import { CardInfoResponse } from '../model/response/UserCardInfoResponse';
import { VideoPartsResponse } from '../model/response/VideoPartsResponse';

@BasePath("/")
export class DataService extends BaseService {

  /**
   * 获取推荐视频
   * @param @Query('bvid') bvid 视频id
   */
  @GET("x/web-interface/archive/related")
  async getRelated(@Query('bvid') bvid: string):
    Promise<Response<RelatedResponse>> {
    return <Response<RelatedResponse>> {}
  };

  /**
   * 首页推荐视频
   * @param @Query('ps') ps 请求数量
   * @param @Query('fresh_idx') fresh_idx 刷新索引
   * @param @Query('feed_version') feed_version V3不带广告
   */
  @GET("x/web-interface/index/top/feed/rcmd")
  async getRecommend(@Query('ps') ps: number,
                     @Query('fresh_idx') fresh_idx: number,
                     @Query('feed_version') feed_version: string = "V3"):
    Promise<Response<RecommendResponse>> {
    return <Response<RecommendResponse>> {}
  };

  /**
   * 获取热门视频
   * @param @Query('ps') ps 请求数量
   * @param @Query('pn') pn 请求页码
   */
  @GET("x/web-interface/popular")
  async getPopular(@Query('ps') ps: number,
                   @Query('pn') pn: number):
    Promise<Response<PopularResponse>> {
    return <Response<PopularResponse>> {}
  };

  /**
   * 获取视频播放链接
   * @param @Query('bvid') bvid 视频id
   * @param @Query('cid') cid
   */
  @GET("x/player/playurl")
  async getPlayUrl(@Query('bvid') bvid: string,
                   @Query('cid') cid: number):
    Promise<Response<PlayUrlResponse>> {
    return <Response<PlayUrlResponse>> {}
  };

  /**
   * 获取视频评论
   * @param @Query('oid') oid bvid视频id
   * * @param @Query('ps') ps 每页项数
   * @param @Query('pn') pn 页码
   * @param @Query('type') type 评论类型
   * @param @Query('sort') sort 排序
   */
  @GET("x/v2/reply/main")
  async getReply(@Query('oid') oid: string,
                 @Query('ps') ps: number,
                 @Query('next') next: number,
                 @Query('type') type: number,
                 @Query('sort') sort: number):
    Promise<Response<ReplyResponse>> {
    return <Response<ReplyResponse>> {}
  };

  @GET("x/v2/reply/reply")
  async getReplyDetail(@Query('oid') oid: string,
                       @Query('root') root: number,
                       @Query('ps') ps: number,
                       @Query('pn') pn: number,
                       @Query('type') type: number):
    Promise<Response<ReplyDetailResponse>> {
    return <Response<ReplyDetailResponse>> {}
  };

  /**
   * 获取视频弹幕
   * @param @Query('oid') oid cid值
   * @param @Query('type') type 弹幕类型：1 视频弹幕
   * @param @Query('segment_index') segmentIndex 弹幕包索引
   */
  @GET("x/v2/dm/list/seg.so")
  @Headers({ 'Content-Type': 'application/octet-stream' })
  async getDmList(@Query('oid') oid: number,
                  @Query('type') type: number,
                  @Query('segment_index') segmentIndex: number):
    Promise<Response<ArrayBuffer>> {
    return <Response<ArrayBuffer>> {}
  };

  /**
   * 获取热搜榜
   */
  @GET("x/v2/search/trending/ranking")
  async getRanking():
    Promise<Response<RankingResponse>> {
    return <Response<RankingResponse>> {}
  };

  /**
   * 搜索请求
   * @param @Query('keyword') keyword 搜索关键字
   */
  @GET("x/web-interface/search/type")
  async getSearch(@Header('Cookie') cookie: string,
                  @Query('search_type') search_type: string,
                  @Query('keyword') keyword: string,
                  @Query('page') page: number):
    Promise<Response<SearchResponse>> {
    return <Response<SearchResponse>> {}
  };

  /**
   * 获取视频分P列表
   * @param @Query('bvid') bvid 视频id
   * @returns
   */
  @GET("x/player/pagelist")
  async getPageList(@Query('bvid') bvid: string):
    Promise<Response<VideoPartsResponse>> {
    return <Response<VideoPartsResponse>> {}
  };

  /**
   * 获取默认搜索
   * @returns
   */
  @GET("x/web-interface/search/default")
  async getSearchDefault():
    Promise<Response<SearchDefaultResponse>> {
    return <Response<SearchDefaultResponse>> {}
  };

  /**
   * 获取视频状态
   * @returns
   */
  @GET("x/web-interface/archive/stat")
  async getArchiveStat(@Query('bvid') bvid: string):
    Promise<Response<ArchiveStatResponse>> {
    return <Response<ArchiveStatResponse>> {}
  };

  /**
   * 获取视频简介
   * @returns
   */
  @GET("x/web-interface/archive/desc")
  async getArchiveDesc(@Query('bvid') bvid: string):
    Promise<Response<StringResponse>> {
    return <Response<StringResponse>> {}
  };

  /**
   * 获取支持的电话号码国际冠字码
   * @returns
   */
  @GET("web/generic/country/list")
  async getGenericCountryList():
    Promise<Response<CountryListResponse>>{
    return <Response<CountryListResponse>>{};
  }

  /**
   * 请求发送手机验证码
   * @param cid 国际冠字码
   * @param tel 手机号码
   * @param sessionId 登录标识
   * @param captchaToken 登录API token，来自于captcha
   * @param geeChallenge 极验 challenge， 来自于captcha
   * @param geeValidate 极验 result， 来自于captcha
   * @param geeSecCode 极验result+"|jordan"， 来自于captcha
   * @param channel 登录通道，如无特殊，则应为"bili"
   * @param buvid await StringUtil.generateBuvid()
   * @param localId await StringUtil.generateBuvid()
   * @param statistics {"appId":1,"platform":3,"version":"7.27.0","abtest":""}
   * @returns
   */
  @POST("x/passport-login/sms/send")
  async sendSmsCaptcha(
    @Query('cid') cid: number,
    @Query('tel') tel: number,
    @Query('login_session_id') sessionId: string,
    @Query('recaptcha_token') captchaToken: string,
    @Query('gee_challenge') geeChallenge: string,
    @Query('gee_validate') geeValidate: string,
    @Query('gee_seccode') geeSecCode: string,
    @Query('channel') channel: string,
    @Query('buvid') buvid: string,
    @Query('local_id') localId: string,
    @Query('statistics') statistics: string
  ): Promise<Response<SendSmsCaptchaResponse>>
  {
    return <Response<SendSmsCaptchaResponse>>{};
  }

  /**
   * 使用短信验证码登录
   * @param cid 国际冠字码
   * @param tel 电话号码
   * @param sessionId 登录标识，与sendSmsCaptcha一致
   * @param code 短信验证码
   * @param captchaKey 短信登录token，来源于SendSmsCaptchaResponse
   * @returns
   */
  @POST("x/passport-login/login/sms")
  async loginViaSmsCaptcha(
    @Query('cid') cid: number,
    @Query('tel') tel: number,
    @Query('login_session_id') sessionId: string,
    @Query('code') code: number,
    @Query('captcha_key') captchaKey: string
  ): Promise<Response<SmsLoginResponse>> {
    return <Response<SmsLoginResponse>>{};
  }

  /**
   * 获取用户卡片信息，包含用户粉丝数量及用户投稿数量
   * @param mid 用户mid
   * @param photo 是否需要获取用户主页头图，默认false
   * @returns
   */
  @GET("x/web-interface/card")
  async getUserCardInfo(@Query("mid") mid: number, @Query("photo") photo: boolean = false): Promise<Response<CardInfoResponse>> {
    return <Response<CardInfoResponse>>{};
  }
}
