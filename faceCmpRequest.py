#!/usr/bin/python
# -*- coding: utf-8 -*-
from flask import Flask, request

import sys
# sys.path.append('/Users/ppbaby/testvirtualenv/env1/lib/python2.7/site-packages')
sys.path.append('./')
import json

from parse import *
from thrift import Thrift
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol
from face_service import FaceService
from face_service import ttypes

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/uploadImageSubmit', methods=['POST'])
def uploadImageSubmit():
    srcImageName = request.files.get('src_image')
    dstImageName = request.files.get('dst_image')
    srcImageData = srcImageName.read()
    dstImageData = dstImageName.read()
    req = ttypes.FaceCmpRequest()
    req.src_image = srcImageData
    req.dst_image = dstImageData

    transport = TSocket.TSocket('172.18.32.40', 9090)
    transport = TTransport.TBufferedTransport(transport)
    protocol = TBinaryProtocol.TBinaryProtocol(transport)
    client = FaceService.Client(
        protocol)
    transport.open()
    result = client.CompareFaces(req)
    data = objectToStringDouble(result, 'dst_face_rect', 'src_face_rect')
    transport.close()
    return json.dumps(data)


# 方法： 将object先转成String
# 目的： object里存在另一个object
# 参数： obj -- 需要转化成string的对象
#      value_A -- 对象里面的第一个对象
#      value_B -- 对象里面的第二个对象
def objectToStringDouble(obj, value_A, value_B):
    objJson = obj.__dict__
    data = {}
    for key in objJson:
        # print(key)
        if key == value_A:
            value = objJson[key].__dict__
            objJson[key] = value
        if key == value_B:
            value = objJson[key].__dict__
            objJson[key] = value
        data[key] = objJson[key]

    return data

if __name__ == '__main__':
    app.run()
