#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import cv2


if __name__ == '__main__':
    import sys
    try:
        fn = sys.argv[1]
    except:
        fn = '../temp/cat.jpg'

    img = cv2.imread(fn)
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    def nothing(x):
        pass

    cv2.namedWindow('HSV', 0)
    cv2.createTrackbar( "H", "HSV", 127, 255, nothing)
    cv2.createTrackbar( "S", "HSV", 127, 255, nothing)
    cv2.createTrackbar( "V", "HSV", 127, 255, nothing)

    while True:
        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break
        _hsv = hsv.copy()
        _hsv[:,:,0] += cv2.getTrackbarPos("H", "HSV") - 127
        _hsv[:,:,1] += cv2.getTrackbarPos("S", "HSV") - 127
        _hsv[:,:,2] += cv2.getTrackbarPos("V", "HSV") - 127
        cv2.imshow("Image Changing", cv2.cvtColor(_hsv, cv2.COLOR_HSV2BGR))


