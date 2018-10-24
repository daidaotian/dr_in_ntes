# -*- coding: utf-8 -*-
import hashlib
import web
import lxml
import time
import os
import random
import urllib2,json
from lxml import etree




class WeixinInterface:
    def __init__(self):
        self.app_root = os.path.dirname(__file__)
        self.templates_root = os.path.join(self.app_root, 'templates')
        self.render = web.template.render(self.templates_root)
 
    def GET(self):
        #获取输入参数
        data = web.input()
        signature=data.signature
        timestamp=data.timestamp
        nonce=data.nonce
        echostr=data.echostr
        #自己的token
        token="CSDR123456DR" #这里改写你在微信公众平台里输入的token
        #字典序排序
        list=[token,timestamp,nonce]
        list.sort()
        sha1=hashlib.sha1()
        map(sha1.update,list)
        hashcode=sha1.hexdigest()
        #sha1加密算法        
 
        #如果是来自微信的请求，则回复echostr
        if hashcode == signature:
            return echostr
    def POST(self): 

        
        str_xml = web.data() #获得post来的数据
        xml = etree.fromstring(str_xml)#进行XML解析,提取html页面数据
        content=xml.find("Content").text#获得用户所输入的内容
        msgType=xml.find("MsgType").text
        fromUser=xml.find("FromUserName").text
        toUser=xml.find("ToUserName").text
		
        #关键词
        key_result=self.Key_Word(content)
        if key_result != 1:
            return self.render.reply_text(fromUser,toUser,int(time.time()),u"--"+key_result+"\n--little tail--")
        
        #翻译
        Nword = self.youdao(content)
        return self.render.reply_text(fromUser,toUser,int(time.time()),u"功能正在开发中，您刚才说的是："+Nword+"\n--little tail--")

    def Key_Word(self,word):
        xiaohua=[]
        xiaohua.append("笑话1")
        xiaohua.append("笑话2")
        xiaohua.append("笑话3")
        xiaohua.append("笑话4")
        xiaohua.append("笑话5")
        if  '笑话' in word:
           # return random.randint(0,len(xiaohua)-1)
        	return random.randint(0,5)
        else:
            return 1
    def youdao(self,word):
        return word
    	
        qword = urllib2.quote(word)
        baseurl =r'http://fanyi.youdao.com/openapi.do?keyfrom=<WEIXIN>&key=<4ad18abfab44f748>&type=data&doctype=json&version=1.1&q='
        url = baseurl+qword
        resp = urllib2.urlopen(url)
        fanyi = json.loads(resp.read())
        if fanyi['errorCode'] == 0:        
            if 'basic' in fanyi.keys():
                trans = u'%s:\n%s\n%s\n网络释义：\n%s'%(fanyi['query'],''.join(fanyi['translation']),' '.join(fanyi['basic']['explains']),''.join(fanyi['web'][0]['value']))
                return trans
            else:
                trans =u'%s:\n基本翻译:%s\n'%(fanyi['query'],''.join(fanyi['translation']))        
                return trans
        elif fanyi['errorCode'] == 20:
            return u'对不起，要翻译的文本过长'
        elif fanyi['errorCode'] == 30:
            return u'对不起，无法进行有效的翻译'
        elif fanyi['errorCode'] == 40:
            return u'对不起，不支持的语言类型'
        else:
            return u'对不起，您输入的单词%s无法翻译,请检查拼写'% word
    
    	