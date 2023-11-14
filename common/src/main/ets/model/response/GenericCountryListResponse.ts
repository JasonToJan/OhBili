import {BaseResponse} from './Response';

export interface CountryListResponse extends BaseResponse<CountryList> {}

export interface CountryList {
  common: CountryItem[],
  others: CountryItem[]
}

export interface CountryItem {
  id: number;
  cname: string;
  country_id: string;
}