0000                    	ORG 012A0h
12A0    C3 A0 13        	JP	START
12A3    00 00 00 00     	DS	253 ; STACKエリア
12A7    00 00 00 00
12AB    00 00 00 00
12AF    00 00 00 00
12B3    00 00 00 00
12B7    00 00 00 00
12BB    00 00 00 00
12BF    00 00 00 00
12C3    00 00 00 00
12C7    00 00 00 00
12CB    00 00 00 00
12CF    00 00 00 00
12D3    00 00 00 00
12D7    00 00 00 00
12DB    00 00 00 00
12DF    00 00 00 00
12E3    00 00 00 00
12E7    00 00 00 00
12EB    00 00 00 00
12EF    00 00 00 00
12F3    00 00 00 00
12F7    00 00 00 00
12FB    00 00 00 00
12FF    00 00 00 00
1303    00 00 00 00
1307    00 00 00 00
130B    00 00 00 00
130F    00 00 00 00
1313    00 00 00 00
1317    00 00 00 00
131B    00 00 00 00
131F    00 00 00 00
1323    00 00 00 00
1327    00 00 00 00
132B    00 00 00 00
132F    00 00 00 00
1333    00 00 00 00
1337    00 00 00 00
133B    00 00 00 00
133F    00 00 00 00
1343    00 00 00 00
1347    00 00 00 00
134B    00 00 00 00
134F    00 00 00 00
1353    00 00 00 00
1357    00 00 00 00
135B    00 00 00 00
135F    00 00 00 00
1363    00 00 00 00
1367    00 00 00 00
136B    00 00 00 00
136F    00 00 00 00
1373    00 00 00 00
1377    00 00 00 00
137B    00 00 00 00
137F    00 00 00 00
1383    00 00 00 00
1387    00 00 00 00
138B    00 00 00 00
138F    00 00 00 00
1393    00 00 00 00
1397    00 00 00 00
139B    00 00 00 00
139F    00
13A0                    START:
13A0    31 A0 13        	LD	SP, START
13A3
13A3                    ; 割り込み禁止
13A3    F3              	DI
13A4
13A4                    ; 8255 初期化
13A4    3E 82           	LD	A, 082h		; 8255 A=out B=in C=out
13A6    D3 E3           	OUT	(0E3H), A
13A8    3E 58           	LD	A, 058h		; b3:BST=1 b4:OPEN=1 b6:WRITE=1
13AA    D3 E2           	OUT	(0E2H), A
13AC                    ;
13AC                    ; PIO 初期化
13AC                    ;	LD	A, 00Fh		; PIO A=out
13AC                    ;	OUT	(0E9H), A
13AC                    ;	LD	A, 0CFh		; PIO B=in
13AC                    ;	OUT	(0EBH), A
13AC                    ;	LD	A, 0FFh
13AC                    ;	OUT	(0EBH), A
13AC
13AC                    ; テキスト初期化
13AC    3E 50           	LD	A, 80
13AE    CD 2E 1B        	CALL	WIDTH
13B1    CD 5A 1B        	CALL	ENABLE_TEXT_VRAM_ADDR
13B4
13B4                    ; テキスト優先、文字色白
13B4    3E 0F           	LD	A, 0Fh
13B6    D3 F5           	OUT	(0F5h), A
13B8                    ; 背景色黒
13B8    3E 00           	LD	A, 0
13BA    D3 F4           	OUT	(0F4h), A
13BC
13BC                    ; テキストクリア
13BC    CD 6D 1C        	CALL	CLS
13BF                    ; 左上指定
13BF    11 00 00        	LD	DE, 0
13C2    CD 70 1B        	CALL	CURSOR
13C5                    ; メッセージ表示
13C5    21 F7 24        	LD	HL, MSG
13C8    CD F2 1B        	CALL	PRINT_MSG
13CB                    ; 改行
13CB    CD 9D 1B        	CALL	NEW_LINE
13CE
13CE    76              	HALT
13CF
13CF                    ; グラフィック表示初期化
13CF    3E 07           	LD	A, 7
13D1    D3 F6           	OUT	(0F6h), A
13D3                    ; G-VRAM有効
13D3    CD A7 1C        	CALL	ENABLE_GRAPHIC_ADDR
13D6                    ; グラフィック画面クリア
13D6    CD B7 1C        	CALL	GRAPHICS_CLS_ALL
13D9                    ; ソルバルウ表示
13D9                    ; 青
13D9    3E 01           	LD	A, 1
13DB    D3 F7           	OUT	(0F7h), A
13DD    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13E0    21 57 25        	LD	HL, SOLVALOU_B
13E3    CD 06 1F        	CALL	PUT32x16
13E6                    ; 赤
13E6    3E 02           	LD	A, 2
13E8    D3 F7           	OUT	(0F7h), A
13EA    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13ED    21 97 25        	LD	HL, SOLVALOU_R
13F0    CD 06 1F        	CALL	PUT32x16
13F3                    ; 緑
13F3    3E 03           	LD	A, 3
13F5    D3 F7           	OUT	(0F7h), A
13F7    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13FA    21 D7 25        	LD	HL, SOLVALOU_G
13FD    CD 06 1F        	CALL	PUT32x16
1400
1400                    ; G-VRAM無効
1400    CD B0 1C        	CALL	DISABLE_GRAPHIC_ADDR
1403
1403    76              	HALT
1404
1404                    ; ユーティリティ関数
1404                    ; 基本レジスタ破壊を気にしない
1404
1404                    ; 8ビット同士の掛け算
1404                    ; BC = B * E
1404                    MUL_BE:
1404    F5              	PUSH	AF
1405    E5              	PUSH	HL
1406    21 00 00        	LD	HL, 0
1409    0E 00           	LD	C, 0
140B    CB 38           	SRL	B
140D    CB 19           	RR	C
140F    3E 08           	LD	A, 8
1411                    MUL_BE_L1:
1411    CB 23           	SLA	E
1413    30 01           	JR	NC, MUL_BE_L2
1415    09              	ADD	HL, BC
1416                    MUL_BE_L2:
1416    CB 38           	SRL	B
1418    CB 19           	RR	C
141A    3D              	DEC	A
141B    20 F4           	JR	NZ, MUL_BE_L1
141D    4D              	LD	C, L
141E    44              	LD	B, H
141F    E1              	POP	HL
1420    F1              	POP	AF
1421    C9              	RET
1422
1422                    ; HL = HL + A
1422                    ADD_HL_A:
1422    85              	ADD	A, L
1423    6F              	LD	L, A
1424    30 01           	JR	NC, ADD_HL_A_L1
1426    24              	INC	H
1427                    ADD_HL_A_L1:
1427    C9              	RET
1428
1428                    ; HL = HL * 12
1428                    MUL_HLx12:
1428    29              	ADD	HL, HL ; *2
1429    29              	ADD	HL, HL ; *4
142A    44              	LD	B, H
142B    4D              	LD	C, L
142C    29              	ADD	HL, HL ; *8
142D    09              	ADD	HL, BC
142E    C9              	RET
142F
142F                    ; HL = HL * 14
142F                    MUL_HLx14:
142F    29              	ADD	HL, HL ; *2
1430    44              	LD	B, H
1431    4D              	LD	C, L
1432    29              	ADD	HL, HL ; *4
1433    29              	ADD	HL, HL ; *8
1434    09              	ADD	HL, BC
1435    09              	ADD	HL, BC
1436    09              	ADD	HL, BC
1437    C9              	RET
1438
1438                    ; HL = HL * 24
1438                    MUL_HLx24:
1438    29              	ADD	HL, HL ; *2
1439    29              	ADD	HL, HL ; *4
143A    29              	ADD	HL, HL ; *8
143B    44              	LD	B, H
143C    4D              	LD	C, L
143D    29              	ADD	HL, HL ; *16
143E    09              	ADD	HL, BC
143F    C9              	RET
1440
1440                    ; HL = HL * 28
1440                    MUL_HLx28:
1440    29              	ADD	HL, HL ; *2
1441    29              	ADD	HL, HL ; *4
1442    44              	LD	B, H
1443    4D              	LD	C, L
1444    29              	ADD	HL, HL ; *8
1445    54              	LD	D, H
1446    5D              	LD	E, L
1447    29              	ADD	HL, HL ; *16
1448    09              	ADD	HL, BC
1449    19              	ADD	HL, DE
144A    C9              	RET
144B
144B                    ; HL = HL * 40
144B                    ; Break BC
144B                    MUL_HLx40:
144B    29              	ADD	HL, HL ; *2
144C    29              	ADD	HL, HL ; *4
144D    29              	ADD	HL, HL ; *8
144E    44              	LD	B, H
144F    4D              	LD	C, L
1450    29              	ADD	HL, HL ; *16
1451    29              	ADD	HL, HL ; *32
1452    09              	ADD	HL, BC
1453    C9              	RET
1454
1454                    ; HL = HL * 80
1454                    ; Break BC
1454                    MUL_HLx80:
1454    29              	ADD	HL, HL ; *2
1455    29              	ADD	HL, HL ; *4
1456    29              	ADD	HL, HL ; *8
1457    29              	ADD	HL, HL ; *16
1458    44              	LD	B, H
1459    4D              	LD	C, L
145A    29              	ADD	HL, HL ; *32
145B    29              	ADD	HL, HL ; *64
145C    09              	ADD	HL, BC
145D    C9              	RET
145E
145E                    ; HL = HL * 320
145E                    ; Break BC
145E                    MUL_HLx320:
145E    29              	ADD	HL, HL ; *2
145F    29              	ADD	HL, HL ; *4
1460    29              	ADD	HL, HL ; *8
1461    29              	ADD	HL, HL ; *16
1462    29              	ADD	HL, HL ; *32
1463    29              	ADD	HL, HL ; *64
1464    44              	LD	B, H
1465    4D              	LD	C, L
1466    29              	ADD	HL, HL ; *128
1467    29              	ADD	HL, HL ; *256
1468    09              	ADD	HL, BC
1469    C9              	RET
146A
146A                    ; BC = HL / DE 小数点切り捨て, HL = あまり
146A                    DIV16:
146A    01 00 00        	LD	BC, 0
146D    B7              	OR	A
146E                    DIV16_L1:
146E    ED 52           	SBC	HL, DE
1470    38 03           	JR	C, DIV16_L2
1472    03              	INC	BC
1473    18 F9           	JR	DIV16_L1
1475                    DIV16_L2:
1475    19              	ADD	HL, DE
1476    C9              	RET
1477
1477                    ; A(0～15)を(0～F)に変換する
1477                    ; Break HL
1477                    A_TO_HEX:
1477    21 FD 14        	LD	HL, HEX_TABLE
147A    CD 22 14        	CALL	ADD_HL_A
147D    7E              	LD	A, (HL)
147E    C9              	RET
147F
147F                    ; 一定時間待つ
147F    D5              DLY80U:	PUSH	DE	; 80マイクロ秒
1480    11 0D 00        	LD	DE, 13
1483    C3 91 14        	JP	DLYT
1486    D5              DLY1M:	PUSH	DE	; 1ミリ秒
1487    11 82 00        	LD	DE, 130
148A    C3 91 14        	JP	DLYT
148D    D5              DLY60M:	PUSH	DE	; 60ミリ秒
148E    11 2C 1A        	LD	DE, 6700
1491    1B              DLYT:	DEC	DE	; DE回ループする
1492    7B              	LD	A, E
1493    B2              	OR	D
1494    20 FB           	JR	NZ, DLYT
1496    D1              	POP	DE
1497    C9              	RET
1498
1498                    ; 0Dhで終わっている文字列を比較する
1498                    ; LD	DE, 比較文字列1, 0Dh
1498                    ; LD	HL, 比較文字列2, 0Dh
1498                    ; Result Cyフラグ (0: 違う, 1: 同じ)
1498                    CMP_TEXT:
1498                    CMP_TEXT_1:
1498    1A              	LD	A, (DE)
1499    BE              	CP	(HL)
149A    20 08           	JR	NZ, CMP_TEXT_2
149C    FE 0D           	CP	00Dh
149E    13              	INC	DE
149F    23              	INC	HL
14A0    20 F6           	JR	NZ, CMP_TEXT_1
14A2    18 02           	JR	CMP_TEXT_3
14A4                    CMP_TEXT_2:
14A4    B7              	OR	A
14A5    C9              	RET
14A6                    CMP_TEXT_3:
14A6    37              	SCF
14A7    C9              	RET
14A8
14A8                    ; 0-255の乱数をAレジスタに返す
14A8                    RAND:
14A8    3E 00           	LD	A, 0
14AA    5F              	LD	E, A
14AB    87              	ADD	A, A
14AC    87              	ADD	A, A
14AD    83              	ADD	A, E
14AE    3C              	INC	A
14AF    32 A9 14        	LD	(RAND + 1), A
14B2    C9              	RET
14B3
14B3                    ; 0～63の角度番号からX成分を取得する
14B3                    ; LD A, 方向 0～63
14B3                    ; Result HL = 横成分
14B3                    GET_DIR_X:
14B3    21 2D 15        	LD	HL, DIR_X_TBL
14B6                    GET_DIR_Y_SUB:
14B6    87              	ADD	A, A
14B7    06 00           	LD	B, 0
14B9    4F              	LD	C, A
14BA    09              	ADD	HL, BC
14BB    4E              	LD	C, (HL)
14BC    23              	INC	HL
14BD    46              	LD	B, (HL)
14BE    C9              	RET
14BF
14BF                    ; 0～63の角度番号からY成分を取得する
14BF                    ; LD A, 方向 0～63
14BF                    ; Result BC = Y成分
14BF                    GET_DIR_Y:
14BF    21 0D 15        	LD	HL, DIR_Y_TBL
14C2    18 F2           	JR	GET_DIR_Y_SUB
14C4
14C4                    ; 撃つ方向取得
14C4                    ; IX 自分
14C4                    ; IY 相手
14C4                    ; Result A = 方向(0～63)
14C4                    FIRE_DIR:
14C4    D5              	PUSH	DE
14C5    FD 7E 09        	LD	A, (IY + 9) ; TargetY
14C8    CB 2F           	SRA	A ; 1/2
14CA    47              	LD	B, A
14CB    DD 7E 09        	LD	A, (IX + 9) ; Y
14CE    CB 2F           	SRA	A ; 1/2
14D0    90              	SUB	B
14D1    FA D8 14        	JP	M, FIRE_DIR_L1
14D4    26 00           	LD	H, 0
14D6    18 02           	JR	FIRE_DIR_L2
14D8                    FIRE_DIR_L1:
14D8    26 FF           	LD	H, 0FFh
14DA                    FIRE_DIR_L2:
14DA    6F              	LD	L, A
14DB    CD 40 14        	CALL	MUL_HLx28
14DE    FD 7E 07        	LD	A, (IY + 7) ; TargetX
14E1    CB 2F           	SRA	A ; 1/2
14E3    47              	LD	B, A
14E4    DD 7E 07        	LD	A, (IX + 7) ; X
14E7    CB 2F           	SRA	A ; 1/2
14E9    90              	SUB	B
14EA    FA F1 14        	JP	M, FIRE_DIR_L3
14ED    06 00           	LD	B, 0
14EF    18 02           	JR	FIRE_DIR_L4
14F1                    FIRE_DIR_L3:
14F1    06 FF           	LD	B, 0FFh
14F3                    FIRE_DIR_L4:
14F3    4F              	LD	C, A
14F4    09              	ADD	HL, BC
14F5    11 77 18        	LD	DE, FIRE_DIR_TBL + 25 * 28 + 14
14F8    EB              	EX	DE, HL
14F9    19              	ADD	HL, DE
14FA                    	; A=撃つ方向
14FA    7E              	LD	A, (HL)
14FB    D1              	POP	DE
14FC    C9              	RET
14FD
14FD                    ; 16進数変換用テーブル
14FD                    HEX_TABLE:
14FD    30 31 32 33     	DB	"0123456789ABCDEF"
1501    34 35 36 37
1505    38 39 41 42
1509    43 44 45 46
150D
150D                    ; 64方向テーブル
150D                    DIR_Y_TBL:
150D    00 00 26 00     	DW	0, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
1511    4A 00 6F 00
1515    92 00 B4 00
1519    D5 00 F3 00
151D    10 01 28 01
1521    3E 01 52 01
1525    62 01 6E 01
1529    79 01 7D 01
152D                    DIR_X_TBL:
152D    80 01 7D 01     	DW	384, 381, 377, 366, 354, 338, 318, 296, 272, 243, 213, 180, 146, 111, 74, 38
1531    79 01 6E 01
1535    62 01 52 01
1539    3E 01 28 01
153D    10 01 F3 00
1541    D5 00 B4 00
1545    92 00 6F 00
1549    4A 00 26 00
154D    00 00 D9 FF     	DW	0, -39, -75, -113, -147, -182, -215, -245, -273, -297, -320, -339, -356, -368, -378, -383
1551    B5 FF 8F FF
1555    6D FF 4A FF
1559    29 FF 0B FF
155D    EF FE D7 FE
1561    C0 FE AD FE
1565    9C FE 90 FE
1569    86 FE 81 FE
156D    80 FE 81 FE     	DW	-384, -383, -378, -368, -356, -339, -320, -297, -273, -245, -215, -182, -147, -113, -75, -39
1571    86 FE 90 FE
1575    9C FE AD FE
1579    C0 FE D7 FE
157D    EF FE 0B FF
1581    29 FF 4A FF
1585    6D FF 8F FF
1589    B5 FF D9 FF
158D    FE FF 26 00     	DW	-2, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
1591    4A 00 6F 00
1595    92 00 B4 00
1599    D5 00 F3 00
159D    10 01 28 01
15A1    3E 01 52 01
15A5    62 01 6E 01
15A9    79 01 7D 01
15AD
15AD                    ; (25,14)への方向テーブル 50x28
15AD                    FIRE_DIR_TBL:
15AD    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15B1    0C 0C 0D 0D
15B5    0E 0E 0E 0F
15B9    0F 10 10 10
15BD    11 11 12 12
15C1    12 13 13 14
15C5    14 14 15 15
15C9    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15CD    0C 0C 0D 0D
15D1    0E 0E 0E 0F
15D5    0F 10 10 10
15D9    11 11 12 12
15DD    12 13 13 14
15E1    14 14 15 15
15E5    0A 0B 0B 0B     	DB	10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21
15E9    0C 0C 0D 0D
15ED    0D 0E 0E 0F
15F1    0F 10 10 10
15F5    11 11 12 12
15F9    13 13 13 14
15FD    14 15 15 15
1601    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
1605    0C 0C 0C 0D
1609    0D 0E 0E 0F
160D    0F 0F 10 11
1611    11 11 12 12
1615    13 13 14 14
1619    14 15 15 16
161D    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
1621    0C 0C 0C 0D
1625    0D 0E 0E 0F
1629    0F 0F 10 11
162D    11 11 12 12
1631    13 13 14 14
1635    14 15 15 16
1639    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22
163D    0B 0C 0C 0D
1641    0D 0E 0E 0E
1645    0F 0F 10 11
1649    11 12 12 12
164D    13 13 14 14
1651    15 15 16 16
1655    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22, 22
1659    0B 0C 0C 0C
165D    0D 0D 0E 0E
1661    0F 0F 10 11
1665    11 12 12 13
1669    13 14 14 14
166D    15 15 16 16
1671    09 0A 0A 0A     	DB	9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 22
1675    0B 0B 0C 0C
1679    0D 0D 0E 0E
167D    0F 0F 10 11
1681    11 12 12 13
1685    13 14 14 15
1689    15 16 16 16
168D    09 09 0A 0A     	DB	9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23
1691    0B 0B 0C 0C
1695    0D 0D 0E 0E
1699    0F 0F 10 11
169D    11 12 12 13
16A1    13 14 14 15
16A5    15 16 16 17
16A9    09 09 09 0A     	DB	9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23
16AD    0A 0B 0B 0C
16B1    0C 0D 0E 0E
16B5    0F 0F 10 11
16B9    11 12 12 13
16BD    14 14 15 15
16C1    16 16 17 17
16C5    08 09 09 0A     	DB	8, 9, 9, 10, 10, 10, 11, 12, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 22, 23, 23
16C9    0A 0A 0B 0C
16CD    0C 0D 0D 0E
16D1    0F 0F 10 11
16D5    11 12 13 13
16D9    14 14 15 16
16DD    16 16 17 17
16E1    08 08 09 09     	DB	8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16, 17, 17, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24
16E5    0A 0A 0B 0B
16E9    0C 0C 0D 0E
16ED    0F 0F 10 11
16F1    11 12 13 14
16F5    14 15 15 16
16F9    16 17 17 18
16FD    08 08 08 09     	DB	8, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24
1701    09 0A 0A 0B
1705    0C 0C 0D 0E
1709    0E 0F 10 11
170D    12 12 13 14
1711    14 15 16 16
1715    17 17 18 18
1719    07 08 08 08     	DB	7, 8, 8, 8, 9, 9, 10, 11, 11, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24, 24
171D    09 09 0A 0B
1721    0B 0C 0D 0E
1725    0E 0F 10 11
1729    12 12 13 14
172D    15 15 16 17
1731    17 18 18 18
1735    07 07 08 08     	DB	7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24, 25
1739    09 09 0A 0A
173D    0B 0C 0C 0D
1741    0E 0F 10 11
1745    12 13 14 14
1749    15 16 16 17
174D    17 18 18 19
1751    06 07 07 07     	DB	6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 25, 25, 25
1755    08 09 09 0A
1759    0A 0B 0C 0D
175D    0E 0F 10 11
1761    12 13 14 15
1765    16 16 17 17
1769    18 19 19 19
176D    06 06 07 07     	DB	6, 6, 7, 7, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 25, 26
1771    07 08 09 09
1775    0A 0B 0C 0D
1779    0E 0F 10 11
177D    12 13 14 15
1781    16 17 17 18
1785    19 19 19 1A
1789    05 06 06 06     	DB	5, 6, 6, 6, 7, 7, 8, 9, 9, 10, 11, 12, 14, 15, 16, 17, 18, 20, 21, 22, 23, 23, 24, 25, 25, 26, 26, 26
178D    07 07 08 09
1791    09 0A 0B 0C
1795    0E 0F 10 11
1799    12 14 15 16
179D    17 17 18 19
17A1    19 1A 1A 1A
17A5    05 05 05 06     	DB	5, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27
17A9    06 07 07 08
17AD    09 0A 0B 0C
17B1    0D 0F 10 11
17B5    13 14 15 16
17B9    17 18 19 19
17BD    1A 1A 1B 1B
17C1    04 04 05 05     	DB	4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27, 28
17C5    06 06 07 07
17C9    08 09 0A 0B
17CD    0D 0E 10 12
17D1    13 15 16 17
17D5    18 19 19 1A
17D9    1A 1B 1B 1C
17DD    04 04 04 04     	DB	4, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 22, 23, 24, 25, 26, 26, 27, 27, 28, 28, 28
17E1    05 05 06 06
17E5    07 08 09 0A
17E9    0C 0E 10 12
17ED    14 16 17 18
17F1    19 1A 1A 1B
17F5    1B 1C 1C 1C
17F9    03 03 03 04     	DB	3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 8, 9, 11, 14, 16, 18, 21, 23, 24, 25, 26, 27, 27, 28, 28, 28, 29, 29
17FD    04 04 05 05
1801    06 07 08 09
1805    0B 0E 10 12
1809    15 17 18 19
180D    1A 1B 1B 1C
1811    1C 1C 1D 1D
1815    02 02 02 03     	DB	2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 7, 8, 10, 13, 16, 19, 22, 24, 25, 26, 27, 28, 28, 29, 29, 29, 30, 30
1819    03 03 04 04
181D    05 06 07 08
1821    0A 0D 10 13
1825    16 18 19 1A
1829    1B 1C 1C 1D
182D    1D 1D 1E 1E
1831    01 02 02 02     	DB	1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 8, 11, 16, 21, 24, 26, 27, 28, 29, 29, 30, 30, 30, 30, 30, 30
1835    02 02 02 03
1839    03 04 05 06
183D    08 0B 10 15
1841    18 1A 1B 1C
1845    1D 1D 1E 1E
1849    1E 1E 1E 1E
184D    01 01 01 01     	DB	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5, 8, 16, 24, 27, 29, 30, 30, 30, 31, 31, 31, 31, 31, 31, 31
1851    01 01 01 01
1855    02 02 02 03
1859    05 08 10 18
185D    1B 1D 1E 1E
1861    1E 1F 1F 1F
1865    1F 1F 1F 1F
1869    00 00 00 00     	DB	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
186D    00 00 00 00
1871    00 00 00 00
1875    00 00 10 20
1879    20 20 20 20
187D    20 20 20 20
1881    20 20 20 20
1885    3F 3F 3F 3F     	DB	63, 63, 63, 63, 63, 63, 63, 63, 62, 62, 62, 61, 59, 56, 48, 40, 37, 35, 34, 34, 34, 33, 33, 33, 33, 33, 33, 33
1889    3F 3F 3F 3F
188D    3E 3E 3E 3D
1891    3B 38 30 28
1895    25 23 22 22
1899    22 21 21 21
189D    21 21 21 21
18A1    3F 3E 3E 3E     	DB	63, 62, 62, 62, 62, 62, 62, 61, 61, 60, 59, 58, 56, 53, 48, 43, 40, 38, 37, 36, 35, 35, 34, 34, 34, 34, 34, 34
18A5    3E 3E 3E 3D
18A9    3D 3C 3B 3A
18AD    38 35 30 2B
18B1    28 26 25 24
18B5    23 23 22 22
18B9    22 22 22 22
18BD    3E 3E 3E 3D     	DB	62, 62, 62, 61, 61, 61, 60, 60, 59, 58, 57, 56, 54, 51, 48, 45, 42, 40, 39, 38, 37, 36, 36, 35, 35, 35, 34, 34
18C1    3D 3D 3C 3C
18C5    3B 3A 39 38
18C9    36 33 30 2D
18CD    2A 28 27 26
18D1    25 24 24 23
18D5    23 23 22 22
18D9    3D 3D 3D 3C     	DB	61, 61, 61, 60, 60, 60, 59, 59, 58, 57, 56, 55, 53, 50, 48, 46, 43, 41, 40, 39, 38, 37, 37, 36, 36, 36, 35, 35
18DD    3C 3C 3B 3B
18E1    3A 39 38 37
18E5    35 32 30 2E
18E9    2B 29 28 27
18ED    26 25 25 24
18F1    24 24 23 23
18F5    3C 3C 3C 3C     	DB	60, 60, 60, 60, 59, 59, 58, 58, 57, 56, 55, 54, 52, 50, 48, 46, 44, 42, 41, 40, 39, 38, 38, 37, 37, 36, 36, 36
18F9    3B 3B 3A 3A
18FD    39 38 37 36
1901    34 32 30 2E
1905    2C 2A 29 28
1909    27 26 26 25
190D    25 24 24 24
1911    3C 3C 3B 3B     	DB	60, 60, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 51, 50, 48, 46, 45, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37, 36
1915    3A 3A 39 39
1919    38 37 36 35
191D    33 32 30 2E
1921    2D 2B 2A 29
1925    28 27 27 26
1929    26 25 25 24
192D    3B 3B 3B 3A     	DB	59, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 52, 51, 49, 48, 47, 45, 44, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37
1931    3A 39 39 38
1935    37 36 35 34
1939    33 31 30 2F
193D    2D 2C 2B 2A
1941    29 28 27 27
1945    26 26 25 25
1949    3B 3A 3A 3A     	DB	59, 58, 58, 58, 57, 57, 56, 55, 55, 54, 53, 52, 50, 49, 48, 47, 46, 44, 43, 42, 41, 41, 40, 39, 39, 38, 38, 38
194D    39 39 38 37
1951    37 36 35 34
1955    32 31 30 2F
1959    2E 2C 2B 2A
195D    29 29 28 27
1961    27 26 26 26
1965    3A 3A 39 39     	DB	58, 58, 57, 57, 57, 56, 55, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 41, 40, 39, 39, 39, 38
1969    39 38 37 37
196D    36 35 34 33
1971    32 31 30 2F
1975    2E 2D 2C 2B
1979    2A 29 29 28
197D    27 27 27 26
1981    3A 39 39 39     	DB	58, 57, 57, 57, 56, 55, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 42, 41, 41, 40, 39, 39, 39
1985    38 37 37 36
1989    36 35 34 33
198D    32 31 30 2F
1991    2E 2D 2C 2B
1995    2A 2A 29 29
1999    28 27 27 27
199D    39 39 38 38     	DB	57, 57, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 49, 48, 47, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40, 39
19A1    37 37 36 36
19A5    35 34 34 33
19A9    32 31 30 2F
19AD    2E 2D 2C 2C
19B1    2B 2A 2A 29
19B5    29 28 28 27
19B9    39 38 38 38     	DB	57, 56, 56, 56, 55, 55, 54, 53, 53, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 43, 43, 42, 41, 41, 40, 40, 40
19BD    37 37 36 35
19C1    35 34 33 32
19C5    32 31 30 2F
19C9    2E 2E 2D 2C
19CD    2B 2B 2A 29
19D1    29 28 28 28
19D5    38 38 38 37     	DB	56, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40
19D9    37 36 36 35
19DD    34 34 33 32
19E1    32 31 30 2F
19E5    2E 2E 2D 2C
19E9    2C 2B 2A 2A
19ED    29 29 28 28
19F1    38 38 37 37     	DB	56, 56, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 49, 49, 48, 47, 47, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40
19F5    36 36 35 35
19F9    34 34 33 32
19FD    31 31 30 2F
1A01    2F 2E 2D 2C
1A05    2C 2B 2B 2A
1A09    2A 29 29 28
1A0D    38 37 37 36     	DB	56, 55, 55, 54, 54, 54, 53, 52, 52, 51, 51, 50, 49, 49, 48, 47, 47, 46, 45, 45, 44, 44, 43, 42, 42, 42, 41, 41
1A11    36 36 35 34
1A15    34 33 33 32
1A19    31 31 30 2F
1A1D    2F 2E 2D 2D
1A21    2C 2C 2B 2A
1A25    2A 2A 29 29
1A29    37 37 37 36     	DB	55, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41
1A2D    36 35 35 34
1A31    34 33 32 32
1A35    31 31 30 2F
1A39    2F 2E 2E 2D
1A3D    2C 2C 2B 2B
1A41    2A 2A 29 29
1A45    37 37 36 36     	DB	55, 55, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41
1A49    35 35 34 34
1A4D    33 33 32 32
1A51    31 31 30 2F
1A55    2F 2E 2E 2D
1A59    2D 2C 2C 2B
1A5D    2B 2A 2A 29
1A61    37 36 36 36     	DB	55, 54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 42
1A65    35 35 34 34
1A69    33 33 32 32
1A6D    31 31 30 2F
1A71    2F 2E 2E 2D
1A75    2D 2C 2C 2B
1A79    2B 2A 2A 2A
1A7D    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42, 42
1A81    35 34 34 34
1A85    33 33 32 32
1A89    31 31 30 2F
1A8D    2F 2E 2E 2D
1A91    2D 2C 2C 2C
1A95    2B 2B 2A 2A
1A99    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42
1A9D    35 34 34 33
1AA1    33 32 32 32
1AA5    31 31 30 2F
1AA9    2F 2E 2E 2E
1AAD    2D 2D 2C 2C
1AB1    2B 2B 2A 2A
1AB5    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AB9    34 34 34 33
1ABD    33 32 32 31
1AC1    31 31 30 2F
1AC5    2F 2F 2E 2E
1AC9    2D 2D 2C 2C
1ACD    2C 2B 2B 2A
1AD1    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AD5    34 34 34 33
1AD9    33 32 32 31
1ADD    31 31 30 2F
1AE1    2F 2F 2E 2E
1AE5    2D 2D 2C 2C
1AE9    2C 2B 2B 2A
1AED    36 35 35 35     	DB	54, 53, 53, 53, 52, 52, 51, 51, 51, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 45, 45, 45, 44, 44, 43, 43, 43
1AF1    34 34 33 33
1AF5    33 32 32 31
1AF9    31 30 30 30
1AFD    2F 2F 2E 2E
1B01    2D 2D 2D 2C
1B05    2C 2B 2B 2B
1B09    35 35 35 34     	DB	53, 53, 53, 52, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 44, 43, 43
1B0D    34 34 33 33
1B11    32 32 32 31
1B15    31 30 30 30
1B19    2F 2F 2E 2E
1B1D    2E 2D 2D 2C
1B21    2C 2C 2B 2B
1B25                    WIDTH_SIZE:
1B25    28              	DB	40
1B26                    CURSOR_Y:
1B26    00              	DB	0
1B27                    CURSOR_X:
1B27    00              	DB	0
1B28                    CURSOR_ADDR:
1B28    00 D0           	DW	0D000h
1B2A                    TEXT_VRAM_LIMIT:
1B2A    E8 D3           	DW	0D000h + 1000
1B2C                    TEXT_VRAM_SIZE:
1B2C    E8 03           	DW	1000
1B2E
1B2E                    ;テキスト横桁数設定
1B2E                    ;	LD	A, 40 or 80
1B2E                    WIDTH:
1B2E    E5              	PUSH	HL
1B2F    32 25 1B        	LD	(WIDTH_SIZE), A
1B32    FE 28           	CP	40
1B34    DB E8           	IN	A, (0E8h)
1B36    28 10           	JR	Z, WIDTH_40
1B38    F6 20           	OR	020H	; bit5 Hi WIDTH80
1B3A    21 D0 D7        	LD	HL, 0D000h + 2000
1B3D    22 2A 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B40    21 D0 07        	LD	HL, 2000
1B43    22 2C 1B        	LD	(TEXT_VRAM_SIZE), HL
1B46    18 0E           	JR	WIDTH_L1
1B48                    WIDTH_40:
1B48    E6 CF           	AND	0CFh	; bit5 Lo WIDTH40
1B4A    21 E8 D3        	LD	HL, 0D000h + 1000
1B4D    22 2A 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B50    21 E8 03        	LD	HL, 1000
1B53    22 2C 1B        	LD	(TEXT_VRAM_SIZE), HL
1B56                    WIDTH_L1:
1B56    D3 E8           	OUT	(0E8h),A
1B58    E1              	POP	HL
1B59    C9              	RET
1B5A
1B5A                    ENABLE_TEXT_VRAM_ADDR:
1B5A    DB E8           	IN	A,(0E8h)
1B5C    E6 3F           	AND	03Fh
1B5E    F6 C0           	OR	0C0h
1B60    D3 E8           	OUT	(0E8h),A
1B62    C9              	RET
1B63
1B63                    DISABLE_VRAM_ADDR:
1B63    DB E8           	IN	A,(0E8h)
1B65    E6 3F           	AND	03Fh
1B67    D3 E8           	OUT	(0E8h),A
1B69    C9              	RET
1B6A
1B6A                    ;文字と背景の色とプライオリティ設定
1B6A                    ; LD	A, 文字の色(文字優先: 0～7, グラフィック優先: 8～15)
1B6A                    ; LD	B, 背景の色(0～7)
1B6A                    TEXT_COLOR:
1B6A    D3 F5           	OUT	(0F5h), A
1B6C    78              	LD	A, B
1B6D    D3 F4           	OUT	(0F4h), A
1B6F    C9              	RET
1B70
1B70                    ;表示位置設定
1B70                    ;	LD	D, Y
1B70                    ;	LD	E, X
1B70                    CURSOR:
1B70    F5              	PUSH	AF
1B71    C5              	PUSH	BC
1B72    D5              	PUSH	DE
1B73    E5              	PUSH	HL
1B74    7A              	LD	A, D
1B75    32 26 1B        	LD	(CURSOR_Y), A
1B78    7B              	LD	A, E
1B79    32 27 1B        	LD	(CURSOR_X), A
1B7C    26 00           	LD	H, 0
1B7E    6A              	LD	L, D
1B7F    3A 25 1B        	LD	A, (WIDTH_SIZE)
1B82    FE 28           	CP	40
1B84    28 05           	JR	Z, CURSOR_WIDTH40
1B86    CD 54 14        	CALL	MUL_HLx80
1B89    18 03           	JR	CURSOR_L1
1B8B                    CURSOR_WIDTH40:
1B8B    CD 4B 14        	CALL	MUL_HLx40
1B8E                    CURSOR_L1:
1B8E    16 00           	LD	D, 0
1B90    19              	ADD	HL, DE
1B91    11 00 D0        	LD	DE, 0D000h
1B94    19              	ADD	HL, DE
1B95    22 28 1B        	LD	(CURSOR_ADDR), HL
1B98    E1              	POP	HL
1B99    D1              	POP	DE
1B9A    C1              	POP	BC
1B9B    F1              	POP	AF
1B9C    C9              	RET
1B9D
1B9D                    ;改行
1B9D                    NEW_LINE:
1B9D    3A 26 1B        	LD	A, (CURSOR_Y)
1BA0    3C              	INC	A
1BA1    FE 19           	CP	25
1BA3    FA AB 1B        	JP	M, NEW_LINE_L1
1BA6    3E 18           	LD	A, 24
1BA8    CD 23 1C        	CALL	SCROLL_UP
1BAB                    NEW_LINE_L1:
1BAB    57              	LD	D, A
1BAC    1E 00           	LD	E, 0
1BAE    CD 70 1B        	CALL	CURSOR
1BB1    C9              	RET
1BB2
1BB2                    ;一文字表示
1BB2                    ;	LD	HL, 0で終わる文字列へのアドレス
1BB2                    PRINT_MSG1:
1BB2    C5              	PUSH	BC
1BB3    D5              	PUSH	DE
1BB4    E5              	PUSH	HL
1BB5    2A 28 1B        	LD	HL, (CURSOR_ADDR)
1BB8    77              	LD	(HL), A
1BB9    23              	INC	HL
1BBA                    	; 画面右下にはみ出したら一番しての行の左側に戻す
1BBA    E5              	PUSH	HL
1BBB    ED 4B 2A 1B     	LD	BC, (TEXT_VRAM_LIMIT)
1BBF    B7              	OR	A
1BC0    ED 42           	SBC	HL, BC
1BC2    E1              	POP	HL
1BC3    38 0F           	JR	C, PRINT_MSG1_L2
1BC5    2A 2A 1B        	LD	HL, (TEXT_VRAM_LIMIT)
1BC8    06 00           	LD	B, 0
1BCA    3A 25 1B        	LD	A, (WIDTH_SIZE)
1BCD    4F              	LD	C, A
1BCE    B7              	OR	A
1BCF    ED 42           	SBC	HL, BC
1BD1    CD 23 1C        	CALL	SCROLL_UP
1BD4                    PRINT_MSG1_L2:
1BD4    22 28 1B        	LD	(CURSOR_ADDR), HL
1BD7    01 00 D0        	LD	BC, 0D000h
1BDA    B7              	OR	A
1BDB    ED 42           	SBC	HL, BC
1BDD    16 00           	LD	D, 0
1BDF    3A 25 1B        	LD	A, (WIDTH_SIZE)
1BE2    5F              	LD	E, A
1BE3    CD 6A 14        	CALL	DIV16
1BE6    79              	LD	A, C
1BE7    32 26 1B        	LD	(CURSOR_Y), A
1BEA    7D              	LD	A, L
1BEB    32 27 1B        	LD	(CURSOR_X), A
1BEE    E1              	POP	HL
1BEF    D1              	POP	DE
1BF0    C1              	POP	BC
1BF1    C9              	RET
1BF2
1BF2                    ;メッセージを表示
1BF2                    ;	LD	HL, 文字列へのアドレス
1BF2                    PRINT_MSG:
1BF2    E5              	PUSH	HL
1BF3                    PRINT_MSG_L1:
1BF3    7E              	LD	A, (HL)
1BF4    B7              	OR	A
1BF5    28 06           	JR	Z, PRINT_MSG_END
1BF7    CD B2 1B        	CALL	PRINT_MSG1
1BFA    23              	INC	HL
1BFB    18 F6           	JR	PRINT_MSG_L1
1BFD                    PRINT_MSG_END:
1BFD    E1              	POP	HL
1BFE    C9              	RET
1BFF
1BFF                    ; Aレジスタの内容を16進表示する
1BFF                    PRINT_HEX:
1BFF    F5              	PUSH	AF
1C00    CB 3F           	SRL	A
1C02    CB 3F           	SRL	A
1C04    CB 3F           	SRL	A
1C06    CB 3F           	SRL	A
1C08    E6 0F           	AND	00FH
1C0A    CD 16 1C        	CALL	PRINT_HEX1
1C0D    F1              	POP	AF
1C0E    F5              	PUSH	AF
1C0F    E6 0F           	AND	00FH
1C11    CD 16 1C        	CALL	PRINT_HEX1
1C14    F1              	POP	AF
1C15    C9              	RET
1C16
1C16                    ; Aレジスタの0～Fを表示する
1C16                    PRINT_HEX1:
1C16    F5              	PUSH	AF
1C17    C5              	PUSH	BC
1C18    E5              	PUSH	HL
1C19    CD 77 14        	CALL	A_TO_HEX
1C1C    CD B2 1B        	CALL	PRINT_MSG1
1C1F    E1              	POP	HL
1C20    C1              	POP	BC
1C21    F1              	POP	AF
1C22    C9              	RET
1C23
1C23                    ; テキスト画面全体を上方向にスクロール
1C23                    SCROLL_UP:
1C23    F5              	PUSH	AF
1C24    C5              	PUSH	BC
1C25    D5              	PUSH	DE
1C26    E5              	PUSH	HL
1C27    3A 25 1B        	LD	A, (WIDTH_SIZE)
1C2A    FE 28           	CP	40
1C2C    28 05           	JR	Z, SCROLL_UP_L1
1C2E    CD 54 1C        	CALL	SCROLL_UP_WIDTH80
1C31    18 03           	JR	SCROLL_UP_L2
1C33                    SCROLL_UP_L1:
1C33    CD 3B 1C        	CALL	SCROLL_UP_WIDTH40
1C36                    SCROLL_UP_L2:
1C36    E1              	POP	HL
1C37    D1              	POP	DE
1C38    C1              	POP	BC
1C39    F1              	POP	AF
1C3A    C9              	RET
1C3B
1C3B                    ; 40桁のテキスト画面全体を上方向にスクロール
1C3B                    SCROLL_UP_WIDTH40:
1C3B                    	; scroll
1C3B    01 C0 03        	LD	BC, 1000 - 40
1C3E    21 28 D0        	LD	HL, 0D000h + 40
1C41    11 00 D0        	LD	DE, 0D000h
1C44    ED B0           	LDIR
1C46                    	; space
1C46    21 C0 D3        	LD	HL, 0D000h + 1000 - 40
1C49    11 C1 D3        	LD	DE, 0D000h + 1000 - 40 + 1
1C4C    01 27 00        	LD	BC, 40 - 1
1C4F    AF              	XOR	A
1C50    77              	LD	(HL), A
1C51    ED B0           	LDIR
1C53    C9              	RET
1C54
1C54                    ; 80桁のテキスト画面全体を上方向にスクロール
1C54                    SCROLL_UP_WIDTH80:
1C54                    	; scroll
1C54    01 80 07        	LD	BC, 2000 - 80
1C57    21 50 D0        	LD	HL, 0D000h + 80
1C5A    11 00 D0        	LD	DE, 0D000h
1C5D    ED B0           	LDIR
1C5F                    	; space
1C5F    21 80 D7        	LD	HL, 0D000h + 2000 - 80
1C62    11 81 D7        	LD	DE, 0D000h + 2000 - 80 + 1
1C65    01 4F 00        	LD	BC, 80 - 1
1C68    AF              	XOR	A
1C69    77              	LD	(HL), A
1C6A    ED B0           	LDIR
1C6C    C9              	RET
1C6D
1C6D                    ; 画面消去
1C6D                    CLS:
1C6D    3A 25 1B        	LD	A, (WIDTH_SIZE)
1C70    57              	LD	D, A
1C71    1E 19           	LD	E, 25
1C73    3E 20           	LD	A, ' '
1C75    21 00 D0        	LD	HL, 0D000h
1C78    CD 84 1C        	CALL	DRAW_RECT_TEXT
1C7B    11 00 00        	LD	DE, 0
1C7E    CD 70 1B        	CALL	CURSOR
1C81    C9              	RET
1C82
1C82                    ; 桁のテキスト画面で指定した文字で矩形を描く
1C82                    ; LD	A, 'A' ; 描画文字
1C82                    ; LD	D, WIDTH
1C82                    ; LD	E, HEIGHT
1C82                    ; LD	HL, POSITION
1C82                    DRAW_RECT_TEXT_ADD_X:
1C82    00 00           	DW	0
1C84                    DRAW_RECT_TEXT:
1C84    C5              	PUSH	BC
1C85    E5              	PUSH	HL
1C86                    DRAW_RECT_TEXT_WIDTH:
1C86    F5              	PUSH	AF
1C87    3A 25 1B        	LD	A, (WIDTH_SIZE)
1C8A    92              	SUB	D
1C8B    06 00           	LD	B, 0
1C8D    4F              	LD	C, A
1C8E    ED 43 82 1C     	LD	(DRAW_RECT_TEXT_ADD_X), BC
1C92    F1              	POP	AF
1C93    43              	LD	B, E
1C94                    DRAW_RECT_TEXT_1:
1C94    4A              	LD	C, D
1C95                    DRAW_RECT_TEXT_2:
1C95    77              	LD	(HL), A
1C96    23              	INC	HL
1C97    0D              	DEC	C
1C98    20 FB           	JR	NZ, DRAW_RECT_TEXT_2
1C9A    C5              	PUSH	BC
1C9B    ED 4B 82 1C     	LD	BC, (DRAW_RECT_TEXT_ADD_X)
1C9F    09              	ADD	HL, BC
1CA0    C1              	POP	BC
1CA1    05              	DEC	B
1CA2    20 F0           	JR	NZ, DRAW_RECT_TEXT_1
1CA4    E1              	POP	HL
1CA5    C1              	POP	BC
1CA6    C9              	RET
1CA7                    ; GRAMアドレス有効
1CA7                    ENABLE_GRAPHIC_ADDR:
1CA7    DB E8           	IN	A, (0E8h)
1CA9    E6 3F           	AND	03Fh
1CAB    F6 80           	OR	080h
1CAD    D3 E8           	OUT	(0E8h), A
1CAF    C9              	RET
1CB0
1CB0                    ; GRAMアドレス無効
1CB0                    DISABLE_GRAPHIC_ADDR:
1CB0    DB E8           	IN	A, (0E8h)
1CB2    E6 7F           	AND	07Fh
1CB4    D3 E8           	OUT	(0E8h), A
1CB6    C9              	RET
1CB7
1CB7                    ; グラフィックス画面を3ページとも消去する
1CB7                    GRAPHICS_CLS_ALL:
1CB7    3E 01           	LD	A, 1
1CB9    D3 F7           	OUT	(0F7h), A
1CBB    CD CD 1C        	CALL	GRAPHICS_CLS
1CBE    3E 02           	LD	A, 2
1CC0    D3 F7           	OUT	(0F7h), A
1CC2    CD CD 1C        	CALL	GRAPHICS_CLS
1CC5    3E 03           	LD	A, 3
1CC7    D3 F7           	OUT	(0F7h), A
1CC9    CD CD 1C        	CALL	GRAPHICS_CLS
1CCC    C9              	RET
1CCD
1CCD                    ; グラフィックス画面を1ページ分消去する
1CCD                    GRAPHICS_CLS:
1CCD    21 00 C0        	LD	HL, 0C000h
1CD0    01 80 3E        	LD	BC, 16000
1CD3                    GRAPHICS_CLS_L1:
1CD3    36 00           	LD	(HL), 0
1CD5    23              	INC	HL
1CD6    0B              	DEC	BC
1CD7    78              	LD	A, B
1CD8    B1              	OR	C
1CD9    20 F8           	JR	NZ, GRAPHICS_CLS_L1
1CDB    C9              	RET
1CDC
1CDC                    ;16x2(4) 8色を転送する
1CDC                    ;	LD	DE, POSITION
1CDC                    ;	LD	HL, PATTERN
1CDC                    PUT16x2x8:
1CDC    D5              	PUSH	DE
1CDD    ED 73 23 1D     	LD	(PUT16x2x8_RESTORE_STACK + 1), SP
1CE1                    	; B
1CE1    3E 01           	LD	A, 1
1CE3    D3 F7           	OUT	(0F7h), A
1CE5    F9              	LD	SP, HL
1CE6    EB              	EX	DE, HL
1CE7    D1              	POP	DE
1CE8    73              	LD	(HL), E
1CE9    23              	INC	HL
1CEA    72              	LD	(HL), D
1CEB    23              	INC	HL
1CEC    01 9E 00        	LD	BC, 158
1CEF    09              	ADD	HL, BC
1CF0    D1              	POP	DE
1CF1    73              	LD	(HL), E
1CF2    23              	INC	HL
1CF3    72              	LD	(HL), D
1CF4                    	; R
1CF4    3E 02           	LD	A, 2
1CF6    D3 F7           	OUT	(0F7h), A
1CF8    01 A1 00        	LD	BC, 161
1CFB    B7              	OR	A
1CFC    ED 42           	SBC	HL, BC
1CFE    D1              	POP	DE
1CFF    73              	LD	(HL), E
1D00    23              	INC	HL
1D01    72              	LD	(HL), D
1D02    23              	INC	HL
1D03    01 9E 00        	LD	BC, 158
1D06    09              	ADD	HL, BC
1D07    D1              	POP	DE
1D08    73              	LD	(HL), E
1D09    23              	INC	HL
1D0A    72              	LD	(HL), D
1D0B                    	; G
1D0B    3E 03           	LD	A, 3
1D0D    D3 F7           	OUT	(0F7h), A
1D0F    01 A1 00        	LD	BC, 161
1D12    B7              	OR	A
1D13    ED 42           	SBC	HL, BC
1D15    D1              	POP	DE
1D16    73              	LD	(HL), E
1D17    23              	INC	HL
1D18    72              	LD	(HL), D
1D19    23              	INC	HL
1D1A    01 9E 00        	LD	BC, 158
1D1D    09              	ADD	HL, BC
1D1E    D1              	POP	DE
1D1F    73              	LD	(HL), E
1D20    23              	INC	HL
1D21    72              	LD	(HL), D
1D22                    PUT16x2x8_RESTORE_STACK:
1D22    31 00 00        	LD	SP, 0000
1D25    D1              	POP	DE
1D26    C9              	RET
1D27
1D27                    ;16x2(4)単色を転送する
1D27                    ;	LD	DE, POSITION
1D27                    ;	LD	HL, PATTERN
1D27                    PUT16x2:
1D27    D5              	PUSH	DE
1D28    ED 73 3C 1D     	LD	(PUT16x2_RESTORE_STACK + 1), SP
1D2C    F9              	LD	SP, HL
1D2D    EB              	EX	DE, HL
1D2E    D1              	POP	DE
1D2F    73              	LD	(HL), E
1D30    23              	INC	HL
1D31    72              	LD	(HL), D
1D32    23              	INC	HL
1D33    01 9E 00        	LD	BC, 158
1D36    09              	ADD	HL, BC
1D37    D1              	POP	DE
1D38    73              	LD	(HL), E
1D39    23              	INC	HL
1D3A    72              	LD	(HL), D
1D3B                    PUT16x2_RESTORE_STACK:
1D3B    31 00 00        	LD	SP, 0000
1D3E    D1              	POP	DE
1D3F    C9              	RET
1D40
1D40                    ;16x4単色を転送する
1D40                    ;	LD	DE, POSITION
1D40                    ;	LD	HL, PATTERN
1D40                    PUT16x4:
1D40    C5              	PUSH	BC
1D41    D5              	PUSH	DE
1D42    E5              	PUSH	HL
1D43    ED 73 63 1D     	LD	(PUT16x4_RESTORE_STACK + 1), SP
1D47    F9              	LD	SP, HL
1D48    EB              	EX	DE, HL
1D49    01 4E 00        	LD	BC, 78
1D4C    D1              	POP	DE
1D4D    73              	LD	(HL), E
1D4E    23              	INC	HL
1D4F    72              	LD	(HL), D
1D50    23              	INC	HL
1D51    09              	ADD	HL, BC
1D52    D1              	POP	DE
1D53    73              	LD	(HL), E
1D54    23              	INC	HL
1D55    72              	LD	(HL), D
1D56    23              	INC	HL
1D57    09              	ADD	HL, BC
1D58    D1              	POP	DE
1D59    73              	LD	(HL), E
1D5A    23              	INC	HL
1D5B    72              	LD	(HL), D
1D5C    23              	INC	HL
1D5D    09              	ADD	HL, BC
1D5E    D1              	POP	DE
1D5F    73              	LD	(HL), E
1D60    23              	INC	HL
1D61    72              	LD	(HL), D
1D62                    PUT16x4_RESTORE_STACK:
1D62    31 00 00        	LD	SP, 0000
1D65    E1              	POP	HL
1D66    D1              	POP	DE
1D67    C1              	POP	BC
1D68    C9              	RET
1D69
1D69                    ;8x4単色をAND転送する
1D69                    ;	LD	DE, POSITION
1D69                    ;	LD	HL, PATTERN
1D69                    PUT_AND_8x4:
1D69    C5              	PUSH	BC
1D6A    D5              	PUSH	DE
1D6B    E5              	PUSH	HL
1D6C    ED 73 87 1D     	LD	(PUT_AND_8x4_RESTORE_STACK + 1), SP
1D70    F9              	LD	SP, HL
1D71    EB              	EX	DE, HL
1D72    01 50 00        	LD	BC, 80
1D75    D1              	POP	DE
1D76    7B              	LD	A, E
1D77    A6              	AND	(HL)
1D78    77              	LD	(HL), A
1D79    09              	ADD	HL, BC
1D7A    7A              	LD	A, D
1D7B    A6              	AND	(HL)
1D7C    77              	LD	(HL), A
1D7D    09              	ADD	HL, BC
1D7E    D1              	POP	DE
1D7F    7B              	LD	A, E
1D80    A6              	AND	(HL)
1D81    77              	LD	(HL), A
1D82    09              	ADD	HL, BC
1D83    7A              	LD	A, D
1D84    A6              	AND	(HL)
1D85    77              	LD	(HL), A
1D86                    PUT_AND_8x4_RESTORE_STACK:
1D86    31 00 00        	LD	SP, 0000
1D89    E1              	POP	HL
1D8A    D1              	POP	DE
1D8B    C1              	POP	BC
1D8C    C9              	RET
1D8D
1D8D                    ;8x4単色を32x4の左端右端にAND転送する
1D8D                    ;	LD	DE, POSITION
1D8D                    ;	LD	HL, PATTERN
1D8D                    PUT_AND_ZAPPER:
1D8D    C5              	PUSH	BC
1D8E    D5              	PUSH	DE
1D8F    E5              	PUSH	HL
1D90    ED 73 C5 1D     	LD	(PUT_AND_ZAPPER_RESTORE_STACK + 1), SP
1D94    F9              	LD	SP, HL
1D95    EB              	EX	DE, HL
1D96    01 4D 00        	LD	BC, 77
1D99    D1              	POP	DE
1D9A    7B              	LD	A, E
1D9B    A6              	AND	(HL)
1D9C    77              	LD	(HL), A
1D9D    23              	INC	HL
1D9E    23              	INC	HL
1D9F    23              	INC	HL
1DA0    7A              	LD	A, D
1DA1    A6              	AND	(HL)
1DA2    77              	LD	(HL), A
1DA3    09              	ADD	HL, BC
1DA4    D1              	POP	DE
1DA5    7B              	LD	A, E
1DA6    A6              	AND	(HL)
1DA7    77              	LD	(HL), A
1DA8    23              	INC	HL
1DA9    23              	INC	HL
1DAA    23              	INC	HL
1DAB    7A              	LD	A, D
1DAC    A6              	AND	(HL)
1DAD    77              	LD	(HL), A
1DAE    09              	ADD	HL, BC
1DAF    D1              	POP	DE
1DB0    7B              	LD	A, E
1DB1    A6              	AND	(HL)
1DB2    77              	LD	(HL), A
1DB3    23              	INC	HL
1DB4    23              	INC	HL
1DB5    23              	INC	HL
1DB6    7A              	LD	A, D
1DB7    A6              	AND	(HL)
1DB8    77              	LD	(HL), A
1DB9    09              	ADD	HL, BC
1DBA    D1              	POP	DE
1DBB    7B              	LD	A, E
1DBC    A6              	AND	(HL)
1DBD    77              	LD	(HL), A
1DBE    23              	INC	HL
1DBF    23              	INC	HL
1DC0    23              	INC	HL
1DC1    7A              	LD	A, D
1DC2    A6              	AND	(HL)
1DC3    77              	LD	(HL), A
1DC4                    PUT_AND_ZAPPER_RESTORE_STACK:
1DC4    31 00 00        	LD	SP, 0000
1DC7    E1              	POP	HL
1DC8    D1              	POP	DE
1DC9    C1              	POP	BC
1DCA    C9              	RET
1DCB
1DCB                    ;16x4単色をクリアする
1DCB                    ;	LD	HL, POSITION
1DCB                    CLEAR16x4:
1DCB    AF              	XOR	A
1DCC    01 4F 00        	LD	BC, 79
1DCF    77              	LD	(HL), A
1DD0    23              	INC	HL
1DD1    77              	LD	(HL), A
1DD2    09              	ADD	HL, BC
1DD3    77              	LD	(HL), A
1DD4    23              	INC	HL
1DD5    77              	LD	(HL), A
1DD6    09              	ADD	HL, BC
1DD7    77              	LD	(HL), A
1DD8    23              	INC	HL
1DD9    77              	LD	(HL), A
1DDA    09              	ADD	HL, BC
1DDB    77              	LD	(HL), A
1DDC    23              	INC	HL
1DDD    77              	LD	(HL), A
1DDE    C9              	RET
1DDF
1DDF                    ;16x4 青と赤プレーンをクリアする
1DDF                    ;	LD	DE, POSITION
1DDF                    CLEAR16x4_BR:
1DDF    E5              	PUSH	HL
1DE0    C5              	PUSH	BC
1DE1    62              	LD	H, D
1DE2    6B              	LD	L, E
1DE3    3E 01           	LD	A, 1
1DE5    D3 F7           	OUT	(0F7h), A
1DE7    CD CB 1D        	CALL	CLEAR16x4
1DEA    62              	LD	H, D
1DEB    6B              	LD	L, E
1DEC    3E 02           	LD	A, 2
1DEE    D3 F7           	OUT	(0F7h), A
1DF0    CD CB 1D        	CALL	CLEAR16x4
1DF3    C1              	POP	BC
1DF4    E1              	POP	HL
1DF5    C9              	RET
1DF6
1DF6                    ;16x8単色を転送する
1DF6                    ;	LD	DE, POSITION
1DF6                    ;	LD	HL, PATTERN
1DF6                    PUT16x8:
1DF6    ED 73 27 1E     	LD	(PUT16x8_RESTORE_STACK + 1), SP
1DFA    F9              	LD	SP, HL
1DFB    EB              	EX	DE, HL
1DFC    01 4F 00        	LD	BC, 79
1DFF    D1              	POP	DE
1E00    73              	LD	(HL), E
1E01    23              	INC	HL
1E02    72              	LD	(HL), D
1E03    09              	ADD	HL, BC
1E04    D1              	POP	DE
1E05    73              	LD	(HL), E
1E06    23              	INC	HL
1E07    72              	LD	(HL), D
1E08    09              	ADD	HL, BC
1E09    D1              	POP	DE
1E0A    73              	LD	(HL), E
1E0B    23              	INC	HL
1E0C    72              	LD	(HL), D
1E0D    09              	ADD	HL, BC
1E0E    D1              	POP	DE
1E0F    73              	LD	(HL), E
1E10    23              	INC	HL
1E11    72              	LD	(HL), D
1E12    09              	ADD	HL, BC
1E13    D1              	POP	DE
1E14    73              	LD	(HL), E
1E15    23              	INC	HL
1E16    72              	LD	(HL), D
1E17    09              	ADD	HL, BC
1E18    D1              	POP	DE
1E19    73              	LD	(HL), E
1E1A    23              	INC	HL
1E1B    72              	LD	(HL), D
1E1C    09              	ADD	HL, BC
1E1D    D1              	POP	DE
1E1E    73              	LD	(HL), E
1E1F    23              	INC	HL
1E20    72              	LD	(HL), D
1E21    09              	ADD	HL, BC
1E22    D1              	POP	DE
1E23    73              	LD	(HL), E
1E24    23              	INC	HL
1E25    72              	LD	(HL), D
1E26                    PUT16x8_RESTORE_STACK:
1E26    31 00 00        	LD	SP, 0000
1E29    C9              	RET
1E2A
1E2A                    ;32x4単色を転送する
1E2A                    ;	LD	DE, POSITION
1E2A                    ;	LD	HL, PATTERN
1E2A                    PUT32x4:
1E2A    ED 73 5B 1E     	LD	(PUT32x4_RESTORE_STACK + 1), SP
1E2E    F9              	LD	SP, HL
1E2F    EB              	EX	DE, HL
1E30    01 4D 00        	LD	BC, 77
1E33    D1              	POP	DE
1E34    73              	LD	(HL), E
1E35    23              	INC	HL
1E36    72              	LD	(HL), D
1E37    23              	INC	HL
1E38    D1              	POP	DE
1E39    73              	LD	(HL), E
1E3A    23              	INC	HL
1E3B    72              	LD	(HL), D
1E3C    09              	ADD	HL, BC
1E3D    D1              	POP	DE
1E3E    73              	LD	(HL), E
1E3F    23              	INC	HL
1E40    72              	LD	(HL), D
1E41    23              	INC	HL
1E42    D1              	POP	DE
1E43    73              	LD	(HL), E
1E44    23              	INC	HL
1E45    72              	LD	(HL), D
1E46    09              	ADD	HL, BC
1E47    D1              	POP	DE
1E48    73              	LD	(HL), E
1E49    23              	INC	HL
1E4A    72              	LD	(HL), D
1E4B    23              	INC	HL
1E4C    D1              	POP	DE
1E4D    73              	LD	(HL), E
1E4E    23              	INC	HL
1E4F    72              	LD	(HL), D
1E50    09              	ADD	HL, BC
1E51    D1              	POP	DE
1E52    73              	LD	(HL), E
1E53    23              	INC	HL
1E54    72              	LD	(HL), D
1E55    23              	INC	HL
1E56    D1              	POP	DE
1E57    73              	LD	(HL), E
1E58    23              	INC	HL
1E59    72              	LD	(HL), D
1E5A                    PUT32x4_RESTORE_STACK:
1E5A    31 00 00        	LD	SP, 0000
1E5D    C9              	RET
1E5E
1E5E                    ;32x4単色をAND転送する
1E5E                    ;	LD	HL, POSITION
1E5E                    ;	LD	DE, PATTERN
1E5E                    PUT_AND_32x4:
1E5E    ED 73 AF 1E     	LD	(PUT_AND_32x4_RESTORE_STACK + 1), SP
1E62    F9              	LD	SP, HL
1E63    EB              	EX	DE, HL
1E64    01 4D 00        	LD	BC, 77
1E67    D1              	POP	DE
1E68    7B              	LD	A, E
1E69    A6              	AND	(HL)
1E6A    77              	LD	(HL), A
1E6B    23              	INC	HL
1E6C    7A              	LD	A, D
1E6D    A6              	AND	(HL)
1E6E    77              	LD	(HL), A
1E6F    23              	INC	HL
1E70    D1              	POP	DE
1E71    7B              	LD	A, E
1E72    A6              	AND	(HL)
1E73    77              	LD	(HL), A
1E74    23              	INC	HL
1E75    7A              	LD	A, D
1E76    A6              	AND	(HL)
1E77    77              	LD	(HL), A
1E78    09              	ADD	HL, BC
1E79    D1              	POP	DE
1E7A    7B              	LD	A, E
1E7B    A6              	AND	(HL)
1E7C    77              	LD	(HL), A
1E7D    23              	INC	HL
1E7E    7A              	LD	A, D
1E7F    A6              	AND	(HL)
1E80    77              	LD	(HL), A
1E81    23              	INC	HL
1E82    D1              	POP	DE
1E83    7B              	LD	A, E
1E84    A6              	AND	(HL)
1E85    77              	LD	(HL), A
1E86    23              	INC	HL
1E87    7A              	LD	A, D
1E88    A6              	AND	(HL)
1E89    77              	LD	(HL), A
1E8A    09              	ADD	HL, BC
1E8B    D1              	POP	DE
1E8C    7B              	LD	A, E
1E8D    A6              	AND	(HL)
1E8E    77              	LD	(HL), A
1E8F    23              	INC	HL
1E90    7A              	LD	A, D
1E91    A6              	AND	(HL)
1E92    77              	LD	(HL), A
1E93    23              	INC	HL
1E94    D1              	POP	DE
1E95    7B              	LD	A, E
1E96    A6              	AND	(HL)
1E97    77              	LD	(HL), A
1E98    23              	INC	HL
1E99    7A              	LD	A, D
1E9A    A6              	AND	(HL)
1E9B    77              	LD	(HL), A
1E9C    09              	ADD	HL, BC
1E9D    D1              	POP	DE
1E9E    7B              	LD	A, E
1E9F    A6              	AND	(HL)
1EA0    77              	LD	(HL), A
1EA1    23              	INC	HL
1EA2    7A              	LD	A, D
1EA3    A6              	AND	(HL)
1EA4    77              	LD	(HL), A
1EA5    23              	INC	HL
1EA6    D1              	POP	DE
1EA7    7B              	LD	A, E
1EA8    A6              	AND	(HL)
1EA9    77              	LD	(HL), A
1EAA    23              	INC	HL
1EAB    7A              	LD	A, D
1EAC    A6              	AND	(HL)
1EAD    77              	LD	(HL), A
1EAE                    PUT_AND_32x4_RESTORE_STACK:
1EAE    31 00 00        	LD	SP, 0000
1EB1    C9              	RET
1EB2
1EB2                    ;32x4単色をOR転送する
1EB2                    ;	LD	HL, POSITION
1EB2                    ;	LD	DE, PATTERN
1EB2                    PUT_OR_32x4:
1EB2    ED 73 03 1F     	LD	(PUT_OR_32x4_RESTORE_STACK + 1), SP
1EB6    F9              	LD	SP, HL
1EB7    EB              	EX	DE, HL
1EB8    01 4D 00        	LD	BC, 77
1EBB    D1              	POP	DE
1EBC    7B              	LD	A, E
1EBD    B6              	OR	(HL)
1EBE    77              	LD	(HL), A
1EBF    23              	INC	HL
1EC0    7A              	LD	A, D
1EC1    B6              	OR	(HL)
1EC2    77              	LD	(HL), A
1EC3    23              	INC	HL
1EC4    D1              	POP	DE
1EC5    7B              	LD	A, E
1EC6    B6              	OR	(HL)
1EC7    77              	LD	(HL), A
1EC8    23              	INC	HL
1EC9    7A              	LD	A, D
1ECA    B6              	OR	(HL)
1ECB    77              	LD	(HL), A
1ECC    09              	ADD	HL, BC
1ECD    D1              	POP	DE
1ECE    7B              	LD	A, E
1ECF    B6              	OR	(HL)
1ED0    77              	LD	(HL), A
1ED1    23              	INC	HL
1ED2    7A              	LD	A, D
1ED3    B6              	OR	(HL)
1ED4    77              	LD	(HL), A
1ED5    23              	INC	HL
1ED6    D1              	POP	DE
1ED7    7B              	LD	A, E
1ED8    B6              	OR	(HL)
1ED9    77              	LD	(HL), A
1EDA    23              	INC	HL
1EDB    7A              	LD	A, D
1EDC    B6              	OR	(HL)
1EDD    77              	LD	(HL), A
1EDE    09              	ADD	HL, BC
1EDF    D1              	POP	DE
1EE0    7B              	LD	A, E
1EE1    B6              	OR	(HL)
1EE2    77              	LD	(HL), A
1EE3    23              	INC	HL
1EE4    7A              	LD	A, D
1EE5    B6              	OR	(HL)
1EE6    77              	LD	(HL), A
1EE7    23              	INC	HL
1EE8    D1              	POP	DE
1EE9    7B              	LD	A, E
1EEA    B6              	OR	(HL)
1EEB    77              	LD	(HL), A
1EEC    23              	INC	HL
1EED    7A              	LD	A, D
1EEE    B6              	OR	(HL)
1EEF    77              	LD	(HL), A
1EF0    09              	ADD	HL, BC
1EF1    D1              	POP	DE
1EF2    7B              	LD	A, E
1EF3    B6              	OR	(HL)
1EF4    77              	LD	(HL), A
1EF5    23              	INC	HL
1EF6    7A              	LD	A, D
1EF7    B6              	OR	(HL)
1EF8    77              	LD	(HL), A
1EF9    23              	INC	HL
1EFA    D1              	POP	DE
1EFB    7B              	LD	A, E
1EFC    B6              	OR	(HL)
1EFD    77              	LD	(HL), A
1EFE    23              	INC	HL
1EFF    7A              	LD	A, D
1F00    B6              	OR	(HL)
1F01    77              	LD	(HL), A
1F02                    PUT_OR_32x4_RESTORE_STACK:
1F02    31 00 00        	LD	SP, 0000
1F05    C9              	RET
1F06
1F06                    ;32x16単色を転送する
1F06                    ;	LD	DE, POSITION
1F06                    ;	LD	HL, PATTERN
1F06                    PUT32x16:
1F06    ED 73 AF 1F     	LD	(PUT32x16_RESTORE_STACK + 1), SP
1F0A    F9              	LD	SP, HL
1F0B    EB              	EX	DE, HL
1F0C    01 4D 00        	LD	BC, 77
1F0F    D1              	POP	DE
1F10    73              	LD	(HL), E
1F11    23              	INC	HL
1F12    72              	LD	(HL), D
1F13    23              	INC	HL
1F14    D1              	POP	DE
1F15    73              	LD	(HL), E
1F16    23              	INC	HL
1F17    72              	LD	(HL), D
1F18    09              	ADD	HL, BC
1F19    D1              	POP	DE
1F1A    73              	LD	(HL), E
1F1B    23              	INC	HL
1F1C    72              	LD	(HL), D
1F1D    23              	INC	HL
1F1E    D1              	POP	DE
1F1F    73              	LD	(HL), E
1F20    23              	INC	HL
1F21    72              	LD	(HL), D
1F22    09              	ADD	HL, BC
1F23    D1              	POP	DE
1F24    73              	LD	(HL), E
1F25    23              	INC	HL
1F26    72              	LD	(HL), D
1F27    23              	INC	HL
1F28    D1              	POP	DE
1F29    73              	LD	(HL), E
1F2A    23              	INC	HL
1F2B    72              	LD	(HL), D
1F2C    09              	ADD	HL, BC
1F2D    D1              	POP	DE
1F2E    73              	LD	(HL), E
1F2F    23              	INC	HL
1F30    72              	LD	(HL), D
1F31    23              	INC	HL
1F32    D1              	POP	DE
1F33    73              	LD	(HL), E
1F34    23              	INC	HL
1F35    72              	LD	(HL), D
1F36    09              	ADD	HL, BC
1F37    D1              	POP	DE
1F38    73              	LD	(HL), E
1F39    23              	INC	HL
1F3A    72              	LD	(HL), D
1F3B    23              	INC	HL
1F3C    D1              	POP	DE
1F3D    73              	LD	(HL), E
1F3E    23              	INC	HL
1F3F    72              	LD	(HL), D
1F40    09              	ADD	HL, BC
1F41    D1              	POP	DE
1F42    73              	LD	(HL), E
1F43    23              	INC	HL
1F44    72              	LD	(HL), D
1F45    23              	INC	HL
1F46    D1              	POP	DE
1F47    73              	LD	(HL), E
1F48    23              	INC	HL
1F49    72              	LD	(HL), D
1F4A    09              	ADD	HL, BC
1F4B    D1              	POP	DE
1F4C    73              	LD	(HL), E
1F4D    23              	INC	HL
1F4E    72              	LD	(HL), D
1F4F    23              	INC	HL
1F50    D1              	POP	DE
1F51    73              	LD	(HL), E
1F52    23              	INC	HL
1F53    72              	LD	(HL), D
1F54    09              	ADD	HL, BC
1F55    D1              	POP	DE
1F56    73              	LD	(HL), E
1F57    23              	INC	HL
1F58    72              	LD	(HL), D
1F59    23              	INC	HL
1F5A    D1              	POP	DE
1F5B    73              	LD	(HL), E
1F5C    23              	INC	HL
1F5D    72              	LD	(HL), D
1F5E    09              	ADD	HL, BC
1F5F    D1              	POP	DE
1F60    73              	LD	(HL), E
1F61    23              	INC	HL
1F62    72              	LD	(HL), D
1F63    23              	INC	HL
1F64    D1              	POP	DE
1F65    73              	LD	(HL), E
1F66    23              	INC	HL
1F67    72              	LD	(HL), D
1F68    09              	ADD	HL, BC
1F69    D1              	POP	DE
1F6A    73              	LD	(HL), E
1F6B    23              	INC	HL
1F6C    72              	LD	(HL), D
1F6D    23              	INC	HL
1F6E    D1              	POP	DE
1F6F    73              	LD	(HL), E
1F70    23              	INC	HL
1F71    72              	LD	(HL), D
1F72    09              	ADD	HL, BC
1F73    D1              	POP	DE
1F74    73              	LD	(HL), E
1F75    23              	INC	HL
1F76    72              	LD	(HL), D
1F77    23              	INC	HL
1F78    D1              	POP	DE
1F79    73              	LD	(HL), E
1F7A    23              	INC	HL
1F7B    72              	LD	(HL), D
1F7C    09              	ADD	HL, BC
1F7D    D1              	POP	DE
1F7E    73              	LD	(HL), E
1F7F    23              	INC	HL
1F80    72              	LD	(HL), D
1F81    23              	INC	HL
1F82    D1              	POP	DE
1F83    73              	LD	(HL), E
1F84    23              	INC	HL
1F85    72              	LD	(HL), D
1F86    09              	ADD	HL, BC
1F87    D1              	POP	DE
1F88    73              	LD	(HL), E
1F89    23              	INC	HL
1F8A    72              	LD	(HL), D
1F8B    23              	INC	HL
1F8C    D1              	POP	DE
1F8D    73              	LD	(HL), E
1F8E    23              	INC	HL
1F8F    72              	LD	(HL), D
1F90    09              	ADD	HL, BC
1F91    D1              	POP	DE
1F92    73              	LD	(HL), E
1F93    23              	INC	HL
1F94    72              	LD	(HL), D
1F95    23              	INC	HL
1F96    D1              	POP	DE
1F97    73              	LD	(HL), E
1F98    23              	INC	HL
1F99    72              	LD	(HL), D
1F9A    09              	ADD	HL, BC
1F9B    D1              	POP	DE
1F9C    73              	LD	(HL), E
1F9D    23              	INC	HL
1F9E    72              	LD	(HL), D
1F9F    23              	INC	HL
1FA0    D1              	POP	DE
1FA1    73              	LD	(HL), E
1FA2    23              	INC	HL
1FA3    72              	LD	(HL), D
1FA4    09              	ADD	HL, BC
1FA5    D1              	POP	DE
1FA6    73              	LD	(HL), E
1FA7    23              	INC	HL
1FA8    72              	LD	(HL), D
1FA9    23              	INC	HL
1FAA    D1              	POP	DE
1FAB    73              	LD	(HL), E
1FAC    23              	INC	HL
1FAD    72              	LD	(HL), D
1FAE                    PUT32x16_RESTORE_STACK:
1FAE    31 00 00        	LD	SP, 0000
1FB1    C9              	RET
1FB2
1FB2                    ;32x16単色をAND転送する
1FB2                    ;	LD	DE, POSITION
1FB2                    ;	LD	HL, PATTERN
1FB2                    PUT_AND_32x16:
1FB2    ED 73 E2 20     	LD	(PUT_AND_32x16_RESTORE_STACK + 1), SP
1FB6    F9              	LD	SP, HL
1FB7    EB              	EX	DE, HL
1FB8    01 4D 00        	LD	BC, 77
1FBB    D1              	POP	DE
1FBC    7B              	LD	A, E
1FBD    A6              	AND	(HL)
1FBE    77              	LD	(HL), A
1FBF    23              	INC	HL
1FC0    7A              	LD	A, D
1FC1    A6              	AND	(HL)
1FC2    77              	LD	(HL), A
1FC3    23              	INC	HL
1FC4    D1              	POP	DE
1FC5    7B              	LD	A, E
1FC6    A6              	AND	(HL)
1FC7    77              	LD	(HL), A
1FC8    23              	INC	HL
1FC9    7A              	LD	A, D
1FCA    A6              	AND	(HL)
1FCB    77              	LD	(HL), A
1FCC    09              	ADD	HL, BC
1FCD    D1              	POP	DE
1FCE    7B              	LD	A, E
1FCF    A6              	AND	(HL)
1FD0    77              	LD	(HL), A
1FD1    23              	INC	HL
1FD2    7A              	LD	A, D
1FD3    A6              	AND	(HL)
1FD4    77              	LD	(HL), A
1FD5    23              	INC	HL
1FD6    D1              	POP	DE
1FD7    7B              	LD	A, E
1FD8    A6              	AND	(HL)
1FD9    77              	LD	(HL), A
1FDA    23              	INC	HL
1FDB    7A              	LD	A, D
1FDC    A6              	AND	(HL)
1FDD    77              	LD	(HL), A
1FDE    09              	ADD	HL, BC
1FDF    D1              	POP	DE
1FE0    7B              	LD	A, E
1FE1    A6              	AND	(HL)
1FE2    77              	LD	(HL), A
1FE3    23              	INC	HL
1FE4    7A              	LD	A, D
1FE5    A6              	AND	(HL)
1FE6    77              	LD	(HL), A
1FE7    23              	INC	HL
1FE8    D1              	POP	DE
1FE9    7B              	LD	A, E
1FEA    A6              	AND	(HL)
1FEB    77              	LD	(HL), A
1FEC    23              	INC	HL
1FED    7A              	LD	A, D
1FEE    A6              	AND	(HL)
1FEF    77              	LD	(HL), A
1FF0    09              	ADD	HL, BC
1FF1    D1              	POP	DE
1FF2    7B              	LD	A, E
1FF3    A6              	AND	(HL)
1FF4    77              	LD	(HL), A
1FF5    23              	INC	HL
1FF6    7A              	LD	A, D
1FF7    A6              	AND	(HL)
1FF8    77              	LD	(HL), A
1FF9    23              	INC	HL
1FFA    D1              	POP	DE
1FFB    7B              	LD	A, E
1FFC    A6              	AND	(HL)
1FFD    77              	LD	(HL), A
1FFE    23              	INC	HL
1FFF    7A              	LD	A, D
2000    A6              	AND	(HL)
2001    77              	LD	(HL), A
2002    09              	ADD	HL, BC
2003    D1              	POP	DE
2004    7B              	LD	A, E
2005    A6              	AND	(HL)
2006    77              	LD	(HL), A
2007    23              	INC	HL
2008    7A              	LD	A, D
2009    A6              	AND	(HL)
200A    77              	LD	(HL), A
200B    23              	INC	HL
200C    D1              	POP	DE
200D    7B              	LD	A, E
200E    A6              	AND	(HL)
200F    77              	LD	(HL), A
2010    23              	INC	HL
2011    7A              	LD	A, D
2012    A6              	AND	(HL)
2013    77              	LD	(HL), A
2014    09              	ADD	HL, BC
2015    D1              	POP	DE
2016    7B              	LD	A, E
2017    A6              	AND	(HL)
2018    77              	LD	(HL), A
2019    23              	INC	HL
201A    7A              	LD	A, D
201B    A6              	AND	(HL)
201C    77              	LD	(HL), A
201D    23              	INC	HL
201E    D1              	POP	DE
201F    7B              	LD	A, E
2020    A6              	AND	(HL)
2021    77              	LD	(HL), A
2022    23              	INC	HL
2023    7A              	LD	A, D
2024    A6              	AND	(HL)
2025    77              	LD	(HL), A
2026    09              	ADD	HL, BC
2027    D1              	POP	DE
2028    7B              	LD	A, E
2029    A6              	AND	(HL)
202A    77              	LD	(HL), A
202B    23              	INC	HL
202C    7A              	LD	A, D
202D    A6              	AND	(HL)
202E    77              	LD	(HL), A
202F    23              	INC	HL
2030    D1              	POP	DE
2031    7B              	LD	A, E
2032    A6              	AND	(HL)
2033    77              	LD	(HL), A
2034    23              	INC	HL
2035    7A              	LD	A, D
2036    A6              	AND	(HL)
2037    77              	LD	(HL), A
2038    09              	ADD	HL, BC
2039    D1              	POP	DE
203A    7B              	LD	A, E
203B    A6              	AND	(HL)
203C    77              	LD	(HL), A
203D    23              	INC	HL
203E    7A              	LD	A, D
203F    A6              	AND	(HL)
2040    77              	LD	(HL), A
2041    23              	INC	HL
2042    D1              	POP	DE
2043    7B              	LD	A, E
2044    A6              	AND	(HL)
2045    77              	LD	(HL), A
2046    23              	INC	HL
2047    7A              	LD	A, D
2048    A6              	AND	(HL)
2049    77              	LD	(HL), A
204A    09              	ADD	HL, BC
204B    D1              	POP	DE
204C    7B              	LD	A, E
204D    A6              	AND	(HL)
204E    77              	LD	(HL), A
204F    23              	INC	HL
2050    7A              	LD	A, D
2051    A6              	AND	(HL)
2052    77              	LD	(HL), A
2053    23              	INC	HL
2054    D1              	POP	DE
2055    7B              	LD	A, E
2056    A6              	AND	(HL)
2057    77              	LD	(HL), A
2058    23              	INC	HL
2059    7A              	LD	A, D
205A    A6              	AND	(HL)
205B    77              	LD	(HL), A
205C    09              	ADD	HL, BC
205D    D1              	POP	DE
205E    7B              	LD	A, E
205F    A6              	AND	(HL)
2060    77              	LD	(HL), A
2061    23              	INC	HL
2062    7A              	LD	A, D
2063    A6              	AND	(HL)
2064    77              	LD	(HL), A
2065    23              	INC	HL
2066    D1              	POP	DE
2067    7B              	LD	A, E
2068    A6              	AND	(HL)
2069    77              	LD	(HL), A
206A    23              	INC	HL
206B    7A              	LD	A, D
206C    A6              	AND	(HL)
206D    77              	LD	(HL), A
206E    09              	ADD	HL, BC
206F    D1              	POP	DE
2070    7B              	LD	A, E
2071    A6              	AND	(HL)
2072    77              	LD	(HL), A
2073    23              	INC	HL
2074    7A              	LD	A, D
2075    A6              	AND	(HL)
2076    77              	LD	(HL), A
2077    23              	INC	HL
2078    D1              	POP	DE
2079    7B              	LD	A, E
207A    A6              	AND	(HL)
207B    77              	LD	(HL), A
207C    23              	INC	HL
207D    7A              	LD	A, D
207E    A6              	AND	(HL)
207F    77              	LD	(HL), A
2080    09              	ADD	HL, BC
2081    D1              	POP	DE
2082    7B              	LD	A, E
2083    A6              	AND	(HL)
2084    77              	LD	(HL), A
2085    23              	INC	HL
2086    7A              	LD	A, D
2087    A6              	AND	(HL)
2088    77              	LD	(HL), A
2089    23              	INC	HL
208A    D1              	POP	DE
208B    7B              	LD	A, E
208C    A6              	AND	(HL)
208D    77              	LD	(HL), A
208E    23              	INC	HL
208F    7A              	LD	A, D
2090    A6              	AND	(HL)
2091    77              	LD	(HL), A
2092    09              	ADD	HL, BC
2093    D1              	POP	DE
2094    7B              	LD	A, E
2095    A6              	AND	(HL)
2096    77              	LD	(HL), A
2097    23              	INC	HL
2098    7A              	LD	A, D
2099    A6              	AND	(HL)
209A    77              	LD	(HL), A
209B    23              	INC	HL
209C    D1              	POP	DE
209D    7B              	LD	A, E
209E    A6              	AND	(HL)
209F    77              	LD	(HL), A
20A0    23              	INC	HL
20A1    7A              	LD	A, D
20A2    A6              	AND	(HL)
20A3    77              	LD	(HL), A
20A4    09              	ADD	HL, BC
20A5    D1              	POP	DE
20A6    7B              	LD	A, E
20A7    A6              	AND	(HL)
20A8    77              	LD	(HL), A
20A9    23              	INC	HL
20AA    7A              	LD	A, D
20AB    A6              	AND	(HL)
20AC    77              	LD	(HL), A
20AD    23              	INC	HL
20AE    D1              	POP	DE
20AF    7B              	LD	A, E
20B0    A6              	AND	(HL)
20B1    77              	LD	(HL), A
20B2    23              	INC	HL
20B3    7A              	LD	A, D
20B4    A6              	AND	(HL)
20B5    77              	LD	(HL), A
20B6    09              	ADD	HL, BC
20B7    D1              	POP	DE
20B8    7B              	LD	A, E
20B9    A6              	AND	(HL)
20BA    77              	LD	(HL), A
20BB    23              	INC	HL
20BC    7A              	LD	A, D
20BD    A6              	AND	(HL)
20BE    77              	LD	(HL), A
20BF    23              	INC	HL
20C0    D1              	POP	DE
20C1    7B              	LD	A, E
20C2    A6              	AND	(HL)
20C3    77              	LD	(HL), A
20C4    23              	INC	HL
20C5    7A              	LD	A, D
20C6    A6              	AND	(HL)
20C7    77              	LD	(HL), A
20C8    09              	ADD	HL, BC
20C9    D1              	POP	DE
20CA    7B              	LD	A, E
20CB    A6              	AND	(HL)
20CC    77              	LD	(HL), A
20CD    23              	INC	HL
20CE    7A              	LD	A, D
20CF    A6              	AND	(HL)
20D0    77              	LD	(HL), A
20D1    23              	INC	HL
20D2    D1              	POP	DE
20D3    7B              	LD	A, E
20D4    A6              	AND	(HL)
20D5    77              	LD	(HL), A
20D6    23              	INC	HL
20D7    7A              	LD	A, D
20D8    A6              	AND	(HL)
20D9    77              	LD	(HL), A
20DA    ED 73 DF 20     	LD	(PUT_AND_32x16_LD_HL_SP + 1), SP
20DE                    PUT_AND_32x16_LD_HL_SP:
20DE    21 00 00        	LD	HL, 0000
20E1                    PUT_AND_32x16_RESTORE_STACK:
20E1    31 00 00        	LD	SP, 0000
20E4    C9              	RET
20E5
20E5                    ;32x16単色をOR転送する
20E5                    ;	LD	DE, POSITION
20E5                    ;	LD	HL, PATTERN
20E5                    PUT_OR_32x16:
20E5    ED 73 15 22     	LD	(PUT_OR_32x16_RESTORE_STACK + 1), SP
20E9    F9              	LD	SP, HL
20EA    EB              	EX	DE, HL
20EB    01 4D 00        	LD	BC, 77
20EE    D1              	POP	DE
20EF    7B              	LD	A, E
20F0    B6              	OR	(HL)
20F1    77              	LD	(HL), A
20F2    23              	INC	HL
20F3    7A              	LD	A, D
20F4    B6              	OR	(HL)
20F5    77              	LD	(HL), A
20F6    23              	INC	HL
20F7    D1              	POP	DE
20F8    7B              	LD	A, E
20F9    B6              	OR	(HL)
20FA    77              	LD	(HL), A
20FB    23              	INC	HL
20FC    7A              	LD	A, D
20FD    B6              	OR	(HL)
20FE    77              	LD	(HL), A
20FF    09              	ADD	HL, BC
2100    D1              	POP	DE
2101    7B              	LD	A, E
2102    B6              	OR	(HL)
2103    77              	LD	(HL), A
2104    23              	INC	HL
2105    7A              	LD	A, D
2106    B6              	OR	(HL)
2107    77              	LD	(HL), A
2108    23              	INC	HL
2109    D1              	POP	DE
210A    7B              	LD	A, E
210B    B6              	OR	(HL)
210C    77              	LD	(HL), A
210D    23              	INC	HL
210E    7A              	LD	A, D
210F    B6              	OR	(HL)
2110    77              	LD	(HL), A
2111    09              	ADD	HL, BC
2112    D1              	POP	DE
2113    7B              	LD	A, E
2114    B6              	OR	(HL)
2115    77              	LD	(HL), A
2116    23              	INC	HL
2117    7A              	LD	A, D
2118    B6              	OR	(HL)
2119    77              	LD	(HL), A
211A    23              	INC	HL
211B    D1              	POP	DE
211C    7B              	LD	A, E
211D    B6              	OR	(HL)
211E    77              	LD	(HL), A
211F    23              	INC	HL
2120    7A              	LD	A, D
2121    B6              	OR	(HL)
2122    77              	LD	(HL), A
2123    09              	ADD	HL, BC
2124    D1              	POP	DE
2125    7B              	LD	A, E
2126    B6              	OR	(HL)
2127    77              	LD	(HL), A
2128    23              	INC	HL
2129    7A              	LD	A, D
212A    B6              	OR	(HL)
212B    77              	LD	(HL), A
212C    23              	INC	HL
212D    D1              	POP	DE
212E    7B              	LD	A, E
212F    B6              	OR	(HL)
2130    77              	LD	(HL), A
2131    23              	INC	HL
2132    7A              	LD	A, D
2133    B6              	OR	(HL)
2134    77              	LD	(HL), A
2135    09              	ADD	HL, BC
2136    D1              	POP	DE
2137    7B              	LD	A, E
2138    B6              	OR	(HL)
2139    77              	LD	(HL), A
213A    23              	INC	HL
213B    7A              	LD	A, D
213C    B6              	OR	(HL)
213D    77              	LD	(HL), A
213E    23              	INC	HL
213F    D1              	POP	DE
2140    7B              	LD	A, E
2141    B6              	OR	(HL)
2142    77              	LD	(HL), A
2143    23              	INC	HL
2144    7A              	LD	A, D
2145    B6              	OR	(HL)
2146    77              	LD	(HL), A
2147    09              	ADD	HL, BC
2148    D1              	POP	DE
2149    7B              	LD	A, E
214A    B6              	OR	(HL)
214B    77              	LD	(HL), A
214C    23              	INC	HL
214D    7A              	LD	A, D
214E    B6              	OR	(HL)
214F    77              	LD	(HL), A
2150    23              	INC	HL
2151    D1              	POP	DE
2152    7B              	LD	A, E
2153    B6              	OR	(HL)
2154    77              	LD	(HL), A
2155    23              	INC	HL
2156    7A              	LD	A, D
2157    B6              	OR	(HL)
2158    77              	LD	(HL), A
2159    09              	ADD	HL, BC
215A    D1              	POP	DE
215B    7B              	LD	A, E
215C    B6              	OR	(HL)
215D    77              	LD	(HL), A
215E    23              	INC	HL
215F    7A              	LD	A, D
2160    B6              	OR	(HL)
2161    77              	LD	(HL), A
2162    23              	INC	HL
2163    D1              	POP	DE
2164    7B              	LD	A, E
2165    B6              	OR	(HL)
2166    77              	LD	(HL), A
2167    23              	INC	HL
2168    7A              	LD	A, D
2169    B6              	OR	(HL)
216A    77              	LD	(HL), A
216B    09              	ADD	HL, BC
216C    D1              	POP	DE
216D    7B              	LD	A, E
216E    B6              	OR	(HL)
216F    77              	LD	(HL), A
2170    23              	INC	HL
2171    7A              	LD	A, D
2172    B6              	OR	(HL)
2173    77              	LD	(HL), A
2174    23              	INC	HL
2175    D1              	POP	DE
2176    7B              	LD	A, E
2177    B6              	OR	(HL)
2178    77              	LD	(HL), A
2179    23              	INC	HL
217A    7A              	LD	A, D
217B    B6              	OR	(HL)
217C    77              	LD	(HL), A
217D    09              	ADD	HL, BC
217E    D1              	POP	DE
217F    7B              	LD	A, E
2180    B6              	OR	(HL)
2181    77              	LD	(HL), A
2182    23              	INC	HL
2183    7A              	LD	A, D
2184    B6              	OR	(HL)
2185    77              	LD	(HL), A
2186    23              	INC	HL
2187    D1              	POP	DE
2188    7B              	LD	A, E
2189    B6              	OR	(HL)
218A    77              	LD	(HL), A
218B    23              	INC	HL
218C    7A              	LD	A, D
218D    B6              	OR	(HL)
218E    77              	LD	(HL), A
218F    09              	ADD	HL, BC
2190    D1              	POP	DE
2191    7B              	LD	A, E
2192    B6              	OR	(HL)
2193    77              	LD	(HL), A
2194    23              	INC	HL
2195    7A              	LD	A, D
2196    B6              	OR	(HL)
2197    77              	LD	(HL), A
2198    23              	INC	HL
2199    D1              	POP	DE
219A    7B              	LD	A, E
219B    B6              	OR	(HL)
219C    77              	LD	(HL), A
219D    23              	INC	HL
219E    7A              	LD	A, D
219F    B6              	OR	(HL)
21A0    77              	LD	(HL), A
21A1    09              	ADD	HL, BC
21A2    D1              	POP	DE
21A3    7B              	LD	A, E
21A4    B6              	OR	(HL)
21A5    77              	LD	(HL), A
21A6    23              	INC	HL
21A7    7A              	LD	A, D
21A8    B6              	OR	(HL)
21A9    77              	LD	(HL), A
21AA    23              	INC	HL
21AB    D1              	POP	DE
21AC    7B              	LD	A, E
21AD    B6              	OR	(HL)
21AE    77              	LD	(HL), A
21AF    23              	INC	HL
21B0    7A              	LD	A, D
21B1    B6              	OR	(HL)
21B2    77              	LD	(HL), A
21B3    09              	ADD	HL, BC
21B4    D1              	POP	DE
21B5    7B              	LD	A, E
21B6    B6              	OR	(HL)
21B7    77              	LD	(HL), A
21B8    23              	INC	HL
21B9    7A              	LD	A, D
21BA    B6              	OR	(HL)
21BB    77              	LD	(HL), A
21BC    23              	INC	HL
21BD    D1              	POP	DE
21BE    7B              	LD	A, E
21BF    B6              	OR	(HL)
21C0    77              	LD	(HL), A
21C1    23              	INC	HL
21C2    7A              	LD	A, D
21C3    B6              	OR	(HL)
21C4    77              	LD	(HL), A
21C5    09              	ADD	HL, BC
21C6    D1              	POP	DE
21C7    7B              	LD	A, E
21C8    B6              	OR	(HL)
21C9    77              	LD	(HL), A
21CA    23              	INC	HL
21CB    7A              	LD	A, D
21CC    B6              	OR	(HL)
21CD    77              	LD	(HL), A
21CE    23              	INC	HL
21CF    D1              	POP	DE
21D0    7B              	LD	A, E
21D1    B6              	OR	(HL)
21D2    77              	LD	(HL), A
21D3    23              	INC	HL
21D4    7A              	LD	A, D
21D5    B6              	OR	(HL)
21D6    77              	LD	(HL), A
21D7    09              	ADD	HL, BC
21D8    D1              	POP	DE
21D9    7B              	LD	A, E
21DA    B6              	OR	(HL)
21DB    77              	LD	(HL), A
21DC    23              	INC	HL
21DD    7A              	LD	A, D
21DE    B6              	OR	(HL)
21DF    77              	LD	(HL), A
21E0    23              	INC	HL
21E1    D1              	POP	DE
21E2    7B              	LD	A, E
21E3    B6              	OR	(HL)
21E4    77              	LD	(HL), A
21E5    23              	INC	HL
21E6    7A              	LD	A, D
21E7    B6              	OR	(HL)
21E8    77              	LD	(HL), A
21E9    09              	ADD	HL, BC
21EA    D1              	POP	DE
21EB    7B              	LD	A, E
21EC    B6              	OR	(HL)
21ED    77              	LD	(HL), A
21EE    23              	INC	HL
21EF    7A              	LD	A, D
21F0    B6              	OR	(HL)
21F1    77              	LD	(HL), A
21F2    23              	INC	HL
21F3    D1              	POP	DE
21F4    7B              	LD	A, E
21F5    B6              	OR	(HL)
21F6    77              	LD	(HL), A
21F7    23              	INC	HL
21F8    7A              	LD	A, D
21F9    B6              	OR	(HL)
21FA    77              	LD	(HL), A
21FB    09              	ADD	HL, BC
21FC    D1              	POP	DE
21FD    7B              	LD	A, E
21FE    B6              	OR	(HL)
21FF    77              	LD	(HL), A
2200    23              	INC	HL
2201    7A              	LD	A, D
2202    B6              	OR	(HL)
2203    77              	LD	(HL), A
2204    23              	INC	HL
2205    D1              	POP	DE
2206    7B              	LD	A, E
2207    B6              	OR	(HL)
2208    77              	LD	(HL), A
2209    23              	INC	HL
220A    7A              	LD	A, D
220B    B6              	OR	(HL)
220C    77              	LD	(HL), A
220D    ED 73 12 22     	LD	(PUT_OR_32x16_LD_HL_SP + 1), SP
2211                    PUT_OR_32x16_LD_HL_SP:
2211    21 00 00        	LD	HL, 0000
2214                    PUT_OR_32x16_RESTORE_STACK:
2214    31 00 00        	LD	SP, 0000
2217    C9              	RET
2218                    ; プリンタリセット
2218                    RESET_PRINTER:
2218    AF              	XOR	A
2219    D3 FE           	OUT	(0FEh), A
221B    3E 80           	LD	A, 080h
221D    D3 FE           	OUT	(0FEh), A
221F    AF              	XOR	A
2220    D3 FE           	OUT	(0FEh), A
2222    C9              	RET
2223
2223                    ;一文字プリンタに送る
2223                    ;	LD	A, 'A'
2223                    PUT_PRINTER1:
2223    F5              	PUSH	AF
2224                    PUT_PRINTER1_L1:
2224    DB FE           	IN	A, (0FEh)
2226    CB 47           	BIT	0, A
2228    20 FA           	JR	NZ, PUT_PRINTER1_L1
222A    F1              	POP	AF
222B    D3 FF           	OUT	(0FFh), A ; 1文字分送る
222D    3E 80           	LD	A, 080h
222F    D3 FE           	OUT	(0FEh), A ; Hi
2231    AF              	XOR	A
2232    D3 FE           	OUT	(0FEh), A ; Lo
2234    C9              	RET
2235
2235                    ;メッセージをプリンタに送る
2235                    ;	LD	HL, MES
2235                    MSGOUT_PRINTER:
2235    E5              	PUSH	HL
2236                    MSGOUT_PRINTER_L1:
2236    7E              	LD	A, (HL)
2237    B7              	OR	A
2238    28 06           	JR	Z, MSGOUT_PRINTER_END
223A    CD 23 22        	CALL	PUT_PRINTER1
223D    23              	INC	HL
223E    18 F6           	JR	MSGOUT_PRINTER_L1
2240                    MSGOUT_PRINTER_END:
2240    E1              	POP	HL
2241    C9              	RET
2242
2242                    ;0Dhで終わるメッセージをプリンタに送る
2242                    ;	LD	HL, MES
2242                    MSG0D_OUT_PRINTER:
2242    E5              	PUSH	HL
2243                    MSG0D_OUT_PRINTER_L1:
2243    7E              	LD	A, (HL)
2244    FE 0D           	CP	0Dh
2246    28 06           	JR	Z, MSG0D_OUT_PRINTER_END
2248    CD 23 22        	CALL	PUT_PRINTER1
224B    23              	INC	HL
224C    18 F5           	JR	MSG0D_OUT_PRINTER_L1
224E                    MSG0D_OUT_PRINTER_END:
224E    E1              	POP	HL
224F    C9              	RET
2250
2250                    ; HLレジスタの値を16進数2桁でプリンタに送る
2250                    PUTHEX16_PRINTER:
2250    E5              	PUSH	HL
2251    7C              	LD	A, H
2252    CD 5B 22        	CALL	PUTHEX_PRINTER
2255    7D              	LD	A, L
2256    CD 5B 22        	CALL	PUTHEX_PRINTER
2259    E1              	POP	HL
225A    C9              	RET
225B
225B                    ; Aレジスタの値を16進数2桁でプリンタに送る
225B                    PUTHEX_PRINTER:
225B    F5              	PUSH	AF
225C    CB 3F           	SRL	A
225E    CB 3F           	SRL	A
2260    CB 3F           	SRL	A
2262    CB 3F           	SRL	A
2264    E6 0F           	AND	00FH
2266    CD 72 22        	CALL	PUTHEX1_PRINTER
2269    F1              	POP	AF
226A    F5              	PUSH	AF
226B    E6 0F           	AND	00FH
226D    CD 72 22        	CALL	PUTHEX1_PRINTER
2270    F1              	POP	AF
2271    C9              	RET
2272
2272                    ; Aレジスタの0～Fをプリンタに送る
2272                    PUTHEX1_PRINTER:
2272    F5              	PUSH	AF
2273    C5              	PUSH	BC
2274    E5              	PUSH	HL
2275    CD 77 14        	CALL	A_TO_HEX
2278    CD 23 22        	CALL	PUT_PRINTER1
227B    E1              	POP	HL
227C    C1              	POP	BC
227D    F1              	POP	AF
227E    C9              	RET
227F
227F                    ; ダンプする
227F                    ; LD	HL, Addr
227F                    ; LD	DE, size
227F                    DUMP_PRINTER:
227F    C5              	PUSH	BC
2280    D5              	PUSH	DE
2281    E5              	PUSH	HL
2282                    DUMP_PRINTER_1:
2282                    	; アドレス
2282    7C              	LD	A, H
2283    CD 5B 22        	CALL	PUTHEX_PRINTER
2286    7D              	LD	A, L
2287    CD 5B 22        	CALL	PUTHEX_PRINTER
228A    3E 3A           	LD	A, ':'
228C    CD 23 22        	CALL	PUT_PRINTER1
228F    3E 20           	LD	A, ' '
2291    CD 23 22        	CALL	PUT_PRINTER1
2294    06 10           	LD	B, 16
2296                    DUMP_PRINTER_2:
2296    7E              	LD	A, (HL)
2297    CD 5B 22        	CALL	PUTHEX_PRINTER
229A    3E 20           	LD	A, ' '
229C    CD 23 22        	CALL	PUT_PRINTER1
229F    23              	INC	HL
22A0    1B              	DEC	DE
22A1    7A              	LD	A, D
22A2    B3              	OR	E
22A3    28 0F           	JR	Z, DUMP_PRINTER_3
22A5    05              	DEC	B
22A6    20 EE           	JR	NZ, DUMP_PRINTER_2
22A8    3E 0D           	LD	A, 00Dh
22AA    CD 23 22        	CALL	PUT_PRINTER1
22AD    3E 0A           	LD	A, 00Ah
22AF    CD 23 22        	CALL	PUT_PRINTER1
22B2    18 CE           	JR	DUMP_PRINTER_1
22B4                    DUMP_PRINTER_3:
22B4    E1              	POP	HL
22B5    D1              	POP	DE
22B6    C1              	POP	BC
22B7    C9              	RET
22B8                    ; FDD I/O Port
00D8                    CR	EQU	0D8H ; FDCコマンドレジスタ
00D9                    TR	EQU	0D9H ; FDCトラックレジスタ
00DA                    SCR	EQU	0DAH ; FDCセクタレジスタ
00DB                    DR	EQU	0DBH ; FDCデータレジスタ
00DC                    DM	EQU	0DCH ; ディスクドライブの選択とモーター制御
00DD                    HS	EQU	0DDH ; ディスクのサイド(面)選択
22B8
22B8                    ; READ DIR
22B8                    ; LD	A, ドライブ番号
22B8                    ; LD	HL, ファイルネーム
22B8                    ; LD	IX, BUFFER(最低2KB)
22B8                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
22B8                    READ_FILE:
22B8    E5              	PUSH	HL
22B9    FD 21 E2 24     	LD	IY, WKIY
22BD    32 DF 24        	LD	(DIRNO), A	; ドライブ番号
22C0    3E 00           	LD	A, 000h
22C2    FD 77 02        	LD	(IY+2), A
22C5    3E 08           	LD	A, 008h
22C7    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ2Kバイト
22CA    01 10 00        	LD	BC, 16
22CD    ED 43 DD 24     	LD	(STREC), BC	; レコード16 (DIR)
22D1    CD FB 23        	CALL	BREAD
22D4    F5              	PUSH	AF
22D5    CD 6F 23        	CALL	MOFF
22D8    F1              	POP	AF
22D9    E1              	POP	HL
22DA    D8              	RET	C		; Cyが1ならディレクトリ読み込みエラー
22DB    06 40           	LD	B, 64
22DD    DD E5           	PUSH	IX
22DF    D1              	POP	DE
22E0                    READ_FILE_1:
22E0    1A              	LD	A, (DE)
22E1    13              	INC	DE
22E2    FE 01           	CP	001h
22E4    20 09           	JR	NZ, READ_FILE_2 ; モードが01h(Obj)以外は無視
22E6    D5              	PUSH	DE
22E7    E5              	PUSH	HL
22E8    CD 98 14        	CALL	CMP_TEXT
22EB    E1              	POP	HL
22EC    D1              	POP	DE
22ED    38 0D           	JR	C, READ_FILE_3
22EF                    READ_FILE_2:
22EF                    	; DE = DE + 31
22EF    EB              	EX	DE, HL
22F0    C5              	PUSH	BC
22F1    01 1F 00        	LD	BC, 31
22F4    09              	ADD	HL, BC
22F5    C1              	POP	BC
22F6    EB              	EX	DE, HL
22F7                    	; ループ判定
22F7    05              	DEC	B
22F8    20 E6           	JR	NZ, READ_FILE_1
22FA    37              	SCF
22FB    C9              	RET			; ファイルが見つからない
22FC                    READ_FILE_3:
22FC                    	; 読み込むファイルを見つけた
22FC                    	; DE = DE + 19
22FC    01 13 00        	LD	BC, 19
22FF    EB              	EX	DE, HL
2300    09              	ADD	HL, BC
2301    EB              	EX	DE, HL
2302                    	; 読み込みサイズ取得
2302    1A              	LD	A, (DE)
2303    FD 77 02        	LD	(IY+2), A	; 読み込みサイズ下位バイト設定
2306    13              	INC	DE
2307    1A              	LD	A, (DE)
2308    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ上位バイト設定
230B    13              	INC	DE
230C                    	; 読み込みアドレス取得
230C                    ;	LD	A, (DE)
230C    13              	INC	DE
230D                    ;	LD	C, A
230D                    ;	LD	A, (DE)
230D    13              	INC	DE
230E                    ;	LD	B, A
230E                    ;	PUSH	BC
230E                    ;	POP	IX
230E                    	; DE = DE + 6
230E    01 06 00        	LD	BC, 6
2311    EB              	EX	DE, HL
2312    09              	ADD	HL, BC
2313    EB              	EX	DE, HL
2314                    	; 読み込み開始レコード番号
2314    1A              	LD	A, (DE)
2315    13              	INC	DE
2316    4F              	LD	C, A
2317    1A              	LD	A, (DE)
2318    13              	INC	DE
2319    47              	LD	B, A
231A    ED 43 DD 24     	LD	(STREC), BC	; レコード番号設定
231E                    	; 読み込み開始
231E    CD FB 23        	CALL	BREAD
2321    F5              	PUSH	AF
2322    CD 6F 23        	CALL	MOFF
2325    F1              	POP	AF
2326    C9              	RET
2327
2327                    ; READY
2327    3A E0 24        READY:	LD	A, (MTFG)
232A    0F              	RRCA
232B    CD 59 23        	CALL	MTON
232E    3A DF 24        	LD	A, (DIRNO)	; DRIVE NO GET
2331    F6 84           	OR	084H
2333    D3 DC           	OUT	(DM), A		; DRIVE SELECT MOTON
2335    AF              	XOR	A
2336    CD 8D 14        	CALL	DLY60M
2339    21 00 00        	LD	HL, 00000H
233C    2B              REDY0:	DEC	HL
233D    7C              	LD	A, H
233E    B5              	OR	L
233F    CA C9 24        	JP	Z, DERROR	; NO DISK
2342    DB D8           	IN	A, (CR)		; STATUS GET
2344    2F              	CPL
2345    07              	RLCA
2346    38 F4           	JR	C, REDY0
2348    3A DF 24        	LD	A, (DIRNO)
234B    4F              	LD	C,A
234C    21 DB 24        	LD	HL, CLBF0
234F    06 00           	LD	B, 000H
2351    09              	ADD	HL, BC
2352    CB 46           	BIT	0, (HL)
2354    C0              	RET	NZ
2355    CD 8A 23        	CALL	RCLB
2358    C9              	RET
2359
2359                    ; MOTOR ON
2359    3E 80           MTON:	LD	A,080H
235B    D3 DC           	OUT	(DM), A
235D    06 0A           	LD	B, 10		; 1SEC DELAY
235F    21 19 3C        MTD1:	LD	HL, 03C19H
2362    2B              MTD2:	DEC	HL
2363    7D              	LD	A, L
2364    B4              	OR	H
2365    20 FB           	JR	NZ, MTD2
2367    10 F6           	DJNZ	MTD1
2369    3E 01           	LD	A, 1
236B    32 E0 24        	LD	(MTFG), A
236E    C9              	RET
236F
236F                    ; MOTOR OFF
236F    CD 86 14        MOFF:	CALL	DLY1M		; 1000US DELAY
2372    AF              	XOR	A
2373    D3 DC           	OUT	(DM), A
2375    32 E0 24        	LD	(MTFG), A
2378    C9              	RET
2379
2379                    ; SEEK TREATMENT
2379    3E 1B           SEEK:	LD	A, 01BH
237B    2F              	CPL
237C    D3 D8           	OUT	(CR), A
237E    CD A2 23        	CALL	BUSY
2381    CD 8D 14        	CALL	DLY60M
2384    DB D8           	IN	A, (CR)
2386    2F              	CPL
2387    E6 99           	AND	099H
2389    C9              	RET
238A
238A                    ; RECALIBLATION
238A    E5              RCLB:	PUSH	HL
238B    3E 0B           	LD	A, 00BH
238D    2F              	CPL
238E    D3 D8           	OUT	(CR), A
2390    CD A2 23        	CALL	BUSY
2393    CD 8D 14        	CALL	DLY60M
2396    DB D8           	IN	A, (CR)
2398    2F              	CPL
2399    E6 85           	AND	085H
239B    EE 04           	XOR	004H
239D    E1              	POP	HL
239E    C8              	RET	Z
239F    C3 C9 24        	JP	DERROR
23A2
23A2                    ; BUSY AND WAIT
23A2    D5              BUSY:	PUSH	DE
23A3    E5              	PUSH	HL
23A4    CD 7F 14        	CALL	DLY80U
23A7    1E 07           	LD	E, 7
23A9    21 00 00        BUSY2:	LD	HL, 000H
23AC    2B              BUSY0:	DEC	HL
23AD    7C              	LD	A, H
23AE    B5              	OR	L
23AF    28 09           	JR	Z, BUSY1
23B1    DB D8           	IN	A, (CR)
23B3    2F              	CPL
23B4    0F              	RRCA
23B5    38 F5           	JR	C, BUSY0
23B7    E1              	POP	HL
23B8    D1              	POP	DE
23B9    C9              	RET
23BA    1D              BUSY1:	DEC	E
23BB    20 EC           	JR	NZ, BUSY2
23BD    C3 C9 24        	JP	DERROR
23C0
23C0                    ; DATA CHECK
23C0    06 00           CONVRT:	LD	B, 0
23C2    11 10 00        	LD	DE, 16
23C5    2A DD 24        	LD	HL, (STREC)		; START RECORD
23C8    AF              	XOR	A
23C9    ED 52           TRANS:	SBC	HL, DE
23CB    38 03           	JR	C, TRANS1
23CD    04              	INC	B
23CE    18 F9           	JR	TRANS
23D0    19              TRANS1:	ADD	HL, DE
23D1    60              	LD	H, B
23D2    2C              	INC	L
23D3    FD 74 04        	LD	(IY+4), H
23D6    FD 75 05        	LD	(IY+5), L
23D9    3A DF 24        DCHK:	LD	A, (DIRNO)
23DC    FE 04           	CP	4
23DE    30 18           	JR	NC, DTCK1
23E0    FD 7E 04        	LD	A, (IY+4)
23E3    FE A0           MAXTRK:	CP	160		; MAX TRACK ( 70 -> 35TRACK 2D)
23E5                    				; MAX TRACK (160 -> 80TRACK 2D)
23E5    30 11           	JR	NC, DTCK1
23E7    FD 7E 05        	LD	A, (IY+5)
23EA    B7              	OR	A
23EB    28 0B           	JR	Z, DTCK1
23ED    FE 11           	CP	17		; MAX SECTOR
23EF    30 07           	JR	NC, DTCK1
23F1    FD 7E 02        	LD	A, (IY+2)
23F4    FD B6 03        	OR	(IY+3)
23F7    C0              	RET	NZ
23F8    C3 C9 24        DTCK1:	JP	DERROR
23FB
23FB                    ; SEQENTIAL READ
23FB                    ; DIRNO: ドライブ番号
23FB                    ; IX: 読み込みアドレス
23FB                    ; IY: 6バイトのワークエリア
23FB                    ; STREC: 読み込みレコード番号
23FB                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
23FB    F3              BREAD:	DI
23FC    CD C0 23        	CALL	CONVRT
23FF    3E 0A           	LD	A, 10
2401    32 E1 24        	LD	(RETRY), A
2404    CD 27 23        READ1:	CALL	READY
2407    FD 56 03        	LD	D, (IY+3)
240A    FD 7E 02        	LD	A, (IY+2)
240D    B7              	OR	A
240E    28 01           	JR	Z, RE0
2410    14              	INC	D
2411    FD 7E 05        RE0:	LD	A, (IY+5)
2414    FD 77 01        	LD	(IY+1), A
2417    FD 7E 04        	LD	A, (IY+4)
241A    FD 77 00        	LD	(IY+0), A
241D    DD E5           	PUSH	IX
241F    E1              	POP	HL
2420    CB 3F           RE8:	SRL	A
2422    2F              	CPL
2423    D3 DB           	OUT	(DR), A
2425    30 04           	JR	NC, RE1
2427    3E 01           	LD	A, 001H
2429    18 02           	JR	RE2
242B    3E 00           RE1:	LD	A, 000H
242D    2F              RE2:	CPL
242E    D3 DD           	OUT	(HS), A
2430    CD 79 23        	CALL	SEEK
2433    20 6A           	JR	NZ, REE
2435    0E DB           	LD	C, 0DBH
2437    FD 7E 00        	LD	A, (IY+0)
243A    CB 3F           	SRL	A
243C    2F              	CPL
243D    D3 D9           	OUT	(TR), A
243F    FD 7E 01        	LD	A, (IY+1)
2442    2F              	CPL
2443    D3 DA           	OUT	(SCR),A
2445    D9              	EXX
2446    21 78 24        	LD	HL, RE3
2449    E5              	PUSH	HL
244A    D9              	EXX
244B    3E 94           	LD	A, 094H		;READ & CMD
244D    2F              	CPL
244E    D3 D8           	OUT	(CR), A
2450    CD AE 24        	CALL	WAIT
2453    06 00           RE6:	LD	B, 000H
2455    DB D8           RE4:	IN	A, (CR)
2457    0F              	RRCA
2458    D8              	RET	C
2459    0F              	RRCA
245A    38 F9           	JR	C, RE4
245C    ED A2           	INI
245E    20 F5           	JR	NZ, RE4
2460    FD 34 01        	INC	(IY+1)
2463    FD 7E 01        	LD	A, (IY+1)
2466    FE 11           	CP	17
2468    28 05           	JR	Z, RETS
246A    15              	DEC	D
246B    20 E6           	JR	NZ, RE6
246D    18 01           	JR	RE5
246F    15              RETS:	DEC	D
2470    3E D8           RE5:	LD	A, 0D8H		; FORCE INTER RUPT
2472    2F              	CPL
2473    D3 D8           	OUT	(CR), A
2475    CD A2 23        	CALL	BUSY
2478    DB D8           RE3:	IN	A, (CR)
247A    2F              	CPL
247B    E6 FF           	AND	0FFH
247D    20 20           	JR	NZ, REE
247F    D9              	EXX
2480    E1              	POP	HL
2481    D9              	EXX
2482    FD 7E 01        	LD	A, (IY+1)
2485    FE 11           	CP	17
2487    20 08           	JR	NZ, REX
2489    3E 01           	LD	A, 001H
248B    FD 77 01        	LD	(IY+1), A
248E    FD 34 00        	INC	(IY+0)
2491    7A              REX:	LD	A, D
2492    B7              	OR	A
2493    20 05           	JR	NZ, RE7
2495    3E 80           	LD	A, 080H
2497    D3 DC           	OUT	(DM), A
2499    C9              	RET
249A    FD 7E 00        RE7:	LD	A, (IY+0)
249D    18 81           	JR	RE8
249F    3A E1 24        REE:	LD	A, (RETRY)
24A2    3D              	DEC	A
24A3    32 E1 24        	LD	(RETRY), A
24A6    28 21           	JR	Z, DERROR
24A8    CD 8A 23        	CALL	RCLB
24AB    C3 04 24        	JP	READ1
24AE
24AE                    ; WAIT AND BUSY OFF
24AE    D5              WAIT:	PUSH	DE
24AF    E5              	PUSH	HL
24B0    CD 7F 14        	CALL	DLY80U
24B3    21 00 00        WAIT2:	LD	HL, 00000H
24B6    2B              WAIT0:	DEC	HL
24B7    7C              	LD	A, H
24B8    B5              	OR	L
24B9    28 09           	JR	Z, WAIT1
24BB    DB D8           	IN	A, (CR)
24BD    2F              	CPL
24BE    0F              	RRCA
24BF    30 F5           	JR	NC, WAIT0
24C1    E1              	POP	HL
24C2    D1              	POP	DE
24C3    C9              	RET
24C4    1D              WAIT1:	DEC	E
24C5    20 EC           	JR	NZ, WAIT2
24C7    18 00           	JR	DERROR
24C9
24C9                    ; ディスクエラー
24C9    CD 6F 23        DERROR:	CALL	MOFF
24CC    3E A5           	LD	A, 0A5H
24CE    D3 D9           	OUT	(TR), A
24D0    CD 7F 14        	CALL	DLY80U
24D3    21 EA 24        	LD	HL, ERROR_MESSAGE
24D6    CD 35 22        	CALL	MSGOUT_PRINTER
24D9    37              	SCF
24DA    C9              	RET
24DB
24DB    00 00           CLBF0:	DW	0 ; ?
24DD    00 00           STREC:	DW	0 ; 読込み開始セクタ
24DF    00              DIRNO:	DB	0 ; ドライブ番号(0-3)
24E0    00              MTFG:	DB	0 ; モータ0:OFF, 1:ON
24E1    00              RETRY:	DB	0 ; 残りリトライ回数
24E2    00 00 00 00     WKIY:	DS	6 ; FD READ 指示、ワーク
24E6    00 00
24E8    00 00           WKIX:	DW	0 ; 読み込みアドレス
24EA
24EA                    ERROR_MESSAGE:
24EA    44 69 73 6B     	DB	"Disk Error\n", 0
24EE    20 45 72 72
24F2    6F 72 5C 6E
24F6    00
24F7                    ;INCLUDE "lzdec.mac"
24F7
24F7                    MSG:
24F7    4D 5A 2D 32     	DB	"MZ-2000 DrawTest by kuran-kuran",0
24FB    30 30 30 20
24FF    44 72 61 77
2503    54 65 73 74
2507    20 62 79 20
250B    6B 75 72 61
250F    6E 2D 6B 75
2513    72 61 6E 00
2517
2517                    ; ソルバルウ
2517                    SOLVALOU:
2517                    SOLVALOU_MASK:
2517                    	; solvalou_mask
2517                    	; 32 x 16 dot
2517    FF 3F FC FF     	DW 03FFFh, 0FFFCh, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 0003Fh, 0FC00h
251B    FF 0F F0 FF
251F    FF 0F F0 FF
2523    FF 0F F0 FF
2527    FF 00 00 FF
252B    FF 00 00 FF
252F    FF 00 00 FF
2533    3F 00 00 FC
2537    0F 00 00 F0     	DW 0000Fh, 0F000h, 00003h, 0C000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00C00h, 00030h, 00FCFh, 0F3F0h
253B    03 00 00 C0
253F    00 00 00 00
2543    00 00 00 00
2547    00 00 00 00
254B    00 00 00 00
254F    00 0C 30 00
2553    CF 0F F0 F3
2557                    	; solvalou
2557                    	; 32 x 16 dot
2557                    	; Blue data
2557                    SOLVALOU_B:
2557    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 0F000h, 0000Fh, 0F000h, 0000Fh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FCh, 0FFC0h, 003FFh
255B    00 F0 0F 00
255F    00 F0 0F 00
2563    00 F0 0F 00
2567    00 FF FF 00
256B    00 FF FF 00
256F    00 FF FC 00
2573    C0 FF FF 03
2577    F0 FF FF 0F     	DW 0FFF0h, 00FFFh, 0FFFCh, 03FFFh, 0FFFFh, 0FFFFh, 03FFFh, 0FFFCh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0F3FFh, 0FFCFh, 0F030h, 00C0Fh
257B    FC FF FF 3F
257F    FF FF FF FF
2583    FF 3F FC FF
2587    FF FF FF FF
258B    FF FF FF FF
258F    FF F3 CF FF
2593    30 F0 0F 0C
2597                    	; Red data
2597                    SOLVALOU_R:
2597    00 40 01 00     	DW 04000h, 00001h, 0F000h, 0000Bh, 03000h, 00004h, 03000h, 00008h, 03F00h, 00044h, 03000h, 00008h, 0BB00h, 00047h, 0F7C0h, 0008Bh
259B    00 F0 0B 00
259F    00 30 04 00
25A3    00 30 08 00
25A7    00 3F 44 00
25AB    00 30 08 00
25AF    00 BB 47 00
25B3    C0 F7 8B 00
25B7    30 FB 47 04     	DW 0FB30h, 00447h, 0F7CCh, 0208Bh, 0FBF3h, 04447h, 0F733h, 0888Bh, 0FB33h, 04C47h, 0FF33h, 08C8Bh, 00333h, 04C40h, 0F030h, 00C0Ah
25BB    CC F7 8B 20
25BF    F3 FB 47 44
25C3    33 F7 8B 88
25C7    33 FB 47 4C
25CB    33 FF 8B 8C
25CF    33 03 40 4C
25D3    30 F0 0A 0C
25D7                    	; Green data
25D7                    SOLVALOU_G:
25D7    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 07000h, 0000Dh, 0B000h, 0000Ch, 07F00h, 000ECh, 0B000h, 0001Ch, 0FF00h, 000ECh, 0FFC0h, 001DFh
25DB    00 F0 0F 00
25DF    00 70 0D 00
25E3    00 B0 0C 00
25E7    00 7F EC 00
25EB    00 B0 1C 00
25EF    00 FF EC 00
25F3    C0 FF DF 01
25F7    30 FF CF 0E     	DW 0FF30h, 00ECFh, 0FFCCh, 035CFh, 0FFF3h, 0CECFh, 03F73h, 0CDCCh, 0FFB3h, 0CECFh, 0FF73h, 0CDCFh, 083B3h, 0CECAh, 0F030h, 00C0Fh
25FB    CC FF CF 35
25FF    F3 FF CF CE
2603    73 3F CC CD
2607    B3 FF CF CE
260B    73 FF CF CD
260F    B3 83 CA CE
2613    30 F0 0F 0C
2617
