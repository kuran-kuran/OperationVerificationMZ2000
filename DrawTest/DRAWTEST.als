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
13A4    D3 E0           	OUT	(0E0h), A
13A6    3E 82           	LD	A, 082h		; 8255 A=out B=in C=out
13A8    D3 E3           	OUT	(0E3H), A
13AA    3E 58           	LD	A, 058h		; b3:BST=1 b4:OPEN=1 b6:WRITE=1
13AC    D3 E2           	OUT	(0E2H), A
13AE                    ;
13AE                    ; PIO 初期化
13AE                    ;	LD	A, 00Fh		; PIO A=out
13AE                    ;	OUT	(0E9H), A
13AE                    ;	LD	A, 0CFh		; PIO B=in
13AE                    ;	OUT	(0EBH), A
13AE                    ;	LD	A, 0FFh
13AE                    ;	OUT	(0EBH), A
13AE
13AE                    ; テキスト初期化
13AE    3E 50           	LD	A, 80
13B0    CD 5A 1B        	CALL	WIDTH
13B3    CD 86 1B        	CALL	ENABLE_TEXT_VRAM_ADDR
13B6
13B6                    ; テキスト優先、文字色白
13B6    3E 0F           	LD	A, 0Fh
13B8    D3 F5           	OUT	(0F5h), A
13BA                    ; 背景色黒
13BA    3E 00           	LD	A, 0
13BC    D3 F4           	OUT	(0F4h), A
13BE
13BE                    ; テキストクリア
13BE    CD 99 1C        	CALL	CLS
13C1
13C1                    ; 左上指定
13C1    11 00 00        	LD	DE, 0
13C4    CD 9C 1B        	CALL	CURSOR
13C7
13C7                    ; メッセージ表示
13C7    21 23 25        	LD	HL, MSG
13CA    CD 1E 1C        	CALL	PRINT_MSG
13CD
13CD                    ; 改行
13CD    CD C9 1B        	CALL	NEW_LINE
13D0
13D0                    ; グラフィック表示初期化
13D0    3E 07           	LD	A, 7
13D2    D3 F6           	OUT	(0F6h), A
13D4    DB E0           	IN	A, (0E0h)
13D6    CB E7           	SET	4, A
13D8
13D8                    ; G-VRAM有効
13D8    CD D3 1C        	CALL	ENABLE_GRAPHIC_ADDR
13DB
13DB                    ; グラフィック画面クリア
13DB    CD E3 1C        	CALL	GRAPHICS_CLS_ALL
13DE
13DE                    ; ソルバルウ表示
13DE                    ; 青
13DE    3E 01           	LD	A, 1
13E0    D3 F7           	OUT	(0F7h), A
13E2    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13E5    21 83 25        	LD	HL, SOLVALOU_B
13E8    CD 32 1F        	CALL	PUT32x16
13EB                    ; 赤
13EB    3E 02           	LD	A, 2
13ED    D3 F7           	OUT	(0F7h), A
13EF    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13F2    21 C3 25        	LD	HL, SOLVALOU_R
13F5    CD 32 1F        	CALL	PUT32x16
13F8                    ; 緑
13F8    3E 03           	LD	A, 3
13FA    D3 F7           	OUT	(0F7h), A
13FC    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13FF    21 03 26        	LD	HL, SOLVALOU_G
1402    CD 32 1F        	CALL	PUT32x16
1405
1405                    ; ソルバルウ表示
1405                    ; 青
1405    3E 01           	LD	A, 1
1407    D3 F7           	OUT	(0F7h), A
1409    11 06 CA        	LD	DE, 0C000h + 80 * 32 + 6
140C    21 83 25        	LD	HL, SOLVALOU_B
140F    CD 32 1F        	CALL	PUT32x16
1412                    ; 赤
1412    3E 02           	LD	A, 2
1414    D3 F7           	OUT	(0F7h), A
1416    11 0A CF        	LD	DE, 0C000h + 80 * 48 + 10
1419    21 C3 25        	LD	HL, SOLVALOU_R
141C    CD 32 1F        	CALL	PUT32x16
141F                    ; 緑
141F    3E 03           	LD	A, 3
1421    D3 F7           	OUT	(0F7h), A
1423    11 0E D4        	LD	DE, 0C000h + 80 * 64 + 14
1426    21 03 26        	LD	HL, SOLVALOU_G
1429    CD 32 1F        	CALL	PUT32x16
142C
142C                    ; G-VRAM無効
142C    CD DC 1C        	CALL	DISABLE_GRAPHIC_ADDR
142F
142F    76              	HALT
1430
1430                    ; ユーティリティ関数
1430                    ; 基本レジスタ破壊を気にしない
1430
1430                    ; 8ビット同士の掛け算
1430                    ; BC = B * E
1430                    MUL_BE:
1430    F5              	PUSH	AF
1431    E5              	PUSH	HL
1432    21 00 00        	LD	HL, 0
1435    0E 00           	LD	C, 0
1437    CB 38           	SRL	B
1439    CB 19           	RR	C
143B    3E 08           	LD	A, 8
143D                    MUL_BE_L1:
143D    CB 23           	SLA	E
143F    30 01           	JR	NC, MUL_BE_L2
1441    09              	ADD	HL, BC
1442                    MUL_BE_L2:
1442    CB 38           	SRL	B
1444    CB 19           	RR	C
1446    3D              	DEC	A
1447    20 F4           	JR	NZ, MUL_BE_L1
1449    4D              	LD	C, L
144A    44              	LD	B, H
144B    E1              	POP	HL
144C    F1              	POP	AF
144D    C9              	RET
144E
144E                    ; HL = HL + A
144E                    ADD_HL_A:
144E    85              	ADD	A, L
144F    6F              	LD	L, A
1450    30 01           	JR	NC, ADD_HL_A_L1
1452    24              	INC	H
1453                    ADD_HL_A_L1:
1453    C9              	RET
1454
1454                    ; HL = HL * 12
1454                    MUL_HLx12:
1454    29              	ADD	HL, HL ; *2
1455    29              	ADD	HL, HL ; *4
1456    44              	LD	B, H
1457    4D              	LD	C, L
1458    29              	ADD	HL, HL ; *8
1459    09              	ADD	HL, BC
145A    C9              	RET
145B
145B                    ; HL = HL * 14
145B                    MUL_HLx14:
145B    29              	ADD	HL, HL ; *2
145C    44              	LD	B, H
145D    4D              	LD	C, L
145E    29              	ADD	HL, HL ; *4
145F    29              	ADD	HL, HL ; *8
1460    09              	ADD	HL, BC
1461    09              	ADD	HL, BC
1462    09              	ADD	HL, BC
1463    C9              	RET
1464
1464                    ; HL = HL * 24
1464                    MUL_HLx24:
1464    29              	ADD	HL, HL ; *2
1465    29              	ADD	HL, HL ; *4
1466    29              	ADD	HL, HL ; *8
1467    44              	LD	B, H
1468    4D              	LD	C, L
1469    29              	ADD	HL, HL ; *16
146A    09              	ADD	HL, BC
146B    C9              	RET
146C
146C                    ; HL = HL * 28
146C                    MUL_HLx28:
146C    29              	ADD	HL, HL ; *2
146D    29              	ADD	HL, HL ; *4
146E    44              	LD	B, H
146F    4D              	LD	C, L
1470    29              	ADD	HL, HL ; *8
1471    54              	LD	D, H
1472    5D              	LD	E, L
1473    29              	ADD	HL, HL ; *16
1474    09              	ADD	HL, BC
1475    19              	ADD	HL, DE
1476    C9              	RET
1477
1477                    ; HL = HL * 40
1477                    ; Break BC
1477                    MUL_HLx40:
1477    29              	ADD	HL, HL ; *2
1478    29              	ADD	HL, HL ; *4
1479    29              	ADD	HL, HL ; *8
147A    44              	LD	B, H
147B    4D              	LD	C, L
147C    29              	ADD	HL, HL ; *16
147D    29              	ADD	HL, HL ; *32
147E    09              	ADD	HL, BC
147F    C9              	RET
1480
1480                    ; HL = HL * 80
1480                    ; Break BC
1480                    MUL_HLx80:
1480    29              	ADD	HL, HL ; *2
1481    29              	ADD	HL, HL ; *4
1482    29              	ADD	HL, HL ; *8
1483    29              	ADD	HL, HL ; *16
1484    44              	LD	B, H
1485    4D              	LD	C, L
1486    29              	ADD	HL, HL ; *32
1487    29              	ADD	HL, HL ; *64
1488    09              	ADD	HL, BC
1489    C9              	RET
148A
148A                    ; HL = HL * 320
148A                    ; Break BC
148A                    MUL_HLx320:
148A    29              	ADD	HL, HL ; *2
148B    29              	ADD	HL, HL ; *4
148C    29              	ADD	HL, HL ; *8
148D    29              	ADD	HL, HL ; *16
148E    29              	ADD	HL, HL ; *32
148F    29              	ADD	HL, HL ; *64
1490    44              	LD	B, H
1491    4D              	LD	C, L
1492    29              	ADD	HL, HL ; *128
1493    29              	ADD	HL, HL ; *256
1494    09              	ADD	HL, BC
1495    C9              	RET
1496
1496                    ; BC = HL / DE 小数点切り捨て, HL = あまり
1496                    DIV16:
1496    01 00 00        	LD	BC, 0
1499    B7              	OR	A
149A                    DIV16_L1:
149A    ED 52           	SBC	HL, DE
149C    38 03           	JR	C, DIV16_L2
149E    03              	INC	BC
149F    18 F9           	JR	DIV16_L1
14A1                    DIV16_L2:
14A1    19              	ADD	HL, DE
14A2    C9              	RET
14A3
14A3                    ; A(0～15)を(0～F)に変換する
14A3                    ; Break HL
14A3                    A_TO_HEX:
14A3    21 29 15        	LD	HL, HEX_TABLE
14A6    CD 4E 14        	CALL	ADD_HL_A
14A9    7E              	LD	A, (HL)
14AA    C9              	RET
14AB
14AB                    ; 一定時間待つ
14AB    D5              DLY80U:	PUSH	DE	; 80マイクロ秒
14AC    11 0D 00        	LD	DE, 13
14AF    C3 BD 14        	JP	DLYT
14B2    D5              DLY1M:	PUSH	DE	; 1ミリ秒
14B3    11 82 00        	LD	DE, 130
14B6    C3 BD 14        	JP	DLYT
14B9    D5              DLY60M:	PUSH	DE	; 60ミリ秒
14BA    11 2C 1A        	LD	DE, 6700
14BD    1B              DLYT:	DEC	DE	; DE回ループする
14BE    7B              	LD	A, E
14BF    B2              	OR	D
14C0    20 FB           	JR	NZ, DLYT
14C2    D1              	POP	DE
14C3    C9              	RET
14C4
14C4                    ; 0Dhで終わっている文字列を比較する
14C4                    ; LD	DE, 比較文字列1, 0Dh
14C4                    ; LD	HL, 比較文字列2, 0Dh
14C4                    ; Result Cyフラグ (0: 違う, 1: 同じ)
14C4                    CMP_TEXT:
14C4                    CMP_TEXT_1:
14C4    1A              	LD	A, (DE)
14C5    BE              	CP	(HL)
14C6    20 08           	JR	NZ, CMP_TEXT_2
14C8    FE 0D           	CP	00Dh
14CA    13              	INC	DE
14CB    23              	INC	HL
14CC    20 F6           	JR	NZ, CMP_TEXT_1
14CE    18 02           	JR	CMP_TEXT_3
14D0                    CMP_TEXT_2:
14D0    B7              	OR	A
14D1    C9              	RET
14D2                    CMP_TEXT_3:
14D2    37              	SCF
14D3    C9              	RET
14D4
14D4                    ; 0-255の乱数をAレジスタに返す
14D4                    RAND:
14D4    3E 00           	LD	A, 0
14D6    5F              	LD	E, A
14D7    87              	ADD	A, A
14D8    87              	ADD	A, A
14D9    83              	ADD	A, E
14DA    3C              	INC	A
14DB    32 D5 14        	LD	(RAND + 1), A
14DE    C9              	RET
14DF
14DF                    ; 0～63の角度番号からX成分を取得する
14DF                    ; LD A, 方向 0～63
14DF                    ; Result HL = 横成分
14DF                    GET_DIR_X:
14DF    21 59 15        	LD	HL, DIR_X_TBL
14E2                    GET_DIR_Y_SUB:
14E2    87              	ADD	A, A
14E3    06 00           	LD	B, 0
14E5    4F              	LD	C, A
14E6    09              	ADD	HL, BC
14E7    4E              	LD	C, (HL)
14E8    23              	INC	HL
14E9    46              	LD	B, (HL)
14EA    C9              	RET
14EB
14EB                    ; 0～63の角度番号からY成分を取得する
14EB                    ; LD A, 方向 0～63
14EB                    ; Result BC = Y成分
14EB                    GET_DIR_Y:
14EB    21 39 15        	LD	HL, DIR_Y_TBL
14EE    18 F2           	JR	GET_DIR_Y_SUB
14F0
14F0                    ; 撃つ方向取得
14F0                    ; IX 自分
14F0                    ; IY 相手
14F0                    ; Result A = 方向(0～63)
14F0                    FIRE_DIR:
14F0    D5              	PUSH	DE
14F1    FD 7E 09        	LD	A, (IY + 9) ; TargetY
14F4    CB 2F           	SRA	A ; 1/2
14F6    47              	LD	B, A
14F7    DD 7E 09        	LD	A, (IX + 9) ; Y
14FA    CB 2F           	SRA	A ; 1/2
14FC    90              	SUB	B
14FD    FA 04 15        	JP	M, FIRE_DIR_L1
1500    26 00           	LD	H, 0
1502    18 02           	JR	FIRE_DIR_L2
1504                    FIRE_DIR_L1:
1504    26 FF           	LD	H, 0FFh
1506                    FIRE_DIR_L2:
1506    6F              	LD	L, A
1507    CD 6C 14        	CALL	MUL_HLx28
150A    FD 7E 07        	LD	A, (IY + 7) ; TargetX
150D    CB 2F           	SRA	A ; 1/2
150F    47              	LD	B, A
1510    DD 7E 07        	LD	A, (IX + 7) ; X
1513    CB 2F           	SRA	A ; 1/2
1515    90              	SUB	B
1516    FA 1D 15        	JP	M, FIRE_DIR_L3
1519    06 00           	LD	B, 0
151B    18 02           	JR	FIRE_DIR_L4
151D                    FIRE_DIR_L3:
151D    06 FF           	LD	B, 0FFh
151F                    FIRE_DIR_L4:
151F    4F              	LD	C, A
1520    09              	ADD	HL, BC
1521    11 A3 18        	LD	DE, FIRE_DIR_TBL + 25 * 28 + 14
1524    EB              	EX	DE, HL
1525    19              	ADD	HL, DE
1526                    	; A=撃つ方向
1526    7E              	LD	A, (HL)
1527    D1              	POP	DE
1528    C9              	RET
1529
1529                    ; 16進数変換用テーブル
1529                    HEX_TABLE:
1529    30 31 32 33     	DB	"0123456789ABCDEF"
152D    34 35 36 37
1531    38 39 41 42
1535    43 44 45 46
1539
1539                    ; 64方向テーブル
1539                    DIR_Y_TBL:
1539    00 00 26 00     	DW	0, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
153D    4A 00 6F 00
1541    92 00 B4 00
1545    D5 00 F3 00
1549    10 01 28 01
154D    3E 01 52 01
1551    62 01 6E 01
1555    79 01 7D 01
1559                    DIR_X_TBL:
1559    80 01 7D 01     	DW	384, 381, 377, 366, 354, 338, 318, 296, 272, 243, 213, 180, 146, 111, 74, 38
155D    79 01 6E 01
1561    62 01 52 01
1565    3E 01 28 01
1569    10 01 F3 00
156D    D5 00 B4 00
1571    92 00 6F 00
1575    4A 00 26 00
1579    00 00 D9 FF     	DW	0, -39, -75, -113, -147, -182, -215, -245, -273, -297, -320, -339, -356, -368, -378, -383
157D    B5 FF 8F FF
1581    6D FF 4A FF
1585    29 FF 0B FF
1589    EF FE D7 FE
158D    C0 FE AD FE
1591    9C FE 90 FE
1595    86 FE 81 FE
1599    80 FE 81 FE     	DW	-384, -383, -378, -368, -356, -339, -320, -297, -273, -245, -215, -182, -147, -113, -75, -39
159D    86 FE 90 FE
15A1    9C FE AD FE
15A5    C0 FE D7 FE
15A9    EF FE 0B FF
15AD    29 FF 4A FF
15B1    6D FF 8F FF
15B5    B5 FF D9 FF
15B9    FE FF 26 00     	DW	-2, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
15BD    4A 00 6F 00
15C1    92 00 B4 00
15C5    D5 00 F3 00
15C9    10 01 28 01
15CD    3E 01 52 01
15D1    62 01 6E 01
15D5    79 01 7D 01
15D9
15D9                    ; (25,14)への方向テーブル 50x28
15D9                    FIRE_DIR_TBL:
15D9    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15DD    0C 0C 0D 0D
15E1    0E 0E 0E 0F
15E5    0F 10 10 10
15E9    11 11 12 12
15ED    12 13 13 14
15F1    14 14 15 15
15F5    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15F9    0C 0C 0D 0D
15FD    0E 0E 0E 0F
1601    0F 10 10 10
1605    11 11 12 12
1609    12 13 13 14
160D    14 14 15 15
1611    0A 0B 0B 0B     	DB	10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21
1615    0C 0C 0D 0D
1619    0D 0E 0E 0F
161D    0F 10 10 10
1621    11 11 12 12
1625    13 13 13 14
1629    14 15 15 15
162D    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
1631    0C 0C 0C 0D
1635    0D 0E 0E 0F
1639    0F 0F 10 11
163D    11 11 12 12
1641    13 13 14 14
1645    14 15 15 16
1649    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
164D    0C 0C 0C 0D
1651    0D 0E 0E 0F
1655    0F 0F 10 11
1659    11 11 12 12
165D    13 13 14 14
1661    14 15 15 16
1665    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22
1669    0B 0C 0C 0D
166D    0D 0E 0E 0E
1671    0F 0F 10 11
1675    11 12 12 12
1679    13 13 14 14
167D    15 15 16 16
1681    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22, 22
1685    0B 0C 0C 0C
1689    0D 0D 0E 0E
168D    0F 0F 10 11
1691    11 12 12 13
1695    13 14 14 14
1699    15 15 16 16
169D    09 0A 0A 0A     	DB	9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 22
16A1    0B 0B 0C 0C
16A5    0D 0D 0E 0E
16A9    0F 0F 10 11
16AD    11 12 12 13
16B1    13 14 14 15
16B5    15 16 16 16
16B9    09 09 0A 0A     	DB	9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23
16BD    0B 0B 0C 0C
16C1    0D 0D 0E 0E
16C5    0F 0F 10 11
16C9    11 12 12 13
16CD    13 14 14 15
16D1    15 16 16 17
16D5    09 09 09 0A     	DB	9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23
16D9    0A 0B 0B 0C
16DD    0C 0D 0E 0E
16E1    0F 0F 10 11
16E5    11 12 12 13
16E9    14 14 15 15
16ED    16 16 17 17
16F1    08 09 09 0A     	DB	8, 9, 9, 10, 10, 10, 11, 12, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 22, 23, 23
16F5    0A 0A 0B 0C
16F9    0C 0D 0D 0E
16FD    0F 0F 10 11
1701    11 12 13 13
1705    14 14 15 16
1709    16 16 17 17
170D    08 08 09 09     	DB	8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16, 17, 17, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24
1711    0A 0A 0B 0B
1715    0C 0C 0D 0E
1719    0F 0F 10 11
171D    11 12 13 14
1721    14 15 15 16
1725    16 17 17 18
1729    08 08 08 09     	DB	8, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24
172D    09 0A 0A 0B
1731    0C 0C 0D 0E
1735    0E 0F 10 11
1739    12 12 13 14
173D    14 15 16 16
1741    17 17 18 18
1745    07 08 08 08     	DB	7, 8, 8, 8, 9, 9, 10, 11, 11, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24, 24
1749    09 09 0A 0B
174D    0B 0C 0D 0E
1751    0E 0F 10 11
1755    12 12 13 14
1759    15 15 16 17
175D    17 18 18 18
1761    07 07 08 08     	DB	7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24, 25
1765    09 09 0A 0A
1769    0B 0C 0C 0D
176D    0E 0F 10 11
1771    12 13 14 14
1775    15 16 16 17
1779    17 18 18 19
177D    06 07 07 07     	DB	6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 25, 25, 25
1781    08 09 09 0A
1785    0A 0B 0C 0D
1789    0E 0F 10 11
178D    12 13 14 15
1791    16 16 17 17
1795    18 19 19 19
1799    06 06 07 07     	DB	6, 6, 7, 7, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 25, 26
179D    07 08 09 09
17A1    0A 0B 0C 0D
17A5    0E 0F 10 11
17A9    12 13 14 15
17AD    16 17 17 18
17B1    19 19 19 1A
17B5    05 06 06 06     	DB	5, 6, 6, 6, 7, 7, 8, 9, 9, 10, 11, 12, 14, 15, 16, 17, 18, 20, 21, 22, 23, 23, 24, 25, 25, 26, 26, 26
17B9    07 07 08 09
17BD    09 0A 0B 0C
17C1    0E 0F 10 11
17C5    12 14 15 16
17C9    17 17 18 19
17CD    19 1A 1A 1A
17D1    05 05 05 06     	DB	5, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27
17D5    06 07 07 08
17D9    09 0A 0B 0C
17DD    0D 0F 10 11
17E1    13 14 15 16
17E5    17 18 19 19
17E9    1A 1A 1B 1B
17ED    04 04 05 05     	DB	4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27, 28
17F1    06 06 07 07
17F5    08 09 0A 0B
17F9    0D 0E 10 12
17FD    13 15 16 17
1801    18 19 19 1A
1805    1A 1B 1B 1C
1809    04 04 04 04     	DB	4, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 22, 23, 24, 25, 26, 26, 27, 27, 28, 28, 28
180D    05 05 06 06
1811    07 08 09 0A
1815    0C 0E 10 12
1819    14 16 17 18
181D    19 1A 1A 1B
1821    1B 1C 1C 1C
1825    03 03 03 04     	DB	3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 8, 9, 11, 14, 16, 18, 21, 23, 24, 25, 26, 27, 27, 28, 28, 28, 29, 29
1829    04 04 05 05
182D    06 07 08 09
1831    0B 0E 10 12
1835    15 17 18 19
1839    1A 1B 1B 1C
183D    1C 1C 1D 1D
1841    02 02 02 03     	DB	2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 7, 8, 10, 13, 16, 19, 22, 24, 25, 26, 27, 28, 28, 29, 29, 29, 30, 30
1845    03 03 04 04
1849    05 06 07 08
184D    0A 0D 10 13
1851    16 18 19 1A
1855    1B 1C 1C 1D
1859    1D 1D 1E 1E
185D    01 02 02 02     	DB	1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 8, 11, 16, 21, 24, 26, 27, 28, 29, 29, 30, 30, 30, 30, 30, 30
1861    02 02 02 03
1865    03 04 05 06
1869    08 0B 10 15
186D    18 1A 1B 1C
1871    1D 1D 1E 1E
1875    1E 1E 1E 1E
1879    01 01 01 01     	DB	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5, 8, 16, 24, 27, 29, 30, 30, 30, 31, 31, 31, 31, 31, 31, 31
187D    01 01 01 01
1881    02 02 02 03
1885    05 08 10 18
1889    1B 1D 1E 1E
188D    1E 1F 1F 1F
1891    1F 1F 1F 1F
1895    00 00 00 00     	DB	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
1899    00 00 00 00
189D    00 00 00 00
18A1    00 00 10 20
18A5    20 20 20 20
18A9    20 20 20 20
18AD    20 20 20 20
18B1    3F 3F 3F 3F     	DB	63, 63, 63, 63, 63, 63, 63, 63, 62, 62, 62, 61, 59, 56, 48, 40, 37, 35, 34, 34, 34, 33, 33, 33, 33, 33, 33, 33
18B5    3F 3F 3F 3F
18B9    3E 3E 3E 3D
18BD    3B 38 30 28
18C1    25 23 22 22
18C5    22 21 21 21
18C9    21 21 21 21
18CD    3F 3E 3E 3E     	DB	63, 62, 62, 62, 62, 62, 62, 61, 61, 60, 59, 58, 56, 53, 48, 43, 40, 38, 37, 36, 35, 35, 34, 34, 34, 34, 34, 34
18D1    3E 3E 3E 3D
18D5    3D 3C 3B 3A
18D9    38 35 30 2B
18DD    28 26 25 24
18E1    23 23 22 22
18E5    22 22 22 22
18E9    3E 3E 3E 3D     	DB	62, 62, 62, 61, 61, 61, 60, 60, 59, 58, 57, 56, 54, 51, 48, 45, 42, 40, 39, 38, 37, 36, 36, 35, 35, 35, 34, 34
18ED    3D 3D 3C 3C
18F1    3B 3A 39 38
18F5    36 33 30 2D
18F9    2A 28 27 26
18FD    25 24 24 23
1901    23 23 22 22
1905    3D 3D 3D 3C     	DB	61, 61, 61, 60, 60, 60, 59, 59, 58, 57, 56, 55, 53, 50, 48, 46, 43, 41, 40, 39, 38, 37, 37, 36, 36, 36, 35, 35
1909    3C 3C 3B 3B
190D    3A 39 38 37
1911    35 32 30 2E
1915    2B 29 28 27
1919    26 25 25 24
191D    24 24 23 23
1921    3C 3C 3C 3C     	DB	60, 60, 60, 60, 59, 59, 58, 58, 57, 56, 55, 54, 52, 50, 48, 46, 44, 42, 41, 40, 39, 38, 38, 37, 37, 36, 36, 36
1925    3B 3B 3A 3A
1929    39 38 37 36
192D    34 32 30 2E
1931    2C 2A 29 28
1935    27 26 26 25
1939    25 24 24 24
193D    3C 3C 3B 3B     	DB	60, 60, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 51, 50, 48, 46, 45, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37, 36
1941    3A 3A 39 39
1945    38 37 36 35
1949    33 32 30 2E
194D    2D 2B 2A 29
1951    28 27 27 26
1955    26 25 25 24
1959    3B 3B 3B 3A     	DB	59, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 52, 51, 49, 48, 47, 45, 44, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37
195D    3A 39 39 38
1961    37 36 35 34
1965    33 31 30 2F
1969    2D 2C 2B 2A
196D    29 28 27 27
1971    26 26 25 25
1975    3B 3A 3A 3A     	DB	59, 58, 58, 58, 57, 57, 56, 55, 55, 54, 53, 52, 50, 49, 48, 47, 46, 44, 43, 42, 41, 41, 40, 39, 39, 38, 38, 38
1979    39 39 38 37
197D    37 36 35 34
1981    32 31 30 2F
1985    2E 2C 2B 2A
1989    29 29 28 27
198D    27 26 26 26
1991    3A 3A 39 39     	DB	58, 58, 57, 57, 57, 56, 55, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 41, 40, 39, 39, 39, 38
1995    39 38 37 37
1999    36 35 34 33
199D    32 31 30 2F
19A1    2E 2D 2C 2B
19A5    2A 29 29 28
19A9    27 27 27 26
19AD    3A 39 39 39     	DB	58, 57, 57, 57, 56, 55, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 42, 41, 41, 40, 39, 39, 39
19B1    38 37 37 36
19B5    36 35 34 33
19B9    32 31 30 2F
19BD    2E 2D 2C 2B
19C1    2A 2A 29 29
19C5    28 27 27 27
19C9    39 39 38 38     	DB	57, 57, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 49, 48, 47, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40, 39
19CD    37 37 36 36
19D1    35 34 34 33
19D5    32 31 30 2F
19D9    2E 2D 2C 2C
19DD    2B 2A 2A 29
19E1    29 28 28 27
19E5    39 38 38 38     	DB	57, 56, 56, 56, 55, 55, 54, 53, 53, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 43, 43, 42, 41, 41, 40, 40, 40
19E9    37 37 36 35
19ED    35 34 33 32
19F1    32 31 30 2F
19F5    2E 2E 2D 2C
19F9    2B 2B 2A 29
19FD    29 28 28 28
1A01    38 38 38 37     	DB	56, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40
1A05    37 36 36 35
1A09    34 34 33 32
1A0D    32 31 30 2F
1A11    2E 2E 2D 2C
1A15    2C 2B 2A 2A
1A19    29 29 28 28
1A1D    38 38 37 37     	DB	56, 56, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 49, 49, 48, 47, 47, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40
1A21    36 36 35 35
1A25    34 34 33 32
1A29    31 31 30 2F
1A2D    2F 2E 2D 2C
1A31    2C 2B 2B 2A
1A35    2A 29 29 28
1A39    38 37 37 36     	DB	56, 55, 55, 54, 54, 54, 53, 52, 52, 51, 51, 50, 49, 49, 48, 47, 47, 46, 45, 45, 44, 44, 43, 42, 42, 42, 41, 41
1A3D    36 36 35 34
1A41    34 33 33 32
1A45    31 31 30 2F
1A49    2F 2E 2D 2D
1A4D    2C 2C 2B 2A
1A51    2A 2A 29 29
1A55    37 37 37 36     	DB	55, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41
1A59    36 35 35 34
1A5D    34 33 32 32
1A61    31 31 30 2F
1A65    2F 2E 2E 2D
1A69    2C 2C 2B 2B
1A6D    2A 2A 29 29
1A71    37 37 36 36     	DB	55, 55, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41
1A75    35 35 34 34
1A79    33 33 32 32
1A7D    31 31 30 2F
1A81    2F 2E 2E 2D
1A85    2D 2C 2C 2B
1A89    2B 2A 2A 29
1A8D    37 36 36 36     	DB	55, 54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 42
1A91    35 35 34 34
1A95    33 33 32 32
1A99    31 31 30 2F
1A9D    2F 2E 2E 2D
1AA1    2D 2C 2C 2B
1AA5    2B 2A 2A 2A
1AA9    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42, 42
1AAD    35 34 34 34
1AB1    33 33 32 32
1AB5    31 31 30 2F
1AB9    2F 2E 2E 2D
1ABD    2D 2C 2C 2C
1AC1    2B 2B 2A 2A
1AC5    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42
1AC9    35 34 34 33
1ACD    33 32 32 32
1AD1    31 31 30 2F
1AD5    2F 2E 2E 2E
1AD9    2D 2D 2C 2C
1ADD    2B 2B 2A 2A
1AE1    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AE5    34 34 34 33
1AE9    33 32 32 31
1AED    31 31 30 2F
1AF1    2F 2F 2E 2E
1AF5    2D 2D 2C 2C
1AF9    2C 2B 2B 2A
1AFD    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1B01    34 34 34 33
1B05    33 32 32 31
1B09    31 31 30 2F
1B0D    2F 2F 2E 2E
1B11    2D 2D 2C 2C
1B15    2C 2B 2B 2A
1B19    36 35 35 35     	DB	54, 53, 53, 53, 52, 52, 51, 51, 51, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 45, 45, 45, 44, 44, 43, 43, 43
1B1D    34 34 33 33
1B21    33 32 32 31
1B25    31 30 30 30
1B29    2F 2F 2E 2E
1B2D    2D 2D 2D 2C
1B31    2C 2B 2B 2B
1B35    35 35 35 34     	DB	53, 53, 53, 52, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 44, 43, 43
1B39    34 34 33 33
1B3D    32 32 32 31
1B41    31 30 30 30
1B45    2F 2F 2E 2E
1B49    2E 2D 2D 2C
1B4D    2C 2C 2B 2B
1B51                    WIDTH_SIZE:
1B51    28              	DB	40
1B52                    CURSOR_Y:
1B52    00              	DB	0
1B53                    CURSOR_X:
1B53    00              	DB	0
1B54                    CURSOR_ADDR:
1B54    00 D0           	DW	0D000h
1B56                    TEXT_VRAM_LIMIT:
1B56    E8 D3           	DW	0D000h + 1000
1B58                    TEXT_VRAM_SIZE:
1B58    E8 03           	DW	1000
1B5A
1B5A                    ;テキスト横桁数設定
1B5A                    ;	LD	A, 40 or 80
1B5A                    WIDTH:
1B5A    E5              	PUSH	HL
1B5B    32 51 1B        	LD	(WIDTH_SIZE), A
1B5E    FE 28           	CP	40
1B60    DB E8           	IN	A, (0E8h)
1B62    28 10           	JR	Z, WIDTH_40
1B64    F6 20           	OR	020H	; bit5 Hi WIDTH80
1B66    21 D0 D7        	LD	HL, 0D000h + 2000
1B69    22 56 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B6C    21 D0 07        	LD	HL, 2000
1B6F    22 58 1B        	LD	(TEXT_VRAM_SIZE), HL
1B72    18 0E           	JR	WIDTH_L1
1B74                    WIDTH_40:
1B74    E6 CF           	AND	0CFh	; bit5 Lo WIDTH40
1B76    21 E8 D3        	LD	HL, 0D000h + 1000
1B79    22 56 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B7C    21 E8 03        	LD	HL, 1000
1B7F    22 58 1B        	LD	(TEXT_VRAM_SIZE), HL
1B82                    WIDTH_L1:
1B82    D3 E8           	OUT	(0E8h),A
1B84    E1              	POP	HL
1B85    C9              	RET
1B86
1B86                    ENABLE_TEXT_VRAM_ADDR:
1B86    DB E8           	IN	A,(0E8h)
1B88    E6 3F           	AND	03Fh
1B8A    F6 C0           	OR	0C0h
1B8C    D3 E8           	OUT	(0E8h),A
1B8E    C9              	RET
1B8F
1B8F                    DISABLE_VRAM_ADDR:
1B8F    DB E8           	IN	A,(0E8h)
1B91    E6 3F           	AND	03Fh
1B93    D3 E8           	OUT	(0E8h),A
1B95    C9              	RET
1B96
1B96                    ;文字と背景の色とプライオリティ設定
1B96                    ; LD	A, 文字の色(文字優先: 0～7, グラフィック優先: 8～15)
1B96                    ; LD	B, 背景の色(0～7)
1B96                    TEXT_COLOR:
1B96    D3 F5           	OUT	(0F5h), A
1B98    78              	LD	A, B
1B99    D3 F4           	OUT	(0F4h), A
1B9B    C9              	RET
1B9C
1B9C                    ;表示位置設定
1B9C                    ;	LD	D, Y
1B9C                    ;	LD	E, X
1B9C                    CURSOR:
1B9C    F5              	PUSH	AF
1B9D    C5              	PUSH	BC
1B9E    D5              	PUSH	DE
1B9F    E5              	PUSH	HL
1BA0    7A              	LD	A, D
1BA1    32 52 1B        	LD	(CURSOR_Y), A
1BA4    7B              	LD	A, E
1BA5    32 53 1B        	LD	(CURSOR_X), A
1BA8    26 00           	LD	H, 0
1BAA    6A              	LD	L, D
1BAB    3A 51 1B        	LD	A, (WIDTH_SIZE)
1BAE    FE 28           	CP	40
1BB0    28 05           	JR	Z, CURSOR_WIDTH40
1BB2    CD 80 14        	CALL	MUL_HLx80
1BB5    18 03           	JR	CURSOR_L1
1BB7                    CURSOR_WIDTH40:
1BB7    CD 77 14        	CALL	MUL_HLx40
1BBA                    CURSOR_L1:
1BBA    16 00           	LD	D, 0
1BBC    19              	ADD	HL, DE
1BBD    11 00 D0        	LD	DE, 0D000h
1BC0    19              	ADD	HL, DE
1BC1    22 54 1B        	LD	(CURSOR_ADDR), HL
1BC4    E1              	POP	HL
1BC5    D1              	POP	DE
1BC6    C1              	POP	BC
1BC7    F1              	POP	AF
1BC8    C9              	RET
1BC9
1BC9                    ;改行
1BC9                    NEW_LINE:
1BC9    3A 52 1B        	LD	A, (CURSOR_Y)
1BCC    3C              	INC	A
1BCD    FE 19           	CP	25
1BCF    FA D7 1B        	JP	M, NEW_LINE_L1
1BD2    3E 18           	LD	A, 24
1BD4    CD 4F 1C        	CALL	SCROLL_UP
1BD7                    NEW_LINE_L1:
1BD7    57              	LD	D, A
1BD8    1E 00           	LD	E, 0
1BDA    CD 9C 1B        	CALL	CURSOR
1BDD    C9              	RET
1BDE
1BDE                    ;一文字表示
1BDE                    ;	LD	HL, 0で終わる文字列へのアドレス
1BDE                    PRINT_MSG1:
1BDE    C5              	PUSH	BC
1BDF    D5              	PUSH	DE
1BE0    E5              	PUSH	HL
1BE1    2A 54 1B        	LD	HL, (CURSOR_ADDR)
1BE4    77              	LD	(HL), A
1BE5    23              	INC	HL
1BE6                    	; 画面右下にはみ出したら一番しての行の左側に戻す
1BE6    E5              	PUSH	HL
1BE7    ED 4B 56 1B     	LD	BC, (TEXT_VRAM_LIMIT)
1BEB    B7              	OR	A
1BEC    ED 42           	SBC	HL, BC
1BEE    E1              	POP	HL
1BEF    38 0F           	JR	C, PRINT_MSG1_L2
1BF1    2A 56 1B        	LD	HL, (TEXT_VRAM_LIMIT)
1BF4    06 00           	LD	B, 0
1BF6    3A 51 1B        	LD	A, (WIDTH_SIZE)
1BF9    4F              	LD	C, A
1BFA    B7              	OR	A
1BFB    ED 42           	SBC	HL, BC
1BFD    CD 4F 1C        	CALL	SCROLL_UP
1C00                    PRINT_MSG1_L2:
1C00    22 54 1B        	LD	(CURSOR_ADDR), HL
1C03    01 00 D0        	LD	BC, 0D000h
1C06    B7              	OR	A
1C07    ED 42           	SBC	HL, BC
1C09    16 00           	LD	D, 0
1C0B    3A 51 1B        	LD	A, (WIDTH_SIZE)
1C0E    5F              	LD	E, A
1C0F    CD 96 14        	CALL	DIV16
1C12    79              	LD	A, C
1C13    32 52 1B        	LD	(CURSOR_Y), A
1C16    7D              	LD	A, L
1C17    32 53 1B        	LD	(CURSOR_X), A
1C1A    E1              	POP	HL
1C1B    D1              	POP	DE
1C1C    C1              	POP	BC
1C1D    C9              	RET
1C1E
1C1E                    ;メッセージを表示
1C1E                    ;	LD	HL, 文字列へのアドレス
1C1E                    PRINT_MSG:
1C1E    E5              	PUSH	HL
1C1F                    PRINT_MSG_L1:
1C1F    7E              	LD	A, (HL)
1C20    B7              	OR	A
1C21    28 06           	JR	Z, PRINT_MSG_END
1C23    CD DE 1B        	CALL	PRINT_MSG1
1C26    23              	INC	HL
1C27    18 F6           	JR	PRINT_MSG_L1
1C29                    PRINT_MSG_END:
1C29    E1              	POP	HL
1C2A    C9              	RET
1C2B
1C2B                    ; Aレジスタの内容を16進表示する
1C2B                    PRINT_HEX:
1C2B    F5              	PUSH	AF
1C2C    CB 3F           	SRL	A
1C2E    CB 3F           	SRL	A
1C30    CB 3F           	SRL	A
1C32    CB 3F           	SRL	A
1C34    E6 0F           	AND	00FH
1C36    CD 42 1C        	CALL	PRINT_HEX1
1C39    F1              	POP	AF
1C3A    F5              	PUSH	AF
1C3B    E6 0F           	AND	00FH
1C3D    CD 42 1C        	CALL	PRINT_HEX1
1C40    F1              	POP	AF
1C41    C9              	RET
1C42
1C42                    ; Aレジスタの0～Fを表示する
1C42                    PRINT_HEX1:
1C42    F5              	PUSH	AF
1C43    C5              	PUSH	BC
1C44    E5              	PUSH	HL
1C45    CD A3 14        	CALL	A_TO_HEX
1C48    CD DE 1B        	CALL	PRINT_MSG1
1C4B    E1              	POP	HL
1C4C    C1              	POP	BC
1C4D    F1              	POP	AF
1C4E    C9              	RET
1C4F
1C4F                    ; テキスト画面全体を上方向にスクロール
1C4F                    SCROLL_UP:
1C4F    F5              	PUSH	AF
1C50    C5              	PUSH	BC
1C51    D5              	PUSH	DE
1C52    E5              	PUSH	HL
1C53    3A 51 1B        	LD	A, (WIDTH_SIZE)
1C56    FE 28           	CP	40
1C58    28 05           	JR	Z, SCROLL_UP_L1
1C5A    CD 80 1C        	CALL	SCROLL_UP_WIDTH80
1C5D    18 03           	JR	SCROLL_UP_L2
1C5F                    SCROLL_UP_L1:
1C5F    CD 67 1C        	CALL	SCROLL_UP_WIDTH40
1C62                    SCROLL_UP_L2:
1C62    E1              	POP	HL
1C63    D1              	POP	DE
1C64    C1              	POP	BC
1C65    F1              	POP	AF
1C66    C9              	RET
1C67
1C67                    ; 40桁のテキスト画面全体を上方向にスクロール
1C67                    SCROLL_UP_WIDTH40:
1C67                    	; scroll
1C67    01 C0 03        	LD	BC, 1000 - 40
1C6A    21 28 D0        	LD	HL, 0D000h + 40
1C6D    11 00 D0        	LD	DE, 0D000h
1C70    ED B0           	LDIR
1C72                    	; space
1C72    21 C0 D3        	LD	HL, 0D000h + 1000 - 40
1C75    11 C1 D3        	LD	DE, 0D000h + 1000 - 40 + 1
1C78    01 27 00        	LD	BC, 40 - 1
1C7B    AF              	XOR	A
1C7C    77              	LD	(HL), A
1C7D    ED B0           	LDIR
1C7F    C9              	RET
1C80
1C80                    ; 80桁のテキスト画面全体を上方向にスクロール
1C80                    SCROLL_UP_WIDTH80:
1C80                    	; scroll
1C80    01 80 07        	LD	BC, 2000 - 80
1C83    21 50 D0        	LD	HL, 0D000h + 80
1C86    11 00 D0        	LD	DE, 0D000h
1C89    ED B0           	LDIR
1C8B                    	; space
1C8B    21 80 D7        	LD	HL, 0D000h + 2000 - 80
1C8E    11 81 D7        	LD	DE, 0D000h + 2000 - 80 + 1
1C91    01 4F 00        	LD	BC, 80 - 1
1C94    AF              	XOR	A
1C95    77              	LD	(HL), A
1C96    ED B0           	LDIR
1C98    C9              	RET
1C99
1C99                    ; 画面消去
1C99                    CLS:
1C99    3A 51 1B        	LD	A, (WIDTH_SIZE)
1C9C    57              	LD	D, A
1C9D    1E 19           	LD	E, 25
1C9F    3E 20           	LD	A, ' '
1CA1    21 00 D0        	LD	HL, 0D000h
1CA4    CD B0 1C        	CALL	DRAW_RECT_TEXT
1CA7    11 00 00        	LD	DE, 0
1CAA    CD 9C 1B        	CALL	CURSOR
1CAD    C9              	RET
1CAE
1CAE                    ; 桁のテキスト画面で指定した文字で矩形を描く
1CAE                    ; LD	A, 'A' ; 描画文字
1CAE                    ; LD	D, WIDTH
1CAE                    ; LD	E, HEIGHT
1CAE                    ; LD	HL, POSITION
1CAE                    DRAW_RECT_TEXT_ADD_X:
1CAE    00 00           	DW	0
1CB0                    DRAW_RECT_TEXT:
1CB0    C5              	PUSH	BC
1CB1    E5              	PUSH	HL
1CB2                    DRAW_RECT_TEXT_WIDTH:
1CB2    F5              	PUSH	AF
1CB3    3A 51 1B        	LD	A, (WIDTH_SIZE)
1CB6    92              	SUB	D
1CB7    06 00           	LD	B, 0
1CB9    4F              	LD	C, A
1CBA    ED 43 AE 1C     	LD	(DRAW_RECT_TEXT_ADD_X), BC
1CBE    F1              	POP	AF
1CBF    43              	LD	B, E
1CC0                    DRAW_RECT_TEXT_1:
1CC0    4A              	LD	C, D
1CC1                    DRAW_RECT_TEXT_2:
1CC1    77              	LD	(HL), A
1CC2    23              	INC	HL
1CC3    0D              	DEC	C
1CC4    20 FB           	JR	NZ, DRAW_RECT_TEXT_2
1CC6    C5              	PUSH	BC
1CC7    ED 4B AE 1C     	LD	BC, (DRAW_RECT_TEXT_ADD_X)
1CCB    09              	ADD	HL, BC
1CCC    C1              	POP	BC
1CCD    05              	DEC	B
1CCE    20 F0           	JR	NZ, DRAW_RECT_TEXT_1
1CD0    E1              	POP	HL
1CD1    C1              	POP	BC
1CD2    C9              	RET
1CD3                    ; GRAMアドレス有効
1CD3                    ENABLE_GRAPHIC_ADDR:
1CD3    DB E8           	IN	A, (0E8h)
1CD5    E6 3F           	AND	03Fh
1CD7    F6 80           	OR	080h
1CD9    D3 E8           	OUT	(0E8h), A
1CDB    C9              	RET
1CDC
1CDC                    ; GRAMアドレス無効
1CDC                    DISABLE_GRAPHIC_ADDR:
1CDC    DB E8           	IN	A, (0E8h)
1CDE    E6 7F           	AND	07Fh
1CE0    D3 E8           	OUT	(0E8h), A
1CE2    C9              	RET
1CE3
1CE3                    ; グラフィックス画面を3ページとも消去する
1CE3                    GRAPHICS_CLS_ALL:
1CE3    3E 01           	LD	A, 1
1CE5    D3 F7           	OUT	(0F7h), A
1CE7    CD F9 1C        	CALL	GRAPHICS_CLS
1CEA    3E 02           	LD	A, 2
1CEC    D3 F7           	OUT	(0F7h), A
1CEE    CD F9 1C        	CALL	GRAPHICS_CLS
1CF1    3E 03           	LD	A, 3
1CF3    D3 F7           	OUT	(0F7h), A
1CF5    CD F9 1C        	CALL	GRAPHICS_CLS
1CF8    C9              	RET
1CF9
1CF9                    ; グラフィックス画面を1ページ分消去する
1CF9                    GRAPHICS_CLS:
1CF9    21 00 C0        	LD	HL, 0C000h
1CFC    01 80 3E        	LD	BC, 16000
1CFF                    GRAPHICS_CLS_L1:
1CFF    36 00           	LD	(HL), 0
1D01    23              	INC	HL
1D02    0B              	DEC	BC
1D03    78              	LD	A, B
1D04    B1              	OR	C
1D05    20 F8           	JR	NZ, GRAPHICS_CLS_L1
1D07    C9              	RET
1D08
1D08                    ;16x2(4) 8色を転送する
1D08                    ;	LD	DE, POSITION
1D08                    ;	LD	HL, PATTERN
1D08                    PUT16x2x8:
1D08    D5              	PUSH	DE
1D09    ED 73 4F 1D     	LD	(PUT16x2x8_RESTORE_STACK + 1), SP
1D0D                    	; B
1D0D    3E 01           	LD	A, 1
1D0F    D3 F7           	OUT	(0F7h), A
1D11    F9              	LD	SP, HL
1D12    EB              	EX	DE, HL
1D13    D1              	POP	DE
1D14    73              	LD	(HL), E
1D15    23              	INC	HL
1D16    72              	LD	(HL), D
1D17    23              	INC	HL
1D18    01 9E 00        	LD	BC, 158
1D1B    09              	ADD	HL, BC
1D1C    D1              	POP	DE
1D1D    73              	LD	(HL), E
1D1E    23              	INC	HL
1D1F    72              	LD	(HL), D
1D20                    	; R
1D20    3E 02           	LD	A, 2
1D22    D3 F7           	OUT	(0F7h), A
1D24    01 A1 00        	LD	BC, 161
1D27    B7              	OR	A
1D28    ED 42           	SBC	HL, BC
1D2A    D1              	POP	DE
1D2B    73              	LD	(HL), E
1D2C    23              	INC	HL
1D2D    72              	LD	(HL), D
1D2E    23              	INC	HL
1D2F    01 9E 00        	LD	BC, 158
1D32    09              	ADD	HL, BC
1D33    D1              	POP	DE
1D34    73              	LD	(HL), E
1D35    23              	INC	HL
1D36    72              	LD	(HL), D
1D37                    	; G
1D37    3E 03           	LD	A, 3
1D39    D3 F7           	OUT	(0F7h), A
1D3B    01 A1 00        	LD	BC, 161
1D3E    B7              	OR	A
1D3F    ED 42           	SBC	HL, BC
1D41    D1              	POP	DE
1D42    73              	LD	(HL), E
1D43    23              	INC	HL
1D44    72              	LD	(HL), D
1D45    23              	INC	HL
1D46    01 9E 00        	LD	BC, 158
1D49    09              	ADD	HL, BC
1D4A    D1              	POP	DE
1D4B    73              	LD	(HL), E
1D4C    23              	INC	HL
1D4D    72              	LD	(HL), D
1D4E                    PUT16x2x8_RESTORE_STACK:
1D4E    31 00 00        	LD	SP, 0000
1D51    D1              	POP	DE
1D52    C9              	RET
1D53
1D53                    ;16x2(4)単色を転送する
1D53                    ;	LD	DE, POSITION
1D53                    ;	LD	HL, PATTERN
1D53                    PUT16x2:
1D53    D5              	PUSH	DE
1D54    ED 73 68 1D     	LD	(PUT16x2_RESTORE_STACK + 1), SP
1D58    F9              	LD	SP, HL
1D59    EB              	EX	DE, HL
1D5A    D1              	POP	DE
1D5B    73              	LD	(HL), E
1D5C    23              	INC	HL
1D5D    72              	LD	(HL), D
1D5E    23              	INC	HL
1D5F    01 9E 00        	LD	BC, 158
1D62    09              	ADD	HL, BC
1D63    D1              	POP	DE
1D64    73              	LD	(HL), E
1D65    23              	INC	HL
1D66    72              	LD	(HL), D
1D67                    PUT16x2_RESTORE_STACK:
1D67    31 00 00        	LD	SP, 0000
1D6A    D1              	POP	DE
1D6B    C9              	RET
1D6C
1D6C                    ;16x4単色を転送する
1D6C                    ;	LD	DE, POSITION
1D6C                    ;	LD	HL, PATTERN
1D6C                    PUT16x4:
1D6C    C5              	PUSH	BC
1D6D    D5              	PUSH	DE
1D6E    E5              	PUSH	HL
1D6F    ED 73 8F 1D     	LD	(PUT16x4_RESTORE_STACK + 1), SP
1D73    F9              	LD	SP, HL
1D74    EB              	EX	DE, HL
1D75    01 4E 00        	LD	BC, 78
1D78    D1              	POP	DE
1D79    73              	LD	(HL), E
1D7A    23              	INC	HL
1D7B    72              	LD	(HL), D
1D7C    23              	INC	HL
1D7D    09              	ADD	HL, BC
1D7E    D1              	POP	DE
1D7F    73              	LD	(HL), E
1D80    23              	INC	HL
1D81    72              	LD	(HL), D
1D82    23              	INC	HL
1D83    09              	ADD	HL, BC
1D84    D1              	POP	DE
1D85    73              	LD	(HL), E
1D86    23              	INC	HL
1D87    72              	LD	(HL), D
1D88    23              	INC	HL
1D89    09              	ADD	HL, BC
1D8A    D1              	POP	DE
1D8B    73              	LD	(HL), E
1D8C    23              	INC	HL
1D8D    72              	LD	(HL), D
1D8E                    PUT16x4_RESTORE_STACK:
1D8E    31 00 00        	LD	SP, 0000
1D91    E1              	POP	HL
1D92    D1              	POP	DE
1D93    C1              	POP	BC
1D94    C9              	RET
1D95
1D95                    ;8x4単色をAND転送する
1D95                    ;	LD	DE, POSITION
1D95                    ;	LD	HL, PATTERN
1D95                    PUT_AND_8x4:
1D95    C5              	PUSH	BC
1D96    D5              	PUSH	DE
1D97    E5              	PUSH	HL
1D98    ED 73 B3 1D     	LD	(PUT_AND_8x4_RESTORE_STACK + 1), SP
1D9C    F9              	LD	SP, HL
1D9D    EB              	EX	DE, HL
1D9E    01 50 00        	LD	BC, 80
1DA1    D1              	POP	DE
1DA2    7B              	LD	A, E
1DA3    A6              	AND	(HL)
1DA4    77              	LD	(HL), A
1DA5    09              	ADD	HL, BC
1DA6    7A              	LD	A, D
1DA7    A6              	AND	(HL)
1DA8    77              	LD	(HL), A
1DA9    09              	ADD	HL, BC
1DAA    D1              	POP	DE
1DAB    7B              	LD	A, E
1DAC    A6              	AND	(HL)
1DAD    77              	LD	(HL), A
1DAE    09              	ADD	HL, BC
1DAF    7A              	LD	A, D
1DB0    A6              	AND	(HL)
1DB1    77              	LD	(HL), A
1DB2                    PUT_AND_8x4_RESTORE_STACK:
1DB2    31 00 00        	LD	SP, 0000
1DB5    E1              	POP	HL
1DB6    D1              	POP	DE
1DB7    C1              	POP	BC
1DB8    C9              	RET
1DB9
1DB9                    ;8x4単色を32x4の左端右端にAND転送する
1DB9                    ;	LD	DE, POSITION
1DB9                    ;	LD	HL, PATTERN
1DB9                    PUT_AND_ZAPPER:
1DB9    C5              	PUSH	BC
1DBA    D5              	PUSH	DE
1DBB    E5              	PUSH	HL
1DBC    ED 73 F1 1D     	LD	(PUT_AND_ZAPPER_RESTORE_STACK + 1), SP
1DC0    F9              	LD	SP, HL
1DC1    EB              	EX	DE, HL
1DC2    01 4D 00        	LD	BC, 77
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
1DCF    09              	ADD	HL, BC
1DD0    D1              	POP	DE
1DD1    7B              	LD	A, E
1DD2    A6              	AND	(HL)
1DD3    77              	LD	(HL), A
1DD4    23              	INC	HL
1DD5    23              	INC	HL
1DD6    23              	INC	HL
1DD7    7A              	LD	A, D
1DD8    A6              	AND	(HL)
1DD9    77              	LD	(HL), A
1DDA    09              	ADD	HL, BC
1DDB    D1              	POP	DE
1DDC    7B              	LD	A, E
1DDD    A6              	AND	(HL)
1DDE    77              	LD	(HL), A
1DDF    23              	INC	HL
1DE0    23              	INC	HL
1DE1    23              	INC	HL
1DE2    7A              	LD	A, D
1DE3    A6              	AND	(HL)
1DE4    77              	LD	(HL), A
1DE5    09              	ADD	HL, BC
1DE6    D1              	POP	DE
1DE7    7B              	LD	A, E
1DE8    A6              	AND	(HL)
1DE9    77              	LD	(HL), A
1DEA    23              	INC	HL
1DEB    23              	INC	HL
1DEC    23              	INC	HL
1DED    7A              	LD	A, D
1DEE    A6              	AND	(HL)
1DEF    77              	LD	(HL), A
1DF0                    PUT_AND_ZAPPER_RESTORE_STACK:
1DF0    31 00 00        	LD	SP, 0000
1DF3    E1              	POP	HL
1DF4    D1              	POP	DE
1DF5    C1              	POP	BC
1DF6    C9              	RET
1DF7
1DF7                    ;16x4単色をクリアする
1DF7                    ;	LD	HL, POSITION
1DF7                    CLEAR16x4:
1DF7    AF              	XOR	A
1DF8    01 4F 00        	LD	BC, 79
1DFB    77              	LD	(HL), A
1DFC    23              	INC	HL
1DFD    77              	LD	(HL), A
1DFE    09              	ADD	HL, BC
1DFF    77              	LD	(HL), A
1E00    23              	INC	HL
1E01    77              	LD	(HL), A
1E02    09              	ADD	HL, BC
1E03    77              	LD	(HL), A
1E04    23              	INC	HL
1E05    77              	LD	(HL), A
1E06    09              	ADD	HL, BC
1E07    77              	LD	(HL), A
1E08    23              	INC	HL
1E09    77              	LD	(HL), A
1E0A    C9              	RET
1E0B
1E0B                    ;16x4 青と赤プレーンをクリアする
1E0B                    ;	LD	DE, POSITION
1E0B                    CLEAR16x4_BR:
1E0B    E5              	PUSH	HL
1E0C    C5              	PUSH	BC
1E0D    62              	LD	H, D
1E0E    6B              	LD	L, E
1E0F    3E 01           	LD	A, 1
1E11    D3 F7           	OUT	(0F7h), A
1E13    CD F7 1D        	CALL	CLEAR16x4
1E16    62              	LD	H, D
1E17    6B              	LD	L, E
1E18    3E 02           	LD	A, 2
1E1A    D3 F7           	OUT	(0F7h), A
1E1C    CD F7 1D        	CALL	CLEAR16x4
1E1F    C1              	POP	BC
1E20    E1              	POP	HL
1E21    C9              	RET
1E22
1E22                    ;16x8単色を転送する
1E22                    ;	LD	DE, POSITION
1E22                    ;	LD	HL, PATTERN
1E22                    PUT16x8:
1E22    ED 73 53 1E     	LD	(PUT16x8_RESTORE_STACK + 1), SP
1E26    F9              	LD	SP, HL
1E27    EB              	EX	DE, HL
1E28    01 4F 00        	LD	BC, 79
1E2B    D1              	POP	DE
1E2C    73              	LD	(HL), E
1E2D    23              	INC	HL
1E2E    72              	LD	(HL), D
1E2F    09              	ADD	HL, BC
1E30    D1              	POP	DE
1E31    73              	LD	(HL), E
1E32    23              	INC	HL
1E33    72              	LD	(HL), D
1E34    09              	ADD	HL, BC
1E35    D1              	POP	DE
1E36    73              	LD	(HL), E
1E37    23              	INC	HL
1E38    72              	LD	(HL), D
1E39    09              	ADD	HL, BC
1E3A    D1              	POP	DE
1E3B    73              	LD	(HL), E
1E3C    23              	INC	HL
1E3D    72              	LD	(HL), D
1E3E    09              	ADD	HL, BC
1E3F    D1              	POP	DE
1E40    73              	LD	(HL), E
1E41    23              	INC	HL
1E42    72              	LD	(HL), D
1E43    09              	ADD	HL, BC
1E44    D1              	POP	DE
1E45    73              	LD	(HL), E
1E46    23              	INC	HL
1E47    72              	LD	(HL), D
1E48    09              	ADD	HL, BC
1E49    D1              	POP	DE
1E4A    73              	LD	(HL), E
1E4B    23              	INC	HL
1E4C    72              	LD	(HL), D
1E4D    09              	ADD	HL, BC
1E4E    D1              	POP	DE
1E4F    73              	LD	(HL), E
1E50    23              	INC	HL
1E51    72              	LD	(HL), D
1E52                    PUT16x8_RESTORE_STACK:
1E52    31 00 00        	LD	SP, 0000
1E55    C9              	RET
1E56
1E56                    ;32x4単色を転送する
1E56                    ;	LD	DE, POSITION
1E56                    ;	LD	HL, PATTERN
1E56                    PUT32x4:
1E56    ED 73 87 1E     	LD	(PUT32x4_RESTORE_STACK + 1), SP
1E5A    F9              	LD	SP, HL
1E5B    EB              	EX	DE, HL
1E5C    01 4D 00        	LD	BC, 77
1E5F    D1              	POP	DE
1E60    73              	LD	(HL), E
1E61    23              	INC	HL
1E62    72              	LD	(HL), D
1E63    23              	INC	HL
1E64    D1              	POP	DE
1E65    73              	LD	(HL), E
1E66    23              	INC	HL
1E67    72              	LD	(HL), D
1E68    09              	ADD	HL, BC
1E69    D1              	POP	DE
1E6A    73              	LD	(HL), E
1E6B    23              	INC	HL
1E6C    72              	LD	(HL), D
1E6D    23              	INC	HL
1E6E    D1              	POP	DE
1E6F    73              	LD	(HL), E
1E70    23              	INC	HL
1E71    72              	LD	(HL), D
1E72    09              	ADD	HL, BC
1E73    D1              	POP	DE
1E74    73              	LD	(HL), E
1E75    23              	INC	HL
1E76    72              	LD	(HL), D
1E77    23              	INC	HL
1E78    D1              	POP	DE
1E79    73              	LD	(HL), E
1E7A    23              	INC	HL
1E7B    72              	LD	(HL), D
1E7C    09              	ADD	HL, BC
1E7D    D1              	POP	DE
1E7E    73              	LD	(HL), E
1E7F    23              	INC	HL
1E80    72              	LD	(HL), D
1E81    23              	INC	HL
1E82    D1              	POP	DE
1E83    73              	LD	(HL), E
1E84    23              	INC	HL
1E85    72              	LD	(HL), D
1E86                    PUT32x4_RESTORE_STACK:
1E86    31 00 00        	LD	SP, 0000
1E89    C9              	RET
1E8A
1E8A                    ;32x4単色をAND転送する
1E8A                    ;	LD	HL, POSITION
1E8A                    ;	LD	DE, PATTERN
1E8A                    PUT_AND_32x4:
1E8A    ED 73 DB 1E     	LD	(PUT_AND_32x4_RESTORE_STACK + 1), SP
1E8E    F9              	LD	SP, HL
1E8F    EB              	EX	DE, HL
1E90    01 4D 00        	LD	BC, 77
1E93    D1              	POP	DE
1E94    7B              	LD	A, E
1E95    A6              	AND	(HL)
1E96    77              	LD	(HL), A
1E97    23              	INC	HL
1E98    7A              	LD	A, D
1E99    A6              	AND	(HL)
1E9A    77              	LD	(HL), A
1E9B    23              	INC	HL
1E9C    D1              	POP	DE
1E9D    7B              	LD	A, E
1E9E    A6              	AND	(HL)
1E9F    77              	LD	(HL), A
1EA0    23              	INC	HL
1EA1    7A              	LD	A, D
1EA2    A6              	AND	(HL)
1EA3    77              	LD	(HL), A
1EA4    09              	ADD	HL, BC
1EA5    D1              	POP	DE
1EA6    7B              	LD	A, E
1EA7    A6              	AND	(HL)
1EA8    77              	LD	(HL), A
1EA9    23              	INC	HL
1EAA    7A              	LD	A, D
1EAB    A6              	AND	(HL)
1EAC    77              	LD	(HL), A
1EAD    23              	INC	HL
1EAE    D1              	POP	DE
1EAF    7B              	LD	A, E
1EB0    A6              	AND	(HL)
1EB1    77              	LD	(HL), A
1EB2    23              	INC	HL
1EB3    7A              	LD	A, D
1EB4    A6              	AND	(HL)
1EB5    77              	LD	(HL), A
1EB6    09              	ADD	HL, BC
1EB7    D1              	POP	DE
1EB8    7B              	LD	A, E
1EB9    A6              	AND	(HL)
1EBA    77              	LD	(HL), A
1EBB    23              	INC	HL
1EBC    7A              	LD	A, D
1EBD    A6              	AND	(HL)
1EBE    77              	LD	(HL), A
1EBF    23              	INC	HL
1EC0    D1              	POP	DE
1EC1    7B              	LD	A, E
1EC2    A6              	AND	(HL)
1EC3    77              	LD	(HL), A
1EC4    23              	INC	HL
1EC5    7A              	LD	A, D
1EC6    A6              	AND	(HL)
1EC7    77              	LD	(HL), A
1EC8    09              	ADD	HL, BC
1EC9    D1              	POP	DE
1ECA    7B              	LD	A, E
1ECB    A6              	AND	(HL)
1ECC    77              	LD	(HL), A
1ECD    23              	INC	HL
1ECE    7A              	LD	A, D
1ECF    A6              	AND	(HL)
1ED0    77              	LD	(HL), A
1ED1    23              	INC	HL
1ED2    D1              	POP	DE
1ED3    7B              	LD	A, E
1ED4    A6              	AND	(HL)
1ED5    77              	LD	(HL), A
1ED6    23              	INC	HL
1ED7    7A              	LD	A, D
1ED8    A6              	AND	(HL)
1ED9    77              	LD	(HL), A
1EDA                    PUT_AND_32x4_RESTORE_STACK:
1EDA    31 00 00        	LD	SP, 0000
1EDD    C9              	RET
1EDE
1EDE                    ;32x4単色をOR転送する
1EDE                    ;	LD	HL, POSITION
1EDE                    ;	LD	DE, PATTERN
1EDE                    PUT_OR_32x4:
1EDE    ED 73 2F 1F     	LD	(PUT_OR_32x4_RESTORE_STACK + 1), SP
1EE2    F9              	LD	SP, HL
1EE3    EB              	EX	DE, HL
1EE4    01 4D 00        	LD	BC, 77
1EE7    D1              	POP	DE
1EE8    7B              	LD	A, E
1EE9    B6              	OR	(HL)
1EEA    77              	LD	(HL), A
1EEB    23              	INC	HL
1EEC    7A              	LD	A, D
1EED    B6              	OR	(HL)
1EEE    77              	LD	(HL), A
1EEF    23              	INC	HL
1EF0    D1              	POP	DE
1EF1    7B              	LD	A, E
1EF2    B6              	OR	(HL)
1EF3    77              	LD	(HL), A
1EF4    23              	INC	HL
1EF5    7A              	LD	A, D
1EF6    B6              	OR	(HL)
1EF7    77              	LD	(HL), A
1EF8    09              	ADD	HL, BC
1EF9    D1              	POP	DE
1EFA    7B              	LD	A, E
1EFB    B6              	OR	(HL)
1EFC    77              	LD	(HL), A
1EFD    23              	INC	HL
1EFE    7A              	LD	A, D
1EFF    B6              	OR	(HL)
1F00    77              	LD	(HL), A
1F01    23              	INC	HL
1F02    D1              	POP	DE
1F03    7B              	LD	A, E
1F04    B6              	OR	(HL)
1F05    77              	LD	(HL), A
1F06    23              	INC	HL
1F07    7A              	LD	A, D
1F08    B6              	OR	(HL)
1F09    77              	LD	(HL), A
1F0A    09              	ADD	HL, BC
1F0B    D1              	POP	DE
1F0C    7B              	LD	A, E
1F0D    B6              	OR	(HL)
1F0E    77              	LD	(HL), A
1F0F    23              	INC	HL
1F10    7A              	LD	A, D
1F11    B6              	OR	(HL)
1F12    77              	LD	(HL), A
1F13    23              	INC	HL
1F14    D1              	POP	DE
1F15    7B              	LD	A, E
1F16    B6              	OR	(HL)
1F17    77              	LD	(HL), A
1F18    23              	INC	HL
1F19    7A              	LD	A, D
1F1A    B6              	OR	(HL)
1F1B    77              	LD	(HL), A
1F1C    09              	ADD	HL, BC
1F1D    D1              	POP	DE
1F1E    7B              	LD	A, E
1F1F    B6              	OR	(HL)
1F20    77              	LD	(HL), A
1F21    23              	INC	HL
1F22    7A              	LD	A, D
1F23    B6              	OR	(HL)
1F24    77              	LD	(HL), A
1F25    23              	INC	HL
1F26    D1              	POP	DE
1F27    7B              	LD	A, E
1F28    B6              	OR	(HL)
1F29    77              	LD	(HL), A
1F2A    23              	INC	HL
1F2B    7A              	LD	A, D
1F2C    B6              	OR	(HL)
1F2D    77              	LD	(HL), A
1F2E                    PUT_OR_32x4_RESTORE_STACK:
1F2E    31 00 00        	LD	SP, 0000
1F31    C9              	RET
1F32
1F32                    ;32x16単色を転送する
1F32                    ;	LD	DE, POSITION
1F32                    ;	LD	HL, PATTERN
1F32                    PUT32x16:
1F32    ED 73 DB 1F     	LD	(PUT32x16_RESTORE_STACK + 1), SP
1F36    F9              	LD	SP, HL
1F37    EB              	EX	DE, HL
1F38    01 4D 00        	LD	BC, 77
1F3B    D1              	POP	DE
1F3C    73              	LD	(HL), E
1F3D    23              	INC	HL
1F3E    72              	LD	(HL), D
1F3F    23              	INC	HL
1F40    D1              	POP	DE
1F41    73              	LD	(HL), E
1F42    23              	INC	HL
1F43    72              	LD	(HL), D
1F44    09              	ADD	HL, BC
1F45    D1              	POP	DE
1F46    73              	LD	(HL), E
1F47    23              	INC	HL
1F48    72              	LD	(HL), D
1F49    23              	INC	HL
1F4A    D1              	POP	DE
1F4B    73              	LD	(HL), E
1F4C    23              	INC	HL
1F4D    72              	LD	(HL), D
1F4E    09              	ADD	HL, BC
1F4F    D1              	POP	DE
1F50    73              	LD	(HL), E
1F51    23              	INC	HL
1F52    72              	LD	(HL), D
1F53    23              	INC	HL
1F54    D1              	POP	DE
1F55    73              	LD	(HL), E
1F56    23              	INC	HL
1F57    72              	LD	(HL), D
1F58    09              	ADD	HL, BC
1F59    D1              	POP	DE
1F5A    73              	LD	(HL), E
1F5B    23              	INC	HL
1F5C    72              	LD	(HL), D
1F5D    23              	INC	HL
1F5E    D1              	POP	DE
1F5F    73              	LD	(HL), E
1F60    23              	INC	HL
1F61    72              	LD	(HL), D
1F62    09              	ADD	HL, BC
1F63    D1              	POP	DE
1F64    73              	LD	(HL), E
1F65    23              	INC	HL
1F66    72              	LD	(HL), D
1F67    23              	INC	HL
1F68    D1              	POP	DE
1F69    73              	LD	(HL), E
1F6A    23              	INC	HL
1F6B    72              	LD	(HL), D
1F6C    09              	ADD	HL, BC
1F6D    D1              	POP	DE
1F6E    73              	LD	(HL), E
1F6F    23              	INC	HL
1F70    72              	LD	(HL), D
1F71    23              	INC	HL
1F72    D1              	POP	DE
1F73    73              	LD	(HL), E
1F74    23              	INC	HL
1F75    72              	LD	(HL), D
1F76    09              	ADD	HL, BC
1F77    D1              	POP	DE
1F78    73              	LD	(HL), E
1F79    23              	INC	HL
1F7A    72              	LD	(HL), D
1F7B    23              	INC	HL
1F7C    D1              	POP	DE
1F7D    73              	LD	(HL), E
1F7E    23              	INC	HL
1F7F    72              	LD	(HL), D
1F80    09              	ADD	HL, BC
1F81    D1              	POP	DE
1F82    73              	LD	(HL), E
1F83    23              	INC	HL
1F84    72              	LD	(HL), D
1F85    23              	INC	HL
1F86    D1              	POP	DE
1F87    73              	LD	(HL), E
1F88    23              	INC	HL
1F89    72              	LD	(HL), D
1F8A    09              	ADD	HL, BC
1F8B    D1              	POP	DE
1F8C    73              	LD	(HL), E
1F8D    23              	INC	HL
1F8E    72              	LD	(HL), D
1F8F    23              	INC	HL
1F90    D1              	POP	DE
1F91    73              	LD	(HL), E
1F92    23              	INC	HL
1F93    72              	LD	(HL), D
1F94    09              	ADD	HL, BC
1F95    D1              	POP	DE
1F96    73              	LD	(HL), E
1F97    23              	INC	HL
1F98    72              	LD	(HL), D
1F99    23              	INC	HL
1F9A    D1              	POP	DE
1F9B    73              	LD	(HL), E
1F9C    23              	INC	HL
1F9D    72              	LD	(HL), D
1F9E    09              	ADD	HL, BC
1F9F    D1              	POP	DE
1FA0    73              	LD	(HL), E
1FA1    23              	INC	HL
1FA2    72              	LD	(HL), D
1FA3    23              	INC	HL
1FA4    D1              	POP	DE
1FA5    73              	LD	(HL), E
1FA6    23              	INC	HL
1FA7    72              	LD	(HL), D
1FA8    09              	ADD	HL, BC
1FA9    D1              	POP	DE
1FAA    73              	LD	(HL), E
1FAB    23              	INC	HL
1FAC    72              	LD	(HL), D
1FAD    23              	INC	HL
1FAE    D1              	POP	DE
1FAF    73              	LD	(HL), E
1FB0    23              	INC	HL
1FB1    72              	LD	(HL), D
1FB2    09              	ADD	HL, BC
1FB3    D1              	POP	DE
1FB4    73              	LD	(HL), E
1FB5    23              	INC	HL
1FB6    72              	LD	(HL), D
1FB7    23              	INC	HL
1FB8    D1              	POP	DE
1FB9    73              	LD	(HL), E
1FBA    23              	INC	HL
1FBB    72              	LD	(HL), D
1FBC    09              	ADD	HL, BC
1FBD    D1              	POP	DE
1FBE    73              	LD	(HL), E
1FBF    23              	INC	HL
1FC0    72              	LD	(HL), D
1FC1    23              	INC	HL
1FC2    D1              	POP	DE
1FC3    73              	LD	(HL), E
1FC4    23              	INC	HL
1FC5    72              	LD	(HL), D
1FC6    09              	ADD	HL, BC
1FC7    D1              	POP	DE
1FC8    73              	LD	(HL), E
1FC9    23              	INC	HL
1FCA    72              	LD	(HL), D
1FCB    23              	INC	HL
1FCC    D1              	POP	DE
1FCD    73              	LD	(HL), E
1FCE    23              	INC	HL
1FCF    72              	LD	(HL), D
1FD0    09              	ADD	HL, BC
1FD1    D1              	POP	DE
1FD2    73              	LD	(HL), E
1FD3    23              	INC	HL
1FD4    72              	LD	(HL), D
1FD5    23              	INC	HL
1FD6    D1              	POP	DE
1FD7    73              	LD	(HL), E
1FD8    23              	INC	HL
1FD9    72              	LD	(HL), D
1FDA                    PUT32x16_RESTORE_STACK:
1FDA    31 00 00        	LD	SP, 0000
1FDD    C9              	RET
1FDE
1FDE                    ;32x16単色をAND転送する
1FDE                    ;	LD	DE, POSITION
1FDE                    ;	LD	HL, PATTERN
1FDE                    PUT_AND_32x16:
1FDE    ED 73 0E 21     	LD	(PUT_AND_32x16_RESTORE_STACK + 1), SP
1FE2    F9              	LD	SP, HL
1FE3    EB              	EX	DE, HL
1FE4    01 4D 00        	LD	BC, 77
1FE7    D1              	POP	DE
1FE8    7B              	LD	A, E
1FE9    A6              	AND	(HL)
1FEA    77              	LD	(HL), A
1FEB    23              	INC	HL
1FEC    7A              	LD	A, D
1FED    A6              	AND	(HL)
1FEE    77              	LD	(HL), A
1FEF    23              	INC	HL
1FF0    D1              	POP	DE
1FF1    7B              	LD	A, E
1FF2    A6              	AND	(HL)
1FF3    77              	LD	(HL), A
1FF4    23              	INC	HL
1FF5    7A              	LD	A, D
1FF6    A6              	AND	(HL)
1FF7    77              	LD	(HL), A
1FF8    09              	ADD	HL, BC
1FF9    D1              	POP	DE
1FFA    7B              	LD	A, E
1FFB    A6              	AND	(HL)
1FFC    77              	LD	(HL), A
1FFD    23              	INC	HL
1FFE    7A              	LD	A, D
1FFF    A6              	AND	(HL)
2000    77              	LD	(HL), A
2001    23              	INC	HL
2002    D1              	POP	DE
2003    7B              	LD	A, E
2004    A6              	AND	(HL)
2005    77              	LD	(HL), A
2006    23              	INC	HL
2007    7A              	LD	A, D
2008    A6              	AND	(HL)
2009    77              	LD	(HL), A
200A    09              	ADD	HL, BC
200B    D1              	POP	DE
200C    7B              	LD	A, E
200D    A6              	AND	(HL)
200E    77              	LD	(HL), A
200F    23              	INC	HL
2010    7A              	LD	A, D
2011    A6              	AND	(HL)
2012    77              	LD	(HL), A
2013    23              	INC	HL
2014    D1              	POP	DE
2015    7B              	LD	A, E
2016    A6              	AND	(HL)
2017    77              	LD	(HL), A
2018    23              	INC	HL
2019    7A              	LD	A, D
201A    A6              	AND	(HL)
201B    77              	LD	(HL), A
201C    09              	ADD	HL, BC
201D    D1              	POP	DE
201E    7B              	LD	A, E
201F    A6              	AND	(HL)
2020    77              	LD	(HL), A
2021    23              	INC	HL
2022    7A              	LD	A, D
2023    A6              	AND	(HL)
2024    77              	LD	(HL), A
2025    23              	INC	HL
2026    D1              	POP	DE
2027    7B              	LD	A, E
2028    A6              	AND	(HL)
2029    77              	LD	(HL), A
202A    23              	INC	HL
202B    7A              	LD	A, D
202C    A6              	AND	(HL)
202D    77              	LD	(HL), A
202E    09              	ADD	HL, BC
202F    D1              	POP	DE
2030    7B              	LD	A, E
2031    A6              	AND	(HL)
2032    77              	LD	(HL), A
2033    23              	INC	HL
2034    7A              	LD	A, D
2035    A6              	AND	(HL)
2036    77              	LD	(HL), A
2037    23              	INC	HL
2038    D1              	POP	DE
2039    7B              	LD	A, E
203A    A6              	AND	(HL)
203B    77              	LD	(HL), A
203C    23              	INC	HL
203D    7A              	LD	A, D
203E    A6              	AND	(HL)
203F    77              	LD	(HL), A
2040    09              	ADD	HL, BC
2041    D1              	POP	DE
2042    7B              	LD	A, E
2043    A6              	AND	(HL)
2044    77              	LD	(HL), A
2045    23              	INC	HL
2046    7A              	LD	A, D
2047    A6              	AND	(HL)
2048    77              	LD	(HL), A
2049    23              	INC	HL
204A    D1              	POP	DE
204B    7B              	LD	A, E
204C    A6              	AND	(HL)
204D    77              	LD	(HL), A
204E    23              	INC	HL
204F    7A              	LD	A, D
2050    A6              	AND	(HL)
2051    77              	LD	(HL), A
2052    09              	ADD	HL, BC
2053    D1              	POP	DE
2054    7B              	LD	A, E
2055    A6              	AND	(HL)
2056    77              	LD	(HL), A
2057    23              	INC	HL
2058    7A              	LD	A, D
2059    A6              	AND	(HL)
205A    77              	LD	(HL), A
205B    23              	INC	HL
205C    D1              	POP	DE
205D    7B              	LD	A, E
205E    A6              	AND	(HL)
205F    77              	LD	(HL), A
2060    23              	INC	HL
2061    7A              	LD	A, D
2062    A6              	AND	(HL)
2063    77              	LD	(HL), A
2064    09              	ADD	HL, BC
2065    D1              	POP	DE
2066    7B              	LD	A, E
2067    A6              	AND	(HL)
2068    77              	LD	(HL), A
2069    23              	INC	HL
206A    7A              	LD	A, D
206B    A6              	AND	(HL)
206C    77              	LD	(HL), A
206D    23              	INC	HL
206E    D1              	POP	DE
206F    7B              	LD	A, E
2070    A6              	AND	(HL)
2071    77              	LD	(HL), A
2072    23              	INC	HL
2073    7A              	LD	A, D
2074    A6              	AND	(HL)
2075    77              	LD	(HL), A
2076    09              	ADD	HL, BC
2077    D1              	POP	DE
2078    7B              	LD	A, E
2079    A6              	AND	(HL)
207A    77              	LD	(HL), A
207B    23              	INC	HL
207C    7A              	LD	A, D
207D    A6              	AND	(HL)
207E    77              	LD	(HL), A
207F    23              	INC	HL
2080    D1              	POP	DE
2081    7B              	LD	A, E
2082    A6              	AND	(HL)
2083    77              	LD	(HL), A
2084    23              	INC	HL
2085    7A              	LD	A, D
2086    A6              	AND	(HL)
2087    77              	LD	(HL), A
2088    09              	ADD	HL, BC
2089    D1              	POP	DE
208A    7B              	LD	A, E
208B    A6              	AND	(HL)
208C    77              	LD	(HL), A
208D    23              	INC	HL
208E    7A              	LD	A, D
208F    A6              	AND	(HL)
2090    77              	LD	(HL), A
2091    23              	INC	HL
2092    D1              	POP	DE
2093    7B              	LD	A, E
2094    A6              	AND	(HL)
2095    77              	LD	(HL), A
2096    23              	INC	HL
2097    7A              	LD	A, D
2098    A6              	AND	(HL)
2099    77              	LD	(HL), A
209A    09              	ADD	HL, BC
209B    D1              	POP	DE
209C    7B              	LD	A, E
209D    A6              	AND	(HL)
209E    77              	LD	(HL), A
209F    23              	INC	HL
20A0    7A              	LD	A, D
20A1    A6              	AND	(HL)
20A2    77              	LD	(HL), A
20A3    23              	INC	HL
20A4    D1              	POP	DE
20A5    7B              	LD	A, E
20A6    A6              	AND	(HL)
20A7    77              	LD	(HL), A
20A8    23              	INC	HL
20A9    7A              	LD	A, D
20AA    A6              	AND	(HL)
20AB    77              	LD	(HL), A
20AC    09              	ADD	HL, BC
20AD    D1              	POP	DE
20AE    7B              	LD	A, E
20AF    A6              	AND	(HL)
20B0    77              	LD	(HL), A
20B1    23              	INC	HL
20B2    7A              	LD	A, D
20B3    A6              	AND	(HL)
20B4    77              	LD	(HL), A
20B5    23              	INC	HL
20B6    D1              	POP	DE
20B7    7B              	LD	A, E
20B8    A6              	AND	(HL)
20B9    77              	LD	(HL), A
20BA    23              	INC	HL
20BB    7A              	LD	A, D
20BC    A6              	AND	(HL)
20BD    77              	LD	(HL), A
20BE    09              	ADD	HL, BC
20BF    D1              	POP	DE
20C0    7B              	LD	A, E
20C1    A6              	AND	(HL)
20C2    77              	LD	(HL), A
20C3    23              	INC	HL
20C4    7A              	LD	A, D
20C5    A6              	AND	(HL)
20C6    77              	LD	(HL), A
20C7    23              	INC	HL
20C8    D1              	POP	DE
20C9    7B              	LD	A, E
20CA    A6              	AND	(HL)
20CB    77              	LD	(HL), A
20CC    23              	INC	HL
20CD    7A              	LD	A, D
20CE    A6              	AND	(HL)
20CF    77              	LD	(HL), A
20D0    09              	ADD	HL, BC
20D1    D1              	POP	DE
20D2    7B              	LD	A, E
20D3    A6              	AND	(HL)
20D4    77              	LD	(HL), A
20D5    23              	INC	HL
20D6    7A              	LD	A, D
20D7    A6              	AND	(HL)
20D8    77              	LD	(HL), A
20D9    23              	INC	HL
20DA    D1              	POP	DE
20DB    7B              	LD	A, E
20DC    A6              	AND	(HL)
20DD    77              	LD	(HL), A
20DE    23              	INC	HL
20DF    7A              	LD	A, D
20E0    A6              	AND	(HL)
20E1    77              	LD	(HL), A
20E2    09              	ADD	HL, BC
20E3    D1              	POP	DE
20E4    7B              	LD	A, E
20E5    A6              	AND	(HL)
20E6    77              	LD	(HL), A
20E7    23              	INC	HL
20E8    7A              	LD	A, D
20E9    A6              	AND	(HL)
20EA    77              	LD	(HL), A
20EB    23              	INC	HL
20EC    D1              	POP	DE
20ED    7B              	LD	A, E
20EE    A6              	AND	(HL)
20EF    77              	LD	(HL), A
20F0    23              	INC	HL
20F1    7A              	LD	A, D
20F2    A6              	AND	(HL)
20F3    77              	LD	(HL), A
20F4    09              	ADD	HL, BC
20F5    D1              	POP	DE
20F6    7B              	LD	A, E
20F7    A6              	AND	(HL)
20F8    77              	LD	(HL), A
20F9    23              	INC	HL
20FA    7A              	LD	A, D
20FB    A6              	AND	(HL)
20FC    77              	LD	(HL), A
20FD    23              	INC	HL
20FE    D1              	POP	DE
20FF    7B              	LD	A, E
2100    A6              	AND	(HL)
2101    77              	LD	(HL), A
2102    23              	INC	HL
2103    7A              	LD	A, D
2104    A6              	AND	(HL)
2105    77              	LD	(HL), A
2106    ED 73 0B 21     	LD	(PUT_AND_32x16_LD_HL_SP + 1), SP
210A                    PUT_AND_32x16_LD_HL_SP:
210A    21 00 00        	LD	HL, 0000
210D                    PUT_AND_32x16_RESTORE_STACK:
210D    31 00 00        	LD	SP, 0000
2110    C9              	RET
2111
2111                    ;32x16単色をOR転送する
2111                    ;	LD	DE, POSITION
2111                    ;	LD	HL, PATTERN
2111                    PUT_OR_32x16:
2111    ED 73 41 22     	LD	(PUT_OR_32x16_RESTORE_STACK + 1), SP
2115    F9              	LD	SP, HL
2116    EB              	EX	DE, HL
2117    01 4D 00        	LD	BC, 77
211A    D1              	POP	DE
211B    7B              	LD	A, E
211C    B6              	OR	(HL)
211D    77              	LD	(HL), A
211E    23              	INC	HL
211F    7A              	LD	A, D
2120    B6              	OR	(HL)
2121    77              	LD	(HL), A
2122    23              	INC	HL
2123    D1              	POP	DE
2124    7B              	LD	A, E
2125    B6              	OR	(HL)
2126    77              	LD	(HL), A
2127    23              	INC	HL
2128    7A              	LD	A, D
2129    B6              	OR	(HL)
212A    77              	LD	(HL), A
212B    09              	ADD	HL, BC
212C    D1              	POP	DE
212D    7B              	LD	A, E
212E    B6              	OR	(HL)
212F    77              	LD	(HL), A
2130    23              	INC	HL
2131    7A              	LD	A, D
2132    B6              	OR	(HL)
2133    77              	LD	(HL), A
2134    23              	INC	HL
2135    D1              	POP	DE
2136    7B              	LD	A, E
2137    B6              	OR	(HL)
2138    77              	LD	(HL), A
2139    23              	INC	HL
213A    7A              	LD	A, D
213B    B6              	OR	(HL)
213C    77              	LD	(HL), A
213D    09              	ADD	HL, BC
213E    D1              	POP	DE
213F    7B              	LD	A, E
2140    B6              	OR	(HL)
2141    77              	LD	(HL), A
2142    23              	INC	HL
2143    7A              	LD	A, D
2144    B6              	OR	(HL)
2145    77              	LD	(HL), A
2146    23              	INC	HL
2147    D1              	POP	DE
2148    7B              	LD	A, E
2149    B6              	OR	(HL)
214A    77              	LD	(HL), A
214B    23              	INC	HL
214C    7A              	LD	A, D
214D    B6              	OR	(HL)
214E    77              	LD	(HL), A
214F    09              	ADD	HL, BC
2150    D1              	POP	DE
2151    7B              	LD	A, E
2152    B6              	OR	(HL)
2153    77              	LD	(HL), A
2154    23              	INC	HL
2155    7A              	LD	A, D
2156    B6              	OR	(HL)
2157    77              	LD	(HL), A
2158    23              	INC	HL
2159    D1              	POP	DE
215A    7B              	LD	A, E
215B    B6              	OR	(HL)
215C    77              	LD	(HL), A
215D    23              	INC	HL
215E    7A              	LD	A, D
215F    B6              	OR	(HL)
2160    77              	LD	(HL), A
2161    09              	ADD	HL, BC
2162    D1              	POP	DE
2163    7B              	LD	A, E
2164    B6              	OR	(HL)
2165    77              	LD	(HL), A
2166    23              	INC	HL
2167    7A              	LD	A, D
2168    B6              	OR	(HL)
2169    77              	LD	(HL), A
216A    23              	INC	HL
216B    D1              	POP	DE
216C    7B              	LD	A, E
216D    B6              	OR	(HL)
216E    77              	LD	(HL), A
216F    23              	INC	HL
2170    7A              	LD	A, D
2171    B6              	OR	(HL)
2172    77              	LD	(HL), A
2173    09              	ADD	HL, BC
2174    D1              	POP	DE
2175    7B              	LD	A, E
2176    B6              	OR	(HL)
2177    77              	LD	(HL), A
2178    23              	INC	HL
2179    7A              	LD	A, D
217A    B6              	OR	(HL)
217B    77              	LD	(HL), A
217C    23              	INC	HL
217D    D1              	POP	DE
217E    7B              	LD	A, E
217F    B6              	OR	(HL)
2180    77              	LD	(HL), A
2181    23              	INC	HL
2182    7A              	LD	A, D
2183    B6              	OR	(HL)
2184    77              	LD	(HL), A
2185    09              	ADD	HL, BC
2186    D1              	POP	DE
2187    7B              	LD	A, E
2188    B6              	OR	(HL)
2189    77              	LD	(HL), A
218A    23              	INC	HL
218B    7A              	LD	A, D
218C    B6              	OR	(HL)
218D    77              	LD	(HL), A
218E    23              	INC	HL
218F    D1              	POP	DE
2190    7B              	LD	A, E
2191    B6              	OR	(HL)
2192    77              	LD	(HL), A
2193    23              	INC	HL
2194    7A              	LD	A, D
2195    B6              	OR	(HL)
2196    77              	LD	(HL), A
2197    09              	ADD	HL, BC
2198    D1              	POP	DE
2199    7B              	LD	A, E
219A    B6              	OR	(HL)
219B    77              	LD	(HL), A
219C    23              	INC	HL
219D    7A              	LD	A, D
219E    B6              	OR	(HL)
219F    77              	LD	(HL), A
21A0    23              	INC	HL
21A1    D1              	POP	DE
21A2    7B              	LD	A, E
21A3    B6              	OR	(HL)
21A4    77              	LD	(HL), A
21A5    23              	INC	HL
21A6    7A              	LD	A, D
21A7    B6              	OR	(HL)
21A8    77              	LD	(HL), A
21A9    09              	ADD	HL, BC
21AA    D1              	POP	DE
21AB    7B              	LD	A, E
21AC    B6              	OR	(HL)
21AD    77              	LD	(HL), A
21AE    23              	INC	HL
21AF    7A              	LD	A, D
21B0    B6              	OR	(HL)
21B1    77              	LD	(HL), A
21B2    23              	INC	HL
21B3    D1              	POP	DE
21B4    7B              	LD	A, E
21B5    B6              	OR	(HL)
21B6    77              	LD	(HL), A
21B7    23              	INC	HL
21B8    7A              	LD	A, D
21B9    B6              	OR	(HL)
21BA    77              	LD	(HL), A
21BB    09              	ADD	HL, BC
21BC    D1              	POP	DE
21BD    7B              	LD	A, E
21BE    B6              	OR	(HL)
21BF    77              	LD	(HL), A
21C0    23              	INC	HL
21C1    7A              	LD	A, D
21C2    B6              	OR	(HL)
21C3    77              	LD	(HL), A
21C4    23              	INC	HL
21C5    D1              	POP	DE
21C6    7B              	LD	A, E
21C7    B6              	OR	(HL)
21C8    77              	LD	(HL), A
21C9    23              	INC	HL
21CA    7A              	LD	A, D
21CB    B6              	OR	(HL)
21CC    77              	LD	(HL), A
21CD    09              	ADD	HL, BC
21CE    D1              	POP	DE
21CF    7B              	LD	A, E
21D0    B6              	OR	(HL)
21D1    77              	LD	(HL), A
21D2    23              	INC	HL
21D3    7A              	LD	A, D
21D4    B6              	OR	(HL)
21D5    77              	LD	(HL), A
21D6    23              	INC	HL
21D7    D1              	POP	DE
21D8    7B              	LD	A, E
21D9    B6              	OR	(HL)
21DA    77              	LD	(HL), A
21DB    23              	INC	HL
21DC    7A              	LD	A, D
21DD    B6              	OR	(HL)
21DE    77              	LD	(HL), A
21DF    09              	ADD	HL, BC
21E0    D1              	POP	DE
21E1    7B              	LD	A, E
21E2    B6              	OR	(HL)
21E3    77              	LD	(HL), A
21E4    23              	INC	HL
21E5    7A              	LD	A, D
21E6    B6              	OR	(HL)
21E7    77              	LD	(HL), A
21E8    23              	INC	HL
21E9    D1              	POP	DE
21EA    7B              	LD	A, E
21EB    B6              	OR	(HL)
21EC    77              	LD	(HL), A
21ED    23              	INC	HL
21EE    7A              	LD	A, D
21EF    B6              	OR	(HL)
21F0    77              	LD	(HL), A
21F1    09              	ADD	HL, BC
21F2    D1              	POP	DE
21F3    7B              	LD	A, E
21F4    B6              	OR	(HL)
21F5    77              	LD	(HL), A
21F6    23              	INC	HL
21F7    7A              	LD	A, D
21F8    B6              	OR	(HL)
21F9    77              	LD	(HL), A
21FA    23              	INC	HL
21FB    D1              	POP	DE
21FC    7B              	LD	A, E
21FD    B6              	OR	(HL)
21FE    77              	LD	(HL), A
21FF    23              	INC	HL
2200    7A              	LD	A, D
2201    B6              	OR	(HL)
2202    77              	LD	(HL), A
2203    09              	ADD	HL, BC
2204    D1              	POP	DE
2205    7B              	LD	A, E
2206    B6              	OR	(HL)
2207    77              	LD	(HL), A
2208    23              	INC	HL
2209    7A              	LD	A, D
220A    B6              	OR	(HL)
220B    77              	LD	(HL), A
220C    23              	INC	HL
220D    D1              	POP	DE
220E    7B              	LD	A, E
220F    B6              	OR	(HL)
2210    77              	LD	(HL), A
2211    23              	INC	HL
2212    7A              	LD	A, D
2213    B6              	OR	(HL)
2214    77              	LD	(HL), A
2215    09              	ADD	HL, BC
2216    D1              	POP	DE
2217    7B              	LD	A, E
2218    B6              	OR	(HL)
2219    77              	LD	(HL), A
221A    23              	INC	HL
221B    7A              	LD	A, D
221C    B6              	OR	(HL)
221D    77              	LD	(HL), A
221E    23              	INC	HL
221F    D1              	POP	DE
2220    7B              	LD	A, E
2221    B6              	OR	(HL)
2222    77              	LD	(HL), A
2223    23              	INC	HL
2224    7A              	LD	A, D
2225    B6              	OR	(HL)
2226    77              	LD	(HL), A
2227    09              	ADD	HL, BC
2228    D1              	POP	DE
2229    7B              	LD	A, E
222A    B6              	OR	(HL)
222B    77              	LD	(HL), A
222C    23              	INC	HL
222D    7A              	LD	A, D
222E    B6              	OR	(HL)
222F    77              	LD	(HL), A
2230    23              	INC	HL
2231    D1              	POP	DE
2232    7B              	LD	A, E
2233    B6              	OR	(HL)
2234    77              	LD	(HL), A
2235    23              	INC	HL
2236    7A              	LD	A, D
2237    B6              	OR	(HL)
2238    77              	LD	(HL), A
2239    ED 73 3E 22     	LD	(PUT_OR_32x16_LD_HL_SP + 1), SP
223D                    PUT_OR_32x16_LD_HL_SP:
223D    21 00 00        	LD	HL, 0000
2240                    PUT_OR_32x16_RESTORE_STACK:
2240    31 00 00        	LD	SP, 0000
2243    C9              	RET
2244                    ; プリンタリセット
2244                    RESET_PRINTER:
2244    AF              	XOR	A
2245    D3 FE           	OUT	(0FEh), A
2247    3E 80           	LD	A, 080h
2249    D3 FE           	OUT	(0FEh), A
224B    AF              	XOR	A
224C    D3 FE           	OUT	(0FEh), A
224E    C9              	RET
224F
224F                    ;一文字プリンタに送る
224F                    ;	LD	A, 'A'
224F                    PUT_PRINTER1:
224F    F5              	PUSH	AF
2250                    PUT_PRINTER1_L1:
2250    DB FE           	IN	A, (0FEh)
2252    CB 47           	BIT	0, A
2254    20 FA           	JR	NZ, PUT_PRINTER1_L1
2256    F1              	POP	AF
2257    D3 FF           	OUT	(0FFh), A ; 1文字分送る
2259    3E 80           	LD	A, 080h
225B    D3 FE           	OUT	(0FEh), A ; Hi
225D    AF              	XOR	A
225E    D3 FE           	OUT	(0FEh), A ; Lo
2260    C9              	RET
2261
2261                    ;メッセージをプリンタに送る
2261                    ;	LD	HL, MES
2261                    MSGOUT_PRINTER:
2261    E5              	PUSH	HL
2262                    MSGOUT_PRINTER_L1:
2262    7E              	LD	A, (HL)
2263    B7              	OR	A
2264    28 06           	JR	Z, MSGOUT_PRINTER_END
2266    CD 4F 22        	CALL	PUT_PRINTER1
2269    23              	INC	HL
226A    18 F6           	JR	MSGOUT_PRINTER_L1
226C                    MSGOUT_PRINTER_END:
226C    E1              	POP	HL
226D    C9              	RET
226E
226E                    ;0Dhで終わるメッセージをプリンタに送る
226E                    ;	LD	HL, MES
226E                    MSG0D_OUT_PRINTER:
226E    E5              	PUSH	HL
226F                    MSG0D_OUT_PRINTER_L1:
226F    7E              	LD	A, (HL)
2270    FE 0D           	CP	0Dh
2272    28 06           	JR	Z, MSG0D_OUT_PRINTER_END
2274    CD 4F 22        	CALL	PUT_PRINTER1
2277    23              	INC	HL
2278    18 F5           	JR	MSG0D_OUT_PRINTER_L1
227A                    MSG0D_OUT_PRINTER_END:
227A    E1              	POP	HL
227B    C9              	RET
227C
227C                    ; HLレジスタの値を16進数2桁でプリンタに送る
227C                    PUTHEX16_PRINTER:
227C    E5              	PUSH	HL
227D    7C              	LD	A, H
227E    CD 87 22        	CALL	PUTHEX_PRINTER
2281    7D              	LD	A, L
2282    CD 87 22        	CALL	PUTHEX_PRINTER
2285    E1              	POP	HL
2286    C9              	RET
2287
2287                    ; Aレジスタの値を16進数2桁でプリンタに送る
2287                    PUTHEX_PRINTER:
2287    F5              	PUSH	AF
2288    CB 3F           	SRL	A
228A    CB 3F           	SRL	A
228C    CB 3F           	SRL	A
228E    CB 3F           	SRL	A
2290    E6 0F           	AND	00FH
2292    CD 9E 22        	CALL	PUTHEX1_PRINTER
2295    F1              	POP	AF
2296    F5              	PUSH	AF
2297    E6 0F           	AND	00FH
2299    CD 9E 22        	CALL	PUTHEX1_PRINTER
229C    F1              	POP	AF
229D    C9              	RET
229E
229E                    ; Aレジスタの0～Fをプリンタに送る
229E                    PUTHEX1_PRINTER:
229E    F5              	PUSH	AF
229F    C5              	PUSH	BC
22A0    E5              	PUSH	HL
22A1    CD A3 14        	CALL	A_TO_HEX
22A4    CD 4F 22        	CALL	PUT_PRINTER1
22A7    E1              	POP	HL
22A8    C1              	POP	BC
22A9    F1              	POP	AF
22AA    C9              	RET
22AB
22AB                    ; ダンプする
22AB                    ; LD	HL, Addr
22AB                    ; LD	DE, size
22AB                    DUMP_PRINTER:
22AB    C5              	PUSH	BC
22AC    D5              	PUSH	DE
22AD    E5              	PUSH	HL
22AE                    DUMP_PRINTER_1:
22AE                    	; アドレス
22AE    7C              	LD	A, H
22AF    CD 87 22        	CALL	PUTHEX_PRINTER
22B2    7D              	LD	A, L
22B3    CD 87 22        	CALL	PUTHEX_PRINTER
22B6    3E 3A           	LD	A, ':'
22B8    CD 4F 22        	CALL	PUT_PRINTER1
22BB    3E 20           	LD	A, ' '
22BD    CD 4F 22        	CALL	PUT_PRINTER1
22C0    06 10           	LD	B, 16
22C2                    DUMP_PRINTER_2:
22C2    7E              	LD	A, (HL)
22C3    CD 87 22        	CALL	PUTHEX_PRINTER
22C6    3E 20           	LD	A, ' '
22C8    CD 4F 22        	CALL	PUT_PRINTER1
22CB    23              	INC	HL
22CC    1B              	DEC	DE
22CD    7A              	LD	A, D
22CE    B3              	OR	E
22CF    28 0F           	JR	Z, DUMP_PRINTER_3
22D1    05              	DEC	B
22D2    20 EE           	JR	NZ, DUMP_PRINTER_2
22D4    3E 0D           	LD	A, 00Dh
22D6    CD 4F 22        	CALL	PUT_PRINTER1
22D9    3E 0A           	LD	A, 00Ah
22DB    CD 4F 22        	CALL	PUT_PRINTER1
22DE    18 CE           	JR	DUMP_PRINTER_1
22E0                    DUMP_PRINTER_3:
22E0    E1              	POP	HL
22E1    D1              	POP	DE
22E2    C1              	POP	BC
22E3    C9              	RET
22E4                    ; FDD I/O Port
00D8                    CR	EQU	0D8H ; FDCコマンドレジスタ
00D9                    TR	EQU	0D9H ; FDCトラックレジスタ
00DA                    SCR	EQU	0DAH ; FDCセクタレジスタ
00DB                    DR	EQU	0DBH ; FDCデータレジスタ
00DC                    DM	EQU	0DCH ; ディスクドライブの選択とモーター制御
00DD                    HS	EQU	0DDH ; ディスクのサイド(面)選択
22E4
22E4                    ; READ DIR
22E4                    ; LD	A, ドライブ番号
22E4                    ; LD	HL, ファイルネーム
22E4                    ; LD	IX, BUFFER(最低2KB)
22E4                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
22E4                    READ_FILE:
22E4    E5              	PUSH	HL
22E5    FD 21 0E 25     	LD	IY, WKIY
22E9    32 0B 25        	LD	(DIRNO), A	; ドライブ番号
22EC    3E 00           	LD	A, 000h
22EE    FD 77 02        	LD	(IY+2), A
22F1    3E 08           	LD	A, 008h
22F3    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ2Kバイト
22F6    01 10 00        	LD	BC, 16
22F9    ED 43 09 25     	LD	(STREC), BC	; レコード16 (DIR)
22FD    CD 27 24        	CALL	BREAD
2300    F5              	PUSH	AF
2301    CD 9B 23        	CALL	MOFF
2304    F1              	POP	AF
2305    E1              	POP	HL
2306    D8              	RET	C		; Cyが1ならディレクトリ読み込みエラー
2307    06 40           	LD	B, 64
2309    DD E5           	PUSH	IX
230B    D1              	POP	DE
230C                    READ_FILE_1:
230C    1A              	LD	A, (DE)
230D    13              	INC	DE
230E    FE 01           	CP	001h
2310    20 09           	JR	NZ, READ_FILE_2 ; モードが01h(Obj)以外は無視
2312    D5              	PUSH	DE
2313    E5              	PUSH	HL
2314    CD C4 14        	CALL	CMP_TEXT
2317    E1              	POP	HL
2318    D1              	POP	DE
2319    38 0D           	JR	C, READ_FILE_3
231B                    READ_FILE_2:
231B                    	; DE = DE + 31
231B    EB              	EX	DE, HL
231C    C5              	PUSH	BC
231D    01 1F 00        	LD	BC, 31
2320    09              	ADD	HL, BC
2321    C1              	POP	BC
2322    EB              	EX	DE, HL
2323                    	; ループ判定
2323    05              	DEC	B
2324    20 E6           	JR	NZ, READ_FILE_1
2326    37              	SCF
2327    C9              	RET			; ファイルが見つからない
2328                    READ_FILE_3:
2328                    	; 読み込むファイルを見つけた
2328                    	; DE = DE + 19
2328    01 13 00        	LD	BC, 19
232B    EB              	EX	DE, HL
232C    09              	ADD	HL, BC
232D    EB              	EX	DE, HL
232E                    	; 読み込みサイズ取得
232E    1A              	LD	A, (DE)
232F    FD 77 02        	LD	(IY+2), A	; 読み込みサイズ下位バイト設定
2332    13              	INC	DE
2333    1A              	LD	A, (DE)
2334    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ上位バイト設定
2337    13              	INC	DE
2338                    	; 読み込みアドレス取得
2338                    ;	LD	A, (DE)
2338    13              	INC	DE
2339                    ;	LD	C, A
2339                    ;	LD	A, (DE)
2339    13              	INC	DE
233A                    ;	LD	B, A
233A                    ;	PUSH	BC
233A                    ;	POP	IX
233A                    	; DE = DE + 6
233A    01 06 00        	LD	BC, 6
233D    EB              	EX	DE, HL
233E    09              	ADD	HL, BC
233F    EB              	EX	DE, HL
2340                    	; 読み込み開始レコード番号
2340    1A              	LD	A, (DE)
2341    13              	INC	DE
2342    4F              	LD	C, A
2343    1A              	LD	A, (DE)
2344    13              	INC	DE
2345    47              	LD	B, A
2346    ED 43 09 25     	LD	(STREC), BC	; レコード番号設定
234A                    	; 読み込み開始
234A    CD 27 24        	CALL	BREAD
234D    F5              	PUSH	AF
234E    CD 9B 23        	CALL	MOFF
2351    F1              	POP	AF
2352    C9              	RET
2353
2353                    ; READY
2353    3A 0C 25        READY:	LD	A, (MTFG)
2356    0F              	RRCA
2357    CD 85 23        	CALL	MTON
235A    3A 0B 25        	LD	A, (DIRNO)	; DRIVE NO GET
235D    F6 84           	OR	084H
235F    D3 DC           	OUT	(DM), A		; DRIVE SELECT MOTON
2361    AF              	XOR	A
2362    CD B9 14        	CALL	DLY60M
2365    21 00 00        	LD	HL, 00000H
2368    2B              REDY0:	DEC	HL
2369    7C              	LD	A, H
236A    B5              	OR	L
236B    CA F5 24        	JP	Z, DERROR	; NO DISK
236E    DB D8           	IN	A, (CR)		; STATUS GET
2370    2F              	CPL
2371    07              	RLCA
2372    38 F4           	JR	C, REDY0
2374    3A 0B 25        	LD	A, (DIRNO)
2377    4F              	LD	C,A
2378    21 07 25        	LD	HL, CLBF0
237B    06 00           	LD	B, 000H
237D    09              	ADD	HL, BC
237E    CB 46           	BIT	0, (HL)
2380    C0              	RET	NZ
2381    CD B6 23        	CALL	RCLB
2384    C9              	RET
2385
2385                    ; MOTOR ON
2385    3E 80           MTON:	LD	A,080H
2387    D3 DC           	OUT	(DM), A
2389    06 0A           	LD	B, 10		; 1SEC DELAY
238B    21 19 3C        MTD1:	LD	HL, 03C19H
238E    2B              MTD2:	DEC	HL
238F    7D              	LD	A, L
2390    B4              	OR	H
2391    20 FB           	JR	NZ, MTD2
2393    10 F6           	DJNZ	MTD1
2395    3E 01           	LD	A, 1
2397    32 0C 25        	LD	(MTFG), A
239A    C9              	RET
239B
239B                    ; MOTOR OFF
239B    CD B2 14        MOFF:	CALL	DLY1M		; 1000US DELAY
239E    AF              	XOR	A
239F    D3 DC           	OUT	(DM), A
23A1    32 0C 25        	LD	(MTFG), A
23A4    C9              	RET
23A5
23A5                    ; SEEK TREATMENT
23A5    3E 1B           SEEK:	LD	A, 01BH
23A7    2F              	CPL
23A8    D3 D8           	OUT	(CR), A
23AA    CD CE 23        	CALL	BUSY
23AD    CD B9 14        	CALL	DLY60M
23B0    DB D8           	IN	A, (CR)
23B2    2F              	CPL
23B3    E6 99           	AND	099H
23B5    C9              	RET
23B6
23B6                    ; RECALIBLATION
23B6    E5              RCLB:	PUSH	HL
23B7    3E 0B           	LD	A, 00BH
23B9    2F              	CPL
23BA    D3 D8           	OUT	(CR), A
23BC    CD CE 23        	CALL	BUSY
23BF    CD B9 14        	CALL	DLY60M
23C2    DB D8           	IN	A, (CR)
23C4    2F              	CPL
23C5    E6 85           	AND	085H
23C7    EE 04           	XOR	004H
23C9    E1              	POP	HL
23CA    C8              	RET	Z
23CB    C3 F5 24        	JP	DERROR
23CE
23CE                    ; BUSY AND WAIT
23CE    D5              BUSY:	PUSH	DE
23CF    E5              	PUSH	HL
23D0    CD AB 14        	CALL	DLY80U
23D3    1E 07           	LD	E, 7
23D5    21 00 00        BUSY2:	LD	HL, 000H
23D8    2B              BUSY0:	DEC	HL
23D9    7C              	LD	A, H
23DA    B5              	OR	L
23DB    28 09           	JR	Z, BUSY1
23DD    DB D8           	IN	A, (CR)
23DF    2F              	CPL
23E0    0F              	RRCA
23E1    38 F5           	JR	C, BUSY0
23E3    E1              	POP	HL
23E4    D1              	POP	DE
23E5    C9              	RET
23E6    1D              BUSY1:	DEC	E
23E7    20 EC           	JR	NZ, BUSY2
23E9    C3 F5 24        	JP	DERROR
23EC
23EC                    ; DATA CHECK
23EC    06 00           CONVRT:	LD	B, 0
23EE    11 10 00        	LD	DE, 16
23F1    2A 09 25        	LD	HL, (STREC)		; START RECORD
23F4    AF              	XOR	A
23F5    ED 52           TRANS:	SBC	HL, DE
23F7    38 03           	JR	C, TRANS1
23F9    04              	INC	B
23FA    18 F9           	JR	TRANS
23FC    19              TRANS1:	ADD	HL, DE
23FD    60              	LD	H, B
23FE    2C              	INC	L
23FF    FD 74 04        	LD	(IY+4), H
2402    FD 75 05        	LD	(IY+5), L
2405    3A 0B 25        DCHK:	LD	A, (DIRNO)
2408    FE 04           	CP	4
240A    30 18           	JR	NC, DTCK1
240C    FD 7E 04        	LD	A, (IY+4)
240F    FE A0           MAXTRK:	CP	160		; MAX TRACK ( 70 -> 35TRACK 2D)
2411                    				; MAX TRACK (160 -> 80TRACK 2D)
2411    30 11           	JR	NC, DTCK1
2413    FD 7E 05        	LD	A, (IY+5)
2416    B7              	OR	A
2417    28 0B           	JR	Z, DTCK1
2419    FE 11           	CP	17		; MAX SECTOR
241B    30 07           	JR	NC, DTCK1
241D    FD 7E 02        	LD	A, (IY+2)
2420    FD B6 03        	OR	(IY+3)
2423    C0              	RET	NZ
2424    C3 F5 24        DTCK1:	JP	DERROR
2427
2427                    ; SEQENTIAL READ
2427                    ; DIRNO: ドライブ番号
2427                    ; IX: 読み込みアドレス
2427                    ; IY: 6バイトのワークエリア
2427                    ; STREC: 読み込みレコード番号
2427                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
2427    F3              BREAD:	DI
2428    CD EC 23        	CALL	CONVRT
242B    3E 0A           	LD	A, 10
242D    32 0D 25        	LD	(RETRY), A
2430    CD 53 23        READ1:	CALL	READY
2433    FD 56 03        	LD	D, (IY+3)
2436    FD 7E 02        	LD	A, (IY+2)
2439    B7              	OR	A
243A    28 01           	JR	Z, RE0
243C    14              	INC	D
243D    FD 7E 05        RE0:	LD	A, (IY+5)
2440    FD 77 01        	LD	(IY+1), A
2443    FD 7E 04        	LD	A, (IY+4)
2446    FD 77 00        	LD	(IY+0), A
2449    DD E5           	PUSH	IX
244B    E1              	POP	HL
244C    CB 3F           RE8:	SRL	A
244E    2F              	CPL
244F    D3 DB           	OUT	(DR), A
2451    30 04           	JR	NC, RE1
2453    3E 01           	LD	A, 001H
2455    18 02           	JR	RE2
2457    3E 00           RE1:	LD	A, 000H
2459    2F              RE2:	CPL
245A    D3 DD           	OUT	(HS), A
245C    CD A5 23        	CALL	SEEK
245F    20 6A           	JR	NZ, REE
2461    0E DB           	LD	C, 0DBH
2463    FD 7E 00        	LD	A, (IY+0)
2466    CB 3F           	SRL	A
2468    2F              	CPL
2469    D3 D9           	OUT	(TR), A
246B    FD 7E 01        	LD	A, (IY+1)
246E    2F              	CPL
246F    D3 DA           	OUT	(SCR),A
2471    D9              	EXX
2472    21 A4 24        	LD	HL, RE3
2475    E5              	PUSH	HL
2476    D9              	EXX
2477    3E 94           	LD	A, 094H		;READ & CMD
2479    2F              	CPL
247A    D3 D8           	OUT	(CR), A
247C    CD DA 24        	CALL	WAIT
247F    06 00           RE6:	LD	B, 000H
2481    DB D8           RE4:	IN	A, (CR)
2483    0F              	RRCA
2484    D8              	RET	C
2485    0F              	RRCA
2486    38 F9           	JR	C, RE4
2488    ED A2           	INI
248A    20 F5           	JR	NZ, RE4
248C    FD 34 01        	INC	(IY+1)
248F    FD 7E 01        	LD	A, (IY+1)
2492    FE 11           	CP	17
2494    28 05           	JR	Z, RETS
2496    15              	DEC	D
2497    20 E6           	JR	NZ, RE6
2499    18 01           	JR	RE5
249B    15              RETS:	DEC	D
249C    3E D8           RE5:	LD	A, 0D8H		; FORCE INTER RUPT
249E    2F              	CPL
249F    D3 D8           	OUT	(CR), A
24A1    CD CE 23        	CALL	BUSY
24A4    DB D8           RE3:	IN	A, (CR)
24A6    2F              	CPL
24A7    E6 FF           	AND	0FFH
24A9    20 20           	JR	NZ, REE
24AB    D9              	EXX
24AC    E1              	POP	HL
24AD    D9              	EXX
24AE    FD 7E 01        	LD	A, (IY+1)
24B1    FE 11           	CP	17
24B3    20 08           	JR	NZ, REX
24B5    3E 01           	LD	A, 001H
24B7    FD 77 01        	LD	(IY+1), A
24BA    FD 34 00        	INC	(IY+0)
24BD    7A              REX:	LD	A, D
24BE    B7              	OR	A
24BF    20 05           	JR	NZ, RE7
24C1    3E 80           	LD	A, 080H
24C3    D3 DC           	OUT	(DM), A
24C5    C9              	RET
24C6    FD 7E 00        RE7:	LD	A, (IY+0)
24C9    18 81           	JR	RE8
24CB    3A 0D 25        REE:	LD	A, (RETRY)
24CE    3D              	DEC	A
24CF    32 0D 25        	LD	(RETRY), A
24D2    28 21           	JR	Z, DERROR
24D4    CD B6 23        	CALL	RCLB
24D7    C3 30 24        	JP	READ1
24DA
24DA                    ; WAIT AND BUSY OFF
24DA    D5              WAIT:	PUSH	DE
24DB    E5              	PUSH	HL
24DC    CD AB 14        	CALL	DLY80U
24DF    21 00 00        WAIT2:	LD	HL, 00000H
24E2    2B              WAIT0:	DEC	HL
24E3    7C              	LD	A, H
24E4    B5              	OR	L
24E5    28 09           	JR	Z, WAIT1
24E7    DB D8           	IN	A, (CR)
24E9    2F              	CPL
24EA    0F              	RRCA
24EB    30 F5           	JR	NC, WAIT0
24ED    E1              	POP	HL
24EE    D1              	POP	DE
24EF    C9              	RET
24F0    1D              WAIT1:	DEC	E
24F1    20 EC           	JR	NZ, WAIT2
24F3    18 00           	JR	DERROR
24F5
24F5                    ; ディスクエラー
24F5    CD 9B 23        DERROR:	CALL	MOFF
24F8    3E A5           	LD	A, 0A5H
24FA    D3 D9           	OUT	(TR), A
24FC    CD AB 14        	CALL	DLY80U
24FF    21 16 25        	LD	HL, ERROR_MESSAGE
2502    CD 61 22        	CALL	MSGOUT_PRINTER
2505    37              	SCF
2506    C9              	RET
2507
2507    00 00           CLBF0:	DW	0 ; ?
2509    00 00           STREC:	DW	0 ; 読込み開始セクタ
250B    00              DIRNO:	DB	0 ; ドライブ番号(0-3)
250C    00              MTFG:	DB	0 ; モータ0:OFF, 1:ON
250D    00              RETRY:	DB	0 ; 残りリトライ回数
250E    00 00 00 00     WKIY:	DS	6 ; FD READ 指示、ワーク
2512    00 00
2514    00 00           WKIX:	DW	0 ; 読み込みアドレス
2516
2516                    ERROR_MESSAGE:
2516    44 69 73 6B     	DB	"Disk Error\n", 0
251A    20 45 72 72
251E    6F 72 5C 6E
2522    00
2523                    ;INCLUDE "lzdec.mac"
2523
2523                    MSG:
2523    4D 5A 2D 32     	DB	"MZ-2000 DrawTest by kuran-kuran",0
2527    30 30 30 20
252B    44 72 61 77
252F    54 65 73 74
2533    20 62 79 20
2537    6B 75 72 61
253B    6E 2D 6B 75
253F    72 61 6E 00
2543
2543                    ; ソルバルウ
2543                    SOLVALOU:
2543                    SOLVALOU_MASK:
2543                    	; solvalou_mask
2543                    	; 32 x 16 dot
2543    FF 3F FC FF     	DW 03FFFh, 0FFFCh, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 0003Fh, 0FC00h
2547    FF 0F F0 FF
254B    FF 0F F0 FF
254F    FF 0F F0 FF
2553    FF 00 00 FF
2557    FF 00 00 FF
255B    FF 00 00 FF
255F    3F 00 00 FC
2563    0F 00 00 F0     	DW 0000Fh, 0F000h, 00003h, 0C000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00C00h, 00030h, 00FCFh, 0F3F0h
2567    03 00 00 C0
256B    00 00 00 00
256F    00 00 00 00
2573    00 00 00 00
2577    00 00 00 00
257B    00 0C 30 00
257F    CF 0F F0 F3
2583                    	; solvalou
2583                    	; 32 x 16 dot
2583                    	; Blue data
2583                    SOLVALOU_B:
2583    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 0F000h, 0000Fh, 0F000h, 0000Fh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FCh, 0FFC0h, 003FFh
2587    00 F0 0F 00
258B    00 F0 0F 00
258F    00 F0 0F 00
2593    00 FF FF 00
2597    00 FF FF 00
259B    00 FF FC 00
259F    C0 FF FF 03
25A3    F0 FF FF 0F     	DW 0FFF0h, 00FFFh, 0FFFCh, 03FFFh, 0FFFFh, 0FFFFh, 03FFFh, 0FFFCh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0F3FFh, 0FFCFh, 0F030h, 00C0Fh
25A7    FC FF FF 3F
25AB    FF FF FF FF
25AF    FF 3F FC FF
25B3    FF FF FF FF
25B7    FF FF FF FF
25BB    FF F3 CF FF
25BF    30 F0 0F 0C
25C3                    	; Red data
25C3                    SOLVALOU_R:
25C3    00 40 01 00     	DW 04000h, 00001h, 0F000h, 0000Bh, 03000h, 00004h, 03000h, 00008h, 03F00h, 00044h, 03000h, 00008h, 0BB00h, 00047h, 0F7C0h, 0008Bh
25C7    00 F0 0B 00
25CB    00 30 04 00
25CF    00 30 08 00
25D3    00 3F 44 00
25D7    00 30 08 00
25DB    00 BB 47 00
25DF    C0 F7 8B 00
25E3    30 FB 47 04     	DW 0FB30h, 00447h, 0F7CCh, 0208Bh, 0FBF3h, 04447h, 0F733h, 0888Bh, 0FB33h, 04C47h, 0FF33h, 08C8Bh, 00333h, 04C40h, 0F030h, 00C0Ah
25E7    CC F7 8B 20
25EB    F3 FB 47 44
25EF    33 F7 8B 88
25F3    33 FB 47 4C
25F7    33 FF 8B 8C
25FB    33 03 40 4C
25FF    30 F0 0A 0C
2603                    	; Green data
2603                    SOLVALOU_G:
2603    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 07000h, 0000Dh, 0B000h, 0000Ch, 07F00h, 000ECh, 0B000h, 0001Ch, 0FF00h, 000ECh, 0FFC0h, 001DFh
2607    00 F0 0F 00
260B    00 70 0D 00
260F    00 B0 0C 00
2613    00 7F EC 00
2617    00 B0 1C 00
261B    00 FF EC 00
261F    C0 FF DF 01
2623    30 FF CF 0E     	DW 0FF30h, 00ECFh, 0FFCCh, 035CFh, 0FFF3h, 0CECFh, 03F73h, 0CDCCh, 0FFB3h, 0CECFh, 0FF73h, 0CDCFh, 083B3h, 0CECAh, 0F030h, 00C0Fh
2627    CC FF CF 35
262B    F3 FF CF CE
262F    73 3F CC CD
2633    B3 FF CF CE
2637    73 FF CF CD
263B    B3 83 CA CE
263F    30 F0 0F 0C
2643
