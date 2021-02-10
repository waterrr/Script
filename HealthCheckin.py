import requests
import json
import time

#BARK推送提醒服务，只支持IOS，如果为安卓，可以参考Server酱
def notice(message):
    #notice_url="https://api.day.app/YOUR_TOKEN/提示/用户登录成功/?sound=telegraph"
    url_notice = requests.get('https://api.day.app/YOUR_TOKEN/提示/'+ message +'/?sound=telegraph')
    return

#检查填报状态
def checktody(header_token):
    url_checkHealth = "https://xiaobei.yinghuaonline.com/prod-api/student/health/list?params=%7B%22beginCreateTime%22:%222021-01-01%22,%22endCreateTime%22:%222021-12-31%22%7D"
    response = session.get(url=url_checkHealth, headers={"User-Agent": "iPhone11,2(iOS/14.0.1) Uninview(Uninview/1.0.0) Weex/0.26.0 1125x2436","Host": "xiaobei.yinghuaonline.com", "Authorization": header_token})
    ret = json.loads(response.text)
    print(ret)
    return ret

#上报健康状态
def health(header_token):
    url_health = "https://xiaobei.yinghuaonline.com/prod-api/student/health"
    data = {
        "temperature": "36.3",                                  #对应温度
        "coordinates": "undefined-湖南省-长沙市-天心区",        #城市，按照格式填写，如 undefined-湖南省-长沙市-天心区
        "location": "110.9059434678819,28.39134195963542",      #对应定位经纬度，110.9059434678819,28.39134195963542
        "healthState": "1",                                     #健康状态，默认1（健康），无需修改
        "dangerousRegion": "2",                                 #是否风险地区，默认2（非中高风险地区），无需修改
        "dangerousRegionRemark": "",                            #危险标记，请保持留空，否则后果自负
        "contactSituation": "2",                                #接触疫情人员，默认2（无接触），无需修改
        "goOut": "1",                                           #是否外出，无需修改，默认1（无外出）
        "goOutRemark": "",                                      #外出标记，请保持留空，否则后果自负
        "remark": "无",                                         #备注，默认无
        "familySituation": "1"                                  #家庭成员健康状况，默认1（健康无异常）
    }
    response = session.post(url=url_health, data=json.dumps(data), headers={"User-Agent": "iPhone11,2(iOS/14.0.1) Uninview(Uninview/1.0.0) Weex/0.26.0 1125x2436","Host": "xiaobei.yinghuaonline.com", "Authorization": header_token, "Content-Type": "application/json"})
    ret = json.loads(response.text)
    print("登录成功：", ret.get('msg'))
    return ret

r = requests.get('https://xiaobei.yinghuaonline.com/prod-api/captchaImage')
showCode = r.json()["showCode"]
uuid = r.json()["uuid"]

session = requests.session()
url = "https://xiaobei.yinghuaonline.com/prod-api/login"
data = {
    "username": "43xxxxxxxxxxxxxxxx",     #修改为你登录的身份证
    "password": "MTIzNDU4Ng==",           #请把登录密码改为base64加密后的，例如密码为123456就填 MTIzNDU4Ng==
    "code": showCode,
    "uuid": uuid
}
headers = {
    "User-Agent": "iPhone11,2(iOS/14.0.1) Uninview(Uninview/1.0.0) Weex/0.26.0 1125x2436",
    "Content-Type": "application/json",
    "Host": "xiaobei.yinghuaonline.com"
}
response = session.post(url=url, data=json.dumps(data), headers=headers)
ret = json.loads(response.text)
print("登录成功：", ret.get('token'))
token = ret.get('token')
header_token ="Bearer "+token
url_checkHealth = "https://xiaobei.yinghuaonline.com/prod-api/student/health/checkHealth"
response = session.get(url=url_checkHealth, headers={"User-Agent": "iPhone11,2(iOS/14.0.1) Uninview(Uninview/1.0.0) Weex/0.26.0 1125x2436","Host": "xiaobei.yinghuaonline.com", "Authorization": header_token})
ret = json.loads(response.text)


if (time.strftime("%Y-%m-%d", time.localtime()) in json.dumps(checktody(header_token))) :
    print(time.strftime("%Y-%m-%d", time.localtime())+"已经填报")
    notice(time.strftime("%Y-%m-%d", time.localtime())+"小北学生健康状态已经填报")
else:
    print(time.strftime("%Y-%m-%d", time.localtime())+"没有填报!!!!")
    notice(time.strftime("%Y-%m-%d", time.localtime())+"小北学生健康状态没有填报!!!")
    if ("200" in json.dumps(health(header_token))):
        print("程序帮你已完成填报")
        notice(time.strftime("%Y-%m-%d", time.localtime())+"已自动完成填报")
