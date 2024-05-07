import {createHash} from 'crypto'

export const apis = [
  {method: 'get', url: 'https://www.baidu.com', data: {}},
  /*{method: 'get', url: 'http://122.70.153.130:10090/sms/SendSMS.aspx'},
  {method: 'post', url: 'http://122.70.153.130:10090/cgi-bin/stable_token'},
  {method: 'post', url: 'http://122.70.153.130:10090/mattress/user/authorize'},
  {method: 'post', url: 'http://122.70.153.130:10090/v2/hLq4g7NUuv8cUKSMvov4M6/auth',
    data: () => {
      const timestamp = Date.now()
      const sign = createHash('sha256')
        .update("6Zb7l9tBHA7haWtyFpJjbA" + timestamp + "bwjtf2tHnb8cWGZVLg6ut")
        .digest('hex')
      return {
        "appkey": "6Zb7l9tBHA7haWtyFpJjbA",
        "timestamp": timestamp,
        "sign": sign}
    }
  },*/
]
