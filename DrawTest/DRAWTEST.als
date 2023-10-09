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
13AC    3E 0F           	LD	A, 00Fh		; PIO A=out
13AE    D3 E9           	OUT	(0E9H), A
13B0    3E CF           	LD	A, 0CFh		; PIO B=in
13B2    D3 EB           	OUT	(0EBH), A
13B4    3E FF           	LD	A, 0FFh
13B6    D3 EB           	OUT	(0EBH), A
13B8
13B8                    ; テキスト初期化
13B8    3E 50           	LD	A, 80
13BA    CD 39 1B        	CALL	WIDTH
13BD    CD 65 1B        	CALL	ENABLE_TEXT_VRAM_ADDR
13C0
13C0                    ; テキスト優先、文字色赤
13C0    3E 0F           	LD	A, 0Fh
13C2    D3 F5           	OUT	(0F5h), A
13C4                    ; 背景色青
13C4    3E 00           	LD	A, 0
13C6    D3 F4           	OUT	(0F4h), A
13C8
13C8                    ; テキストクリア
13C8    CD 78 1C        	CALL	CLS
13CB                    ; 左上指定
13CB    11 00 00        	LD	DE, 0
13CE    CD 7B 1B        	CALL	CURSOR
13D1                    ; メッセージ表示
13D1    21 02 25        	LD	HL, MSG
13D4    CD FD 1B        	CALL	PRINT_MSG
13D7                    ; 改行
13D7    CD A8 1B        	CALL	NEW_LINE
13DA                    ; グラフィック初期化
13DA    3E 07           	LD	A, 7
13DC    D3 F6           	OUT	(0F6h), A
13DE                    ; G-VRAM有効
13DE    CD B2 1C        	CALL	ENABLE_GRAPHIC_ADDR
13E1                    ; グラフィック画面クリア
13E1    CD C2 1C        	CALL	GRAPHICS_CLS_ALL
13E4                    ; ソルバルウ表示
13E4                    ; 青
13E4    3E 01           	LD	A, 1
13E6    D3 F7           	OUT	(0F7h), A
13E8    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13EB    21 62 25        	LD	HL, SOLVALOU_B
13EE    CD 11 1F        	CALL	PUT32x16
13F1                    ; 赤
13F1    3E 02           	LD	A, 2
13F3    D3 F7           	OUT	(0F7h), A
13F5    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13F8    21 A2 25        	LD	HL, SOLVALOU_R
13FB    CD 11 1F        	CALL	PUT32x16
13FE                    ; 緑
13FE    3E 03           	LD	A, 3
1400    D3 F7           	OUT	(0F7h), A
1402    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
1405    21 E2 25        	LD	HL, SOLVALOU_G
1408    CD 11 1F        	CALL	PUT32x16
140B
140B                    ; G-VRAM無効
140B    CD BB 1C        	CALL	DISABLE_GRAPHIC_ADDR
140E
140E    76              	HALT
140F
140F                    ; ユーティリティ関数
140F                    ; 基本レジスタ破壊を気にしない
140F
140F                    ; 8ビット同士の掛け算
140F                    ; BC = B * E
140F                    MUL_BE:
140F    F5              	PUSH	AF
1410    E5              	PUSH	HL
1411    21 00 00        	LD	HL, 0
1414    0E 00           	LD	C, 0
1416    CB 38           	SRL	B
1418    CB 19           	RR	C
141A    3E 08           	LD	A, 8
141C                    MUL_BE_L1:
141C    CB 23           	SLA	E
141E    30 01           	JR	NC, MUL_BE_L2
1420    09              	ADD	HL, BC
1421                    MUL_BE_L2:
1421    CB 38           	SRL	B
1423    CB 19           	RR	C
1425    3D              	DEC	A
1426    20 F4           	JR	NZ, MUL_BE_L1
1428    4D              	LD	C, L
1429    44              	LD	B, H
142A    E1              	POP	HL
142B    F1              	POP	AF
142C    C9              	RET
142D
142D                    ; HL = HL + A
142D                    ADD_HL_A:
142D    85              	ADD	A, L
142E    6F              	LD	L, A
142F    30 01           	JR	NC, ADD_HL_A_L1
1431    24              	INC	H
1432                    ADD_HL_A_L1:
1432    C9              	RET
1433
1433                    ; HL = HL * 12
1433                    MUL_HLx12:
1433    29              	ADD	HL, HL ; *2
1434    29              	ADD	HL, HL ; *4
1435    44              	LD	B, H
1436    4D              	LD	C, L
1437    29              	ADD	HL, HL ; *8
1438    09              	ADD	HL, BC
1439    C9              	RET
143A
143A                    ; HL = HL * 14
143A                    MUL_HLx14:
143A    29              	ADD	HL, HL ; *2
143B    44              	LD	B, H
143C    4D              	LD	C, L
143D    29              	ADD	HL, HL ; *4
143E    29              	ADD	HL, HL ; *8
143F    09              	ADD	HL, BC
1440    09              	ADD	HL, BC
1441    09              	ADD	HL, BC
1442    C9              	RET
1443
1443                    ; HL = HL * 24
1443                    MUL_HLx24:
1443    29              	ADD	HL, HL ; *2
1444    29              	ADD	HL, HL ; *4
1445    29              	ADD	HL, HL ; *8
1446    44              	LD	B, H
1447    4D              	LD	C, L
1448    29              	ADD	HL, HL ; *16
1449    09              	ADD	HL, BC
144A    C9              	RET
144B
144B                    ; HL = HL * 28
144B                    MUL_HLx28:
144B    29              	ADD	HL, HL ; *2
144C    29              	ADD	HL, HL ; *4
144D    44              	LD	B, H
144E    4D              	LD	C, L
144F    29              	ADD	HL, HL ; *8
1450    54              	LD	D, H
1451    5D              	LD	E, L
1452    29              	ADD	HL, HL ; *16
1453    09              	ADD	HL, BC
1454    19              	ADD	HL, DE
1455    C9              	RET
1456
1456                    ; HL = HL * 40
1456                    ; Break BC
1456                    MUL_HLx40:
1456    29              	ADD	HL, HL ; *2
1457    29              	ADD	HL, HL ; *4
1458    29              	ADD	HL, HL ; *8
1459    44              	LD	B, H
145A    4D              	LD	C, L
145B    29              	ADD	HL, HL ; *16
145C    29              	ADD	HL, HL ; *32
145D    09              	ADD	HL, BC
145E    C9              	RET
145F
145F                    ; HL = HL * 80
145F                    ; Break BC
145F                    MUL_HLx80:
145F    29              	ADD	HL, HL ; *2
1460    29              	ADD	HL, HL ; *4
1461    29              	ADD	HL, HL ; *8
1462    29              	ADD	HL, HL ; *16
1463    44              	LD	B, H
1464    4D              	LD	C, L
1465    29              	ADD	HL, HL ; *32
1466    29              	ADD	HL, HL ; *64
1467    09              	ADD	HL, BC
1468    C9              	RET
1469
1469                    ; HL = HL * 320
1469                    ; Break BC
1469                    MUL_HLx320:
1469    29              	ADD	HL, HL ; *2
146A    29              	ADD	HL, HL ; *4
146B    29              	ADD	HL, HL ; *8
146C    29              	ADD	HL, HL ; *16
146D    29              	ADD	HL, HL ; *32
146E    29              	ADD	HL, HL ; *64
146F    44              	LD	B, H
1470    4D              	LD	C, L
1471    29              	ADD	HL, HL ; *128
1472    29              	ADD	HL, HL ; *256
1473    09              	ADD	HL, BC
1474    C9              	RET
1475
1475                    ; BC = HL / DE 小数点切り捨て, HL = あまり
1475                    DIV16:
1475    01 00 00        	LD	BC, 0
1478    B7              	OR	A
1479                    DIV16_L1:
1479    ED 52           	SBC	HL, DE
147B    38 03           	JR	C, DIV16_L2
147D    03              	INC	BC
147E    18 F9           	JR	DIV16_L1
1480                    DIV16_L2:
1480    19              	ADD	HL, DE
1481    C9              	RET
1482
1482                    ; A(0～15)を(0～F)に変換する
1482                    ; Break HL
1482                    A_TO_HEX:
1482    21 08 15        	LD	HL, HEX_TABLE
1485    CD 2D 14        	CALL	ADD_HL_A
1488    7E              	LD	A, (HL)
1489    C9              	RET
148A
148A                    ; 一定時間待つ
148A    D5              DLY80U:	PUSH	DE	; 80マイクロ秒
148B    11 0D 00        	LD	DE, 13
148E    C3 9C 14        	JP	DLYT
1491    D5              DLY1M:	PUSH	DE	; 1ミリ秒
1492    11 82 00        	LD	DE, 130
1495    C3 9C 14        	JP	DLYT
1498    D5              DLY60M:	PUSH	DE	; 60ミリ秒
1499    11 2C 1A        	LD	DE, 6700
149C    1B              DLYT:	DEC	DE	; DE回ループする
149D    7B              	LD	A, E
149E    B2              	OR	D
149F    20 FB           	JR	NZ, DLYT
14A1    D1              	POP	DE
14A2    C9              	RET
14A3
14A3                    ; 0Dhで終わっている文字列を比較する
14A3                    ; LD	DE, 比較文字列1, 0Dh
14A3                    ; LD	HL, 比較文字列2, 0Dh
14A3                    ; Result Cyフラグ (0: 違う, 1: 同じ)
14A3                    CMP_TEXT:
14A3                    CMP_TEXT_1:
14A3    1A              	LD	A, (DE)
14A4    BE              	CP	(HL)
14A5    20 08           	JR	NZ, CMP_TEXT_2
14A7    FE 0D           	CP	00Dh
14A9    13              	INC	DE
14AA    23              	INC	HL
14AB    20 F6           	JR	NZ, CMP_TEXT_1
14AD    18 02           	JR	CMP_TEXT_3
14AF                    CMP_TEXT_2:
14AF    B7              	OR	A
14B0    C9              	RET
14B1                    CMP_TEXT_3:
14B1    37              	SCF
14B2    C9              	RET
14B3
14B3                    ; 0-255の乱数をAレジスタに返す
14B3                    RAND:
14B3    3E 00           	LD	A, 0
14B5    5F              	LD	E, A
14B6    87              	ADD	A, A
14B7    87              	ADD	A, A
14B8    83              	ADD	A, E
14B9    3C              	INC	A
14BA    32 B4 14        	LD	(RAND + 1), A
14BD    C9              	RET
14BE
14BE                    ; 0～63の角度番号からX成分を取得する
14BE                    ; LD A, 方向 0～63
14BE                    ; Result HL = 横成分
14BE                    GET_DIR_X:
14BE    21 38 15        	LD	HL, DIR_X_TBL
14C1                    GET_DIR_Y_SUB:
14C1    87              	ADD	A, A
14C2    06 00           	LD	B, 0
14C4    4F              	LD	C, A
14C5    09              	ADD	HL, BC
14C6    4E              	LD	C, (HL)
14C7    23              	INC	HL
14C8    46              	LD	B, (HL)
14C9    C9              	RET
14CA
14CA                    ; 0～63の角度番号からY成分を取得する
14CA                    ; LD A, 方向 0～63
14CA                    ; Result BC = Y成分
14CA                    GET_DIR_Y:
14CA    21 18 15        	LD	HL, DIR_Y_TBL
14CD    18 F2           	JR	GET_DIR_Y_SUB
14CF
14CF                    ; 撃つ方向取得
14CF                    ; IX 自分
14CF                    ; IY 相手
14CF                    ; Result A = 方向(0～63)
14CF                    FIRE_DIR:
14CF    D5              	PUSH	DE
14D0    FD 7E 09        	LD	A, (IY + 9) ; TargetY
14D3    CB 2F           	SRA	A ; 1/2
14D5    47              	LD	B, A
14D6    DD 7E 09        	LD	A, (IX + 9) ; Y
14D9    CB 2F           	SRA	A ; 1/2
14DB    90              	SUB	B
14DC    FA E3 14        	JP	M, FIRE_DIR_L1
14DF    26 00           	LD	H, 0
14E1    18 02           	JR	FIRE_DIR_L2
14E3                    FIRE_DIR_L1:
14E3    26 FF           	LD	H, 0FFh
14E5                    FIRE_DIR_L2:
14E5    6F              	LD	L, A
14E6    CD 4B 14        	CALL	MUL_HLx28
14E9    FD 7E 07        	LD	A, (IY + 7) ; TargetX
14EC    CB 2F           	SRA	A ; 1/2
14EE    47              	LD	B, A
14EF    DD 7E 07        	LD	A, (IX + 7) ; X
14F2    CB 2F           	SRA	A ; 1/2
14F4    90              	SUB	B
14F5    FA FC 14        	JP	M, FIRE_DIR_L3
14F8    06 00           	LD	B, 0
14FA    18 02           	JR	FIRE_DIR_L4
14FC                    FIRE_DIR_L3:
14FC    06 FF           	LD	B, 0FFh
14FE                    FIRE_DIR_L4:
14FE    4F              	LD	C, A
14FF    09              	ADD	HL, BC
1500    11 82 18        	LD	DE, FIRE_DIR_TBL + 25 * 28 + 14
1503    EB              	EX	DE, HL
1504    19              	ADD	HL, DE
1505                    	; A=撃つ方向
1505    7E              	LD	A, (HL)
1506    D1              	POP	DE
1507    C9              	RET
1508
1508                    ; 16進数変換用テーブル
1508                    HEX_TABLE:
1508    30 31 32 33     	DB	"0123456789ABCDEF"
150C    34 35 36 37
1510    38 39 41 42
1514    43 44 45 46
1518
1518                    ; 64方向テーブル
1518                    DIR_Y_TBL:
1518    00 00 26 00     	DW	0, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
151C    4A 00 6F 00
1520    92 00 B4 00
1524    D5 00 F3 00
1528    10 01 28 01
152C    3E 01 52 01
1530    62 01 6E 01
1534    79 01 7D 01
1538                    DIR_X_TBL:
1538    80 01 7D 01     	DW	384, 381, 377, 366, 354, 338, 318, 296, 272, 243, 213, 180, 146, 111, 74, 38
153C    79 01 6E 01
1540    62 01 52 01
1544    3E 01 28 01
1548    10 01 F3 00
154C    D5 00 B4 00
1550    92 00 6F 00
1554    4A 00 26 00
1558    00 00 D9 FF     	DW	0, -39, -75, -113, -147, -182, -215, -245, -273, -297, -320, -339, -356, -368, -378, -383
155C    B5 FF 8F FF
1560    6D FF 4A FF
1564    29 FF 0B FF
1568    EF FE D7 FE
156C    C0 FE AD FE
1570    9C FE 90 FE
1574    86 FE 81 FE
1578    80 FE 81 FE     	DW	-384, -383, -378, -368, -356, -339, -320, -297, -273, -245, -215, -182, -147, -113, -75, -39
157C    86 FE 90 FE
1580    9C FE AD FE
1584    C0 FE D7 FE
1588    EF FE 0B FF
158C    29 FF 4A FF
1590    6D FF 8F FF
1594    B5 FF D9 FF
1598    FE FF 26 00     	DW	-2, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
159C    4A 00 6F 00
15A0    92 00 B4 00
15A4    D5 00 F3 00
15A8    10 01 28 01
15AC    3E 01 52 01
15B0    62 01 6E 01
15B4    79 01 7D 01
15B8
15B8                    ; (25,14)への方向テーブル 50x28
15B8                    FIRE_DIR_TBL:
15B8    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15BC    0C 0C 0D 0D
15C0    0E 0E 0E 0F
15C4    0F 10 10 10
15C8    11 11 12 12
15CC    12 13 13 14
15D0    14 14 15 15
15D4    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15D8    0C 0C 0D 0D
15DC    0E 0E 0E 0F
15E0    0F 10 10 10
15E4    11 11 12 12
15E8    12 13 13 14
15EC    14 14 15 15
15F0    0A 0B 0B 0B     	DB	10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21
15F4    0C 0C 0D 0D
15F8    0D 0E 0E 0F
15FC    0F 10 10 10
1600    11 11 12 12
1604    13 13 13 14
1608    14 15 15 15
160C    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
1610    0C 0C 0C 0D
1614    0D 0E 0E 0F
1618    0F 0F 10 11
161C    11 11 12 12
1620    13 13 14 14
1624    14 15 15 16
1628    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
162C    0C 0C 0C 0D
1630    0D 0E 0E 0F
1634    0F 0F 10 11
1638    11 11 12 12
163C    13 13 14 14
1640    14 15 15 16
1644    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22
1648    0B 0C 0C 0D
164C    0D 0E 0E 0E
1650    0F 0F 10 11
1654    11 12 12 12
1658    13 13 14 14
165C    15 15 16 16
1660    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22, 22
1664    0B 0C 0C 0C
1668    0D 0D 0E 0E
166C    0F 0F 10 11
1670    11 12 12 13
1674    13 14 14 14
1678    15 15 16 16
167C    09 0A 0A 0A     	DB	9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 22
1680    0B 0B 0C 0C
1684    0D 0D 0E 0E
1688    0F 0F 10 11
168C    11 12 12 13
1690    13 14 14 15
1694    15 16 16 16
1698    09 09 0A 0A     	DB	9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23
169C    0B 0B 0C 0C
16A0    0D 0D 0E 0E
16A4    0F 0F 10 11
16A8    11 12 12 13
16AC    13 14 14 15
16B0    15 16 16 17
16B4    09 09 09 0A     	DB	9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23
16B8    0A 0B 0B 0C
16BC    0C 0D 0E 0E
16C0    0F 0F 10 11
16C4    11 12 12 13
16C8    14 14 15 15
16CC    16 16 17 17
16D0    08 09 09 0A     	DB	8, 9, 9, 10, 10, 10, 11, 12, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 22, 23, 23
16D4    0A 0A 0B 0C
16D8    0C 0D 0D 0E
16DC    0F 0F 10 11
16E0    11 12 13 13
16E4    14 14 15 16
16E8    16 16 17 17
16EC    08 08 09 09     	DB	8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16, 17, 17, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24
16F0    0A 0A 0B 0B
16F4    0C 0C 0D 0E
16F8    0F 0F 10 11
16FC    11 12 13 14
1700    14 15 15 16
1704    16 17 17 18
1708    08 08 08 09     	DB	8, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24
170C    09 0A 0A 0B
1710    0C 0C 0D 0E
1714    0E 0F 10 11
1718    12 12 13 14
171C    14 15 16 16
1720    17 17 18 18
1724    07 08 08 08     	DB	7, 8, 8, 8, 9, 9, 10, 11, 11, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24, 24
1728    09 09 0A 0B
172C    0B 0C 0D 0E
1730    0E 0F 10 11
1734    12 12 13 14
1738    15 15 16 17
173C    17 18 18 18
1740    07 07 08 08     	DB	7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24, 25
1744    09 09 0A 0A
1748    0B 0C 0C 0D
174C    0E 0F 10 11
1750    12 13 14 14
1754    15 16 16 17
1758    17 18 18 19
175C    06 07 07 07     	DB	6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 25, 25, 25
1760    08 09 09 0A
1764    0A 0B 0C 0D
1768    0E 0F 10 11
176C    12 13 14 15
1770    16 16 17 17
1774    18 19 19 19
1778    06 06 07 07     	DB	6, 6, 7, 7, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 25, 26
177C    07 08 09 09
1780    0A 0B 0C 0D
1784    0E 0F 10 11
1788    12 13 14 15
178C    16 17 17 18
1790    19 19 19 1A
1794    05 06 06 06     	DB	5, 6, 6, 6, 7, 7, 8, 9, 9, 10, 11, 12, 14, 15, 16, 17, 18, 20, 21, 22, 23, 23, 24, 25, 25, 26, 26, 26
1798    07 07 08 09
179C    09 0A 0B 0C
17A0    0E 0F 10 11
17A4    12 14 15 16
17A8    17 17 18 19
17AC    19 1A 1A 1A
17B0    05 05 05 06     	DB	5, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27
17B4    06 07 07 08
17B8    09 0A 0B 0C
17BC    0D 0F 10 11
17C0    13 14 15 16
17C4    17 18 19 19
17C8    1A 1A 1B 1B
17CC    04 04 05 05     	DB	4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27, 28
17D0    06 06 07 07
17D4    08 09 0A 0B
17D8    0D 0E 10 12
17DC    13 15 16 17
17E0    18 19 19 1A
17E4    1A 1B 1B 1C
17E8    04 04 04 04     	DB	4, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 22, 23, 24, 25, 26, 26, 27, 27, 28, 28, 28
17EC    05 05 06 06
17F0    07 08 09 0A
17F4    0C 0E 10 12
17F8    14 16 17 18
17FC    19 1A 1A 1B
1800    1B 1C 1C 1C
1804    03 03 03 04     	DB	3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 8, 9, 11, 14, 16, 18, 21, 23, 24, 25, 26, 27, 27, 28, 28, 28, 29, 29
1808    04 04 05 05
180C    06 07 08 09
1810    0B 0E 10 12
1814    15 17 18 19
1818    1A 1B 1B 1C
181C    1C 1C 1D 1D
1820    02 02 02 03     	DB	2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 7, 8, 10, 13, 16, 19, 22, 24, 25, 26, 27, 28, 28, 29, 29, 29, 30, 30
1824    03 03 04 04
1828    05 06 07 08
182C    0A 0D 10 13
1830    16 18 19 1A
1834    1B 1C 1C 1D
1838    1D 1D 1E 1E
183C    01 02 02 02     	DB	1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 8, 11, 16, 21, 24, 26, 27, 28, 29, 29, 30, 30, 30, 30, 30, 30
1840    02 02 02 03
1844    03 04 05 06
1848    08 0B 10 15
184C    18 1A 1B 1C
1850    1D 1D 1E 1E
1854    1E 1E 1E 1E
1858    01 01 01 01     	DB	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5, 8, 16, 24, 27, 29, 30, 30, 30, 31, 31, 31, 31, 31, 31, 31
185C    01 01 01 01
1860    02 02 02 03
1864    05 08 10 18
1868    1B 1D 1E 1E
186C    1E 1F 1F 1F
1870    1F 1F 1F 1F
1874    00 00 00 00     	DB	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
1878    00 00 00 00
187C    00 00 00 00
1880    00 00 10 20
1884    20 20 20 20
1888    20 20 20 20
188C    20 20 20 20
1890    3F 3F 3F 3F     	DB	63, 63, 63, 63, 63, 63, 63, 63, 62, 62, 62, 61, 59, 56, 48, 40, 37, 35, 34, 34, 34, 33, 33, 33, 33, 33, 33, 33
1894    3F 3F 3F 3F
1898    3E 3E 3E 3D
189C    3B 38 30 28
18A0    25 23 22 22
18A4    22 21 21 21
18A8    21 21 21 21
18AC    3F 3E 3E 3E     	DB	63, 62, 62, 62, 62, 62, 62, 61, 61, 60, 59, 58, 56, 53, 48, 43, 40, 38, 37, 36, 35, 35, 34, 34, 34, 34, 34, 34
18B0    3E 3E 3E 3D
18B4    3D 3C 3B 3A
18B8    38 35 30 2B
18BC    28 26 25 24
18C0    23 23 22 22
18C4    22 22 22 22
18C8    3E 3E 3E 3D     	DB	62, 62, 62, 61, 61, 61, 60, 60, 59, 58, 57, 56, 54, 51, 48, 45, 42, 40, 39, 38, 37, 36, 36, 35, 35, 35, 34, 34
18CC    3D 3D 3C 3C
18D0    3B 3A 39 38
18D4    36 33 30 2D
18D8    2A 28 27 26
18DC    25 24 24 23
18E0    23 23 22 22
18E4    3D 3D 3D 3C     	DB	61, 61, 61, 60, 60, 60, 59, 59, 58, 57, 56, 55, 53, 50, 48, 46, 43, 41, 40, 39, 38, 37, 37, 36, 36, 36, 35, 35
18E8    3C 3C 3B 3B
18EC    3A 39 38 37
18F0    35 32 30 2E
18F4    2B 29 28 27
18F8    26 25 25 24
18FC    24 24 23 23
1900    3C 3C 3C 3C     	DB	60, 60, 60, 60, 59, 59, 58, 58, 57, 56, 55, 54, 52, 50, 48, 46, 44, 42, 41, 40, 39, 38, 38, 37, 37, 36, 36, 36
1904    3B 3B 3A 3A
1908    39 38 37 36
190C    34 32 30 2E
1910    2C 2A 29 28
1914    27 26 26 25
1918    25 24 24 24
191C    3C 3C 3B 3B     	DB	60, 60, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 51, 50, 48, 46, 45, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37, 36
1920    3A 3A 39 39
1924    38 37 36 35
1928    33 32 30 2E
192C    2D 2B 2A 29
1930    28 27 27 26
1934    26 25 25 24
1938    3B 3B 3B 3A     	DB	59, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 52, 51, 49, 48, 47, 45, 44, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37
193C    3A 39 39 38
1940    37 36 35 34
1944    33 31 30 2F
1948    2D 2C 2B 2A
194C    29 28 27 27
1950    26 26 25 25
1954    3B 3A 3A 3A     	DB	59, 58, 58, 58, 57, 57, 56, 55, 55, 54, 53, 52, 50, 49, 48, 47, 46, 44, 43, 42, 41, 41, 40, 39, 39, 38, 38, 38
1958    39 39 38 37
195C    37 36 35 34
1960    32 31 30 2F
1964    2E 2C 2B 2A
1968    29 29 28 27
196C    27 26 26 26
1970    3A 3A 39 39     	DB	58, 58, 57, 57, 57, 56, 55, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 41, 40, 39, 39, 39, 38
1974    39 38 37 37
1978    36 35 34 33
197C    32 31 30 2F
1980    2E 2D 2C 2B
1984    2A 29 29 28
1988    27 27 27 26
198C    3A 39 39 39     	DB	58, 57, 57, 57, 56, 55, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 42, 41, 41, 40, 39, 39, 39
1990    38 37 37 36
1994    36 35 34 33
1998    32 31 30 2F
199C    2E 2D 2C 2B
19A0    2A 2A 29 29
19A4    28 27 27 27
19A8    39 39 38 38     	DB	57, 57, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 49, 48, 47, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40, 39
19AC    37 37 36 36
19B0    35 34 34 33
19B4    32 31 30 2F
19B8    2E 2D 2C 2C
19BC    2B 2A 2A 29
19C0    29 28 28 27
19C4    39 38 38 38     	DB	57, 56, 56, 56, 55, 55, 54, 53, 53, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 43, 43, 42, 41, 41, 40, 40, 40
19C8    37 37 36 35
19CC    35 34 33 32
19D0    32 31 30 2F
19D4    2E 2E 2D 2C
19D8    2B 2B 2A 29
19DC    29 28 28 28
19E0    38 38 38 37     	DB	56, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40
19E4    37 36 36 35
19E8    34 34 33 32
19EC    32 31 30 2F
19F0    2E 2E 2D 2C
19F4    2C 2B 2A 2A
19F8    29 29 28 28
19FC    38 38 37 37     	DB	56, 56, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 49, 49, 48, 47, 47, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40
1A00    36 36 35 35
1A04    34 34 33 32
1A08    31 31 30 2F
1A0C    2F 2E 2D 2C
1A10    2C 2B 2B 2A
1A14    2A 29 29 28
1A18    38 37 37 36     	DB	56, 55, 55, 54, 54, 54, 53, 52, 52, 51, 51, 50, 49, 49, 48, 47, 47, 46, 45, 45, 44, 44, 43, 42, 42, 42, 41, 41
1A1C    36 36 35 34
1A20    34 33 33 32
1A24    31 31 30 2F
1A28    2F 2E 2D 2D
1A2C    2C 2C 2B 2A
1A30    2A 2A 29 29
1A34    37 37 37 36     	DB	55, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41
1A38    36 35 35 34
1A3C    34 33 32 32
1A40    31 31 30 2F
1A44    2F 2E 2E 2D
1A48    2C 2C 2B 2B
1A4C    2A 2A 29 29
1A50    37 37 36 36     	DB	55, 55, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41
1A54    35 35 34 34
1A58    33 33 32 32
1A5C    31 31 30 2F
1A60    2F 2E 2E 2D
1A64    2D 2C 2C 2B
1A68    2B 2A 2A 29
1A6C    37 36 36 36     	DB	55, 54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 42
1A70    35 35 34 34
1A74    33 33 32 32
1A78    31 31 30 2F
1A7C    2F 2E 2E 2D
1A80    2D 2C 2C 2B
1A84    2B 2A 2A 2A
1A88    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42, 42
1A8C    35 34 34 34
1A90    33 33 32 32
1A94    31 31 30 2F
1A98    2F 2E 2E 2D
1A9C    2D 2C 2C 2C
1AA0    2B 2B 2A 2A
1AA4    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42
1AA8    35 34 34 33
1AAC    33 32 32 32
1AB0    31 31 30 2F
1AB4    2F 2E 2E 2E
1AB8    2D 2D 2C 2C
1ABC    2B 2B 2A 2A
1AC0    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AC4    34 34 34 33
1AC8    33 32 32 31
1ACC    31 31 30 2F
1AD0    2F 2F 2E 2E
1AD4    2D 2D 2C 2C
1AD8    2C 2B 2B 2A
1ADC    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AE0    34 34 34 33
1AE4    33 32 32 31
1AE8    31 31 30 2F
1AEC    2F 2F 2E 2E
1AF0    2D 2D 2C 2C
1AF4    2C 2B 2B 2A
1AF8    36 35 35 35     	DB	54, 53, 53, 53, 52, 52, 51, 51, 51, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 45, 45, 45, 44, 44, 43, 43, 43
1AFC    34 34 33 33
1B00    33 32 32 31
1B04    31 30 30 30
1B08    2F 2F 2E 2E
1B0C    2D 2D 2D 2C
1B10    2C 2B 2B 2B
1B14    35 35 35 34     	DB	53, 53, 53, 52, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 44, 43, 43
1B18    34 34 33 33
1B1C    32 32 32 31
1B20    31 30 30 30
1B24    2F 2F 2E 2E
1B28    2E 2D 2D 2C
1B2C    2C 2C 2B 2B
1B30                    WIDTH_SIZE:
1B30    28              	DB	40
1B31                    CURSOR_Y:
1B31    00              	DB	0
1B32                    CURSOR_X:
1B32    00              	DB	0
1B33                    CURSOR_ADDR:
1B33    00 D0           	DW	0D000h
1B35                    TEXT_VRAM_LIMIT:
1B35    E8 D3           	DW	0D000h + 1000
1B37                    TEXT_VRAM_SIZE:
1B37    E8 03           	DW	1000
1B39
1B39                    ;テキスト横桁数設定
1B39                    ;	LD	A, 40 or 80
1B39                    WIDTH:
1B39    E5              	PUSH	HL
1B3A    32 30 1B        	LD	(WIDTH_SIZE), A
1B3D    FE 28           	CP	40
1B3F    DB E8           	IN	A, (0E8h)
1B41    28 10           	JR	Z, WIDTH_40
1B43    F6 20           	OR	020H	; bit5 Hi WIDTH80
1B45    21 D0 D7        	LD	HL, 0D000h + 2000
1B48    22 35 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B4B    21 D0 07        	LD	HL, 2000
1B4E    22 37 1B        	LD	(TEXT_VRAM_SIZE), HL
1B51    18 0E           	JR	WIDTH_L1
1B53                    WIDTH_40:
1B53    E6 CF           	AND	0CFh	; bit5 Lo WIDTH40
1B55    21 E8 D3        	LD	HL, 0D000h + 1000
1B58    22 35 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B5B    21 E8 03        	LD	HL, 1000
1B5E    22 37 1B        	LD	(TEXT_VRAM_SIZE), HL
1B61                    WIDTH_L1:
1B61    D3 E8           	OUT	(0E8h),A
1B63    E1              	POP	HL
1B64    C9              	RET
1B65
1B65                    ENABLE_TEXT_VRAM_ADDR:
1B65    DB E8           	IN	A,(0E8h)
1B67    E6 3F           	AND	03Fh
1B69    F6 C0           	OR	0C0h
1B6B    D3 E8           	OUT	(0E8h),A
1B6D    C9              	RET
1B6E
1B6E                    DISABLE_VRAM_ADDR:
1B6E    DB E8           	IN	A,(0E8h)
1B70    E6 3F           	AND	03Fh
1B72    D3 E8           	OUT	(0E8h),A
1B74    C9              	RET
1B75
1B75                    ;文字と背景の色とプライオリティ設定
1B75                    ; LD	A, 文字の色(文字優先: 0～7, グラフィック優先: 8～15)
1B75                    ; LD	B, 背景の色(0～7)
1B75                    TEXT_COLOR:
1B75    D3 F5           	OUT	(0F5h), A
1B77    78              	LD	A, B
1B78    D3 F4           	OUT	(0F4h), A
1B7A    C9              	RET
1B7B
1B7B                    ;表示位置設定
1B7B                    ;	LD	D, Y
1B7B                    ;	LD	E, X
1B7B                    CURSOR:
1B7B    F5              	PUSH	AF
1B7C    C5              	PUSH	BC
1B7D    D5              	PUSH	DE
1B7E    E5              	PUSH	HL
1B7F    7A              	LD	A, D
1B80    32 31 1B        	LD	(CURSOR_Y), A
1B83    7B              	LD	A, E
1B84    32 32 1B        	LD	(CURSOR_X), A
1B87    26 00           	LD	H, 0
1B89    6A              	LD	L, D
1B8A    3A 30 1B        	LD	A, (WIDTH_SIZE)
1B8D    FE 28           	CP	40
1B8F    28 05           	JR	Z, CURSOR_WIDTH40
1B91    CD 5F 14        	CALL	MUL_HLx80
1B94    18 03           	JR	CURSOR_L1
1B96                    CURSOR_WIDTH40:
1B96    CD 56 14        	CALL	MUL_HLx40
1B99                    CURSOR_L1:
1B99    16 00           	LD	D, 0
1B9B    19              	ADD	HL, DE
1B9C    11 00 D0        	LD	DE, 0D000h
1B9F    19              	ADD	HL, DE
1BA0    22 33 1B        	LD	(CURSOR_ADDR), HL
1BA3    E1              	POP	HL
1BA4    D1              	POP	DE
1BA5    C1              	POP	BC
1BA6    F1              	POP	AF
1BA7    C9              	RET
1BA8
1BA8                    ;改行
1BA8                    NEW_LINE:
1BA8    3A 31 1B        	LD	A, (CURSOR_Y)
1BAB    3C              	INC	A
1BAC    FE 19           	CP	25
1BAE    FA B6 1B        	JP	M, NEW_LINE_L1
1BB1    3E 18           	LD	A, 24
1BB3    CD 2E 1C        	CALL	SCROLL_UP
1BB6                    NEW_LINE_L1:
1BB6    57              	LD	D, A
1BB7    1E 00           	LD	E, 0
1BB9    CD 7B 1B        	CALL	CURSOR
1BBC    C9              	RET
1BBD
1BBD                    ;一文字表示
1BBD                    ;	LD	HL, 0で終わる文字列へのアドレス
1BBD                    PRINT_MSG1:
1BBD    C5              	PUSH	BC
1BBE    D5              	PUSH	DE
1BBF    E5              	PUSH	HL
1BC0    2A 33 1B        	LD	HL, (CURSOR_ADDR)
1BC3    77              	LD	(HL), A
1BC4    23              	INC	HL
1BC5                    	; 画面右下にはみ出したら一番しての行の左側に戻す
1BC5    E5              	PUSH	HL
1BC6    ED 4B 35 1B     	LD	BC, (TEXT_VRAM_LIMIT)
1BCA    B7              	OR	A
1BCB    ED 42           	SBC	HL, BC
1BCD    E1              	POP	HL
1BCE    38 0F           	JR	C, PRINT_MSG1_L2
1BD0    2A 35 1B        	LD	HL, (TEXT_VRAM_LIMIT)
1BD3    06 00           	LD	B, 0
1BD5    3A 30 1B        	LD	A, (WIDTH_SIZE)
1BD8    4F              	LD	C, A
1BD9    B7              	OR	A
1BDA    ED 42           	SBC	HL, BC
1BDC    CD 2E 1C        	CALL	SCROLL_UP
1BDF                    PRINT_MSG1_L2:
1BDF    22 33 1B        	LD	(CURSOR_ADDR), HL
1BE2    01 00 D0        	LD	BC, 0D000h
1BE5    B7              	OR	A
1BE6    ED 42           	SBC	HL, BC
1BE8    16 00           	LD	D, 0
1BEA    3A 30 1B        	LD	A, (WIDTH_SIZE)
1BED    5F              	LD	E, A
1BEE    CD 75 14        	CALL	DIV16
1BF1    79              	LD	A, C
1BF2    32 31 1B        	LD	(CURSOR_Y), A
1BF5    7D              	LD	A, L
1BF6    32 32 1B        	LD	(CURSOR_X), A
1BF9    E1              	POP	HL
1BFA    D1              	POP	DE
1BFB    C1              	POP	BC
1BFC    C9              	RET
1BFD
1BFD                    ;メッセージを表示
1BFD                    ;	LD	HL, 文字列へのアドレス
1BFD                    PRINT_MSG:
1BFD    E5              	PUSH	HL
1BFE                    PRINT_MSG_L1:
1BFE    7E              	LD	A, (HL)
1BFF    B7              	OR	A
1C00    28 06           	JR	Z, PRINT_MSG_END
1C02    CD BD 1B        	CALL	PRINT_MSG1
1C05    23              	INC	HL
1C06    18 F6           	JR	PRINT_MSG_L1
1C08                    PRINT_MSG_END:
1C08    E1              	POP	HL
1C09    C9              	RET
1C0A
1C0A                    ; Aレジスタの内容を16進表示する
1C0A                    PRINT_HEX:
1C0A    F5              	PUSH	AF
1C0B    CB 3F           	SRL	A
1C0D    CB 3F           	SRL	A
1C0F    CB 3F           	SRL	A
1C11    CB 3F           	SRL	A
1C13    E6 0F           	AND	00FH
1C15    CD 21 1C        	CALL	PRINT_HEX1
1C18    F1              	POP	AF
1C19    F5              	PUSH	AF
1C1A    E6 0F           	AND	00FH
1C1C    CD 21 1C        	CALL	PRINT_HEX1
1C1F    F1              	POP	AF
1C20    C9              	RET
1C21
1C21                    ; Aレジスタの0～Fを表示する
1C21                    PRINT_HEX1:
1C21    F5              	PUSH	AF
1C22    C5              	PUSH	BC
1C23    E5              	PUSH	HL
1C24    CD 82 14        	CALL	A_TO_HEX
1C27    CD BD 1B        	CALL	PRINT_MSG1
1C2A    E1              	POP	HL
1C2B    C1              	POP	BC
1C2C    F1              	POP	AF
1C2D    C9              	RET
1C2E
1C2E                    ; テキスト画面全体を上方向にスクロール
1C2E                    SCROLL_UP:
1C2E    F5              	PUSH	AF
1C2F    C5              	PUSH	BC
1C30    D5              	PUSH	DE
1C31    E5              	PUSH	HL
1C32    3A 30 1B        	LD	A, (WIDTH_SIZE)
1C35    FE 28           	CP	40
1C37    28 05           	JR	Z, SCROLL_UP_L1
1C39    CD 5F 1C        	CALL	SCROLL_UP_WIDTH80
1C3C    18 03           	JR	SCROLL_UP_L2
1C3E                    SCROLL_UP_L1:
1C3E    CD 46 1C        	CALL	SCROLL_UP_WIDTH40
1C41                    SCROLL_UP_L2:
1C41    E1              	POP	HL
1C42    D1              	POP	DE
1C43    C1              	POP	BC
1C44    F1              	POP	AF
1C45    C9              	RET
1C46
1C46                    ; 40桁のテキスト画面全体を上方向にスクロール
1C46                    SCROLL_UP_WIDTH40:
1C46                    	; scroll
1C46    01 C0 03        	LD	BC, 1000 - 40
1C49    21 28 D0        	LD	HL, 0D000h + 40
1C4C    11 00 D0        	LD	DE, 0D000h
1C4F    ED B0           	LDIR
1C51                    	; space
1C51    21 C0 D3        	LD	HL, 0D000h + 1000 - 40
1C54    11 C1 D3        	LD	DE, 0D000h + 1000 - 40 + 1
1C57    01 27 00        	LD	BC, 40 - 1
1C5A    AF              	XOR	A
1C5B    77              	LD	(HL), A
1C5C    ED B0           	LDIR
1C5E    C9              	RET
1C5F
1C5F                    ; 80桁のテキスト画面全体を上方向にスクロール
1C5F                    SCROLL_UP_WIDTH80:
1C5F                    	; scroll
1C5F    01 80 07        	LD	BC, 2000 - 80
1C62    21 50 D0        	LD	HL, 0D000h + 80
1C65    11 00 D0        	LD	DE, 0D000h
1C68    ED B0           	LDIR
1C6A                    	; space
1C6A    21 80 D7        	LD	HL, 0D000h + 2000 - 80
1C6D    11 81 D7        	LD	DE, 0D000h + 2000 - 80 + 1
1C70    01 4F 00        	LD	BC, 80 - 1
1C73    AF              	XOR	A
1C74    77              	LD	(HL), A
1C75    ED B0           	LDIR
1C77    C9              	RET
1C78
1C78                    ; 画面消去
1C78                    CLS:
1C78    3A 30 1B        	LD	A, (WIDTH_SIZE)
1C7B    57              	LD	D, A
1C7C    1E 19           	LD	E, 25
1C7E    3E 20           	LD	A, ' '
1C80    21 00 D0        	LD	HL, 0D000h
1C83    CD 8F 1C        	CALL	DRAW_RECT_TEXT
1C86    11 00 00        	LD	DE, 0
1C89    CD 7B 1B        	CALL	CURSOR
1C8C    C9              	RET
1C8D
1C8D                    ; 桁のテキスト画面で指定した文字で矩形を描く
1C8D                    ; LD	A, 'A' ; 描画文字
1C8D                    ; LD	D, WIDTH
1C8D                    ; LD	E, HEIGHT
1C8D                    ; LD	HL, POSITION
1C8D                    DRAW_RECT_TEXT_ADD_X:
1C8D    00 00           	DW	0
1C8F                    DRAW_RECT_TEXT:
1C8F    C5              	PUSH	BC
1C90    E5              	PUSH	HL
1C91                    DRAW_RECT_TEXT_WIDTH:
1C91    F5              	PUSH	AF
1C92    3A 30 1B        	LD	A, (WIDTH_SIZE)
1C95    92              	SUB	D
1C96    06 00           	LD	B, 0
1C98    4F              	LD	C, A
1C99    ED 43 8D 1C     	LD	(DRAW_RECT_TEXT_ADD_X), BC
1C9D    F1              	POP	AF
1C9E    43              	LD	B, E
1C9F                    DRAW_RECT_TEXT_1:
1C9F    4A              	LD	C, D
1CA0                    DRAW_RECT_TEXT_2:
1CA0    77              	LD	(HL), A
1CA1    23              	INC	HL
1CA2    0D              	DEC	C
1CA3    20 FB           	JR	NZ, DRAW_RECT_TEXT_2
1CA5    C5              	PUSH	BC
1CA6    ED 4B 8D 1C     	LD	BC, (DRAW_RECT_TEXT_ADD_X)
1CAA    09              	ADD	HL, BC
1CAB    C1              	POP	BC
1CAC    05              	DEC	B
1CAD    20 F0           	JR	NZ, DRAW_RECT_TEXT_1
1CAF    E1              	POP	HL
1CB0    C1              	POP	BC
1CB1    C9              	RET
1CB2                    ; GRAMアドレス有効
1CB2                    ENABLE_GRAPHIC_ADDR:
1CB2    DB E8           	IN	A, (0E8h)
1CB4    E6 3F           	AND	03Fh
1CB6    F6 80           	OR	080h
1CB8    D3 E8           	OUT	(0E8h), A
1CBA    C9              	RET
1CBB
1CBB                    ; GRAMアドレス無効
1CBB                    DISABLE_GRAPHIC_ADDR:
1CBB    DB E8           	IN	A, (0E8h)
1CBD    E6 7F           	AND	07Fh
1CBF    D3 E8           	OUT	(0E8h), A
1CC1    C9              	RET
1CC2
1CC2                    ; グラフィックス画面を3ページとも消去する
1CC2                    GRAPHICS_CLS_ALL:
1CC2    3E 01           	LD	A, 1
1CC4    D3 F7           	OUT	(0F7h), A
1CC6    CD D8 1C        	CALL	GRAPHICS_CLS
1CC9    3E 02           	LD	A, 2
1CCB    D3 F7           	OUT	(0F7h), A
1CCD    CD D8 1C        	CALL	GRAPHICS_CLS
1CD0    3E 03           	LD	A, 3
1CD2    D3 F7           	OUT	(0F7h), A
1CD4    CD D8 1C        	CALL	GRAPHICS_CLS
1CD7    C9              	RET
1CD8
1CD8                    ; グラフィックス画面を1ページ分消去する
1CD8                    GRAPHICS_CLS:
1CD8    21 00 C0        	LD	HL, 0C000h
1CDB    01 80 3E        	LD	BC, 16000
1CDE                    GRAPHICS_CLS_L1:
1CDE    36 00           	LD	(HL), 0
1CE0    23              	INC	HL
1CE1    0B              	DEC	BC
1CE2    78              	LD	A, B
1CE3    B1              	OR	C
1CE4    20 F8           	JR	NZ, GRAPHICS_CLS_L1
1CE6    C9              	RET
1CE7
1CE7                    ;16x2(4) 8色を転送する
1CE7                    ;	LD	DE, POSITION
1CE7                    ;	LD	HL, PATTERN
1CE7                    PUT16x2x8:
1CE7    D5              	PUSH	DE
1CE8    ED 73 2E 1D     	LD	(PUT16x2x8_RESTORE_STACK + 1), SP
1CEC                    	; B
1CEC    3E 01           	LD	A, 1
1CEE    D3 F7           	OUT	(0F7h), A
1CF0    F9              	LD	SP, HL
1CF1    EB              	EX	DE, HL
1CF2    D1              	POP	DE
1CF3    73              	LD	(HL), E
1CF4    23              	INC	HL
1CF5    72              	LD	(HL), D
1CF6    23              	INC	HL
1CF7    01 9E 00        	LD	BC, 158
1CFA    09              	ADD	HL, BC
1CFB    D1              	POP	DE
1CFC    73              	LD	(HL), E
1CFD    23              	INC	HL
1CFE    72              	LD	(HL), D
1CFF                    	; R
1CFF    3E 02           	LD	A, 2
1D01    D3 F7           	OUT	(0F7h), A
1D03    01 A1 00        	LD	BC, 161
1D06    B7              	OR	A
1D07    ED 42           	SBC	HL, BC
1D09    D1              	POP	DE
1D0A    73              	LD	(HL), E
1D0B    23              	INC	HL
1D0C    72              	LD	(HL), D
1D0D    23              	INC	HL
1D0E    01 9E 00        	LD	BC, 158
1D11    09              	ADD	HL, BC
1D12    D1              	POP	DE
1D13    73              	LD	(HL), E
1D14    23              	INC	HL
1D15    72              	LD	(HL), D
1D16                    	; G
1D16    3E 03           	LD	A, 3
1D18    D3 F7           	OUT	(0F7h), A
1D1A    01 A1 00        	LD	BC, 161
1D1D    B7              	OR	A
1D1E    ED 42           	SBC	HL, BC
1D20    D1              	POP	DE
1D21    73              	LD	(HL), E
1D22    23              	INC	HL
1D23    72              	LD	(HL), D
1D24    23              	INC	HL
1D25    01 9E 00        	LD	BC, 158
1D28    09              	ADD	HL, BC
1D29    D1              	POP	DE
1D2A    73              	LD	(HL), E
1D2B    23              	INC	HL
1D2C    72              	LD	(HL), D
1D2D                    PUT16x2x8_RESTORE_STACK:
1D2D    31 00 00        	LD	SP, 0000
1D30    D1              	POP	DE
1D31    C9              	RET
1D32
1D32                    ;16x2(4)単色を転送する
1D32                    ;	LD	DE, POSITION
1D32                    ;	LD	HL, PATTERN
1D32                    PUT16x2:
1D32    D5              	PUSH	DE
1D33    ED 73 47 1D     	LD	(PUT16x2_RESTORE_STACK + 1), SP
1D37    F9              	LD	SP, HL
1D38    EB              	EX	DE, HL
1D39    D1              	POP	DE
1D3A    73              	LD	(HL), E
1D3B    23              	INC	HL
1D3C    72              	LD	(HL), D
1D3D    23              	INC	HL
1D3E    01 9E 00        	LD	BC, 158
1D41    09              	ADD	HL, BC
1D42    D1              	POP	DE
1D43    73              	LD	(HL), E
1D44    23              	INC	HL
1D45    72              	LD	(HL), D
1D46                    PUT16x2_RESTORE_STACK:
1D46    31 00 00        	LD	SP, 0000
1D49    D1              	POP	DE
1D4A    C9              	RET
1D4B
1D4B                    ;16x4単色を転送する
1D4B                    ;	LD	DE, POSITION
1D4B                    ;	LD	HL, PATTERN
1D4B                    PUT16x4:
1D4B    C5              	PUSH	BC
1D4C    D5              	PUSH	DE
1D4D    E5              	PUSH	HL
1D4E    ED 73 6E 1D     	LD	(PUT16x4_RESTORE_STACK + 1), SP
1D52    F9              	LD	SP, HL
1D53    EB              	EX	DE, HL
1D54    01 4E 00        	LD	BC, 78
1D57    D1              	POP	DE
1D58    73              	LD	(HL), E
1D59    23              	INC	HL
1D5A    72              	LD	(HL), D
1D5B    23              	INC	HL
1D5C    09              	ADD	HL, BC
1D5D    D1              	POP	DE
1D5E    73              	LD	(HL), E
1D5F    23              	INC	HL
1D60    72              	LD	(HL), D
1D61    23              	INC	HL
1D62    09              	ADD	HL, BC
1D63    D1              	POP	DE
1D64    73              	LD	(HL), E
1D65    23              	INC	HL
1D66    72              	LD	(HL), D
1D67    23              	INC	HL
1D68    09              	ADD	HL, BC
1D69    D1              	POP	DE
1D6A    73              	LD	(HL), E
1D6B    23              	INC	HL
1D6C    72              	LD	(HL), D
1D6D                    PUT16x4_RESTORE_STACK:
1D6D    31 00 00        	LD	SP, 0000
1D70    E1              	POP	HL
1D71    D1              	POP	DE
1D72    C1              	POP	BC
1D73    C9              	RET
1D74
1D74                    ;8x4単色をAND転送する
1D74                    ;	LD	DE, POSITION
1D74                    ;	LD	HL, PATTERN
1D74                    PUT_AND_8x4:
1D74    C5              	PUSH	BC
1D75    D5              	PUSH	DE
1D76    E5              	PUSH	HL
1D77    ED 73 92 1D     	LD	(PUT_AND_8x4_RESTORE_STACK + 1), SP
1D7B    F9              	LD	SP, HL
1D7C    EB              	EX	DE, HL
1D7D    01 50 00        	LD	BC, 80
1D80    D1              	POP	DE
1D81    7B              	LD	A, E
1D82    A6              	AND	(HL)
1D83    77              	LD	(HL), A
1D84    09              	ADD	HL, BC
1D85    7A              	LD	A, D
1D86    A6              	AND	(HL)
1D87    77              	LD	(HL), A
1D88    09              	ADD	HL, BC
1D89    D1              	POP	DE
1D8A    7B              	LD	A, E
1D8B    A6              	AND	(HL)
1D8C    77              	LD	(HL), A
1D8D    09              	ADD	HL, BC
1D8E    7A              	LD	A, D
1D8F    A6              	AND	(HL)
1D90    77              	LD	(HL), A
1D91                    PUT_AND_8x4_RESTORE_STACK:
1D91    31 00 00        	LD	SP, 0000
1D94    E1              	POP	HL
1D95    D1              	POP	DE
1D96    C1              	POP	BC
1D97    C9              	RET
1D98
1D98                    ;8x4単色を32x4の左端右端にAND転送する
1D98                    ;	LD	DE, POSITION
1D98                    ;	LD	HL, PATTERN
1D98                    PUT_AND_ZAPPER:
1D98    C5              	PUSH	BC
1D99    D5              	PUSH	DE
1D9A    E5              	PUSH	HL
1D9B    ED 73 D0 1D     	LD	(PUT_AND_ZAPPER_RESTORE_STACK + 1), SP
1D9F    F9              	LD	SP, HL
1DA0    EB              	EX	DE, HL
1DA1    01 4D 00        	LD	BC, 77
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
1DC4    09              	ADD	HL, BC
1DC5    D1              	POP	DE
1DC6    7B              	LD	A, E
1DC7    A6              	AND	(HL)
1DC8    77              	LD	(HL), A
1DC9    23              	INC	HL
1DCA    23              	INC	HL
1DCB    23              	INC	HL
1DCC    7A              	LD	A, D
1DCD    A6              	AND	(HL)
1DCE    77              	LD	(HL), A
1DCF                    PUT_AND_ZAPPER_RESTORE_STACK:
1DCF    31 00 00        	LD	SP, 0000
1DD2    E1              	POP	HL
1DD3    D1              	POP	DE
1DD4    C1              	POP	BC
1DD5    C9              	RET
1DD6
1DD6                    ;16x4単色をクリアする
1DD6                    ;	LD	HL, POSITION
1DD6                    CLEAR16x4:
1DD6    AF              	XOR	A
1DD7    01 4F 00        	LD	BC, 79
1DDA    77              	LD	(HL), A
1DDB    23              	INC	HL
1DDC    77              	LD	(HL), A
1DDD    09              	ADD	HL, BC
1DDE    77              	LD	(HL), A
1DDF    23              	INC	HL
1DE0    77              	LD	(HL), A
1DE1    09              	ADD	HL, BC
1DE2    77              	LD	(HL), A
1DE3    23              	INC	HL
1DE4    77              	LD	(HL), A
1DE5    09              	ADD	HL, BC
1DE6    77              	LD	(HL), A
1DE7    23              	INC	HL
1DE8    77              	LD	(HL), A
1DE9    C9              	RET
1DEA
1DEA                    ;16x4 青と赤プレーンをクリアする
1DEA                    ;	LD	DE, POSITION
1DEA                    CLEAR16x4_BR:
1DEA    E5              	PUSH	HL
1DEB    C5              	PUSH	BC
1DEC    62              	LD	H, D
1DED    6B              	LD	L, E
1DEE    3E 01           	LD	A, 1
1DF0    D3 F7           	OUT	(0F7h), A
1DF2    CD D6 1D        	CALL	CLEAR16x4
1DF5    62              	LD	H, D
1DF6    6B              	LD	L, E
1DF7    3E 02           	LD	A, 2
1DF9    D3 F7           	OUT	(0F7h), A
1DFB    CD D6 1D        	CALL	CLEAR16x4
1DFE    C1              	POP	BC
1DFF    E1              	POP	HL
1E00    C9              	RET
1E01
1E01                    ;16x8単色を転送する
1E01                    ;	LD	DE, POSITION
1E01                    ;	LD	HL, PATTERN
1E01                    PUT16x8:
1E01    ED 73 32 1E     	LD	(PUT16x8_RESTORE_STACK + 1), SP
1E05    F9              	LD	SP, HL
1E06    EB              	EX	DE, HL
1E07    01 4F 00        	LD	BC, 79
1E0A    D1              	POP	DE
1E0B    73              	LD	(HL), E
1E0C    23              	INC	HL
1E0D    72              	LD	(HL), D
1E0E    09              	ADD	HL, BC
1E0F    D1              	POP	DE
1E10    73              	LD	(HL), E
1E11    23              	INC	HL
1E12    72              	LD	(HL), D
1E13    09              	ADD	HL, BC
1E14    D1              	POP	DE
1E15    73              	LD	(HL), E
1E16    23              	INC	HL
1E17    72              	LD	(HL), D
1E18    09              	ADD	HL, BC
1E19    D1              	POP	DE
1E1A    73              	LD	(HL), E
1E1B    23              	INC	HL
1E1C    72              	LD	(HL), D
1E1D    09              	ADD	HL, BC
1E1E    D1              	POP	DE
1E1F    73              	LD	(HL), E
1E20    23              	INC	HL
1E21    72              	LD	(HL), D
1E22    09              	ADD	HL, BC
1E23    D1              	POP	DE
1E24    73              	LD	(HL), E
1E25    23              	INC	HL
1E26    72              	LD	(HL), D
1E27    09              	ADD	HL, BC
1E28    D1              	POP	DE
1E29    73              	LD	(HL), E
1E2A    23              	INC	HL
1E2B    72              	LD	(HL), D
1E2C    09              	ADD	HL, BC
1E2D    D1              	POP	DE
1E2E    73              	LD	(HL), E
1E2F    23              	INC	HL
1E30    72              	LD	(HL), D
1E31                    PUT16x8_RESTORE_STACK:
1E31    31 00 00        	LD	SP, 0000
1E34    C9              	RET
1E35
1E35                    ;32x4単色を転送する
1E35                    ;	LD	DE, POSITION
1E35                    ;	LD	HL, PATTERN
1E35                    PUT32x4:
1E35    ED 73 66 1E     	LD	(PUT32x4_RESTORE_STACK + 1), SP
1E39    F9              	LD	SP, HL
1E3A    EB              	EX	DE, HL
1E3B    01 4D 00        	LD	BC, 77
1E3E    D1              	POP	DE
1E3F    73              	LD	(HL), E
1E40    23              	INC	HL
1E41    72              	LD	(HL), D
1E42    23              	INC	HL
1E43    D1              	POP	DE
1E44    73              	LD	(HL), E
1E45    23              	INC	HL
1E46    72              	LD	(HL), D
1E47    09              	ADD	HL, BC
1E48    D1              	POP	DE
1E49    73              	LD	(HL), E
1E4A    23              	INC	HL
1E4B    72              	LD	(HL), D
1E4C    23              	INC	HL
1E4D    D1              	POP	DE
1E4E    73              	LD	(HL), E
1E4F    23              	INC	HL
1E50    72              	LD	(HL), D
1E51    09              	ADD	HL, BC
1E52    D1              	POP	DE
1E53    73              	LD	(HL), E
1E54    23              	INC	HL
1E55    72              	LD	(HL), D
1E56    23              	INC	HL
1E57    D1              	POP	DE
1E58    73              	LD	(HL), E
1E59    23              	INC	HL
1E5A    72              	LD	(HL), D
1E5B    09              	ADD	HL, BC
1E5C    D1              	POP	DE
1E5D    73              	LD	(HL), E
1E5E    23              	INC	HL
1E5F    72              	LD	(HL), D
1E60    23              	INC	HL
1E61    D1              	POP	DE
1E62    73              	LD	(HL), E
1E63    23              	INC	HL
1E64    72              	LD	(HL), D
1E65                    PUT32x4_RESTORE_STACK:
1E65    31 00 00        	LD	SP, 0000
1E68    C9              	RET
1E69
1E69                    ;32x4単色をAND転送する
1E69                    ;	LD	HL, POSITION
1E69                    ;	LD	DE, PATTERN
1E69                    PUT_AND_32x4:
1E69    ED 73 BA 1E     	LD	(PUT_AND_32x4_RESTORE_STACK + 1), SP
1E6D    F9              	LD	SP, HL
1E6E    EB              	EX	DE, HL
1E6F    01 4D 00        	LD	BC, 77
1E72    D1              	POP	DE
1E73    7B              	LD	A, E
1E74    A6              	AND	(HL)
1E75    77              	LD	(HL), A
1E76    23              	INC	HL
1E77    7A              	LD	A, D
1E78    A6              	AND	(HL)
1E79    77              	LD	(HL), A
1E7A    23              	INC	HL
1E7B    D1              	POP	DE
1E7C    7B              	LD	A, E
1E7D    A6              	AND	(HL)
1E7E    77              	LD	(HL), A
1E7F    23              	INC	HL
1E80    7A              	LD	A, D
1E81    A6              	AND	(HL)
1E82    77              	LD	(HL), A
1E83    09              	ADD	HL, BC
1E84    D1              	POP	DE
1E85    7B              	LD	A, E
1E86    A6              	AND	(HL)
1E87    77              	LD	(HL), A
1E88    23              	INC	HL
1E89    7A              	LD	A, D
1E8A    A6              	AND	(HL)
1E8B    77              	LD	(HL), A
1E8C    23              	INC	HL
1E8D    D1              	POP	DE
1E8E    7B              	LD	A, E
1E8F    A6              	AND	(HL)
1E90    77              	LD	(HL), A
1E91    23              	INC	HL
1E92    7A              	LD	A, D
1E93    A6              	AND	(HL)
1E94    77              	LD	(HL), A
1E95    09              	ADD	HL, BC
1E96    D1              	POP	DE
1E97    7B              	LD	A, E
1E98    A6              	AND	(HL)
1E99    77              	LD	(HL), A
1E9A    23              	INC	HL
1E9B    7A              	LD	A, D
1E9C    A6              	AND	(HL)
1E9D    77              	LD	(HL), A
1E9E    23              	INC	HL
1E9F    D1              	POP	DE
1EA0    7B              	LD	A, E
1EA1    A6              	AND	(HL)
1EA2    77              	LD	(HL), A
1EA3    23              	INC	HL
1EA4    7A              	LD	A, D
1EA5    A6              	AND	(HL)
1EA6    77              	LD	(HL), A
1EA7    09              	ADD	HL, BC
1EA8    D1              	POP	DE
1EA9    7B              	LD	A, E
1EAA    A6              	AND	(HL)
1EAB    77              	LD	(HL), A
1EAC    23              	INC	HL
1EAD    7A              	LD	A, D
1EAE    A6              	AND	(HL)
1EAF    77              	LD	(HL), A
1EB0    23              	INC	HL
1EB1    D1              	POP	DE
1EB2    7B              	LD	A, E
1EB3    A6              	AND	(HL)
1EB4    77              	LD	(HL), A
1EB5    23              	INC	HL
1EB6    7A              	LD	A, D
1EB7    A6              	AND	(HL)
1EB8    77              	LD	(HL), A
1EB9                    PUT_AND_32x4_RESTORE_STACK:
1EB9    31 00 00        	LD	SP, 0000
1EBC    C9              	RET
1EBD
1EBD                    ;32x4単色をOR転送する
1EBD                    ;	LD	HL, POSITION
1EBD                    ;	LD	DE, PATTERN
1EBD                    PUT_OR_32x4:
1EBD    ED 73 0E 1F     	LD	(PUT_OR_32x4_RESTORE_STACK + 1), SP
1EC1    F9              	LD	SP, HL
1EC2    EB              	EX	DE, HL
1EC3    01 4D 00        	LD	BC, 77
1EC6    D1              	POP	DE
1EC7    7B              	LD	A, E
1EC8    B6              	OR	(HL)
1EC9    77              	LD	(HL), A
1ECA    23              	INC	HL
1ECB    7A              	LD	A, D
1ECC    B6              	OR	(HL)
1ECD    77              	LD	(HL), A
1ECE    23              	INC	HL
1ECF    D1              	POP	DE
1ED0    7B              	LD	A, E
1ED1    B6              	OR	(HL)
1ED2    77              	LD	(HL), A
1ED3    23              	INC	HL
1ED4    7A              	LD	A, D
1ED5    B6              	OR	(HL)
1ED6    77              	LD	(HL), A
1ED7    09              	ADD	HL, BC
1ED8    D1              	POP	DE
1ED9    7B              	LD	A, E
1EDA    B6              	OR	(HL)
1EDB    77              	LD	(HL), A
1EDC    23              	INC	HL
1EDD    7A              	LD	A, D
1EDE    B6              	OR	(HL)
1EDF    77              	LD	(HL), A
1EE0    23              	INC	HL
1EE1    D1              	POP	DE
1EE2    7B              	LD	A, E
1EE3    B6              	OR	(HL)
1EE4    77              	LD	(HL), A
1EE5    23              	INC	HL
1EE6    7A              	LD	A, D
1EE7    B6              	OR	(HL)
1EE8    77              	LD	(HL), A
1EE9    09              	ADD	HL, BC
1EEA    D1              	POP	DE
1EEB    7B              	LD	A, E
1EEC    B6              	OR	(HL)
1EED    77              	LD	(HL), A
1EEE    23              	INC	HL
1EEF    7A              	LD	A, D
1EF0    B6              	OR	(HL)
1EF1    77              	LD	(HL), A
1EF2    23              	INC	HL
1EF3    D1              	POP	DE
1EF4    7B              	LD	A, E
1EF5    B6              	OR	(HL)
1EF6    77              	LD	(HL), A
1EF7    23              	INC	HL
1EF8    7A              	LD	A, D
1EF9    B6              	OR	(HL)
1EFA    77              	LD	(HL), A
1EFB    09              	ADD	HL, BC
1EFC    D1              	POP	DE
1EFD    7B              	LD	A, E
1EFE    B6              	OR	(HL)
1EFF    77              	LD	(HL), A
1F00    23              	INC	HL
1F01    7A              	LD	A, D
1F02    B6              	OR	(HL)
1F03    77              	LD	(HL), A
1F04    23              	INC	HL
1F05    D1              	POP	DE
1F06    7B              	LD	A, E
1F07    B6              	OR	(HL)
1F08    77              	LD	(HL), A
1F09    23              	INC	HL
1F0A    7A              	LD	A, D
1F0B    B6              	OR	(HL)
1F0C    77              	LD	(HL), A
1F0D                    PUT_OR_32x4_RESTORE_STACK:
1F0D    31 00 00        	LD	SP, 0000
1F10    C9              	RET
1F11
1F11                    ;32x16単色を転送する
1F11                    ;	LD	DE, POSITION
1F11                    ;	LD	HL, PATTERN
1F11                    PUT32x16:
1F11    ED 73 BA 1F     	LD	(PUT32x16_RESTORE_STACK + 1), SP
1F15    F9              	LD	SP, HL
1F16    EB              	EX	DE, HL
1F17    01 4D 00        	LD	BC, 77
1F1A    D1              	POP	DE
1F1B    73              	LD	(HL), E
1F1C    23              	INC	HL
1F1D    72              	LD	(HL), D
1F1E    23              	INC	HL
1F1F    D1              	POP	DE
1F20    73              	LD	(HL), E
1F21    23              	INC	HL
1F22    72              	LD	(HL), D
1F23    09              	ADD	HL, BC
1F24    D1              	POP	DE
1F25    73              	LD	(HL), E
1F26    23              	INC	HL
1F27    72              	LD	(HL), D
1F28    23              	INC	HL
1F29    D1              	POP	DE
1F2A    73              	LD	(HL), E
1F2B    23              	INC	HL
1F2C    72              	LD	(HL), D
1F2D    09              	ADD	HL, BC
1F2E    D1              	POP	DE
1F2F    73              	LD	(HL), E
1F30    23              	INC	HL
1F31    72              	LD	(HL), D
1F32    23              	INC	HL
1F33    D1              	POP	DE
1F34    73              	LD	(HL), E
1F35    23              	INC	HL
1F36    72              	LD	(HL), D
1F37    09              	ADD	HL, BC
1F38    D1              	POP	DE
1F39    73              	LD	(HL), E
1F3A    23              	INC	HL
1F3B    72              	LD	(HL), D
1F3C    23              	INC	HL
1F3D    D1              	POP	DE
1F3E    73              	LD	(HL), E
1F3F    23              	INC	HL
1F40    72              	LD	(HL), D
1F41    09              	ADD	HL, BC
1F42    D1              	POP	DE
1F43    73              	LD	(HL), E
1F44    23              	INC	HL
1F45    72              	LD	(HL), D
1F46    23              	INC	HL
1F47    D1              	POP	DE
1F48    73              	LD	(HL), E
1F49    23              	INC	HL
1F4A    72              	LD	(HL), D
1F4B    09              	ADD	HL, BC
1F4C    D1              	POP	DE
1F4D    73              	LD	(HL), E
1F4E    23              	INC	HL
1F4F    72              	LD	(HL), D
1F50    23              	INC	HL
1F51    D1              	POP	DE
1F52    73              	LD	(HL), E
1F53    23              	INC	HL
1F54    72              	LD	(HL), D
1F55    09              	ADD	HL, BC
1F56    D1              	POP	DE
1F57    73              	LD	(HL), E
1F58    23              	INC	HL
1F59    72              	LD	(HL), D
1F5A    23              	INC	HL
1F5B    D1              	POP	DE
1F5C    73              	LD	(HL), E
1F5D    23              	INC	HL
1F5E    72              	LD	(HL), D
1F5F    09              	ADD	HL, BC
1F60    D1              	POP	DE
1F61    73              	LD	(HL), E
1F62    23              	INC	HL
1F63    72              	LD	(HL), D
1F64    23              	INC	HL
1F65    D1              	POP	DE
1F66    73              	LD	(HL), E
1F67    23              	INC	HL
1F68    72              	LD	(HL), D
1F69    09              	ADD	HL, BC
1F6A    D1              	POP	DE
1F6B    73              	LD	(HL), E
1F6C    23              	INC	HL
1F6D    72              	LD	(HL), D
1F6E    23              	INC	HL
1F6F    D1              	POP	DE
1F70    73              	LD	(HL), E
1F71    23              	INC	HL
1F72    72              	LD	(HL), D
1F73    09              	ADD	HL, BC
1F74    D1              	POP	DE
1F75    73              	LD	(HL), E
1F76    23              	INC	HL
1F77    72              	LD	(HL), D
1F78    23              	INC	HL
1F79    D1              	POP	DE
1F7A    73              	LD	(HL), E
1F7B    23              	INC	HL
1F7C    72              	LD	(HL), D
1F7D    09              	ADD	HL, BC
1F7E    D1              	POP	DE
1F7F    73              	LD	(HL), E
1F80    23              	INC	HL
1F81    72              	LD	(HL), D
1F82    23              	INC	HL
1F83    D1              	POP	DE
1F84    73              	LD	(HL), E
1F85    23              	INC	HL
1F86    72              	LD	(HL), D
1F87    09              	ADD	HL, BC
1F88    D1              	POP	DE
1F89    73              	LD	(HL), E
1F8A    23              	INC	HL
1F8B    72              	LD	(HL), D
1F8C    23              	INC	HL
1F8D    D1              	POP	DE
1F8E    73              	LD	(HL), E
1F8F    23              	INC	HL
1F90    72              	LD	(HL), D
1F91    09              	ADD	HL, BC
1F92    D1              	POP	DE
1F93    73              	LD	(HL), E
1F94    23              	INC	HL
1F95    72              	LD	(HL), D
1F96    23              	INC	HL
1F97    D1              	POP	DE
1F98    73              	LD	(HL), E
1F99    23              	INC	HL
1F9A    72              	LD	(HL), D
1F9B    09              	ADD	HL, BC
1F9C    D1              	POP	DE
1F9D    73              	LD	(HL), E
1F9E    23              	INC	HL
1F9F    72              	LD	(HL), D
1FA0    23              	INC	HL
1FA1    D1              	POP	DE
1FA2    73              	LD	(HL), E
1FA3    23              	INC	HL
1FA4    72              	LD	(HL), D
1FA5    09              	ADD	HL, BC
1FA6    D1              	POP	DE
1FA7    73              	LD	(HL), E
1FA8    23              	INC	HL
1FA9    72              	LD	(HL), D
1FAA    23              	INC	HL
1FAB    D1              	POP	DE
1FAC    73              	LD	(HL), E
1FAD    23              	INC	HL
1FAE    72              	LD	(HL), D
1FAF    09              	ADD	HL, BC
1FB0    D1              	POP	DE
1FB1    73              	LD	(HL), E
1FB2    23              	INC	HL
1FB3    72              	LD	(HL), D
1FB4    23              	INC	HL
1FB5    D1              	POP	DE
1FB6    73              	LD	(HL), E
1FB7    23              	INC	HL
1FB8    72              	LD	(HL), D
1FB9                    PUT32x16_RESTORE_STACK:
1FB9    31 00 00        	LD	SP, 0000
1FBC    C9              	RET
1FBD
1FBD                    ;32x16単色をAND転送する
1FBD                    ;	LD	DE, POSITION
1FBD                    ;	LD	HL, PATTERN
1FBD                    PUT_AND_32x16:
1FBD    ED 73 ED 20     	LD	(PUT_AND_32x16_RESTORE_STACK + 1), SP
1FC1    F9              	LD	SP, HL
1FC2    EB              	EX	DE, HL
1FC3    01 4D 00        	LD	BC, 77
1FC6    D1              	POP	DE
1FC7    7B              	LD	A, E
1FC8    A6              	AND	(HL)
1FC9    77              	LD	(HL), A
1FCA    23              	INC	HL
1FCB    7A              	LD	A, D
1FCC    A6              	AND	(HL)
1FCD    77              	LD	(HL), A
1FCE    23              	INC	HL
1FCF    D1              	POP	DE
1FD0    7B              	LD	A, E
1FD1    A6              	AND	(HL)
1FD2    77              	LD	(HL), A
1FD3    23              	INC	HL
1FD4    7A              	LD	A, D
1FD5    A6              	AND	(HL)
1FD6    77              	LD	(HL), A
1FD7    09              	ADD	HL, BC
1FD8    D1              	POP	DE
1FD9    7B              	LD	A, E
1FDA    A6              	AND	(HL)
1FDB    77              	LD	(HL), A
1FDC    23              	INC	HL
1FDD    7A              	LD	A, D
1FDE    A6              	AND	(HL)
1FDF    77              	LD	(HL), A
1FE0    23              	INC	HL
1FE1    D1              	POP	DE
1FE2    7B              	LD	A, E
1FE3    A6              	AND	(HL)
1FE4    77              	LD	(HL), A
1FE5    23              	INC	HL
1FE6    7A              	LD	A, D
1FE7    A6              	AND	(HL)
1FE8    77              	LD	(HL), A
1FE9    09              	ADD	HL, BC
1FEA    D1              	POP	DE
1FEB    7B              	LD	A, E
1FEC    A6              	AND	(HL)
1FED    77              	LD	(HL), A
1FEE    23              	INC	HL
1FEF    7A              	LD	A, D
1FF0    A6              	AND	(HL)
1FF1    77              	LD	(HL), A
1FF2    23              	INC	HL
1FF3    D1              	POP	DE
1FF4    7B              	LD	A, E
1FF5    A6              	AND	(HL)
1FF6    77              	LD	(HL), A
1FF7    23              	INC	HL
1FF8    7A              	LD	A, D
1FF9    A6              	AND	(HL)
1FFA    77              	LD	(HL), A
1FFB    09              	ADD	HL, BC
1FFC    D1              	POP	DE
1FFD    7B              	LD	A, E
1FFE    A6              	AND	(HL)
1FFF    77              	LD	(HL), A
2000    23              	INC	HL
2001    7A              	LD	A, D
2002    A6              	AND	(HL)
2003    77              	LD	(HL), A
2004    23              	INC	HL
2005    D1              	POP	DE
2006    7B              	LD	A, E
2007    A6              	AND	(HL)
2008    77              	LD	(HL), A
2009    23              	INC	HL
200A    7A              	LD	A, D
200B    A6              	AND	(HL)
200C    77              	LD	(HL), A
200D    09              	ADD	HL, BC
200E    D1              	POP	DE
200F    7B              	LD	A, E
2010    A6              	AND	(HL)
2011    77              	LD	(HL), A
2012    23              	INC	HL
2013    7A              	LD	A, D
2014    A6              	AND	(HL)
2015    77              	LD	(HL), A
2016    23              	INC	HL
2017    D1              	POP	DE
2018    7B              	LD	A, E
2019    A6              	AND	(HL)
201A    77              	LD	(HL), A
201B    23              	INC	HL
201C    7A              	LD	A, D
201D    A6              	AND	(HL)
201E    77              	LD	(HL), A
201F    09              	ADD	HL, BC
2020    D1              	POP	DE
2021    7B              	LD	A, E
2022    A6              	AND	(HL)
2023    77              	LD	(HL), A
2024    23              	INC	HL
2025    7A              	LD	A, D
2026    A6              	AND	(HL)
2027    77              	LD	(HL), A
2028    23              	INC	HL
2029    D1              	POP	DE
202A    7B              	LD	A, E
202B    A6              	AND	(HL)
202C    77              	LD	(HL), A
202D    23              	INC	HL
202E    7A              	LD	A, D
202F    A6              	AND	(HL)
2030    77              	LD	(HL), A
2031    09              	ADD	HL, BC
2032    D1              	POP	DE
2033    7B              	LD	A, E
2034    A6              	AND	(HL)
2035    77              	LD	(HL), A
2036    23              	INC	HL
2037    7A              	LD	A, D
2038    A6              	AND	(HL)
2039    77              	LD	(HL), A
203A    23              	INC	HL
203B    D1              	POP	DE
203C    7B              	LD	A, E
203D    A6              	AND	(HL)
203E    77              	LD	(HL), A
203F    23              	INC	HL
2040    7A              	LD	A, D
2041    A6              	AND	(HL)
2042    77              	LD	(HL), A
2043    09              	ADD	HL, BC
2044    D1              	POP	DE
2045    7B              	LD	A, E
2046    A6              	AND	(HL)
2047    77              	LD	(HL), A
2048    23              	INC	HL
2049    7A              	LD	A, D
204A    A6              	AND	(HL)
204B    77              	LD	(HL), A
204C    23              	INC	HL
204D    D1              	POP	DE
204E    7B              	LD	A, E
204F    A6              	AND	(HL)
2050    77              	LD	(HL), A
2051    23              	INC	HL
2052    7A              	LD	A, D
2053    A6              	AND	(HL)
2054    77              	LD	(HL), A
2055    09              	ADD	HL, BC
2056    D1              	POP	DE
2057    7B              	LD	A, E
2058    A6              	AND	(HL)
2059    77              	LD	(HL), A
205A    23              	INC	HL
205B    7A              	LD	A, D
205C    A6              	AND	(HL)
205D    77              	LD	(HL), A
205E    23              	INC	HL
205F    D1              	POP	DE
2060    7B              	LD	A, E
2061    A6              	AND	(HL)
2062    77              	LD	(HL), A
2063    23              	INC	HL
2064    7A              	LD	A, D
2065    A6              	AND	(HL)
2066    77              	LD	(HL), A
2067    09              	ADD	HL, BC
2068    D1              	POP	DE
2069    7B              	LD	A, E
206A    A6              	AND	(HL)
206B    77              	LD	(HL), A
206C    23              	INC	HL
206D    7A              	LD	A, D
206E    A6              	AND	(HL)
206F    77              	LD	(HL), A
2070    23              	INC	HL
2071    D1              	POP	DE
2072    7B              	LD	A, E
2073    A6              	AND	(HL)
2074    77              	LD	(HL), A
2075    23              	INC	HL
2076    7A              	LD	A, D
2077    A6              	AND	(HL)
2078    77              	LD	(HL), A
2079    09              	ADD	HL, BC
207A    D1              	POP	DE
207B    7B              	LD	A, E
207C    A6              	AND	(HL)
207D    77              	LD	(HL), A
207E    23              	INC	HL
207F    7A              	LD	A, D
2080    A6              	AND	(HL)
2081    77              	LD	(HL), A
2082    23              	INC	HL
2083    D1              	POP	DE
2084    7B              	LD	A, E
2085    A6              	AND	(HL)
2086    77              	LD	(HL), A
2087    23              	INC	HL
2088    7A              	LD	A, D
2089    A6              	AND	(HL)
208A    77              	LD	(HL), A
208B    09              	ADD	HL, BC
208C    D1              	POP	DE
208D    7B              	LD	A, E
208E    A6              	AND	(HL)
208F    77              	LD	(HL), A
2090    23              	INC	HL
2091    7A              	LD	A, D
2092    A6              	AND	(HL)
2093    77              	LD	(HL), A
2094    23              	INC	HL
2095    D1              	POP	DE
2096    7B              	LD	A, E
2097    A6              	AND	(HL)
2098    77              	LD	(HL), A
2099    23              	INC	HL
209A    7A              	LD	A, D
209B    A6              	AND	(HL)
209C    77              	LD	(HL), A
209D    09              	ADD	HL, BC
209E    D1              	POP	DE
209F    7B              	LD	A, E
20A0    A6              	AND	(HL)
20A1    77              	LD	(HL), A
20A2    23              	INC	HL
20A3    7A              	LD	A, D
20A4    A6              	AND	(HL)
20A5    77              	LD	(HL), A
20A6    23              	INC	HL
20A7    D1              	POP	DE
20A8    7B              	LD	A, E
20A9    A6              	AND	(HL)
20AA    77              	LD	(HL), A
20AB    23              	INC	HL
20AC    7A              	LD	A, D
20AD    A6              	AND	(HL)
20AE    77              	LD	(HL), A
20AF    09              	ADD	HL, BC
20B0    D1              	POP	DE
20B1    7B              	LD	A, E
20B2    A6              	AND	(HL)
20B3    77              	LD	(HL), A
20B4    23              	INC	HL
20B5    7A              	LD	A, D
20B6    A6              	AND	(HL)
20B7    77              	LD	(HL), A
20B8    23              	INC	HL
20B9    D1              	POP	DE
20BA    7B              	LD	A, E
20BB    A6              	AND	(HL)
20BC    77              	LD	(HL), A
20BD    23              	INC	HL
20BE    7A              	LD	A, D
20BF    A6              	AND	(HL)
20C0    77              	LD	(HL), A
20C1    09              	ADD	HL, BC
20C2    D1              	POP	DE
20C3    7B              	LD	A, E
20C4    A6              	AND	(HL)
20C5    77              	LD	(HL), A
20C6    23              	INC	HL
20C7    7A              	LD	A, D
20C8    A6              	AND	(HL)
20C9    77              	LD	(HL), A
20CA    23              	INC	HL
20CB    D1              	POP	DE
20CC    7B              	LD	A, E
20CD    A6              	AND	(HL)
20CE    77              	LD	(HL), A
20CF    23              	INC	HL
20D0    7A              	LD	A, D
20D1    A6              	AND	(HL)
20D2    77              	LD	(HL), A
20D3    09              	ADD	HL, BC
20D4    D1              	POP	DE
20D5    7B              	LD	A, E
20D6    A6              	AND	(HL)
20D7    77              	LD	(HL), A
20D8    23              	INC	HL
20D9    7A              	LD	A, D
20DA    A6              	AND	(HL)
20DB    77              	LD	(HL), A
20DC    23              	INC	HL
20DD    D1              	POP	DE
20DE    7B              	LD	A, E
20DF    A6              	AND	(HL)
20E0    77              	LD	(HL), A
20E1    23              	INC	HL
20E2    7A              	LD	A, D
20E3    A6              	AND	(HL)
20E4    77              	LD	(HL), A
20E5    ED 73 EA 20     	LD	(PUT_AND_32x16_LD_HL_SP + 1), SP
20E9                    PUT_AND_32x16_LD_HL_SP:
20E9    21 00 00        	LD	HL, 0000
20EC                    PUT_AND_32x16_RESTORE_STACK:
20EC    31 00 00        	LD	SP, 0000
20EF    C9              	RET
20F0
20F0                    ;32x16単色をOR転送する
20F0                    ;	LD	DE, POSITION
20F0                    ;	LD	HL, PATTERN
20F0                    PUT_OR_32x16:
20F0    ED 73 20 22     	LD	(PUT_OR_32x16_RESTORE_STACK + 1), SP
20F4    F9              	LD	SP, HL
20F5    EB              	EX	DE, HL
20F6    01 4D 00        	LD	BC, 77
20F9    D1              	POP	DE
20FA    7B              	LD	A, E
20FB    B6              	OR	(HL)
20FC    77              	LD	(HL), A
20FD    23              	INC	HL
20FE    7A              	LD	A, D
20FF    B6              	OR	(HL)
2100    77              	LD	(HL), A
2101    23              	INC	HL
2102    D1              	POP	DE
2103    7B              	LD	A, E
2104    B6              	OR	(HL)
2105    77              	LD	(HL), A
2106    23              	INC	HL
2107    7A              	LD	A, D
2108    B6              	OR	(HL)
2109    77              	LD	(HL), A
210A    09              	ADD	HL, BC
210B    D1              	POP	DE
210C    7B              	LD	A, E
210D    B6              	OR	(HL)
210E    77              	LD	(HL), A
210F    23              	INC	HL
2110    7A              	LD	A, D
2111    B6              	OR	(HL)
2112    77              	LD	(HL), A
2113    23              	INC	HL
2114    D1              	POP	DE
2115    7B              	LD	A, E
2116    B6              	OR	(HL)
2117    77              	LD	(HL), A
2118    23              	INC	HL
2119    7A              	LD	A, D
211A    B6              	OR	(HL)
211B    77              	LD	(HL), A
211C    09              	ADD	HL, BC
211D    D1              	POP	DE
211E    7B              	LD	A, E
211F    B6              	OR	(HL)
2120    77              	LD	(HL), A
2121    23              	INC	HL
2122    7A              	LD	A, D
2123    B6              	OR	(HL)
2124    77              	LD	(HL), A
2125    23              	INC	HL
2126    D1              	POP	DE
2127    7B              	LD	A, E
2128    B6              	OR	(HL)
2129    77              	LD	(HL), A
212A    23              	INC	HL
212B    7A              	LD	A, D
212C    B6              	OR	(HL)
212D    77              	LD	(HL), A
212E    09              	ADD	HL, BC
212F    D1              	POP	DE
2130    7B              	LD	A, E
2131    B6              	OR	(HL)
2132    77              	LD	(HL), A
2133    23              	INC	HL
2134    7A              	LD	A, D
2135    B6              	OR	(HL)
2136    77              	LD	(HL), A
2137    23              	INC	HL
2138    D1              	POP	DE
2139    7B              	LD	A, E
213A    B6              	OR	(HL)
213B    77              	LD	(HL), A
213C    23              	INC	HL
213D    7A              	LD	A, D
213E    B6              	OR	(HL)
213F    77              	LD	(HL), A
2140    09              	ADD	HL, BC
2141    D1              	POP	DE
2142    7B              	LD	A, E
2143    B6              	OR	(HL)
2144    77              	LD	(HL), A
2145    23              	INC	HL
2146    7A              	LD	A, D
2147    B6              	OR	(HL)
2148    77              	LD	(HL), A
2149    23              	INC	HL
214A    D1              	POP	DE
214B    7B              	LD	A, E
214C    B6              	OR	(HL)
214D    77              	LD	(HL), A
214E    23              	INC	HL
214F    7A              	LD	A, D
2150    B6              	OR	(HL)
2151    77              	LD	(HL), A
2152    09              	ADD	HL, BC
2153    D1              	POP	DE
2154    7B              	LD	A, E
2155    B6              	OR	(HL)
2156    77              	LD	(HL), A
2157    23              	INC	HL
2158    7A              	LD	A, D
2159    B6              	OR	(HL)
215A    77              	LD	(HL), A
215B    23              	INC	HL
215C    D1              	POP	DE
215D    7B              	LD	A, E
215E    B6              	OR	(HL)
215F    77              	LD	(HL), A
2160    23              	INC	HL
2161    7A              	LD	A, D
2162    B6              	OR	(HL)
2163    77              	LD	(HL), A
2164    09              	ADD	HL, BC
2165    D1              	POP	DE
2166    7B              	LD	A, E
2167    B6              	OR	(HL)
2168    77              	LD	(HL), A
2169    23              	INC	HL
216A    7A              	LD	A, D
216B    B6              	OR	(HL)
216C    77              	LD	(HL), A
216D    23              	INC	HL
216E    D1              	POP	DE
216F    7B              	LD	A, E
2170    B6              	OR	(HL)
2171    77              	LD	(HL), A
2172    23              	INC	HL
2173    7A              	LD	A, D
2174    B6              	OR	(HL)
2175    77              	LD	(HL), A
2176    09              	ADD	HL, BC
2177    D1              	POP	DE
2178    7B              	LD	A, E
2179    B6              	OR	(HL)
217A    77              	LD	(HL), A
217B    23              	INC	HL
217C    7A              	LD	A, D
217D    B6              	OR	(HL)
217E    77              	LD	(HL), A
217F    23              	INC	HL
2180    D1              	POP	DE
2181    7B              	LD	A, E
2182    B6              	OR	(HL)
2183    77              	LD	(HL), A
2184    23              	INC	HL
2185    7A              	LD	A, D
2186    B6              	OR	(HL)
2187    77              	LD	(HL), A
2188    09              	ADD	HL, BC
2189    D1              	POP	DE
218A    7B              	LD	A, E
218B    B6              	OR	(HL)
218C    77              	LD	(HL), A
218D    23              	INC	HL
218E    7A              	LD	A, D
218F    B6              	OR	(HL)
2190    77              	LD	(HL), A
2191    23              	INC	HL
2192    D1              	POP	DE
2193    7B              	LD	A, E
2194    B6              	OR	(HL)
2195    77              	LD	(HL), A
2196    23              	INC	HL
2197    7A              	LD	A, D
2198    B6              	OR	(HL)
2199    77              	LD	(HL), A
219A    09              	ADD	HL, BC
219B    D1              	POP	DE
219C    7B              	LD	A, E
219D    B6              	OR	(HL)
219E    77              	LD	(HL), A
219F    23              	INC	HL
21A0    7A              	LD	A, D
21A1    B6              	OR	(HL)
21A2    77              	LD	(HL), A
21A3    23              	INC	HL
21A4    D1              	POP	DE
21A5    7B              	LD	A, E
21A6    B6              	OR	(HL)
21A7    77              	LD	(HL), A
21A8    23              	INC	HL
21A9    7A              	LD	A, D
21AA    B6              	OR	(HL)
21AB    77              	LD	(HL), A
21AC    09              	ADD	HL, BC
21AD    D1              	POP	DE
21AE    7B              	LD	A, E
21AF    B6              	OR	(HL)
21B0    77              	LD	(HL), A
21B1    23              	INC	HL
21B2    7A              	LD	A, D
21B3    B6              	OR	(HL)
21B4    77              	LD	(HL), A
21B5    23              	INC	HL
21B6    D1              	POP	DE
21B7    7B              	LD	A, E
21B8    B6              	OR	(HL)
21B9    77              	LD	(HL), A
21BA    23              	INC	HL
21BB    7A              	LD	A, D
21BC    B6              	OR	(HL)
21BD    77              	LD	(HL), A
21BE    09              	ADD	HL, BC
21BF    D1              	POP	DE
21C0    7B              	LD	A, E
21C1    B6              	OR	(HL)
21C2    77              	LD	(HL), A
21C3    23              	INC	HL
21C4    7A              	LD	A, D
21C5    B6              	OR	(HL)
21C6    77              	LD	(HL), A
21C7    23              	INC	HL
21C8    D1              	POP	DE
21C9    7B              	LD	A, E
21CA    B6              	OR	(HL)
21CB    77              	LD	(HL), A
21CC    23              	INC	HL
21CD    7A              	LD	A, D
21CE    B6              	OR	(HL)
21CF    77              	LD	(HL), A
21D0    09              	ADD	HL, BC
21D1    D1              	POP	DE
21D2    7B              	LD	A, E
21D3    B6              	OR	(HL)
21D4    77              	LD	(HL), A
21D5    23              	INC	HL
21D6    7A              	LD	A, D
21D7    B6              	OR	(HL)
21D8    77              	LD	(HL), A
21D9    23              	INC	HL
21DA    D1              	POP	DE
21DB    7B              	LD	A, E
21DC    B6              	OR	(HL)
21DD    77              	LD	(HL), A
21DE    23              	INC	HL
21DF    7A              	LD	A, D
21E0    B6              	OR	(HL)
21E1    77              	LD	(HL), A
21E2    09              	ADD	HL, BC
21E3    D1              	POP	DE
21E4    7B              	LD	A, E
21E5    B6              	OR	(HL)
21E6    77              	LD	(HL), A
21E7    23              	INC	HL
21E8    7A              	LD	A, D
21E9    B6              	OR	(HL)
21EA    77              	LD	(HL), A
21EB    23              	INC	HL
21EC    D1              	POP	DE
21ED    7B              	LD	A, E
21EE    B6              	OR	(HL)
21EF    77              	LD	(HL), A
21F0    23              	INC	HL
21F1    7A              	LD	A, D
21F2    B6              	OR	(HL)
21F3    77              	LD	(HL), A
21F4    09              	ADD	HL, BC
21F5    D1              	POP	DE
21F6    7B              	LD	A, E
21F7    B6              	OR	(HL)
21F8    77              	LD	(HL), A
21F9    23              	INC	HL
21FA    7A              	LD	A, D
21FB    B6              	OR	(HL)
21FC    77              	LD	(HL), A
21FD    23              	INC	HL
21FE    D1              	POP	DE
21FF    7B              	LD	A, E
2200    B6              	OR	(HL)
2201    77              	LD	(HL), A
2202    23              	INC	HL
2203    7A              	LD	A, D
2204    B6              	OR	(HL)
2205    77              	LD	(HL), A
2206    09              	ADD	HL, BC
2207    D1              	POP	DE
2208    7B              	LD	A, E
2209    B6              	OR	(HL)
220A    77              	LD	(HL), A
220B    23              	INC	HL
220C    7A              	LD	A, D
220D    B6              	OR	(HL)
220E    77              	LD	(HL), A
220F    23              	INC	HL
2210    D1              	POP	DE
2211    7B              	LD	A, E
2212    B6              	OR	(HL)
2213    77              	LD	(HL), A
2214    23              	INC	HL
2215    7A              	LD	A, D
2216    B6              	OR	(HL)
2217    77              	LD	(HL), A
2218    ED 73 1D 22     	LD	(PUT_OR_32x16_LD_HL_SP + 1), SP
221C                    PUT_OR_32x16_LD_HL_SP:
221C    21 00 00        	LD	HL, 0000
221F                    PUT_OR_32x16_RESTORE_STACK:
221F    31 00 00        	LD	SP, 0000
2222    C9              	RET
2223                    ; プリンタリセット
2223                    RESET_PRINTER:
2223    AF              	XOR	A
2224    D3 FE           	OUT	(0FEh), A
2226    3E 80           	LD	A, 080h
2228    D3 FE           	OUT	(0FEh), A
222A    AF              	XOR	A
222B    D3 FE           	OUT	(0FEh), A
222D    C9              	RET
222E
222E                    ;一文字プリンタに送る
222E                    ;	LD	A, 'A'
222E                    PUT_PRINTER1:
222E    F5              	PUSH	AF
222F                    PUT_PRINTER1_L1:
222F    DB FE           	IN	A, (0FEh)
2231    CB 47           	BIT	0, A
2233    20 FA           	JR	NZ, PUT_PRINTER1_L1
2235    F1              	POP	AF
2236    D3 FF           	OUT	(0FFh), A ; 1文字分送る
2238    3E 80           	LD	A, 080h
223A    D3 FE           	OUT	(0FEh), A ; Hi
223C    AF              	XOR	A
223D    D3 FE           	OUT	(0FEh), A ; Lo
223F    C9              	RET
2240
2240                    ;メッセージをプリンタに送る
2240                    ;	LD	HL, MES
2240                    MSGOUT_PRINTER:
2240    E5              	PUSH	HL
2241                    MSGOUT_PRINTER_L1:
2241    7E              	LD	A, (HL)
2242    B7              	OR	A
2243    28 06           	JR	Z, MSGOUT_PRINTER_END
2245    CD 2E 22        	CALL	PUT_PRINTER1
2248    23              	INC	HL
2249    18 F6           	JR	MSGOUT_PRINTER_L1
224B                    MSGOUT_PRINTER_END:
224B    E1              	POP	HL
224C    C9              	RET
224D
224D                    ;0Dhで終わるメッセージをプリンタに送る
224D                    ;	LD	HL, MES
224D                    MSG0D_OUT_PRINTER:
224D    E5              	PUSH	HL
224E                    MSG0D_OUT_PRINTER_L1:
224E    7E              	LD	A, (HL)
224F    FE 0D           	CP	0Dh
2251    28 06           	JR	Z, MSG0D_OUT_PRINTER_END
2253    CD 2E 22        	CALL	PUT_PRINTER1
2256    23              	INC	HL
2257    18 F5           	JR	MSG0D_OUT_PRINTER_L1
2259                    MSG0D_OUT_PRINTER_END:
2259    E1              	POP	HL
225A    C9              	RET
225B
225B                    ; HLレジスタの値を16進数2桁でプリンタに送る
225B                    PUTHEX16_PRINTER:
225B    E5              	PUSH	HL
225C    7C              	LD	A, H
225D    CD 66 22        	CALL	PUTHEX_PRINTER
2260    7D              	LD	A, L
2261    CD 66 22        	CALL	PUTHEX_PRINTER
2264    E1              	POP	HL
2265    C9              	RET
2266
2266                    ; Aレジスタの値を16進数2桁でプリンタに送る
2266                    PUTHEX_PRINTER:
2266    F5              	PUSH	AF
2267    CB 3F           	SRL	A
2269    CB 3F           	SRL	A
226B    CB 3F           	SRL	A
226D    CB 3F           	SRL	A
226F    E6 0F           	AND	00FH
2271    CD 7D 22        	CALL	PUTHEX1_PRINTER
2274    F1              	POP	AF
2275    F5              	PUSH	AF
2276    E6 0F           	AND	00FH
2278    CD 7D 22        	CALL	PUTHEX1_PRINTER
227B    F1              	POP	AF
227C    C9              	RET
227D
227D                    ; Aレジスタの0～Fをプリンタに送る
227D                    PUTHEX1_PRINTER:
227D    F5              	PUSH	AF
227E    C5              	PUSH	BC
227F    E5              	PUSH	HL
2280    CD 82 14        	CALL	A_TO_HEX
2283    CD 2E 22        	CALL	PUT_PRINTER1
2286    E1              	POP	HL
2287    C1              	POP	BC
2288    F1              	POP	AF
2289    C9              	RET
228A
228A                    ; ダンプする
228A                    ; LD	HL, Addr
228A                    ; LD	DE, size
228A                    DUMP_PRINTER:
228A    C5              	PUSH	BC
228B    D5              	PUSH	DE
228C    E5              	PUSH	HL
228D                    DUMP_PRINTER_1:
228D                    	; アドレス
228D    7C              	LD	A, H
228E    CD 66 22        	CALL	PUTHEX_PRINTER
2291    7D              	LD	A, L
2292    CD 66 22        	CALL	PUTHEX_PRINTER
2295    3E 3A           	LD	A, ':'
2297    CD 2E 22        	CALL	PUT_PRINTER1
229A    3E 20           	LD	A, ' '
229C    CD 2E 22        	CALL	PUT_PRINTER1
229F    06 10           	LD	B, 16
22A1                    DUMP_PRINTER_2:
22A1    7E              	LD	A, (HL)
22A2    CD 66 22        	CALL	PUTHEX_PRINTER
22A5    3E 20           	LD	A, ' '
22A7    CD 2E 22        	CALL	PUT_PRINTER1
22AA    23              	INC	HL
22AB    1B              	DEC	DE
22AC    7A              	LD	A, D
22AD    B3              	OR	E
22AE    28 0F           	JR	Z, DUMP_PRINTER_3
22B0    05              	DEC	B
22B1    20 EE           	JR	NZ, DUMP_PRINTER_2
22B3    3E 0D           	LD	A, 00Dh
22B5    CD 2E 22        	CALL	PUT_PRINTER1
22B8    3E 0A           	LD	A, 00Ah
22BA    CD 2E 22        	CALL	PUT_PRINTER1
22BD    18 CE           	JR	DUMP_PRINTER_1
22BF                    DUMP_PRINTER_3:
22BF    E1              	POP	HL
22C0    D1              	POP	DE
22C1    C1              	POP	BC
22C2    C9              	RET
22C3                    ; FDD I/O Port
00D8                    CR	EQU	0D8H ; FDCコマンドレジスタ
00D9                    TR	EQU	0D9H ; FDCトラックレジスタ
00DA                    SCR	EQU	0DAH ; FDCセクタレジスタ
00DB                    DR	EQU	0DBH ; FDCデータレジスタ
00DC                    DM	EQU	0DCH ; ディスクドライブの選択とモーター制御
00DD                    HS	EQU	0DDH ; ディスクのサイド(面)選択
22C3
22C3                    ; READ DIR
22C3                    ; LD	A, ドライブ番号
22C3                    ; LD	HL, ファイルネーム
22C3                    ; LD	IX, BUFFER(最低2KB)
22C3                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
22C3                    READ_FILE:
22C3    E5              	PUSH	HL
22C4    FD 21 ED 24     	LD	IY, WKIY
22C8    32 EA 24        	LD	(DIRNO), A	; ドライブ番号
22CB    3E 00           	LD	A, 000h
22CD    FD 77 02        	LD	(IY+2), A
22D0    3E 08           	LD	A, 008h
22D2    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ2Kバイト
22D5    01 10 00        	LD	BC, 16
22D8    ED 43 E8 24     	LD	(STREC), BC	; レコード16 (DIR)
22DC    CD 06 24        	CALL	BREAD
22DF    F5              	PUSH	AF
22E0    CD 7A 23        	CALL	MOFF
22E3    F1              	POP	AF
22E4    E1              	POP	HL
22E5    D8              	RET	C		; Cyが1ならディレクトリ読み込みエラー
22E6    06 40           	LD	B, 64
22E8    DD E5           	PUSH	IX
22EA    D1              	POP	DE
22EB                    READ_FILE_1:
22EB    1A              	LD	A, (DE)
22EC    13              	INC	DE
22ED    FE 01           	CP	001h
22EF    20 09           	JR	NZ, READ_FILE_2 ; モードが01h(Obj)以外は無視
22F1    D5              	PUSH	DE
22F2    E5              	PUSH	HL
22F3    CD A3 14        	CALL	CMP_TEXT
22F6    E1              	POP	HL
22F7    D1              	POP	DE
22F8    38 0D           	JR	C, READ_FILE_3
22FA                    READ_FILE_2:
22FA                    	; DE = DE + 31
22FA    EB              	EX	DE, HL
22FB    C5              	PUSH	BC
22FC    01 1F 00        	LD	BC, 31
22FF    09              	ADD	HL, BC
2300    C1              	POP	BC
2301    EB              	EX	DE, HL
2302                    	; ループ判定
2302    05              	DEC	B
2303    20 E6           	JR	NZ, READ_FILE_1
2305    37              	SCF
2306    C9              	RET			; ファイルが見つからない
2307                    READ_FILE_3:
2307                    	; 読み込むファイルを見つけた
2307                    	; DE = DE + 19
2307    01 13 00        	LD	BC, 19
230A    EB              	EX	DE, HL
230B    09              	ADD	HL, BC
230C    EB              	EX	DE, HL
230D                    	; 読み込みサイズ取得
230D    1A              	LD	A, (DE)
230E    FD 77 02        	LD	(IY+2), A	; 読み込みサイズ下位バイト設定
2311    13              	INC	DE
2312    1A              	LD	A, (DE)
2313    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ上位バイト設定
2316    13              	INC	DE
2317                    	; 読み込みアドレス取得
2317                    ;	LD	A, (DE)
2317    13              	INC	DE
2318                    ;	LD	C, A
2318                    ;	LD	A, (DE)
2318    13              	INC	DE
2319                    ;	LD	B, A
2319                    ;	PUSH	BC
2319                    ;	POP	IX
2319                    	; DE = DE + 6
2319    01 06 00        	LD	BC, 6
231C    EB              	EX	DE, HL
231D    09              	ADD	HL, BC
231E    EB              	EX	DE, HL
231F                    	; 読み込み開始レコード番号
231F    1A              	LD	A, (DE)
2320    13              	INC	DE
2321    4F              	LD	C, A
2322    1A              	LD	A, (DE)
2323    13              	INC	DE
2324    47              	LD	B, A
2325    ED 43 E8 24     	LD	(STREC), BC	; レコード番号設定
2329                    	; 読み込み開始
2329    CD 06 24        	CALL	BREAD
232C    F5              	PUSH	AF
232D    CD 7A 23        	CALL	MOFF
2330    F1              	POP	AF
2331    C9              	RET
2332
2332                    ; READY
2332    3A EB 24        READY:	LD	A, (MTFG)
2335    0F              	RRCA
2336    CD 64 23        	CALL	MTON
2339    3A EA 24        	LD	A, (DIRNO)	; DRIVE NO GET
233C    F6 84           	OR	084H
233E    D3 DC           	OUT	(DM), A		; DRIVE SELECT MOTON
2340    AF              	XOR	A
2341    CD 98 14        	CALL	DLY60M
2344    21 00 00        	LD	HL, 00000H
2347    2B              REDY0:	DEC	HL
2348    7C              	LD	A, H
2349    B5              	OR	L
234A    CA D4 24        	JP	Z, DERROR	; NO DISK
234D    DB D8           	IN	A, (CR)		; STATUS GET
234F    2F              	CPL
2350    07              	RLCA
2351    38 F4           	JR	C, REDY0
2353    3A EA 24        	LD	A, (DIRNO)
2356    4F              	LD	C,A
2357    21 E6 24        	LD	HL, CLBF0
235A    06 00           	LD	B, 000H
235C    09              	ADD	HL, BC
235D    CB 46           	BIT	0, (HL)
235F    C0              	RET	NZ
2360    CD 95 23        	CALL	RCLB
2363    C9              	RET
2364
2364                    ; MOTOR ON
2364    3E 80           MTON:	LD	A,080H
2366    D3 DC           	OUT	(DM), A
2368    06 0A           	LD	B, 10		; 1SEC DELAY
236A    21 19 3C        MTD1:	LD	HL, 03C19H
236D    2B              MTD2:	DEC	HL
236E    7D              	LD	A, L
236F    B4              	OR	H
2370    20 FB           	JR	NZ, MTD2
2372    10 F6           	DJNZ	MTD1
2374    3E 01           	LD	A, 1
2376    32 EB 24        	LD	(MTFG), A
2379    C9              	RET
237A
237A                    ; MOTOR OFF
237A    CD 91 14        MOFF:	CALL	DLY1M		; 1000US DELAY
237D    AF              	XOR	A
237E    D3 DC           	OUT	(DM), A
2380    32 EB 24        	LD	(MTFG), A
2383    C9              	RET
2384
2384                    ; SEEK TREATMENT
2384    3E 1B           SEEK:	LD	A, 01BH
2386    2F              	CPL
2387    D3 D8           	OUT	(CR), A
2389    CD AD 23        	CALL	BUSY
238C    CD 98 14        	CALL	DLY60M
238F    DB D8           	IN	A, (CR)
2391    2F              	CPL
2392    E6 99           	AND	099H
2394    C9              	RET
2395
2395                    ; RECALIBLATION
2395    E5              RCLB:	PUSH	HL
2396    3E 0B           	LD	A, 00BH
2398    2F              	CPL
2399    D3 D8           	OUT	(CR), A
239B    CD AD 23        	CALL	BUSY
239E    CD 98 14        	CALL	DLY60M
23A1    DB D8           	IN	A, (CR)
23A3    2F              	CPL
23A4    E6 85           	AND	085H
23A6    EE 04           	XOR	004H
23A8    E1              	POP	HL
23A9    C8              	RET	Z
23AA    C3 D4 24        	JP	DERROR
23AD
23AD                    ; BUSY AND WAIT
23AD    D5              BUSY:	PUSH	DE
23AE    E5              	PUSH	HL
23AF    CD 8A 14        	CALL	DLY80U
23B2    1E 07           	LD	E, 7
23B4    21 00 00        BUSY2:	LD	HL, 000H
23B7    2B              BUSY0:	DEC	HL
23B8    7C              	LD	A, H
23B9    B5              	OR	L
23BA    28 09           	JR	Z, BUSY1
23BC    DB D8           	IN	A, (CR)
23BE    2F              	CPL
23BF    0F              	RRCA
23C0    38 F5           	JR	C, BUSY0
23C2    E1              	POP	HL
23C3    D1              	POP	DE
23C4    C9              	RET
23C5    1D              BUSY1:	DEC	E
23C6    20 EC           	JR	NZ, BUSY2
23C8    C3 D4 24        	JP	DERROR
23CB
23CB                    ; DATA CHECK
23CB    06 00           CONVRT:	LD	B, 0
23CD    11 10 00        	LD	DE, 16
23D0    2A E8 24        	LD	HL, (STREC)		; START RECORD
23D3    AF              	XOR	A
23D4    ED 52           TRANS:	SBC	HL, DE
23D6    38 03           	JR	C, TRANS1
23D8    04              	INC	B
23D9    18 F9           	JR	TRANS
23DB    19              TRANS1:	ADD	HL, DE
23DC    60              	LD	H, B
23DD    2C              	INC	L
23DE    FD 74 04        	LD	(IY+4), H
23E1    FD 75 05        	LD	(IY+5), L
23E4    3A EA 24        DCHK:	LD	A, (DIRNO)
23E7    FE 04           	CP	4
23E9    30 18           	JR	NC, DTCK1
23EB    FD 7E 04        	LD	A, (IY+4)
23EE    FE A0           MAXTRK:	CP	160		; MAX TRACK ( 70 -> 35TRACK 2D)
23F0                    				; MAX TRACK (160 -> 80TRACK 2D)
23F0    30 11           	JR	NC, DTCK1
23F2    FD 7E 05        	LD	A, (IY+5)
23F5    B7              	OR	A
23F6    28 0B           	JR	Z, DTCK1
23F8    FE 11           	CP	17		; MAX SECTOR
23FA    30 07           	JR	NC, DTCK1
23FC    FD 7E 02        	LD	A, (IY+2)
23FF    FD B6 03        	OR	(IY+3)
2402    C0              	RET	NZ
2403    C3 D4 24        DTCK1:	JP	DERROR
2406
2406                    ; SEQENTIAL READ
2406                    ; DIRNO: ドライブ番号
2406                    ; IX: 読み込みアドレス
2406                    ; IY: 6バイトのワークエリア
2406                    ; STREC: 読み込みレコード番号
2406                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
2406    F3              BREAD:	DI
2407    CD CB 23        	CALL	CONVRT
240A    3E 0A           	LD	A, 10
240C    32 EC 24        	LD	(RETRY), A
240F    CD 32 23        READ1:	CALL	READY
2412    FD 56 03        	LD	D, (IY+3)
2415    FD 7E 02        	LD	A, (IY+2)
2418    B7              	OR	A
2419    28 01           	JR	Z, RE0
241B    14              	INC	D
241C    FD 7E 05        RE0:	LD	A, (IY+5)
241F    FD 77 01        	LD	(IY+1), A
2422    FD 7E 04        	LD	A, (IY+4)
2425    FD 77 00        	LD	(IY+0), A
2428    DD E5           	PUSH	IX
242A    E1              	POP	HL
242B    CB 3F           RE8:	SRL	A
242D    2F              	CPL
242E    D3 DB           	OUT	(DR), A
2430    30 04           	JR	NC, RE1
2432    3E 01           	LD	A, 001H
2434    18 02           	JR	RE2
2436    3E 00           RE1:	LD	A, 000H
2438    2F              RE2:	CPL
2439    D3 DD           	OUT	(HS), A
243B    CD 84 23        	CALL	SEEK
243E    20 6A           	JR	NZ, REE
2440    0E DB           	LD	C, 0DBH
2442    FD 7E 00        	LD	A, (IY+0)
2445    CB 3F           	SRL	A
2447    2F              	CPL
2448    D3 D9           	OUT	(TR), A
244A    FD 7E 01        	LD	A, (IY+1)
244D    2F              	CPL
244E    D3 DA           	OUT	(SCR),A
2450    D9              	EXX
2451    21 83 24        	LD	HL, RE3
2454    E5              	PUSH	HL
2455    D9              	EXX
2456    3E 94           	LD	A, 094H		;READ & CMD
2458    2F              	CPL
2459    D3 D8           	OUT	(CR), A
245B    CD B9 24        	CALL	WAIT
245E    06 00           RE6:	LD	B, 000H
2460    DB D8           RE4:	IN	A, (CR)
2462    0F              	RRCA
2463    D8              	RET	C
2464    0F              	RRCA
2465    38 F9           	JR	C, RE4
2467    ED A2           	INI
2469    20 F5           	JR	NZ, RE4
246B    FD 34 01        	INC	(IY+1)
246E    FD 7E 01        	LD	A, (IY+1)
2471    FE 11           	CP	17
2473    28 05           	JR	Z, RETS
2475    15              	DEC	D
2476    20 E6           	JR	NZ, RE6
2478    18 01           	JR	RE5
247A    15              RETS:	DEC	D
247B    3E D8           RE5:	LD	A, 0D8H		; FORCE INTER RUPT
247D    2F              	CPL
247E    D3 D8           	OUT	(CR), A
2480    CD AD 23        	CALL	BUSY
2483    DB D8           RE3:	IN	A, (CR)
2485    2F              	CPL
2486    E6 FF           	AND	0FFH
2488    20 20           	JR	NZ, REE
248A    D9              	EXX
248B    E1              	POP	HL
248C    D9              	EXX
248D    FD 7E 01        	LD	A, (IY+1)
2490    FE 11           	CP	17
2492    20 08           	JR	NZ, REX
2494    3E 01           	LD	A, 001H
2496    FD 77 01        	LD	(IY+1), A
2499    FD 34 00        	INC	(IY+0)
249C    7A              REX:	LD	A, D
249D    B7              	OR	A
249E    20 05           	JR	NZ, RE7
24A0    3E 80           	LD	A, 080H
24A2    D3 DC           	OUT	(DM), A
24A4    C9              	RET
24A5    FD 7E 00        RE7:	LD	A, (IY+0)
24A8    18 81           	JR	RE8
24AA    3A EC 24        REE:	LD	A, (RETRY)
24AD    3D              	DEC	A
24AE    32 EC 24        	LD	(RETRY), A
24B1    28 21           	JR	Z, DERROR
24B3    CD 95 23        	CALL	RCLB
24B6    C3 0F 24        	JP	READ1
24B9
24B9                    ; WAIT AND BUSY OFF
24B9    D5              WAIT:	PUSH	DE
24BA    E5              	PUSH	HL
24BB    CD 8A 14        	CALL	DLY80U
24BE    21 00 00        WAIT2:	LD	HL, 00000H
24C1    2B              WAIT0:	DEC	HL
24C2    7C              	LD	A, H
24C3    B5              	OR	L
24C4    28 09           	JR	Z, WAIT1
24C6    DB D8           	IN	A, (CR)
24C8    2F              	CPL
24C9    0F              	RRCA
24CA    30 F5           	JR	NC, WAIT0
24CC    E1              	POP	HL
24CD    D1              	POP	DE
24CE    C9              	RET
24CF    1D              WAIT1:	DEC	E
24D0    20 EC           	JR	NZ, WAIT2
24D2    18 00           	JR	DERROR
24D4
24D4                    ; ディスクエラー
24D4    CD 7A 23        DERROR:	CALL	MOFF
24D7    3E A5           	LD	A, 0A5H
24D9    D3 D9           	OUT	(TR), A
24DB    CD 8A 14        	CALL	DLY80U
24DE    21 F5 24        	LD	HL, ERROR_MESSAGE
24E1    CD 40 22        	CALL	MSGOUT_PRINTER
24E4    37              	SCF
24E5    C9              	RET
24E6
24E6    00 00           CLBF0:	DW	0 ; ?
24E8    00 00           STREC:	DW	0 ; 読込み開始セクタ
24EA    00              DIRNO:	DB	0 ; ドライブ番号(0-3)
24EB    00              MTFG:	DB	0 ; モータ0:OFF, 1:ON
24EC    00              RETRY:	DB	0 ; 残りリトライ回数
24ED    00 00 00 00     WKIY:	DS	6 ; FD READ 指示、ワーク
24F1    00 00
24F3    00 00           WKIX:	DW	0 ; 読み込みアドレス
24F5
24F5                    ERROR_MESSAGE:
24F5    44 69 73 6B     	DB	"Disk Error\n", 0
24F9    20 45 72 72
24FD    6F 72 5C 6E
2501    00
2502                    ;INCLUDE "lzdec.mac"
2502
2502                    MSG:
2502    4D 5A 2D 32     	DB	"MZ-2000 DrawTest by kuran-kuran",0
2506    30 30 30 20
250A    44 72 61 77
250E    54 65 73 74
2512    20 62 79 20
2516    6B 75 72 61
251A    6E 2D 6B 75
251E    72 61 6E 00
2522
2522                    ; ソルバルウ
2522                    SOLVALOU:
2522                    SOLVALOU_MASK:
2522                    	; solvalou_mask
2522                    	; 32 x 16 dot
2522    FF 3F FC FF     	DW 03FFFh, 0FFFCh, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 0003Fh, 0FC00h
2526    FF 0F F0 FF
252A    FF 0F F0 FF
252E    FF 0F F0 FF
2532    FF 00 00 FF
2536    FF 00 00 FF
253A    FF 00 00 FF
253E    3F 00 00 FC
2542    0F 00 00 F0     	DW 0000Fh, 0F000h, 00003h, 0C000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00C00h, 00030h, 00FCFh, 0F3F0h
2546    03 00 00 C0
254A    00 00 00 00
254E    00 00 00 00
2552    00 00 00 00
2556    00 00 00 00
255A    00 0C 30 00
255E    CF 0F F0 F3
2562                    	; solvalou
2562                    	; 32 x 16 dot
2562                    	; Blue data
2562                    SOLVALOU_B:
2562    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 0F000h, 0000Fh, 0F000h, 0000Fh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FCh, 0FFC0h, 003FFh
2566    00 F0 0F 00
256A    00 F0 0F 00
256E    00 F0 0F 00
2572    00 FF FF 00
2576    00 FF FF 00
257A    00 FF FC 00
257E    C0 FF FF 03
2582    F0 FF FF 0F     	DW 0FFF0h, 00FFFh, 0FFFCh, 03FFFh, 0FFFFh, 0FFFFh, 03FFFh, 0FFFCh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0F3FFh, 0FFCFh, 0F030h, 00C0Fh
2586    FC FF FF 3F
258A    FF FF FF FF
258E    FF 3F FC FF
2592    FF FF FF FF
2596    FF FF FF FF
259A    FF F3 CF FF
259E    30 F0 0F 0C
25A2                    	; Red data
25A2                    SOLVALOU_R:
25A2    00 40 01 00     	DW 04000h, 00001h, 0F000h, 0000Bh, 03000h, 00004h, 03000h, 00008h, 03F00h, 00044h, 03000h, 00008h, 0BB00h, 00047h, 0F7C0h, 0008Bh
25A6    00 F0 0B 00
25AA    00 30 04 00
25AE    00 30 08 00
25B2    00 3F 44 00
25B6    00 30 08 00
25BA    00 BB 47 00
25BE    C0 F7 8B 00
25C2    30 FB 47 04     	DW 0FB30h, 00447h, 0F7CCh, 0208Bh, 0FBF3h, 04447h, 0F733h, 0888Bh, 0FB33h, 04C47h, 0FF33h, 08C8Bh, 00333h, 04C40h, 0F030h, 00C0Ah
25C6    CC F7 8B 20
25CA    F3 FB 47 44
25CE    33 F7 8B 88
25D2    33 FB 47 4C
25D6    33 FF 8B 8C
25DA    33 03 40 4C
25DE    30 F0 0A 0C
25E2                    	; Green data
25E2                    SOLVALOU_G:
25E2    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 07000h, 0000Dh, 0B000h, 0000Ch, 07F00h, 000ECh, 0B000h, 0001Ch, 0FF00h, 000ECh, 0FFC0h, 001DFh
25E6    00 F0 0F 00
25EA    00 70 0D 00
25EE    00 B0 0C 00
25F2    00 7F EC 00
25F6    00 B0 1C 00
25FA    00 FF EC 00
25FE    C0 FF DF 01
2602    30 FF CF 0E     	DW 0FF30h, 00ECFh, 0FFCCh, 035CFh, 0FFF3h, 0CECFh, 03F73h, 0CDCCh, 0FFB3h, 0CECFh, 0FF73h, 0CDCFh, 083B3h, 0CECAh, 0F030h, 00C0Fh
2606    CC FF CF 35
260A    F3 FF CF CE
260E    73 3F CC CD
2612    B3 FF CF CE
2616    73 FF CF CD
261A    B3 83 CA CE
261E    30 F0 0F 0C
2622
