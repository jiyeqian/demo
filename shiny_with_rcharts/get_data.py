#!/usr/bin/env python
# -*- coding:utf-8 -*-
# 

import datetime
import sqlite3
import random

# conn = sqlite3.connect('sensor_data.db')
# c = conn.cursor()

# c.execute('''DROP TABLE IF EXISTS stocks''')
# c.execute('''CREATE TABLE IF NOT EXISTS stocks(time text, var1 real, var2 real, var3 real)''')

while(1):
# for _ in xrange(10):
    conn = sqlite3.connect('sensor_data.db')
    c = conn.cursor()
    c.execute('''DROP TABLE IF EXISTS stocks''')
    c.execute('''CREATE TABLE IF NOT EXISTS stocks(time text, var1 real, var2 real, var3 real)''')
    for _ in xrange(10):
        c.execute('INSERT INTO stocks VALUES ("%s", %f, %f, %f)' % 
            (datetime.datetime.now(), 
                abs(random.gauss(0, 1)), 
                abs(random.gauss(0, 1)), 
                abs(random.gauss(0, 1))))
        conn.commit()
    for row in c.execute('SELECT * FROM stocks ORDER BY var1'):
        print row
    conn.close()

for row in c.execute('SELECT * FROM stocks ORDER BY var1'):
    print row

conn.close()