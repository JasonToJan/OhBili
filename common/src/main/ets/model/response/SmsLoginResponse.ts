import {BaseResponse} from './Response';

export interface SmsLoginResponse extends BaseResponse<SmsLogin> {};

export interface SmsLogin {
  mid: string;
  expires_in: string;
  access_token: string;
  refresh_token: string;
  cookie_info: string[];
}