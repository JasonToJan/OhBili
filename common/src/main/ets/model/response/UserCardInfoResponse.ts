import {BaseResponse} from './Response';

export interface CardInfoResponse extends BaseResponse<CardInfo> {};

export interface CardInfo {
  following: boolean;
  archive_count: number;
  article_count: number;
  follower: number;
  likeNum: number;
}