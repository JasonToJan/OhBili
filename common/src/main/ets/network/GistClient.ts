import axios from '@ohos/retrofit'
import { GistConfig, GistData } from './GistTypes'

const version = "1.0" // process.env.version

export class HTTPError extends Error {
  status: number
  statusText: string
  data: GistData
  config: GistConfig

  constructor(status: number, statusText: string, data: GistData, config: GistConfig) {
    super(`status: ${status}
statusText: ${statusText}
data: ${JSON.stringify(data, null, 2)}
config: ${JSON.stringify(config, null, 2)}`)
    this.status = status
    this.statusText = statusText
    this.data = data
    this.config = config
  }
}

class GistClient {
  token: string
  server: string
  //_axios: AxiosInstance
  _axios: any
  userAgentHeader: string

  static apiServer = 'https://gitee.com/api'

  constructor(
    token: string,
    userAgentHeader = `gitee-js/v${version}`
  ) {
    this.token = token
    this.server = GistClient.apiServer
    this.userAgentHeader = userAgentHeader
    this._axios = axios.create()
    const request = this._axios.request.bind(this._axios)
    this._axios.request = (config) => {
      try {
        return request(config)
      } catch (e) {
        if (e.response) {
          throw new HTTPError(e.response.status, e.response.statusText, e.response.data, e.response.config)
        } else {
          throw e
        }
      }
    }
  }

  request(config: GistConfig) {
    let uri = config.url.startsWith('http')
      ? config.url
      : this.server + config.url
    const methods = ['get', 'delete']
    if (methods.includes(config.method)) {
      const sep = uri.includes('?') ? '&' : '?'
      const tokenQuery = `access_token=${this.token}`
      uri = uri + sep + tokenQuery
    } else {
      if (!config.data) {
        config.data = {}
      }
      config.data.access_token = this.token
    }
    return this._axios.request({
      ...config,
      url: uri.toString(),
      headers: this._patchHeaders(config.headers)
    })
  }

  async get(url: string, config = {}): Promise<any> {
    return this.request({ ...config, method: 'get', url })
  }

  async delete(url: string, config = {}): Promise<any> {
    return this.request({ ...config, method: 'delete', url })
  }

  async post(url: string, data = undefined, config = {}): Promise<any> {
    return this.request({ ...config, method: 'post', url, data })
  }

  async put(url: string, data = undefined, config = {}): Promise<any> {
    return this.request({ ...config, method: 'put', url, data })
  }

  async patch(url: string, data = undefined, config = {}): Promise<any> {
    return this.request({ ...config, method: 'patch', url, data })
  }

  _patchHeaders(headers: GistData = {}) {
    return {
      'Content-Type': 'application/json',
      ...this._authHeader(),
      'X-User-Agent': this.userAgentHeader,
      ...headers
    }
  }

  _authHeader() {
    return {}
  }
}

export default GistClient