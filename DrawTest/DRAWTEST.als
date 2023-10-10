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
13AE    CD 54 1B        	CALL	WIDTH
13B1    CD 80 1B        	CALL	ENABLE_TEXT_VRAM_ADDR
13B4
13B4                    ; テキスト優先、文字色白
13B4    3E 0F           	LD	A, 0Fh
13B6    D3 F5           	OUT	(0F5h), A
13B8                    ; 背景色黒
13B8    3E 00           	LD	A, 0
13BA    D3 F4           	OUT	(0F4h), A
13BC
13BC                    ; テキストクリア
13BC    CD 93 1C        	CALL	CLS
13BF
13BF                    ; 左上指定
13BF    11 00 00        	LD	DE, 0
13C2    CD 96 1B        	CALL	CURSOR
13C5
13C5                    ; メッセージ表示
13C5    21 1D 25        	LD	HL, MSG
13C8    CD 18 1C        	CALL	PRINT_MSG
13CB
13CB                    ; 改行
13CB    CD C3 1B        	CALL	NEW_LINE
13CE
13CE                    ; グラフィック表示初期化
13CE    3E 07           	LD	A, 7
13D0    D3 F6           	OUT	(0F6h), A
13D2
13D2                    ; G-VRAM有効
13D2    CD CD 1C        	CALL	ENABLE_GRAPHIC_ADDR
13D5
13D5                    ; グラフィック画面クリア
13D5    CD DD 1C        	CALL	GRAPHICS_CLS_ALL
13D8
13D8                    ; ソルバルウ表示
13D8                    ; 青
13D8    3E 01           	LD	A, 1
13DA    D3 F7           	OUT	(0F7h), A
13DC    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13DF    21 7D 25        	LD	HL, SOLVALOU_B
13E2    CD 2C 1F        	CALL	PUT32x16
13E5                    ; 赤
13E5    3E 02           	LD	A, 2
13E7    D3 F7           	OUT	(0F7h), A
13E9    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13EC    21 BD 25        	LD	HL, SOLVALOU_R
13EF    CD 2C 1F        	CALL	PUT32x16
13F2                    ; 緑
13F2    3E 03           	LD	A, 3
13F4    D3 F7           	OUT	(0F7h), A
13F6    11 02 C5        	LD	DE, 0C000h + 80 * 16 + 2
13F9    21 FD 25        	LD	HL, SOLVALOU_G
13FC    CD 2C 1F        	CALL	PUT32x16
13FF
13FF                    ; ソルバルウ表示
13FF                    ; 青
13FF    3E 01           	LD	A, 1
1401    D3 F7           	OUT	(0F7h), A
1403    11 06 CA        	LD	DE, 0C000h + 80 * 32 + 6
1406    21 7D 25        	LD	HL, SOLVALOU_B
1409    CD 2C 1F        	CALL	PUT32x16
140C                    ; 赤
140C    3E 02           	LD	A, 2
140E    D3 F7           	OUT	(0F7h), A
1410    11 0A CF        	LD	DE, 0C000h + 80 * 48 + 10
1413    21 BD 25        	LD	HL, SOLVALOU_R
1416    CD 2C 1F        	CALL	PUT32x16
1419                    ; 緑
1419    3E 03           	LD	A, 3
141B    D3 F7           	OUT	(0F7h), A
141D    11 0E D4        	LD	DE, 0C000h + 80 * 64 + 14
1420    21 FD 25        	LD	HL, SOLVALOU_G
1423    CD 2C 1F        	CALL	PUT32x16
1426
1426                    ; G-VRAM無効
1426    CD D6 1C        	CALL	DISABLE_GRAPHIC_ADDR
1429
1429    76              	HALT
142A
142A                    ; ユーティリティ関数
142A                    ; 基本レジスタ破壊を気にしない
142A
142A                    ; 8ビット同士の掛け算
142A                    ; BC = B * E
142A                    MUL_BE:
142A    F5              	PUSH	AF
142B    E5              	PUSH	HL
142C    21 00 00        	LD	HL, 0
142F    0E 00           	LD	C, 0
1431    CB 38           	SRL	B
1433    CB 19           	RR	C
1435    3E 08           	LD	A, 8
1437                    MUL_BE_L1:
1437    CB 23           	SLA	E
1439    30 01           	JR	NC, MUL_BE_L2
143B    09              	ADD	HL, BC
143C                    MUL_BE_L2:
143C    CB 38           	SRL	B
143E    CB 19           	RR	C
1440    3D              	DEC	A
1441    20 F4           	JR	NZ, MUL_BE_L1
1443    4D              	LD	C, L
1444    44              	LD	B, H
1445    E1              	POP	HL
1446    F1              	POP	AF
1447    C9              	RET
1448
1448                    ; HL = HL + A
1448                    ADD_HL_A:
1448    85              	ADD	A, L
1449    6F              	LD	L, A
144A    30 01           	JR	NC, ADD_HL_A_L1
144C    24              	INC	H
144D                    ADD_HL_A_L1:
144D    C9              	RET
144E
144E                    ; HL = HL * 12
144E                    MUL_HLx12:
144E    29              	ADD	HL, HL ; *2
144F    29              	ADD	HL, HL ; *4
1450    44              	LD	B, H
1451    4D              	LD	C, L
1452    29              	ADD	HL, HL ; *8
1453    09              	ADD	HL, BC
1454    C9              	RET
1455
1455                    ; HL = HL * 14
1455                    MUL_HLx14:
1455    29              	ADD	HL, HL ; *2
1456    44              	LD	B, H
1457    4D              	LD	C, L
1458    29              	ADD	HL, HL ; *4
1459    29              	ADD	HL, HL ; *8
145A    09              	ADD	HL, BC
145B    09              	ADD	HL, BC
145C    09              	ADD	HL, BC
145D    C9              	RET
145E
145E                    ; HL = HL * 24
145E                    MUL_HLx24:
145E    29              	ADD	HL, HL ; *2
145F    29              	ADD	HL, HL ; *4
1460    29              	ADD	HL, HL ; *8
1461    44              	LD	B, H
1462    4D              	LD	C, L
1463    29              	ADD	HL, HL ; *16
1464    09              	ADD	HL, BC
1465    C9              	RET
1466
1466                    ; HL = HL * 28
1466                    MUL_HLx28:
1466    29              	ADD	HL, HL ; *2
1467    29              	ADD	HL, HL ; *4
1468    44              	LD	B, H
1469    4D              	LD	C, L
146A    29              	ADD	HL, HL ; *8
146B    54              	LD	D, H
146C    5D              	LD	E, L
146D    29              	ADD	HL, HL ; *16
146E    09              	ADD	HL, BC
146F    19              	ADD	HL, DE
1470    C9              	RET
1471
1471                    ; HL = HL * 40
1471                    ; Break BC
1471                    MUL_HLx40:
1471    29              	ADD	HL, HL ; *2
1472    29              	ADD	HL, HL ; *4
1473    29              	ADD	HL, HL ; *8
1474    44              	LD	B, H
1475    4D              	LD	C, L
1476    29              	ADD	HL, HL ; *16
1477    29              	ADD	HL, HL ; *32
1478    09              	ADD	HL, BC
1479    C9              	RET
147A
147A                    ; HL = HL * 80
147A                    ; Break BC
147A                    MUL_HLx80:
147A    29              	ADD	HL, HL ; *2
147B    29              	ADD	HL, HL ; *4
147C    29              	ADD	HL, HL ; *8
147D    29              	ADD	HL, HL ; *16
147E    44              	LD	B, H
147F    4D              	LD	C, L
1480    29              	ADD	HL, HL ; *32
1481    29              	ADD	HL, HL ; *64
1482    09              	ADD	HL, BC
1483    C9              	RET
1484
1484                    ; HL = HL * 320
1484                    ; Break BC
1484                    MUL_HLx320:
1484    29              	ADD	HL, HL ; *2
1485    29              	ADD	HL, HL ; *4
1486    29              	ADD	HL, HL ; *8
1487    29              	ADD	HL, HL ; *16
1488    29              	ADD	HL, HL ; *32
1489    29              	ADD	HL, HL ; *64
148A    44              	LD	B, H
148B    4D              	LD	C, L
148C    29              	ADD	HL, HL ; *128
148D    29              	ADD	HL, HL ; *256
148E    09              	ADD	HL, BC
148F    C9              	RET
1490
1490                    ; BC = HL / DE 小数点切り捨て, HL = あまり
1490                    DIV16:
1490    01 00 00        	LD	BC, 0
1493    B7              	OR	A
1494                    DIV16_L1:
1494    ED 52           	SBC	HL, DE
1496    38 03           	JR	C, DIV16_L2
1498    03              	INC	BC
1499    18 F9           	JR	DIV16_L1
149B                    DIV16_L2:
149B    19              	ADD	HL, DE
149C    C9              	RET
149D
149D                    ; A(0～15)を(0～F)に変換する
149D                    ; Break HL
149D                    A_TO_HEX:
149D    21 23 15        	LD	HL, HEX_TABLE
14A0    CD 48 14        	CALL	ADD_HL_A
14A3    7E              	LD	A, (HL)
14A4    C9              	RET
14A5
14A5                    ; 一定時間待つ
14A5    D5              DLY80U:	PUSH	DE	; 80マイクロ秒
14A6    11 0D 00        	LD	DE, 13
14A9    C3 B7 14        	JP	DLYT
14AC    D5              DLY1M:	PUSH	DE	; 1ミリ秒
14AD    11 82 00        	LD	DE, 130
14B0    C3 B7 14        	JP	DLYT
14B3    D5              DLY60M:	PUSH	DE	; 60ミリ秒
14B4    11 2C 1A        	LD	DE, 6700
14B7    1B              DLYT:	DEC	DE	; DE回ループする
14B8    7B              	LD	A, E
14B9    B2              	OR	D
14BA    20 FB           	JR	NZ, DLYT
14BC    D1              	POP	DE
14BD    C9              	RET
14BE
14BE                    ; 0Dhで終わっている文字列を比較する
14BE                    ; LD	DE, 比較文字列1, 0Dh
14BE                    ; LD	HL, 比較文字列2, 0Dh
14BE                    ; Result Cyフラグ (0: 違う, 1: 同じ)
14BE                    CMP_TEXT:
14BE                    CMP_TEXT_1:
14BE    1A              	LD	A, (DE)
14BF    BE              	CP	(HL)
14C0    20 08           	JR	NZ, CMP_TEXT_2
14C2    FE 0D           	CP	00Dh
14C4    13              	INC	DE
14C5    23              	INC	HL
14C6    20 F6           	JR	NZ, CMP_TEXT_1
14C8    18 02           	JR	CMP_TEXT_3
14CA                    CMP_TEXT_2:
14CA    B7              	OR	A
14CB    C9              	RET
14CC                    CMP_TEXT_3:
14CC    37              	SCF
14CD    C9              	RET
14CE
14CE                    ; 0-255の乱数をAレジスタに返す
14CE                    RAND:
14CE    3E 00           	LD	A, 0
14D0    5F              	LD	E, A
14D1    87              	ADD	A, A
14D2    87              	ADD	A, A
14D3    83              	ADD	A, E
14D4    3C              	INC	A
14D5    32 CF 14        	LD	(RAND + 1), A
14D8    C9              	RET
14D9
14D9                    ; 0～63の角度番号からX成分を取得する
14D9                    ; LD A, 方向 0～63
14D9                    ; Result HL = 横成分
14D9                    GET_DIR_X:
14D9    21 53 15        	LD	HL, DIR_X_TBL
14DC                    GET_DIR_Y_SUB:
14DC    87              	ADD	A, A
14DD    06 00           	LD	B, 0
14DF    4F              	LD	C, A
14E0    09              	ADD	HL, BC
14E1    4E              	LD	C, (HL)
14E2    23              	INC	HL
14E3    46              	LD	B, (HL)
14E4    C9              	RET
14E5
14E5                    ; 0～63の角度番号からY成分を取得する
14E5                    ; LD A, 方向 0～63
14E5                    ; Result BC = Y成分
14E5                    GET_DIR_Y:
14E5    21 33 15        	LD	HL, DIR_Y_TBL
14E8    18 F2           	JR	GET_DIR_Y_SUB
14EA
14EA                    ; 撃つ方向取得
14EA                    ; IX 自分
14EA                    ; IY 相手
14EA                    ; Result A = 方向(0～63)
14EA                    FIRE_DIR:
14EA    D5              	PUSH	DE
14EB    FD 7E 09        	LD	A, (IY + 9) ; TargetY
14EE    CB 2F           	SRA	A ; 1/2
14F0    47              	LD	B, A
14F1    DD 7E 09        	LD	A, (IX + 9) ; Y
14F4    CB 2F           	SRA	A ; 1/2
14F6    90              	SUB	B
14F7    FA FE 14        	JP	M, FIRE_DIR_L1
14FA    26 00           	LD	H, 0
14FC    18 02           	JR	FIRE_DIR_L2
14FE                    FIRE_DIR_L1:
14FE    26 FF           	LD	H, 0FFh
1500                    FIRE_DIR_L2:
1500    6F              	LD	L, A
1501    CD 66 14        	CALL	MUL_HLx28
1504    FD 7E 07        	LD	A, (IY + 7) ; TargetX
1507    CB 2F           	SRA	A ; 1/2
1509    47              	LD	B, A
150A    DD 7E 07        	LD	A, (IX + 7) ; X
150D    CB 2F           	SRA	A ; 1/2
150F    90              	SUB	B
1510    FA 17 15        	JP	M, FIRE_DIR_L3
1513    06 00           	LD	B, 0
1515    18 02           	JR	FIRE_DIR_L4
1517                    FIRE_DIR_L3:
1517    06 FF           	LD	B, 0FFh
1519                    FIRE_DIR_L4:
1519    4F              	LD	C, A
151A    09              	ADD	HL, BC
151B    11 9D 18        	LD	DE, FIRE_DIR_TBL + 25 * 28 + 14
151E    EB              	EX	DE, HL
151F    19              	ADD	HL, DE
1520                    	; A=撃つ方向
1520    7E              	LD	A, (HL)
1521    D1              	POP	DE
1522    C9              	RET
1523
1523                    ; 16進数変換用テーブル
1523                    HEX_TABLE:
1523    30 31 32 33     	DB	"0123456789ABCDEF"
1527    34 35 36 37
152B    38 39 41 42
152F    43 44 45 46
1533
1533                    ; 64方向テーブル
1533                    DIR_Y_TBL:
1533    00 00 26 00     	DW	0, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
1537    4A 00 6F 00
153B    92 00 B4 00
153F    D5 00 F3 00
1543    10 01 28 01
1547    3E 01 52 01
154B    62 01 6E 01
154F    79 01 7D 01
1553                    DIR_X_TBL:
1553    80 01 7D 01     	DW	384, 381, 377, 366, 354, 338, 318, 296, 272, 243, 213, 180, 146, 111, 74, 38
1557    79 01 6E 01
155B    62 01 52 01
155F    3E 01 28 01
1563    10 01 F3 00
1567    D5 00 B4 00
156B    92 00 6F 00
156F    4A 00 26 00
1573    00 00 D9 FF     	DW	0, -39, -75, -113, -147, -182, -215, -245, -273, -297, -320, -339, -356, -368, -378, -383
1577    B5 FF 8F FF
157B    6D FF 4A FF
157F    29 FF 0B FF
1583    EF FE D7 FE
1587    C0 FE AD FE
158B    9C FE 90 FE
158F    86 FE 81 FE
1593    80 FE 81 FE     	DW	-384, -383, -378, -368, -356, -339, -320, -297, -273, -245, -215, -182, -147, -113, -75, -39
1597    86 FE 90 FE
159B    9C FE AD FE
159F    C0 FE D7 FE
15A3    EF FE 0B FF
15A7    29 FF 4A FF
15AB    6D FF 8F FF
15AF    B5 FF D9 FF
15B3    FE FF 26 00     	DW	-2, 38, 74, 111, 146, 180, 213, 243, 272, 296, 318, 338, 354, 366, 377, 381
15B7    4A 00 6F 00
15BB    92 00 B4 00
15BF    D5 00 F3 00
15C3    10 01 28 01
15C7    3E 01 52 01
15CB    62 01 6E 01
15CF    79 01 7D 01
15D3
15D3                    ; (25,14)への方向テーブル 50x28
15D3                    FIRE_DIR_TBL:
15D3    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15D7    0C 0C 0D 0D
15DB    0E 0E 0E 0F
15DF    0F 10 10 10
15E3    11 11 12 12
15E7    12 13 13 14
15EB    14 14 15 15
15EF    0B 0B 0B 0C     	DB	11, 11, 11, 12, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 20, 21, 21
15F3    0C 0C 0D 0D
15F7    0E 0E 0E 0F
15FB    0F 10 10 10
15FF    11 11 12 12
1603    12 13 13 14
1607    14 14 15 15
160B    0A 0B 0B 0B     	DB	10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 16, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21
160F    0C 0C 0D 0D
1613    0D 0E 0E 0F
1617    0F 10 10 10
161B    11 11 12 12
161F    13 13 13 14
1623    14 15 15 15
1627    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
162B    0C 0C 0C 0D
162F    0D 0E 0E 0F
1633    0F 0F 10 11
1637    11 11 12 12
163B    13 13 14 14
163F    14 15 15 16
1643    0A 0A 0B 0B     	DB	10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22
1647    0C 0C 0C 0D
164B    0D 0E 0E 0F
164F    0F 0F 10 11
1653    11 11 12 12
1657    13 13 14 14
165B    14 15 15 16
165F    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 15, 15, 16, 17, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22
1663    0B 0C 0C 0D
1667    0D 0E 0E 0E
166B    0F 0F 10 11
166F    11 12 12 12
1673    13 13 14 14
1677    15 15 16 16
167B    0A 0A 0A 0B     	DB	10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 20, 21, 21, 22, 22
167F    0B 0C 0C 0C
1683    0D 0D 0E 0E
1687    0F 0F 10 11
168B    11 12 12 13
168F    13 14 14 14
1693    15 15 16 16
1697    09 0A 0A 0A     	DB	9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 22
169B    0B 0B 0C 0C
169F    0D 0D 0E 0E
16A3    0F 0F 10 11
16A7    11 12 12 13
16AB    13 14 14 15
16AF    15 16 16 16
16B3    09 09 0A 0A     	DB	9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23
16B7    0B 0B 0C 0C
16BB    0D 0D 0E 0E
16BF    0F 0F 10 11
16C3    11 12 12 13
16C7    13 14 14 15
16CB    15 16 16 17
16CF    09 09 09 0A     	DB	9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23
16D3    0A 0B 0B 0C
16D7    0C 0D 0E 0E
16DB    0F 0F 10 11
16DF    11 12 12 13
16E3    14 14 15 15
16E7    16 16 17 17
16EB    08 09 09 0A     	DB	8, 9, 9, 10, 10, 10, 11, 12, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 22, 23, 23
16EF    0A 0A 0B 0C
16F3    0C 0D 0D 0E
16F7    0F 0F 10 11
16FB    11 12 13 13
16FF    14 14 15 16
1703    16 16 17 17
1707    08 08 09 09     	DB	8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16, 17, 17, 18, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24
170B    0A 0A 0B 0B
170F    0C 0C 0D 0E
1713    0F 0F 10 11
1717    11 12 13 14
171B    14 15 15 16
171F    16 17 17 18
1723    08 08 08 09     	DB	8, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24
1727    09 0A 0A 0B
172B    0C 0C 0D 0E
172F    0E 0F 10 11
1733    12 12 13 14
1737    14 15 16 16
173B    17 17 18 18
173F    07 08 08 08     	DB	7, 8, 8, 8, 9, 9, 10, 11, 11, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24, 24
1743    09 09 0A 0B
1747    0B 0C 0D 0E
174B    0E 0F 10 11
174F    12 12 13 14
1753    15 15 16 17
1757    17 18 18 18
175B    07 07 08 08     	DB	7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 24, 25
175F    09 09 0A 0A
1763    0B 0C 0C 0D
1767    0E 0F 10 11
176B    12 13 14 14
176F    15 16 16 17
1773    17 18 18 19
1777    06 07 07 07     	DB	6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 25, 25, 25
177B    08 09 09 0A
177F    0A 0B 0C 0D
1783    0E 0F 10 11
1787    12 13 14 15
178B    16 16 17 17
178F    18 19 19 19
1793    06 06 07 07     	DB	6, 6, 7, 7, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 25, 26
1797    07 08 09 09
179B    0A 0B 0C 0D
179F    0E 0F 10 11
17A3    12 13 14 15
17A7    16 17 17 18
17AB    19 19 19 1A
17AF    05 06 06 06     	DB	5, 6, 6, 6, 7, 7, 8, 9, 9, 10, 11, 12, 14, 15, 16, 17, 18, 20, 21, 22, 23, 23, 24, 25, 25, 26, 26, 26
17B3    07 07 08 09
17B7    09 0A 0B 0C
17BB    0E 0F 10 11
17BF    12 14 15 16
17C3    17 17 18 19
17C7    19 1A 1A 1A
17CB    05 05 05 06     	DB	5, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27
17CF    06 07 07 08
17D3    09 0A 0B 0C
17D7    0D 0F 10 11
17DB    13 14 15 16
17DF    17 18 19 19
17E3    1A 1A 1B 1B
17E7    04 04 05 05     	DB	4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21, 22, 23, 24, 25, 25, 26, 26, 27, 27, 28
17EB    06 06 07 07
17EF    08 09 0A 0B
17F3    0D 0E 10 12
17F7    13 15 16 17
17FB    18 19 19 1A
17FF    1A 1B 1B 1C
1803    04 04 04 04     	DB	4, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 22, 23, 24, 25, 26, 26, 27, 27, 28, 28, 28
1807    05 05 06 06
180B    07 08 09 0A
180F    0C 0E 10 12
1813    14 16 17 18
1817    19 1A 1A 1B
181B    1B 1C 1C 1C
181F    03 03 03 04     	DB	3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 8, 9, 11, 14, 16, 18, 21, 23, 24, 25, 26, 27, 27, 28, 28, 28, 29, 29
1823    04 04 05 05
1827    06 07 08 09
182B    0B 0E 10 12
182F    15 17 18 19
1833    1A 1B 1B 1C
1837    1C 1C 1D 1D
183B    02 02 02 03     	DB	2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 7, 8, 10, 13, 16, 19, 22, 24, 25, 26, 27, 28, 28, 29, 29, 29, 30, 30
183F    03 03 04 04
1843    05 06 07 08
1847    0A 0D 10 13
184B    16 18 19 1A
184F    1B 1C 1C 1D
1853    1D 1D 1E 1E
1857    01 02 02 02     	DB	1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 8, 11, 16, 21, 24, 26, 27, 28, 29, 29, 30, 30, 30, 30, 30, 30
185B    02 02 02 03
185F    03 04 05 06
1863    08 0B 10 15
1867    18 1A 1B 1C
186B    1D 1D 1E 1E
186F    1E 1E 1E 1E
1873    01 01 01 01     	DB	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5, 8, 16, 24, 27, 29, 30, 30, 30, 31, 31, 31, 31, 31, 31, 31
1877    01 01 01 01
187B    02 02 02 03
187F    05 08 10 18
1883    1B 1D 1E 1E
1887    1E 1F 1F 1F
188B    1F 1F 1F 1F
188F    00 00 00 00     	DB	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
1893    00 00 00 00
1897    00 00 00 00
189B    00 00 10 20
189F    20 20 20 20
18A3    20 20 20 20
18A7    20 20 20 20
18AB    3F 3F 3F 3F     	DB	63, 63, 63, 63, 63, 63, 63, 63, 62, 62, 62, 61, 59, 56, 48, 40, 37, 35, 34, 34, 34, 33, 33, 33, 33, 33, 33, 33
18AF    3F 3F 3F 3F
18B3    3E 3E 3E 3D
18B7    3B 38 30 28
18BB    25 23 22 22
18BF    22 21 21 21
18C3    21 21 21 21
18C7    3F 3E 3E 3E     	DB	63, 62, 62, 62, 62, 62, 62, 61, 61, 60, 59, 58, 56, 53, 48, 43, 40, 38, 37, 36, 35, 35, 34, 34, 34, 34, 34, 34
18CB    3E 3E 3E 3D
18CF    3D 3C 3B 3A
18D3    38 35 30 2B
18D7    28 26 25 24
18DB    23 23 22 22
18DF    22 22 22 22
18E3    3E 3E 3E 3D     	DB	62, 62, 62, 61, 61, 61, 60, 60, 59, 58, 57, 56, 54, 51, 48, 45, 42, 40, 39, 38, 37, 36, 36, 35, 35, 35, 34, 34
18E7    3D 3D 3C 3C
18EB    3B 3A 39 38
18EF    36 33 30 2D
18F3    2A 28 27 26
18F7    25 24 24 23
18FB    23 23 22 22
18FF    3D 3D 3D 3C     	DB	61, 61, 61, 60, 60, 60, 59, 59, 58, 57, 56, 55, 53, 50, 48, 46, 43, 41, 40, 39, 38, 37, 37, 36, 36, 36, 35, 35
1903    3C 3C 3B 3B
1907    3A 39 38 37
190B    35 32 30 2E
190F    2B 29 28 27
1913    26 25 25 24
1917    24 24 23 23
191B    3C 3C 3C 3C     	DB	60, 60, 60, 60, 59, 59, 58, 58, 57, 56, 55, 54, 52, 50, 48, 46, 44, 42, 41, 40, 39, 38, 38, 37, 37, 36, 36, 36
191F    3B 3B 3A 3A
1923    39 38 37 36
1927    34 32 30 2E
192B    2C 2A 29 28
192F    27 26 26 25
1933    25 24 24 24
1937    3C 3C 3B 3B     	DB	60, 60, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 51, 50, 48, 46, 45, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37, 36
193B    3A 3A 39 39
193F    38 37 36 35
1943    33 32 30 2E
1947    2D 2B 2A 29
194B    28 27 27 26
194F    26 25 25 24
1953    3B 3B 3B 3A     	DB	59, 59, 59, 58, 58, 57, 57, 56, 55, 54, 53, 52, 51, 49, 48, 47, 45, 44, 43, 42, 41, 40, 39, 39, 38, 38, 37, 37
1957    3A 39 39 38
195B    37 36 35 34
195F    33 31 30 2F
1963    2D 2C 2B 2A
1967    29 28 27 27
196B    26 26 25 25
196F    3B 3A 3A 3A     	DB	59, 58, 58, 58, 57, 57, 56, 55, 55, 54, 53, 52, 50, 49, 48, 47, 46, 44, 43, 42, 41, 41, 40, 39, 39, 38, 38, 38
1973    39 39 38 37
1977    37 36 35 34
197B    32 31 30 2F
197F    2E 2C 2B 2A
1983    29 29 28 27
1987    27 26 26 26
198B    3A 3A 39 39     	DB	58, 58, 57, 57, 57, 56, 55, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 41, 40, 39, 39, 39, 38
198F    39 38 37 37
1993    36 35 34 33
1997    32 31 30 2F
199B    2E 2D 2C 2B
199F    2A 29 29 28
19A3    27 27 27 26
19A7    3A 39 39 39     	DB	58, 57, 57, 57, 56, 55, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 42, 41, 41, 40, 39, 39, 39
19AB    38 37 37 36
19AF    36 35 34 33
19B3    32 31 30 2F
19B7    2E 2D 2C 2B
19BB    2A 2A 29 29
19BF    28 27 27 27
19C3    39 39 38 38     	DB	57, 57, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 49, 48, 47, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40, 39
19C7    37 37 36 36
19CB    35 34 34 33
19CF    32 31 30 2F
19D3    2E 2D 2C 2C
19D7    2B 2A 2A 29
19DB    29 28 28 27
19DF    39 38 38 38     	DB	57, 56, 56, 56, 55, 55, 54, 53, 53, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 43, 43, 42, 41, 41, 40, 40, 40
19E3    37 37 36 35
19E7    35 34 33 32
19EB    32 31 30 2F
19EF    2E 2E 2D 2C
19F3    2B 2B 2A 29
19F7    29 28 28 28
19FB    38 38 38 37     	DB	56, 56, 56, 55, 55, 54, 54, 53, 52, 52, 51, 50, 50, 49, 48, 47, 46, 46, 45, 44, 44, 43, 42, 42, 41, 41, 40, 40
19FF    37 36 36 35
1A03    34 34 33 32
1A07    32 31 30 2F
1A0B    2E 2E 2D 2C
1A0F    2C 2B 2A 2A
1A13    29 29 28 28
1A17    38 38 37 37     	DB	56, 56, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 49, 49, 48, 47, 47, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40
1A1B    36 36 35 35
1A1F    34 34 33 32
1A23    31 31 30 2F
1A27    2F 2E 2D 2C
1A2B    2C 2B 2B 2A
1A2F    2A 29 29 28
1A33    38 37 37 36     	DB	56, 55, 55, 54, 54, 54, 53, 52, 52, 51, 51, 50, 49, 49, 48, 47, 47, 46, 45, 45, 44, 44, 43, 42, 42, 42, 41, 41
1A37    36 36 35 34
1A3B    34 33 33 32
1A3F    31 31 30 2F
1A43    2F 2E 2D 2D
1A47    2C 2C 2B 2A
1A4B    2A 2A 29 29
1A4F    37 37 37 36     	DB	55, 55, 55, 54, 54, 53, 53, 52, 52, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 41
1A53    36 35 35 34
1A57    34 33 32 32
1A5B    31 31 30 2F
1A5F    2F 2E 2E 2D
1A63    2C 2C 2B 2B
1A67    2A 2A 29 29
1A6B    37 37 36 36     	DB	55, 55, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41
1A6F    35 35 34 34
1A73    33 33 32 32
1A77    31 31 30 2F
1A7B    2F 2E 2E 2D
1A7F    2D 2C 2C 2B
1A83    2B 2A 2A 29
1A87    37 36 36 36     	DB	55, 54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 42
1A8B    35 35 34 34
1A8F    33 33 32 32
1A93    31 31 30 2F
1A97    2F 2E 2E 2D
1A9B    2D 2C 2C 2B
1A9F    2B 2A 2A 2A
1AA3    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 48, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42, 42
1AA7    35 34 34 34
1AAB    33 33 32 32
1AAF    31 31 30 2F
1AB3    2F 2E 2E 2D
1AB7    2D 2C 2C 2C
1ABB    2B 2B 2A 2A
1ABF    36 36 36 35     	DB	54, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42
1AC3    35 34 34 33
1AC7    33 32 32 32
1ACB    31 31 30 2F
1ACF    2F 2E 2E 2E
1AD3    2D 2D 2C 2C
1AD7    2B 2B 2A 2A
1ADB    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1ADF    34 34 34 33
1AE3    33 32 32 31
1AE7    31 31 30 2F
1AEB    2F 2F 2E 2E
1AEF    2D 2D 2C 2C
1AF3    2C 2B 2B 2A
1AF7    36 36 35 35     	DB	54, 54, 53, 53, 52, 52, 52, 51, 51, 50, 50, 49, 49, 49, 48, 47, 47, 47, 46, 46, 45, 45, 44, 44, 44, 43, 43, 42
1AFB    34 34 34 33
1AFF    33 32 32 31
1B03    31 31 30 2F
1B07    2F 2F 2E 2E
1B0B    2D 2D 2C 2C
1B0F    2C 2B 2B 2A
1B13    36 35 35 35     	DB	54, 53, 53, 53, 52, 52, 51, 51, 51, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 45, 45, 45, 44, 44, 43, 43, 43
1B17    34 34 33 33
1B1B    33 32 32 31
1B1F    31 30 30 30
1B23    2F 2F 2E 2E
1B27    2D 2D 2D 2C
1B2B    2C 2B 2B 2B
1B2F    35 35 35 34     	DB	53, 53, 53, 52, 52, 52, 51, 51, 50, 50, 50, 49, 49, 48, 48, 48, 47, 47, 46, 46, 46, 45, 45, 44, 44, 44, 43, 43
1B33    34 34 33 33
1B37    32 32 32 31
1B3B    31 30 30 30
1B3F    2F 2F 2E 2E
1B43    2E 2D 2D 2C
1B47    2C 2C 2B 2B
1B4B                    WIDTH_SIZE:
1B4B    28              	DB	40
1B4C                    CURSOR_Y:
1B4C    00              	DB	0
1B4D                    CURSOR_X:
1B4D    00              	DB	0
1B4E                    CURSOR_ADDR:
1B4E    00 D0           	DW	0D000h
1B50                    TEXT_VRAM_LIMIT:
1B50    E8 D3           	DW	0D000h + 1000
1B52                    TEXT_VRAM_SIZE:
1B52    E8 03           	DW	1000
1B54
1B54                    ;テキスト横桁数設定
1B54                    ;	LD	A, 40 or 80
1B54                    WIDTH:
1B54    E5              	PUSH	HL
1B55    32 4B 1B        	LD	(WIDTH_SIZE), A
1B58    FE 28           	CP	40
1B5A    DB E8           	IN	A, (0E8h)
1B5C    28 10           	JR	Z, WIDTH_40
1B5E    F6 20           	OR	020H	; bit5 Hi WIDTH80
1B60    21 D0 D7        	LD	HL, 0D000h + 2000
1B63    22 50 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B66    21 D0 07        	LD	HL, 2000
1B69    22 52 1B        	LD	(TEXT_VRAM_SIZE), HL
1B6C    18 0E           	JR	WIDTH_L1
1B6E                    WIDTH_40:
1B6E    E6 CF           	AND	0CFh	; bit5 Lo WIDTH40
1B70    21 E8 D3        	LD	HL, 0D000h + 1000
1B73    22 50 1B        	LD	(TEXT_VRAM_LIMIT), HL
1B76    21 E8 03        	LD	HL, 1000
1B79    22 52 1B        	LD	(TEXT_VRAM_SIZE), HL
1B7C                    WIDTH_L1:
1B7C    D3 E8           	OUT	(0E8h),A
1B7E    E1              	POP	HL
1B7F    C9              	RET
1B80
1B80                    ENABLE_TEXT_VRAM_ADDR:
1B80    DB E8           	IN	A,(0E8h)
1B82    E6 3F           	AND	03Fh
1B84    F6 C0           	OR	0C0h
1B86    D3 E8           	OUT	(0E8h),A
1B88    C9              	RET
1B89
1B89                    DISABLE_VRAM_ADDR:
1B89    DB E8           	IN	A,(0E8h)
1B8B    E6 3F           	AND	03Fh
1B8D    D3 E8           	OUT	(0E8h),A
1B8F    C9              	RET
1B90
1B90                    ;文字と背景の色とプライオリティ設定
1B90                    ; LD	A, 文字の色(文字優先: 0～7, グラフィック優先: 8～15)
1B90                    ; LD	B, 背景の色(0～7)
1B90                    TEXT_COLOR:
1B90    D3 F5           	OUT	(0F5h), A
1B92    78              	LD	A, B
1B93    D3 F4           	OUT	(0F4h), A
1B95    C9              	RET
1B96
1B96                    ;表示位置設定
1B96                    ;	LD	D, Y
1B96                    ;	LD	E, X
1B96                    CURSOR:
1B96    F5              	PUSH	AF
1B97    C5              	PUSH	BC
1B98    D5              	PUSH	DE
1B99    E5              	PUSH	HL
1B9A    7A              	LD	A, D
1B9B    32 4C 1B        	LD	(CURSOR_Y), A
1B9E    7B              	LD	A, E
1B9F    32 4D 1B        	LD	(CURSOR_X), A
1BA2    26 00           	LD	H, 0
1BA4    6A              	LD	L, D
1BA5    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1BA8    FE 28           	CP	40
1BAA    28 05           	JR	Z, CURSOR_WIDTH40
1BAC    CD 7A 14        	CALL	MUL_HLx80
1BAF    18 03           	JR	CURSOR_L1
1BB1                    CURSOR_WIDTH40:
1BB1    CD 71 14        	CALL	MUL_HLx40
1BB4                    CURSOR_L1:
1BB4    16 00           	LD	D, 0
1BB6    19              	ADD	HL, DE
1BB7    11 00 D0        	LD	DE, 0D000h
1BBA    19              	ADD	HL, DE
1BBB    22 4E 1B        	LD	(CURSOR_ADDR), HL
1BBE    E1              	POP	HL
1BBF    D1              	POP	DE
1BC0    C1              	POP	BC
1BC1    F1              	POP	AF
1BC2    C9              	RET
1BC3
1BC3                    ;改行
1BC3                    NEW_LINE:
1BC3    3A 4C 1B        	LD	A, (CURSOR_Y)
1BC6    3C              	INC	A
1BC7    FE 19           	CP	25
1BC9    FA D1 1B        	JP	M, NEW_LINE_L1
1BCC    3E 18           	LD	A, 24
1BCE    CD 49 1C        	CALL	SCROLL_UP
1BD1                    NEW_LINE_L1:
1BD1    57              	LD	D, A
1BD2    1E 00           	LD	E, 0
1BD4    CD 96 1B        	CALL	CURSOR
1BD7    C9              	RET
1BD8
1BD8                    ;一文字表示
1BD8                    ;	LD	HL, 0で終わる文字列へのアドレス
1BD8                    PRINT_MSG1:
1BD8    C5              	PUSH	BC
1BD9    D5              	PUSH	DE
1BDA    E5              	PUSH	HL
1BDB    2A 4E 1B        	LD	HL, (CURSOR_ADDR)
1BDE    77              	LD	(HL), A
1BDF    23              	INC	HL
1BE0                    	; 画面右下にはみ出したら一番しての行の左側に戻す
1BE0    E5              	PUSH	HL
1BE1    ED 4B 50 1B     	LD	BC, (TEXT_VRAM_LIMIT)
1BE5    B7              	OR	A
1BE6    ED 42           	SBC	HL, BC
1BE8    E1              	POP	HL
1BE9    38 0F           	JR	C, PRINT_MSG1_L2
1BEB    2A 50 1B        	LD	HL, (TEXT_VRAM_LIMIT)
1BEE    06 00           	LD	B, 0
1BF0    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1BF3    4F              	LD	C, A
1BF4    B7              	OR	A
1BF5    ED 42           	SBC	HL, BC
1BF7    CD 49 1C        	CALL	SCROLL_UP
1BFA                    PRINT_MSG1_L2:
1BFA    22 4E 1B        	LD	(CURSOR_ADDR), HL
1BFD    01 00 D0        	LD	BC, 0D000h
1C00    B7              	OR	A
1C01    ED 42           	SBC	HL, BC
1C03    16 00           	LD	D, 0
1C05    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1C08    5F              	LD	E, A
1C09    CD 90 14        	CALL	DIV16
1C0C    79              	LD	A, C
1C0D    32 4C 1B        	LD	(CURSOR_Y), A
1C10    7D              	LD	A, L
1C11    32 4D 1B        	LD	(CURSOR_X), A
1C14    E1              	POP	HL
1C15    D1              	POP	DE
1C16    C1              	POP	BC
1C17    C9              	RET
1C18
1C18                    ;メッセージを表示
1C18                    ;	LD	HL, 文字列へのアドレス
1C18                    PRINT_MSG:
1C18    E5              	PUSH	HL
1C19                    PRINT_MSG_L1:
1C19    7E              	LD	A, (HL)
1C1A    B7              	OR	A
1C1B    28 06           	JR	Z, PRINT_MSG_END
1C1D    CD D8 1B        	CALL	PRINT_MSG1
1C20    23              	INC	HL
1C21    18 F6           	JR	PRINT_MSG_L1
1C23                    PRINT_MSG_END:
1C23    E1              	POP	HL
1C24    C9              	RET
1C25
1C25                    ; Aレジスタの内容を16進表示する
1C25                    PRINT_HEX:
1C25    F5              	PUSH	AF
1C26    CB 3F           	SRL	A
1C28    CB 3F           	SRL	A
1C2A    CB 3F           	SRL	A
1C2C    CB 3F           	SRL	A
1C2E    E6 0F           	AND	00FH
1C30    CD 3C 1C        	CALL	PRINT_HEX1
1C33    F1              	POP	AF
1C34    F5              	PUSH	AF
1C35    E6 0F           	AND	00FH
1C37    CD 3C 1C        	CALL	PRINT_HEX1
1C3A    F1              	POP	AF
1C3B    C9              	RET
1C3C
1C3C                    ; Aレジスタの0～Fを表示する
1C3C                    PRINT_HEX1:
1C3C    F5              	PUSH	AF
1C3D    C5              	PUSH	BC
1C3E    E5              	PUSH	HL
1C3F    CD 9D 14        	CALL	A_TO_HEX
1C42    CD D8 1B        	CALL	PRINT_MSG1
1C45    E1              	POP	HL
1C46    C1              	POP	BC
1C47    F1              	POP	AF
1C48    C9              	RET
1C49
1C49                    ; テキスト画面全体を上方向にスクロール
1C49                    SCROLL_UP:
1C49    F5              	PUSH	AF
1C4A    C5              	PUSH	BC
1C4B    D5              	PUSH	DE
1C4C    E5              	PUSH	HL
1C4D    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1C50    FE 28           	CP	40
1C52    28 05           	JR	Z, SCROLL_UP_L1
1C54    CD 7A 1C        	CALL	SCROLL_UP_WIDTH80
1C57    18 03           	JR	SCROLL_UP_L2
1C59                    SCROLL_UP_L1:
1C59    CD 61 1C        	CALL	SCROLL_UP_WIDTH40
1C5C                    SCROLL_UP_L2:
1C5C    E1              	POP	HL
1C5D    D1              	POP	DE
1C5E    C1              	POP	BC
1C5F    F1              	POP	AF
1C60    C9              	RET
1C61
1C61                    ; 40桁のテキスト画面全体を上方向にスクロール
1C61                    SCROLL_UP_WIDTH40:
1C61                    	; scroll
1C61    01 C0 03        	LD	BC, 1000 - 40
1C64    21 28 D0        	LD	HL, 0D000h + 40
1C67    11 00 D0        	LD	DE, 0D000h
1C6A    ED B0           	LDIR
1C6C                    	; space
1C6C    21 C0 D3        	LD	HL, 0D000h + 1000 - 40
1C6F    11 C1 D3        	LD	DE, 0D000h + 1000 - 40 + 1
1C72    01 27 00        	LD	BC, 40 - 1
1C75    AF              	XOR	A
1C76    77              	LD	(HL), A
1C77    ED B0           	LDIR
1C79    C9              	RET
1C7A
1C7A                    ; 80桁のテキスト画面全体を上方向にスクロール
1C7A                    SCROLL_UP_WIDTH80:
1C7A                    	; scroll
1C7A    01 80 07        	LD	BC, 2000 - 80
1C7D    21 50 D0        	LD	HL, 0D000h + 80
1C80    11 00 D0        	LD	DE, 0D000h
1C83    ED B0           	LDIR
1C85                    	; space
1C85    21 80 D7        	LD	HL, 0D000h + 2000 - 80
1C88    11 81 D7        	LD	DE, 0D000h + 2000 - 80 + 1
1C8B    01 4F 00        	LD	BC, 80 - 1
1C8E    AF              	XOR	A
1C8F    77              	LD	(HL), A
1C90    ED B0           	LDIR
1C92    C9              	RET
1C93
1C93                    ; 画面消去
1C93                    CLS:
1C93    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1C96    57              	LD	D, A
1C97    1E 19           	LD	E, 25
1C99    3E 20           	LD	A, ' '
1C9B    21 00 D0        	LD	HL, 0D000h
1C9E    CD AA 1C        	CALL	DRAW_RECT_TEXT
1CA1    11 00 00        	LD	DE, 0
1CA4    CD 96 1B        	CALL	CURSOR
1CA7    C9              	RET
1CA8
1CA8                    ; 桁のテキスト画面で指定した文字で矩形を描く
1CA8                    ; LD	A, 'A' ; 描画文字
1CA8                    ; LD	D, WIDTH
1CA8                    ; LD	E, HEIGHT
1CA8                    ; LD	HL, POSITION
1CA8                    DRAW_RECT_TEXT_ADD_X:
1CA8    00 00           	DW	0
1CAA                    DRAW_RECT_TEXT:
1CAA    C5              	PUSH	BC
1CAB    E5              	PUSH	HL
1CAC                    DRAW_RECT_TEXT_WIDTH:
1CAC    F5              	PUSH	AF
1CAD    3A 4B 1B        	LD	A, (WIDTH_SIZE)
1CB0    92              	SUB	D
1CB1    06 00           	LD	B, 0
1CB3    4F              	LD	C, A
1CB4    ED 43 A8 1C     	LD	(DRAW_RECT_TEXT_ADD_X), BC
1CB8    F1              	POP	AF
1CB9    43              	LD	B, E
1CBA                    DRAW_RECT_TEXT_1:
1CBA    4A              	LD	C, D
1CBB                    DRAW_RECT_TEXT_2:
1CBB    77              	LD	(HL), A
1CBC    23              	INC	HL
1CBD    0D              	DEC	C
1CBE    20 FB           	JR	NZ, DRAW_RECT_TEXT_2
1CC0    C5              	PUSH	BC
1CC1    ED 4B A8 1C     	LD	BC, (DRAW_RECT_TEXT_ADD_X)
1CC5    09              	ADD	HL, BC
1CC6    C1              	POP	BC
1CC7    05              	DEC	B
1CC8    20 F0           	JR	NZ, DRAW_RECT_TEXT_1
1CCA    E1              	POP	HL
1CCB    C1              	POP	BC
1CCC    C9              	RET
1CCD                    ; GRAMアドレス有効
1CCD                    ENABLE_GRAPHIC_ADDR:
1CCD    DB E8           	IN	A, (0E8h)
1CCF    E6 3F           	AND	03Fh
1CD1    F6 80           	OR	080h
1CD3    D3 E8           	OUT	(0E8h), A
1CD5    C9              	RET
1CD6
1CD6                    ; GRAMアドレス無効
1CD6                    DISABLE_GRAPHIC_ADDR:
1CD6    DB E8           	IN	A, (0E8h)
1CD8    E6 7F           	AND	07Fh
1CDA    D3 E8           	OUT	(0E8h), A
1CDC    C9              	RET
1CDD
1CDD                    ; グラフィックス画面を3ページとも消去する
1CDD                    GRAPHICS_CLS_ALL:
1CDD    3E 01           	LD	A, 1
1CDF    D3 F7           	OUT	(0F7h), A
1CE1    CD F3 1C        	CALL	GRAPHICS_CLS
1CE4    3E 02           	LD	A, 2
1CE6    D3 F7           	OUT	(0F7h), A
1CE8    CD F3 1C        	CALL	GRAPHICS_CLS
1CEB    3E 03           	LD	A, 3
1CED    D3 F7           	OUT	(0F7h), A
1CEF    CD F3 1C        	CALL	GRAPHICS_CLS
1CF2    C9              	RET
1CF3
1CF3                    ; グラフィックス画面を1ページ分消去する
1CF3                    GRAPHICS_CLS:
1CF3    21 00 C0        	LD	HL, 0C000h
1CF6    01 80 3E        	LD	BC, 16000
1CF9                    GRAPHICS_CLS_L1:
1CF9    36 00           	LD	(HL), 0
1CFB    23              	INC	HL
1CFC    0B              	DEC	BC
1CFD    78              	LD	A, B
1CFE    B1              	OR	C
1CFF    20 F8           	JR	NZ, GRAPHICS_CLS_L1
1D01    C9              	RET
1D02
1D02                    ;16x2(4) 8色を転送する
1D02                    ;	LD	DE, POSITION
1D02                    ;	LD	HL, PATTERN
1D02                    PUT16x2x8:
1D02    D5              	PUSH	DE
1D03    ED 73 49 1D     	LD	(PUT16x2x8_RESTORE_STACK + 1), SP
1D07                    	; B
1D07    3E 01           	LD	A, 1
1D09    D3 F7           	OUT	(0F7h), A
1D0B    F9              	LD	SP, HL
1D0C    EB              	EX	DE, HL
1D0D    D1              	POP	DE
1D0E    73              	LD	(HL), E
1D0F    23              	INC	HL
1D10    72              	LD	(HL), D
1D11    23              	INC	HL
1D12    01 9E 00        	LD	BC, 158
1D15    09              	ADD	HL, BC
1D16    D1              	POP	DE
1D17    73              	LD	(HL), E
1D18    23              	INC	HL
1D19    72              	LD	(HL), D
1D1A                    	; R
1D1A    3E 02           	LD	A, 2
1D1C    D3 F7           	OUT	(0F7h), A
1D1E    01 A1 00        	LD	BC, 161
1D21    B7              	OR	A
1D22    ED 42           	SBC	HL, BC
1D24    D1              	POP	DE
1D25    73              	LD	(HL), E
1D26    23              	INC	HL
1D27    72              	LD	(HL), D
1D28    23              	INC	HL
1D29    01 9E 00        	LD	BC, 158
1D2C    09              	ADD	HL, BC
1D2D    D1              	POP	DE
1D2E    73              	LD	(HL), E
1D2F    23              	INC	HL
1D30    72              	LD	(HL), D
1D31                    	; G
1D31    3E 03           	LD	A, 3
1D33    D3 F7           	OUT	(0F7h), A
1D35    01 A1 00        	LD	BC, 161
1D38    B7              	OR	A
1D39    ED 42           	SBC	HL, BC
1D3B    D1              	POP	DE
1D3C    73              	LD	(HL), E
1D3D    23              	INC	HL
1D3E    72              	LD	(HL), D
1D3F    23              	INC	HL
1D40    01 9E 00        	LD	BC, 158
1D43    09              	ADD	HL, BC
1D44    D1              	POP	DE
1D45    73              	LD	(HL), E
1D46    23              	INC	HL
1D47    72              	LD	(HL), D
1D48                    PUT16x2x8_RESTORE_STACK:
1D48    31 00 00        	LD	SP, 0000
1D4B    D1              	POP	DE
1D4C    C9              	RET
1D4D
1D4D                    ;16x2(4)単色を転送する
1D4D                    ;	LD	DE, POSITION
1D4D                    ;	LD	HL, PATTERN
1D4D                    PUT16x2:
1D4D    D5              	PUSH	DE
1D4E    ED 73 62 1D     	LD	(PUT16x2_RESTORE_STACK + 1), SP
1D52    F9              	LD	SP, HL
1D53    EB              	EX	DE, HL
1D54    D1              	POP	DE
1D55    73              	LD	(HL), E
1D56    23              	INC	HL
1D57    72              	LD	(HL), D
1D58    23              	INC	HL
1D59    01 9E 00        	LD	BC, 158
1D5C    09              	ADD	HL, BC
1D5D    D1              	POP	DE
1D5E    73              	LD	(HL), E
1D5F    23              	INC	HL
1D60    72              	LD	(HL), D
1D61                    PUT16x2_RESTORE_STACK:
1D61    31 00 00        	LD	SP, 0000
1D64    D1              	POP	DE
1D65    C9              	RET
1D66
1D66                    ;16x4単色を転送する
1D66                    ;	LD	DE, POSITION
1D66                    ;	LD	HL, PATTERN
1D66                    PUT16x4:
1D66    C5              	PUSH	BC
1D67    D5              	PUSH	DE
1D68    E5              	PUSH	HL
1D69    ED 73 89 1D     	LD	(PUT16x4_RESTORE_STACK + 1), SP
1D6D    F9              	LD	SP, HL
1D6E    EB              	EX	DE, HL
1D6F    01 4E 00        	LD	BC, 78
1D72    D1              	POP	DE
1D73    73              	LD	(HL), E
1D74    23              	INC	HL
1D75    72              	LD	(HL), D
1D76    23              	INC	HL
1D77    09              	ADD	HL, BC
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
1D88                    PUT16x4_RESTORE_STACK:
1D88    31 00 00        	LD	SP, 0000
1D8B    E1              	POP	HL
1D8C    D1              	POP	DE
1D8D    C1              	POP	BC
1D8E    C9              	RET
1D8F
1D8F                    ;8x4単色をAND転送する
1D8F                    ;	LD	DE, POSITION
1D8F                    ;	LD	HL, PATTERN
1D8F                    PUT_AND_8x4:
1D8F    C5              	PUSH	BC
1D90    D5              	PUSH	DE
1D91    E5              	PUSH	HL
1D92    ED 73 AD 1D     	LD	(PUT_AND_8x4_RESTORE_STACK + 1), SP
1D96    F9              	LD	SP, HL
1D97    EB              	EX	DE, HL
1D98    01 50 00        	LD	BC, 80
1D9B    D1              	POP	DE
1D9C    7B              	LD	A, E
1D9D    A6              	AND	(HL)
1D9E    77              	LD	(HL), A
1D9F    09              	ADD	HL, BC
1DA0    7A              	LD	A, D
1DA1    A6              	AND	(HL)
1DA2    77              	LD	(HL), A
1DA3    09              	ADD	HL, BC
1DA4    D1              	POP	DE
1DA5    7B              	LD	A, E
1DA6    A6              	AND	(HL)
1DA7    77              	LD	(HL), A
1DA8    09              	ADD	HL, BC
1DA9    7A              	LD	A, D
1DAA    A6              	AND	(HL)
1DAB    77              	LD	(HL), A
1DAC                    PUT_AND_8x4_RESTORE_STACK:
1DAC    31 00 00        	LD	SP, 0000
1DAF    E1              	POP	HL
1DB0    D1              	POP	DE
1DB1    C1              	POP	BC
1DB2    C9              	RET
1DB3
1DB3                    ;8x4単色を32x4の左端右端にAND転送する
1DB3                    ;	LD	DE, POSITION
1DB3                    ;	LD	HL, PATTERN
1DB3                    PUT_AND_ZAPPER:
1DB3    C5              	PUSH	BC
1DB4    D5              	PUSH	DE
1DB5    E5              	PUSH	HL
1DB6    ED 73 EB 1D     	LD	(PUT_AND_ZAPPER_RESTORE_STACK + 1), SP
1DBA    F9              	LD	SP, HL
1DBB    EB              	EX	DE, HL
1DBC    01 4D 00        	LD	BC, 77
1DBF    D1              	POP	DE
1DC0    7B              	LD	A, E
1DC1    A6              	AND	(HL)
1DC2    77              	LD	(HL), A
1DC3    23              	INC	HL
1DC4    23              	INC	HL
1DC5    23              	INC	HL
1DC6    7A              	LD	A, D
1DC7    A6              	AND	(HL)
1DC8    77              	LD	(HL), A
1DC9    09              	ADD	HL, BC
1DCA    D1              	POP	DE
1DCB    7B              	LD	A, E
1DCC    A6              	AND	(HL)
1DCD    77              	LD	(HL), A
1DCE    23              	INC	HL
1DCF    23              	INC	HL
1DD0    23              	INC	HL
1DD1    7A              	LD	A, D
1DD2    A6              	AND	(HL)
1DD3    77              	LD	(HL), A
1DD4    09              	ADD	HL, BC
1DD5    D1              	POP	DE
1DD6    7B              	LD	A, E
1DD7    A6              	AND	(HL)
1DD8    77              	LD	(HL), A
1DD9    23              	INC	HL
1DDA    23              	INC	HL
1DDB    23              	INC	HL
1DDC    7A              	LD	A, D
1DDD    A6              	AND	(HL)
1DDE    77              	LD	(HL), A
1DDF    09              	ADD	HL, BC
1DE0    D1              	POP	DE
1DE1    7B              	LD	A, E
1DE2    A6              	AND	(HL)
1DE3    77              	LD	(HL), A
1DE4    23              	INC	HL
1DE5    23              	INC	HL
1DE6    23              	INC	HL
1DE7    7A              	LD	A, D
1DE8    A6              	AND	(HL)
1DE9    77              	LD	(HL), A
1DEA                    PUT_AND_ZAPPER_RESTORE_STACK:
1DEA    31 00 00        	LD	SP, 0000
1DED    E1              	POP	HL
1DEE    D1              	POP	DE
1DEF    C1              	POP	BC
1DF0    C9              	RET
1DF1
1DF1                    ;16x4単色をクリアする
1DF1                    ;	LD	HL, POSITION
1DF1                    CLEAR16x4:
1DF1    AF              	XOR	A
1DF2    01 4F 00        	LD	BC, 79
1DF5    77              	LD	(HL), A
1DF6    23              	INC	HL
1DF7    77              	LD	(HL), A
1DF8    09              	ADD	HL, BC
1DF9    77              	LD	(HL), A
1DFA    23              	INC	HL
1DFB    77              	LD	(HL), A
1DFC    09              	ADD	HL, BC
1DFD    77              	LD	(HL), A
1DFE    23              	INC	HL
1DFF    77              	LD	(HL), A
1E00    09              	ADD	HL, BC
1E01    77              	LD	(HL), A
1E02    23              	INC	HL
1E03    77              	LD	(HL), A
1E04    C9              	RET
1E05
1E05                    ;16x4 青と赤プレーンをクリアする
1E05                    ;	LD	DE, POSITION
1E05                    CLEAR16x4_BR:
1E05    E5              	PUSH	HL
1E06    C5              	PUSH	BC
1E07    62              	LD	H, D
1E08    6B              	LD	L, E
1E09    3E 01           	LD	A, 1
1E0B    D3 F7           	OUT	(0F7h), A
1E0D    CD F1 1D        	CALL	CLEAR16x4
1E10    62              	LD	H, D
1E11    6B              	LD	L, E
1E12    3E 02           	LD	A, 2
1E14    D3 F7           	OUT	(0F7h), A
1E16    CD F1 1D        	CALL	CLEAR16x4
1E19    C1              	POP	BC
1E1A    E1              	POP	HL
1E1B    C9              	RET
1E1C
1E1C                    ;16x8単色を転送する
1E1C                    ;	LD	DE, POSITION
1E1C                    ;	LD	HL, PATTERN
1E1C                    PUT16x8:
1E1C    ED 73 4D 1E     	LD	(PUT16x8_RESTORE_STACK + 1), SP
1E20    F9              	LD	SP, HL
1E21    EB              	EX	DE, HL
1E22    01 4F 00        	LD	BC, 79
1E25    D1              	POP	DE
1E26    73              	LD	(HL), E
1E27    23              	INC	HL
1E28    72              	LD	(HL), D
1E29    09              	ADD	HL, BC
1E2A    D1              	POP	DE
1E2B    73              	LD	(HL), E
1E2C    23              	INC	HL
1E2D    72              	LD	(HL), D
1E2E    09              	ADD	HL, BC
1E2F    D1              	POP	DE
1E30    73              	LD	(HL), E
1E31    23              	INC	HL
1E32    72              	LD	(HL), D
1E33    09              	ADD	HL, BC
1E34    D1              	POP	DE
1E35    73              	LD	(HL), E
1E36    23              	INC	HL
1E37    72              	LD	(HL), D
1E38    09              	ADD	HL, BC
1E39    D1              	POP	DE
1E3A    73              	LD	(HL), E
1E3B    23              	INC	HL
1E3C    72              	LD	(HL), D
1E3D    09              	ADD	HL, BC
1E3E    D1              	POP	DE
1E3F    73              	LD	(HL), E
1E40    23              	INC	HL
1E41    72              	LD	(HL), D
1E42    09              	ADD	HL, BC
1E43    D1              	POP	DE
1E44    73              	LD	(HL), E
1E45    23              	INC	HL
1E46    72              	LD	(HL), D
1E47    09              	ADD	HL, BC
1E48    D1              	POP	DE
1E49    73              	LD	(HL), E
1E4A    23              	INC	HL
1E4B    72              	LD	(HL), D
1E4C                    PUT16x8_RESTORE_STACK:
1E4C    31 00 00        	LD	SP, 0000
1E4F    C9              	RET
1E50
1E50                    ;32x4単色を転送する
1E50                    ;	LD	DE, POSITION
1E50                    ;	LD	HL, PATTERN
1E50                    PUT32x4:
1E50    ED 73 81 1E     	LD	(PUT32x4_RESTORE_STACK + 1), SP
1E54    F9              	LD	SP, HL
1E55    EB              	EX	DE, HL
1E56    01 4D 00        	LD	BC, 77
1E59    D1              	POP	DE
1E5A    73              	LD	(HL), E
1E5B    23              	INC	HL
1E5C    72              	LD	(HL), D
1E5D    23              	INC	HL
1E5E    D1              	POP	DE
1E5F    73              	LD	(HL), E
1E60    23              	INC	HL
1E61    72              	LD	(HL), D
1E62    09              	ADD	HL, BC
1E63    D1              	POP	DE
1E64    73              	LD	(HL), E
1E65    23              	INC	HL
1E66    72              	LD	(HL), D
1E67    23              	INC	HL
1E68    D1              	POP	DE
1E69    73              	LD	(HL), E
1E6A    23              	INC	HL
1E6B    72              	LD	(HL), D
1E6C    09              	ADD	HL, BC
1E6D    D1              	POP	DE
1E6E    73              	LD	(HL), E
1E6F    23              	INC	HL
1E70    72              	LD	(HL), D
1E71    23              	INC	HL
1E72    D1              	POP	DE
1E73    73              	LD	(HL), E
1E74    23              	INC	HL
1E75    72              	LD	(HL), D
1E76    09              	ADD	HL, BC
1E77    D1              	POP	DE
1E78    73              	LD	(HL), E
1E79    23              	INC	HL
1E7A    72              	LD	(HL), D
1E7B    23              	INC	HL
1E7C    D1              	POP	DE
1E7D    73              	LD	(HL), E
1E7E    23              	INC	HL
1E7F    72              	LD	(HL), D
1E80                    PUT32x4_RESTORE_STACK:
1E80    31 00 00        	LD	SP, 0000
1E83    C9              	RET
1E84
1E84                    ;32x4単色をAND転送する
1E84                    ;	LD	HL, POSITION
1E84                    ;	LD	DE, PATTERN
1E84                    PUT_AND_32x4:
1E84    ED 73 D5 1E     	LD	(PUT_AND_32x4_RESTORE_STACK + 1), SP
1E88    F9              	LD	SP, HL
1E89    EB              	EX	DE, HL
1E8A    01 4D 00        	LD	BC, 77
1E8D    D1              	POP	DE
1E8E    7B              	LD	A, E
1E8F    A6              	AND	(HL)
1E90    77              	LD	(HL), A
1E91    23              	INC	HL
1E92    7A              	LD	A, D
1E93    A6              	AND	(HL)
1E94    77              	LD	(HL), A
1E95    23              	INC	HL
1E96    D1              	POP	DE
1E97    7B              	LD	A, E
1E98    A6              	AND	(HL)
1E99    77              	LD	(HL), A
1E9A    23              	INC	HL
1E9B    7A              	LD	A, D
1E9C    A6              	AND	(HL)
1E9D    77              	LD	(HL), A
1E9E    09              	ADD	HL, BC
1E9F    D1              	POP	DE
1EA0    7B              	LD	A, E
1EA1    A6              	AND	(HL)
1EA2    77              	LD	(HL), A
1EA3    23              	INC	HL
1EA4    7A              	LD	A, D
1EA5    A6              	AND	(HL)
1EA6    77              	LD	(HL), A
1EA7    23              	INC	HL
1EA8    D1              	POP	DE
1EA9    7B              	LD	A, E
1EAA    A6              	AND	(HL)
1EAB    77              	LD	(HL), A
1EAC    23              	INC	HL
1EAD    7A              	LD	A, D
1EAE    A6              	AND	(HL)
1EAF    77              	LD	(HL), A
1EB0    09              	ADD	HL, BC
1EB1    D1              	POP	DE
1EB2    7B              	LD	A, E
1EB3    A6              	AND	(HL)
1EB4    77              	LD	(HL), A
1EB5    23              	INC	HL
1EB6    7A              	LD	A, D
1EB7    A6              	AND	(HL)
1EB8    77              	LD	(HL), A
1EB9    23              	INC	HL
1EBA    D1              	POP	DE
1EBB    7B              	LD	A, E
1EBC    A6              	AND	(HL)
1EBD    77              	LD	(HL), A
1EBE    23              	INC	HL
1EBF    7A              	LD	A, D
1EC0    A6              	AND	(HL)
1EC1    77              	LD	(HL), A
1EC2    09              	ADD	HL, BC
1EC3    D1              	POP	DE
1EC4    7B              	LD	A, E
1EC5    A6              	AND	(HL)
1EC6    77              	LD	(HL), A
1EC7    23              	INC	HL
1EC8    7A              	LD	A, D
1EC9    A6              	AND	(HL)
1ECA    77              	LD	(HL), A
1ECB    23              	INC	HL
1ECC    D1              	POP	DE
1ECD    7B              	LD	A, E
1ECE    A6              	AND	(HL)
1ECF    77              	LD	(HL), A
1ED0    23              	INC	HL
1ED1    7A              	LD	A, D
1ED2    A6              	AND	(HL)
1ED3    77              	LD	(HL), A
1ED4                    PUT_AND_32x4_RESTORE_STACK:
1ED4    31 00 00        	LD	SP, 0000
1ED7    C9              	RET
1ED8
1ED8                    ;32x4単色をOR転送する
1ED8                    ;	LD	HL, POSITION
1ED8                    ;	LD	DE, PATTERN
1ED8                    PUT_OR_32x4:
1ED8    ED 73 29 1F     	LD	(PUT_OR_32x4_RESTORE_STACK + 1), SP
1EDC    F9              	LD	SP, HL
1EDD    EB              	EX	DE, HL
1EDE    01 4D 00        	LD	BC, 77
1EE1    D1              	POP	DE
1EE2    7B              	LD	A, E
1EE3    B6              	OR	(HL)
1EE4    77              	LD	(HL), A
1EE5    23              	INC	HL
1EE6    7A              	LD	A, D
1EE7    B6              	OR	(HL)
1EE8    77              	LD	(HL), A
1EE9    23              	INC	HL
1EEA    D1              	POP	DE
1EEB    7B              	LD	A, E
1EEC    B6              	OR	(HL)
1EED    77              	LD	(HL), A
1EEE    23              	INC	HL
1EEF    7A              	LD	A, D
1EF0    B6              	OR	(HL)
1EF1    77              	LD	(HL), A
1EF2    09              	ADD	HL, BC
1EF3    D1              	POP	DE
1EF4    7B              	LD	A, E
1EF5    B6              	OR	(HL)
1EF6    77              	LD	(HL), A
1EF7    23              	INC	HL
1EF8    7A              	LD	A, D
1EF9    B6              	OR	(HL)
1EFA    77              	LD	(HL), A
1EFB    23              	INC	HL
1EFC    D1              	POP	DE
1EFD    7B              	LD	A, E
1EFE    B6              	OR	(HL)
1EFF    77              	LD	(HL), A
1F00    23              	INC	HL
1F01    7A              	LD	A, D
1F02    B6              	OR	(HL)
1F03    77              	LD	(HL), A
1F04    09              	ADD	HL, BC
1F05    D1              	POP	DE
1F06    7B              	LD	A, E
1F07    B6              	OR	(HL)
1F08    77              	LD	(HL), A
1F09    23              	INC	HL
1F0A    7A              	LD	A, D
1F0B    B6              	OR	(HL)
1F0C    77              	LD	(HL), A
1F0D    23              	INC	HL
1F0E    D1              	POP	DE
1F0F    7B              	LD	A, E
1F10    B6              	OR	(HL)
1F11    77              	LD	(HL), A
1F12    23              	INC	HL
1F13    7A              	LD	A, D
1F14    B6              	OR	(HL)
1F15    77              	LD	(HL), A
1F16    09              	ADD	HL, BC
1F17    D1              	POP	DE
1F18    7B              	LD	A, E
1F19    B6              	OR	(HL)
1F1A    77              	LD	(HL), A
1F1B    23              	INC	HL
1F1C    7A              	LD	A, D
1F1D    B6              	OR	(HL)
1F1E    77              	LD	(HL), A
1F1F    23              	INC	HL
1F20    D1              	POP	DE
1F21    7B              	LD	A, E
1F22    B6              	OR	(HL)
1F23    77              	LD	(HL), A
1F24    23              	INC	HL
1F25    7A              	LD	A, D
1F26    B6              	OR	(HL)
1F27    77              	LD	(HL), A
1F28                    PUT_OR_32x4_RESTORE_STACK:
1F28    31 00 00        	LD	SP, 0000
1F2B    C9              	RET
1F2C
1F2C                    ;32x16単色を転送する
1F2C                    ;	LD	DE, POSITION
1F2C                    ;	LD	HL, PATTERN
1F2C                    PUT32x16:
1F2C    ED 73 D5 1F     	LD	(PUT32x16_RESTORE_STACK + 1), SP
1F30    F9              	LD	SP, HL
1F31    EB              	EX	DE, HL
1F32    01 4D 00        	LD	BC, 77
1F35    D1              	POP	DE
1F36    73              	LD	(HL), E
1F37    23              	INC	HL
1F38    72              	LD	(HL), D
1F39    23              	INC	HL
1F3A    D1              	POP	DE
1F3B    73              	LD	(HL), E
1F3C    23              	INC	HL
1F3D    72              	LD	(HL), D
1F3E    09              	ADD	HL, BC
1F3F    D1              	POP	DE
1F40    73              	LD	(HL), E
1F41    23              	INC	HL
1F42    72              	LD	(HL), D
1F43    23              	INC	HL
1F44    D1              	POP	DE
1F45    73              	LD	(HL), E
1F46    23              	INC	HL
1F47    72              	LD	(HL), D
1F48    09              	ADD	HL, BC
1F49    D1              	POP	DE
1F4A    73              	LD	(HL), E
1F4B    23              	INC	HL
1F4C    72              	LD	(HL), D
1F4D    23              	INC	HL
1F4E    D1              	POP	DE
1F4F    73              	LD	(HL), E
1F50    23              	INC	HL
1F51    72              	LD	(HL), D
1F52    09              	ADD	HL, BC
1F53    D1              	POP	DE
1F54    73              	LD	(HL), E
1F55    23              	INC	HL
1F56    72              	LD	(HL), D
1F57    23              	INC	HL
1F58    D1              	POP	DE
1F59    73              	LD	(HL), E
1F5A    23              	INC	HL
1F5B    72              	LD	(HL), D
1F5C    09              	ADD	HL, BC
1F5D    D1              	POP	DE
1F5E    73              	LD	(HL), E
1F5F    23              	INC	HL
1F60    72              	LD	(HL), D
1F61    23              	INC	HL
1F62    D1              	POP	DE
1F63    73              	LD	(HL), E
1F64    23              	INC	HL
1F65    72              	LD	(HL), D
1F66    09              	ADD	HL, BC
1F67    D1              	POP	DE
1F68    73              	LD	(HL), E
1F69    23              	INC	HL
1F6A    72              	LD	(HL), D
1F6B    23              	INC	HL
1F6C    D1              	POP	DE
1F6D    73              	LD	(HL), E
1F6E    23              	INC	HL
1F6F    72              	LD	(HL), D
1F70    09              	ADD	HL, BC
1F71    D1              	POP	DE
1F72    73              	LD	(HL), E
1F73    23              	INC	HL
1F74    72              	LD	(HL), D
1F75    23              	INC	HL
1F76    D1              	POP	DE
1F77    73              	LD	(HL), E
1F78    23              	INC	HL
1F79    72              	LD	(HL), D
1F7A    09              	ADD	HL, BC
1F7B    D1              	POP	DE
1F7C    73              	LD	(HL), E
1F7D    23              	INC	HL
1F7E    72              	LD	(HL), D
1F7F    23              	INC	HL
1F80    D1              	POP	DE
1F81    73              	LD	(HL), E
1F82    23              	INC	HL
1F83    72              	LD	(HL), D
1F84    09              	ADD	HL, BC
1F85    D1              	POP	DE
1F86    73              	LD	(HL), E
1F87    23              	INC	HL
1F88    72              	LD	(HL), D
1F89    23              	INC	HL
1F8A    D1              	POP	DE
1F8B    73              	LD	(HL), E
1F8C    23              	INC	HL
1F8D    72              	LD	(HL), D
1F8E    09              	ADD	HL, BC
1F8F    D1              	POP	DE
1F90    73              	LD	(HL), E
1F91    23              	INC	HL
1F92    72              	LD	(HL), D
1F93    23              	INC	HL
1F94    D1              	POP	DE
1F95    73              	LD	(HL), E
1F96    23              	INC	HL
1F97    72              	LD	(HL), D
1F98    09              	ADD	HL, BC
1F99    D1              	POP	DE
1F9A    73              	LD	(HL), E
1F9B    23              	INC	HL
1F9C    72              	LD	(HL), D
1F9D    23              	INC	HL
1F9E    D1              	POP	DE
1F9F    73              	LD	(HL), E
1FA0    23              	INC	HL
1FA1    72              	LD	(HL), D
1FA2    09              	ADD	HL, BC
1FA3    D1              	POP	DE
1FA4    73              	LD	(HL), E
1FA5    23              	INC	HL
1FA6    72              	LD	(HL), D
1FA7    23              	INC	HL
1FA8    D1              	POP	DE
1FA9    73              	LD	(HL), E
1FAA    23              	INC	HL
1FAB    72              	LD	(HL), D
1FAC    09              	ADD	HL, BC
1FAD    D1              	POP	DE
1FAE    73              	LD	(HL), E
1FAF    23              	INC	HL
1FB0    72              	LD	(HL), D
1FB1    23              	INC	HL
1FB2    D1              	POP	DE
1FB3    73              	LD	(HL), E
1FB4    23              	INC	HL
1FB5    72              	LD	(HL), D
1FB6    09              	ADD	HL, BC
1FB7    D1              	POP	DE
1FB8    73              	LD	(HL), E
1FB9    23              	INC	HL
1FBA    72              	LD	(HL), D
1FBB    23              	INC	HL
1FBC    D1              	POP	DE
1FBD    73              	LD	(HL), E
1FBE    23              	INC	HL
1FBF    72              	LD	(HL), D
1FC0    09              	ADD	HL, BC
1FC1    D1              	POP	DE
1FC2    73              	LD	(HL), E
1FC3    23              	INC	HL
1FC4    72              	LD	(HL), D
1FC5    23              	INC	HL
1FC6    D1              	POP	DE
1FC7    73              	LD	(HL), E
1FC8    23              	INC	HL
1FC9    72              	LD	(HL), D
1FCA    09              	ADD	HL, BC
1FCB    D1              	POP	DE
1FCC    73              	LD	(HL), E
1FCD    23              	INC	HL
1FCE    72              	LD	(HL), D
1FCF    23              	INC	HL
1FD0    D1              	POP	DE
1FD1    73              	LD	(HL), E
1FD2    23              	INC	HL
1FD3    72              	LD	(HL), D
1FD4                    PUT32x16_RESTORE_STACK:
1FD4    31 00 00        	LD	SP, 0000
1FD7    C9              	RET
1FD8
1FD8                    ;32x16単色をAND転送する
1FD8                    ;	LD	DE, POSITION
1FD8                    ;	LD	HL, PATTERN
1FD8                    PUT_AND_32x16:
1FD8    ED 73 08 21     	LD	(PUT_AND_32x16_RESTORE_STACK + 1), SP
1FDC    F9              	LD	SP, HL
1FDD    EB              	EX	DE, HL
1FDE    01 4D 00        	LD	BC, 77
1FE1    D1              	POP	DE
1FE2    7B              	LD	A, E
1FE3    A6              	AND	(HL)
1FE4    77              	LD	(HL), A
1FE5    23              	INC	HL
1FE6    7A              	LD	A, D
1FE7    A6              	AND	(HL)
1FE8    77              	LD	(HL), A
1FE9    23              	INC	HL
1FEA    D1              	POP	DE
1FEB    7B              	LD	A, E
1FEC    A6              	AND	(HL)
1FED    77              	LD	(HL), A
1FEE    23              	INC	HL
1FEF    7A              	LD	A, D
1FF0    A6              	AND	(HL)
1FF1    77              	LD	(HL), A
1FF2    09              	ADD	HL, BC
1FF3    D1              	POP	DE
1FF4    7B              	LD	A, E
1FF5    A6              	AND	(HL)
1FF6    77              	LD	(HL), A
1FF7    23              	INC	HL
1FF8    7A              	LD	A, D
1FF9    A6              	AND	(HL)
1FFA    77              	LD	(HL), A
1FFB    23              	INC	HL
1FFC    D1              	POP	DE
1FFD    7B              	LD	A, E
1FFE    A6              	AND	(HL)
1FFF    77              	LD	(HL), A
2000    23              	INC	HL
2001    7A              	LD	A, D
2002    A6              	AND	(HL)
2003    77              	LD	(HL), A
2004    09              	ADD	HL, BC
2005    D1              	POP	DE
2006    7B              	LD	A, E
2007    A6              	AND	(HL)
2008    77              	LD	(HL), A
2009    23              	INC	HL
200A    7A              	LD	A, D
200B    A6              	AND	(HL)
200C    77              	LD	(HL), A
200D    23              	INC	HL
200E    D1              	POP	DE
200F    7B              	LD	A, E
2010    A6              	AND	(HL)
2011    77              	LD	(HL), A
2012    23              	INC	HL
2013    7A              	LD	A, D
2014    A6              	AND	(HL)
2015    77              	LD	(HL), A
2016    09              	ADD	HL, BC
2017    D1              	POP	DE
2018    7B              	LD	A, E
2019    A6              	AND	(HL)
201A    77              	LD	(HL), A
201B    23              	INC	HL
201C    7A              	LD	A, D
201D    A6              	AND	(HL)
201E    77              	LD	(HL), A
201F    23              	INC	HL
2020    D1              	POP	DE
2021    7B              	LD	A, E
2022    A6              	AND	(HL)
2023    77              	LD	(HL), A
2024    23              	INC	HL
2025    7A              	LD	A, D
2026    A6              	AND	(HL)
2027    77              	LD	(HL), A
2028    09              	ADD	HL, BC
2029    D1              	POP	DE
202A    7B              	LD	A, E
202B    A6              	AND	(HL)
202C    77              	LD	(HL), A
202D    23              	INC	HL
202E    7A              	LD	A, D
202F    A6              	AND	(HL)
2030    77              	LD	(HL), A
2031    23              	INC	HL
2032    D1              	POP	DE
2033    7B              	LD	A, E
2034    A6              	AND	(HL)
2035    77              	LD	(HL), A
2036    23              	INC	HL
2037    7A              	LD	A, D
2038    A6              	AND	(HL)
2039    77              	LD	(HL), A
203A    09              	ADD	HL, BC
203B    D1              	POP	DE
203C    7B              	LD	A, E
203D    A6              	AND	(HL)
203E    77              	LD	(HL), A
203F    23              	INC	HL
2040    7A              	LD	A, D
2041    A6              	AND	(HL)
2042    77              	LD	(HL), A
2043    23              	INC	HL
2044    D1              	POP	DE
2045    7B              	LD	A, E
2046    A6              	AND	(HL)
2047    77              	LD	(HL), A
2048    23              	INC	HL
2049    7A              	LD	A, D
204A    A6              	AND	(HL)
204B    77              	LD	(HL), A
204C    09              	ADD	HL, BC
204D    D1              	POP	DE
204E    7B              	LD	A, E
204F    A6              	AND	(HL)
2050    77              	LD	(HL), A
2051    23              	INC	HL
2052    7A              	LD	A, D
2053    A6              	AND	(HL)
2054    77              	LD	(HL), A
2055    23              	INC	HL
2056    D1              	POP	DE
2057    7B              	LD	A, E
2058    A6              	AND	(HL)
2059    77              	LD	(HL), A
205A    23              	INC	HL
205B    7A              	LD	A, D
205C    A6              	AND	(HL)
205D    77              	LD	(HL), A
205E    09              	ADD	HL, BC
205F    D1              	POP	DE
2060    7B              	LD	A, E
2061    A6              	AND	(HL)
2062    77              	LD	(HL), A
2063    23              	INC	HL
2064    7A              	LD	A, D
2065    A6              	AND	(HL)
2066    77              	LD	(HL), A
2067    23              	INC	HL
2068    D1              	POP	DE
2069    7B              	LD	A, E
206A    A6              	AND	(HL)
206B    77              	LD	(HL), A
206C    23              	INC	HL
206D    7A              	LD	A, D
206E    A6              	AND	(HL)
206F    77              	LD	(HL), A
2070    09              	ADD	HL, BC
2071    D1              	POP	DE
2072    7B              	LD	A, E
2073    A6              	AND	(HL)
2074    77              	LD	(HL), A
2075    23              	INC	HL
2076    7A              	LD	A, D
2077    A6              	AND	(HL)
2078    77              	LD	(HL), A
2079    23              	INC	HL
207A    D1              	POP	DE
207B    7B              	LD	A, E
207C    A6              	AND	(HL)
207D    77              	LD	(HL), A
207E    23              	INC	HL
207F    7A              	LD	A, D
2080    A6              	AND	(HL)
2081    77              	LD	(HL), A
2082    09              	ADD	HL, BC
2083    D1              	POP	DE
2084    7B              	LD	A, E
2085    A6              	AND	(HL)
2086    77              	LD	(HL), A
2087    23              	INC	HL
2088    7A              	LD	A, D
2089    A6              	AND	(HL)
208A    77              	LD	(HL), A
208B    23              	INC	HL
208C    D1              	POP	DE
208D    7B              	LD	A, E
208E    A6              	AND	(HL)
208F    77              	LD	(HL), A
2090    23              	INC	HL
2091    7A              	LD	A, D
2092    A6              	AND	(HL)
2093    77              	LD	(HL), A
2094    09              	ADD	HL, BC
2095    D1              	POP	DE
2096    7B              	LD	A, E
2097    A6              	AND	(HL)
2098    77              	LD	(HL), A
2099    23              	INC	HL
209A    7A              	LD	A, D
209B    A6              	AND	(HL)
209C    77              	LD	(HL), A
209D    23              	INC	HL
209E    D1              	POP	DE
209F    7B              	LD	A, E
20A0    A6              	AND	(HL)
20A1    77              	LD	(HL), A
20A2    23              	INC	HL
20A3    7A              	LD	A, D
20A4    A6              	AND	(HL)
20A5    77              	LD	(HL), A
20A6    09              	ADD	HL, BC
20A7    D1              	POP	DE
20A8    7B              	LD	A, E
20A9    A6              	AND	(HL)
20AA    77              	LD	(HL), A
20AB    23              	INC	HL
20AC    7A              	LD	A, D
20AD    A6              	AND	(HL)
20AE    77              	LD	(HL), A
20AF    23              	INC	HL
20B0    D1              	POP	DE
20B1    7B              	LD	A, E
20B2    A6              	AND	(HL)
20B3    77              	LD	(HL), A
20B4    23              	INC	HL
20B5    7A              	LD	A, D
20B6    A6              	AND	(HL)
20B7    77              	LD	(HL), A
20B8    09              	ADD	HL, BC
20B9    D1              	POP	DE
20BA    7B              	LD	A, E
20BB    A6              	AND	(HL)
20BC    77              	LD	(HL), A
20BD    23              	INC	HL
20BE    7A              	LD	A, D
20BF    A6              	AND	(HL)
20C0    77              	LD	(HL), A
20C1    23              	INC	HL
20C2    D1              	POP	DE
20C3    7B              	LD	A, E
20C4    A6              	AND	(HL)
20C5    77              	LD	(HL), A
20C6    23              	INC	HL
20C7    7A              	LD	A, D
20C8    A6              	AND	(HL)
20C9    77              	LD	(HL), A
20CA    09              	ADD	HL, BC
20CB    D1              	POP	DE
20CC    7B              	LD	A, E
20CD    A6              	AND	(HL)
20CE    77              	LD	(HL), A
20CF    23              	INC	HL
20D0    7A              	LD	A, D
20D1    A6              	AND	(HL)
20D2    77              	LD	(HL), A
20D3    23              	INC	HL
20D4    D1              	POP	DE
20D5    7B              	LD	A, E
20D6    A6              	AND	(HL)
20D7    77              	LD	(HL), A
20D8    23              	INC	HL
20D9    7A              	LD	A, D
20DA    A6              	AND	(HL)
20DB    77              	LD	(HL), A
20DC    09              	ADD	HL, BC
20DD    D1              	POP	DE
20DE    7B              	LD	A, E
20DF    A6              	AND	(HL)
20E0    77              	LD	(HL), A
20E1    23              	INC	HL
20E2    7A              	LD	A, D
20E3    A6              	AND	(HL)
20E4    77              	LD	(HL), A
20E5    23              	INC	HL
20E6    D1              	POP	DE
20E7    7B              	LD	A, E
20E8    A6              	AND	(HL)
20E9    77              	LD	(HL), A
20EA    23              	INC	HL
20EB    7A              	LD	A, D
20EC    A6              	AND	(HL)
20ED    77              	LD	(HL), A
20EE    09              	ADD	HL, BC
20EF    D1              	POP	DE
20F0    7B              	LD	A, E
20F1    A6              	AND	(HL)
20F2    77              	LD	(HL), A
20F3    23              	INC	HL
20F4    7A              	LD	A, D
20F5    A6              	AND	(HL)
20F6    77              	LD	(HL), A
20F7    23              	INC	HL
20F8    D1              	POP	DE
20F9    7B              	LD	A, E
20FA    A6              	AND	(HL)
20FB    77              	LD	(HL), A
20FC    23              	INC	HL
20FD    7A              	LD	A, D
20FE    A6              	AND	(HL)
20FF    77              	LD	(HL), A
2100    ED 73 05 21     	LD	(PUT_AND_32x16_LD_HL_SP + 1), SP
2104                    PUT_AND_32x16_LD_HL_SP:
2104    21 00 00        	LD	HL, 0000
2107                    PUT_AND_32x16_RESTORE_STACK:
2107    31 00 00        	LD	SP, 0000
210A    C9              	RET
210B
210B                    ;32x16単色をOR転送する
210B                    ;	LD	DE, POSITION
210B                    ;	LD	HL, PATTERN
210B                    PUT_OR_32x16:
210B    ED 73 3B 22     	LD	(PUT_OR_32x16_RESTORE_STACK + 1), SP
210F    F9              	LD	SP, HL
2110    EB              	EX	DE, HL
2111    01 4D 00        	LD	BC, 77
2114    D1              	POP	DE
2115    7B              	LD	A, E
2116    B6              	OR	(HL)
2117    77              	LD	(HL), A
2118    23              	INC	HL
2119    7A              	LD	A, D
211A    B6              	OR	(HL)
211B    77              	LD	(HL), A
211C    23              	INC	HL
211D    D1              	POP	DE
211E    7B              	LD	A, E
211F    B6              	OR	(HL)
2120    77              	LD	(HL), A
2121    23              	INC	HL
2122    7A              	LD	A, D
2123    B6              	OR	(HL)
2124    77              	LD	(HL), A
2125    09              	ADD	HL, BC
2126    D1              	POP	DE
2127    7B              	LD	A, E
2128    B6              	OR	(HL)
2129    77              	LD	(HL), A
212A    23              	INC	HL
212B    7A              	LD	A, D
212C    B6              	OR	(HL)
212D    77              	LD	(HL), A
212E    23              	INC	HL
212F    D1              	POP	DE
2130    7B              	LD	A, E
2131    B6              	OR	(HL)
2132    77              	LD	(HL), A
2133    23              	INC	HL
2134    7A              	LD	A, D
2135    B6              	OR	(HL)
2136    77              	LD	(HL), A
2137    09              	ADD	HL, BC
2138    D1              	POP	DE
2139    7B              	LD	A, E
213A    B6              	OR	(HL)
213B    77              	LD	(HL), A
213C    23              	INC	HL
213D    7A              	LD	A, D
213E    B6              	OR	(HL)
213F    77              	LD	(HL), A
2140    23              	INC	HL
2141    D1              	POP	DE
2142    7B              	LD	A, E
2143    B6              	OR	(HL)
2144    77              	LD	(HL), A
2145    23              	INC	HL
2146    7A              	LD	A, D
2147    B6              	OR	(HL)
2148    77              	LD	(HL), A
2149    09              	ADD	HL, BC
214A    D1              	POP	DE
214B    7B              	LD	A, E
214C    B6              	OR	(HL)
214D    77              	LD	(HL), A
214E    23              	INC	HL
214F    7A              	LD	A, D
2150    B6              	OR	(HL)
2151    77              	LD	(HL), A
2152    23              	INC	HL
2153    D1              	POP	DE
2154    7B              	LD	A, E
2155    B6              	OR	(HL)
2156    77              	LD	(HL), A
2157    23              	INC	HL
2158    7A              	LD	A, D
2159    B6              	OR	(HL)
215A    77              	LD	(HL), A
215B    09              	ADD	HL, BC
215C    D1              	POP	DE
215D    7B              	LD	A, E
215E    B6              	OR	(HL)
215F    77              	LD	(HL), A
2160    23              	INC	HL
2161    7A              	LD	A, D
2162    B6              	OR	(HL)
2163    77              	LD	(HL), A
2164    23              	INC	HL
2165    D1              	POP	DE
2166    7B              	LD	A, E
2167    B6              	OR	(HL)
2168    77              	LD	(HL), A
2169    23              	INC	HL
216A    7A              	LD	A, D
216B    B6              	OR	(HL)
216C    77              	LD	(HL), A
216D    09              	ADD	HL, BC
216E    D1              	POP	DE
216F    7B              	LD	A, E
2170    B6              	OR	(HL)
2171    77              	LD	(HL), A
2172    23              	INC	HL
2173    7A              	LD	A, D
2174    B6              	OR	(HL)
2175    77              	LD	(HL), A
2176    23              	INC	HL
2177    D1              	POP	DE
2178    7B              	LD	A, E
2179    B6              	OR	(HL)
217A    77              	LD	(HL), A
217B    23              	INC	HL
217C    7A              	LD	A, D
217D    B6              	OR	(HL)
217E    77              	LD	(HL), A
217F    09              	ADD	HL, BC
2180    D1              	POP	DE
2181    7B              	LD	A, E
2182    B6              	OR	(HL)
2183    77              	LD	(HL), A
2184    23              	INC	HL
2185    7A              	LD	A, D
2186    B6              	OR	(HL)
2187    77              	LD	(HL), A
2188    23              	INC	HL
2189    D1              	POP	DE
218A    7B              	LD	A, E
218B    B6              	OR	(HL)
218C    77              	LD	(HL), A
218D    23              	INC	HL
218E    7A              	LD	A, D
218F    B6              	OR	(HL)
2190    77              	LD	(HL), A
2191    09              	ADD	HL, BC
2192    D1              	POP	DE
2193    7B              	LD	A, E
2194    B6              	OR	(HL)
2195    77              	LD	(HL), A
2196    23              	INC	HL
2197    7A              	LD	A, D
2198    B6              	OR	(HL)
2199    77              	LD	(HL), A
219A    23              	INC	HL
219B    D1              	POP	DE
219C    7B              	LD	A, E
219D    B6              	OR	(HL)
219E    77              	LD	(HL), A
219F    23              	INC	HL
21A0    7A              	LD	A, D
21A1    B6              	OR	(HL)
21A2    77              	LD	(HL), A
21A3    09              	ADD	HL, BC
21A4    D1              	POP	DE
21A5    7B              	LD	A, E
21A6    B6              	OR	(HL)
21A7    77              	LD	(HL), A
21A8    23              	INC	HL
21A9    7A              	LD	A, D
21AA    B6              	OR	(HL)
21AB    77              	LD	(HL), A
21AC    23              	INC	HL
21AD    D1              	POP	DE
21AE    7B              	LD	A, E
21AF    B6              	OR	(HL)
21B0    77              	LD	(HL), A
21B1    23              	INC	HL
21B2    7A              	LD	A, D
21B3    B6              	OR	(HL)
21B4    77              	LD	(HL), A
21B5    09              	ADD	HL, BC
21B6    D1              	POP	DE
21B7    7B              	LD	A, E
21B8    B6              	OR	(HL)
21B9    77              	LD	(HL), A
21BA    23              	INC	HL
21BB    7A              	LD	A, D
21BC    B6              	OR	(HL)
21BD    77              	LD	(HL), A
21BE    23              	INC	HL
21BF    D1              	POP	DE
21C0    7B              	LD	A, E
21C1    B6              	OR	(HL)
21C2    77              	LD	(HL), A
21C3    23              	INC	HL
21C4    7A              	LD	A, D
21C5    B6              	OR	(HL)
21C6    77              	LD	(HL), A
21C7    09              	ADD	HL, BC
21C8    D1              	POP	DE
21C9    7B              	LD	A, E
21CA    B6              	OR	(HL)
21CB    77              	LD	(HL), A
21CC    23              	INC	HL
21CD    7A              	LD	A, D
21CE    B6              	OR	(HL)
21CF    77              	LD	(HL), A
21D0    23              	INC	HL
21D1    D1              	POP	DE
21D2    7B              	LD	A, E
21D3    B6              	OR	(HL)
21D4    77              	LD	(HL), A
21D5    23              	INC	HL
21D6    7A              	LD	A, D
21D7    B6              	OR	(HL)
21D8    77              	LD	(HL), A
21D9    09              	ADD	HL, BC
21DA    D1              	POP	DE
21DB    7B              	LD	A, E
21DC    B6              	OR	(HL)
21DD    77              	LD	(HL), A
21DE    23              	INC	HL
21DF    7A              	LD	A, D
21E0    B6              	OR	(HL)
21E1    77              	LD	(HL), A
21E2    23              	INC	HL
21E3    D1              	POP	DE
21E4    7B              	LD	A, E
21E5    B6              	OR	(HL)
21E6    77              	LD	(HL), A
21E7    23              	INC	HL
21E8    7A              	LD	A, D
21E9    B6              	OR	(HL)
21EA    77              	LD	(HL), A
21EB    09              	ADD	HL, BC
21EC    D1              	POP	DE
21ED    7B              	LD	A, E
21EE    B6              	OR	(HL)
21EF    77              	LD	(HL), A
21F0    23              	INC	HL
21F1    7A              	LD	A, D
21F2    B6              	OR	(HL)
21F3    77              	LD	(HL), A
21F4    23              	INC	HL
21F5    D1              	POP	DE
21F6    7B              	LD	A, E
21F7    B6              	OR	(HL)
21F8    77              	LD	(HL), A
21F9    23              	INC	HL
21FA    7A              	LD	A, D
21FB    B6              	OR	(HL)
21FC    77              	LD	(HL), A
21FD    09              	ADD	HL, BC
21FE    D1              	POP	DE
21FF    7B              	LD	A, E
2200    B6              	OR	(HL)
2201    77              	LD	(HL), A
2202    23              	INC	HL
2203    7A              	LD	A, D
2204    B6              	OR	(HL)
2205    77              	LD	(HL), A
2206    23              	INC	HL
2207    D1              	POP	DE
2208    7B              	LD	A, E
2209    B6              	OR	(HL)
220A    77              	LD	(HL), A
220B    23              	INC	HL
220C    7A              	LD	A, D
220D    B6              	OR	(HL)
220E    77              	LD	(HL), A
220F    09              	ADD	HL, BC
2210    D1              	POP	DE
2211    7B              	LD	A, E
2212    B6              	OR	(HL)
2213    77              	LD	(HL), A
2214    23              	INC	HL
2215    7A              	LD	A, D
2216    B6              	OR	(HL)
2217    77              	LD	(HL), A
2218    23              	INC	HL
2219    D1              	POP	DE
221A    7B              	LD	A, E
221B    B6              	OR	(HL)
221C    77              	LD	(HL), A
221D    23              	INC	HL
221E    7A              	LD	A, D
221F    B6              	OR	(HL)
2220    77              	LD	(HL), A
2221    09              	ADD	HL, BC
2222    D1              	POP	DE
2223    7B              	LD	A, E
2224    B6              	OR	(HL)
2225    77              	LD	(HL), A
2226    23              	INC	HL
2227    7A              	LD	A, D
2228    B6              	OR	(HL)
2229    77              	LD	(HL), A
222A    23              	INC	HL
222B    D1              	POP	DE
222C    7B              	LD	A, E
222D    B6              	OR	(HL)
222E    77              	LD	(HL), A
222F    23              	INC	HL
2230    7A              	LD	A, D
2231    B6              	OR	(HL)
2232    77              	LD	(HL), A
2233    ED 73 38 22     	LD	(PUT_OR_32x16_LD_HL_SP + 1), SP
2237                    PUT_OR_32x16_LD_HL_SP:
2237    21 00 00        	LD	HL, 0000
223A                    PUT_OR_32x16_RESTORE_STACK:
223A    31 00 00        	LD	SP, 0000
223D    C9              	RET
223E                    ; プリンタリセット
223E                    RESET_PRINTER:
223E    AF              	XOR	A
223F    D3 FE           	OUT	(0FEh), A
2241    3E 80           	LD	A, 080h
2243    D3 FE           	OUT	(0FEh), A
2245    AF              	XOR	A
2246    D3 FE           	OUT	(0FEh), A
2248    C9              	RET
2249
2249                    ;一文字プリンタに送る
2249                    ;	LD	A, 'A'
2249                    PUT_PRINTER1:
2249    F5              	PUSH	AF
224A                    PUT_PRINTER1_L1:
224A    DB FE           	IN	A, (0FEh)
224C    CB 47           	BIT	0, A
224E    20 FA           	JR	NZ, PUT_PRINTER1_L1
2250    F1              	POP	AF
2251    D3 FF           	OUT	(0FFh), A ; 1文字分送る
2253    3E 80           	LD	A, 080h
2255    D3 FE           	OUT	(0FEh), A ; Hi
2257    AF              	XOR	A
2258    D3 FE           	OUT	(0FEh), A ; Lo
225A    C9              	RET
225B
225B                    ;メッセージをプリンタに送る
225B                    ;	LD	HL, MES
225B                    MSGOUT_PRINTER:
225B    E5              	PUSH	HL
225C                    MSGOUT_PRINTER_L1:
225C    7E              	LD	A, (HL)
225D    B7              	OR	A
225E    28 06           	JR	Z, MSGOUT_PRINTER_END
2260    CD 49 22        	CALL	PUT_PRINTER1
2263    23              	INC	HL
2264    18 F6           	JR	MSGOUT_PRINTER_L1
2266                    MSGOUT_PRINTER_END:
2266    E1              	POP	HL
2267    C9              	RET
2268
2268                    ;0Dhで終わるメッセージをプリンタに送る
2268                    ;	LD	HL, MES
2268                    MSG0D_OUT_PRINTER:
2268    E5              	PUSH	HL
2269                    MSG0D_OUT_PRINTER_L1:
2269    7E              	LD	A, (HL)
226A    FE 0D           	CP	0Dh
226C    28 06           	JR	Z, MSG0D_OUT_PRINTER_END
226E    CD 49 22        	CALL	PUT_PRINTER1
2271    23              	INC	HL
2272    18 F5           	JR	MSG0D_OUT_PRINTER_L1
2274                    MSG0D_OUT_PRINTER_END:
2274    E1              	POP	HL
2275    C9              	RET
2276
2276                    ; HLレジスタの値を16進数2桁でプリンタに送る
2276                    PUTHEX16_PRINTER:
2276    E5              	PUSH	HL
2277    7C              	LD	A, H
2278    CD 81 22        	CALL	PUTHEX_PRINTER
227B    7D              	LD	A, L
227C    CD 81 22        	CALL	PUTHEX_PRINTER
227F    E1              	POP	HL
2280    C9              	RET
2281
2281                    ; Aレジスタの値を16進数2桁でプリンタに送る
2281                    PUTHEX_PRINTER:
2281    F5              	PUSH	AF
2282    CB 3F           	SRL	A
2284    CB 3F           	SRL	A
2286    CB 3F           	SRL	A
2288    CB 3F           	SRL	A
228A    E6 0F           	AND	00FH
228C    CD 98 22        	CALL	PUTHEX1_PRINTER
228F    F1              	POP	AF
2290    F5              	PUSH	AF
2291    E6 0F           	AND	00FH
2293    CD 98 22        	CALL	PUTHEX1_PRINTER
2296    F1              	POP	AF
2297    C9              	RET
2298
2298                    ; Aレジスタの0～Fをプリンタに送る
2298                    PUTHEX1_PRINTER:
2298    F5              	PUSH	AF
2299    C5              	PUSH	BC
229A    E5              	PUSH	HL
229B    CD 9D 14        	CALL	A_TO_HEX
229E    CD 49 22        	CALL	PUT_PRINTER1
22A1    E1              	POP	HL
22A2    C1              	POP	BC
22A3    F1              	POP	AF
22A4    C9              	RET
22A5
22A5                    ; ダンプする
22A5                    ; LD	HL, Addr
22A5                    ; LD	DE, size
22A5                    DUMP_PRINTER:
22A5    C5              	PUSH	BC
22A6    D5              	PUSH	DE
22A7    E5              	PUSH	HL
22A8                    DUMP_PRINTER_1:
22A8                    	; アドレス
22A8    7C              	LD	A, H
22A9    CD 81 22        	CALL	PUTHEX_PRINTER
22AC    7D              	LD	A, L
22AD    CD 81 22        	CALL	PUTHEX_PRINTER
22B0    3E 3A           	LD	A, ':'
22B2    CD 49 22        	CALL	PUT_PRINTER1
22B5    3E 20           	LD	A, ' '
22B7    CD 49 22        	CALL	PUT_PRINTER1
22BA    06 10           	LD	B, 16
22BC                    DUMP_PRINTER_2:
22BC    7E              	LD	A, (HL)
22BD    CD 81 22        	CALL	PUTHEX_PRINTER
22C0    3E 20           	LD	A, ' '
22C2    CD 49 22        	CALL	PUT_PRINTER1
22C5    23              	INC	HL
22C6    1B              	DEC	DE
22C7    7A              	LD	A, D
22C8    B3              	OR	E
22C9    28 0F           	JR	Z, DUMP_PRINTER_3
22CB    05              	DEC	B
22CC    20 EE           	JR	NZ, DUMP_PRINTER_2
22CE    3E 0D           	LD	A, 00Dh
22D0    CD 49 22        	CALL	PUT_PRINTER1
22D3    3E 0A           	LD	A, 00Ah
22D5    CD 49 22        	CALL	PUT_PRINTER1
22D8    18 CE           	JR	DUMP_PRINTER_1
22DA                    DUMP_PRINTER_3:
22DA    E1              	POP	HL
22DB    D1              	POP	DE
22DC    C1              	POP	BC
22DD    C9              	RET
22DE                    ; FDD I/O Port
00D8                    CR	EQU	0D8H ; FDCコマンドレジスタ
00D9                    TR	EQU	0D9H ; FDCトラックレジスタ
00DA                    SCR	EQU	0DAH ; FDCセクタレジスタ
00DB                    DR	EQU	0DBH ; FDCデータレジスタ
00DC                    DM	EQU	0DCH ; ディスクドライブの選択とモーター制御
00DD                    HS	EQU	0DDH ; ディスクのサイド(面)選択
22DE
22DE                    ; READ DIR
22DE                    ; LD	A, ドライブ番号
22DE                    ; LD	HL, ファイルネーム
22DE                    ; LD	IX, BUFFER(最低2KB)
22DE                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
22DE                    READ_FILE:
22DE    E5              	PUSH	HL
22DF    FD 21 08 25     	LD	IY, WKIY
22E3    32 05 25        	LD	(DIRNO), A	; ドライブ番号
22E6    3E 00           	LD	A, 000h
22E8    FD 77 02        	LD	(IY+2), A
22EB    3E 08           	LD	A, 008h
22ED    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ2Kバイト
22F0    01 10 00        	LD	BC, 16
22F3    ED 43 03 25     	LD	(STREC), BC	; レコード16 (DIR)
22F7    CD 21 24        	CALL	BREAD
22FA    F5              	PUSH	AF
22FB    CD 95 23        	CALL	MOFF
22FE    F1              	POP	AF
22FF    E1              	POP	HL
2300    D8              	RET	C		; Cyが1ならディレクトリ読み込みエラー
2301    06 40           	LD	B, 64
2303    DD E5           	PUSH	IX
2305    D1              	POP	DE
2306                    READ_FILE_1:
2306    1A              	LD	A, (DE)
2307    13              	INC	DE
2308    FE 01           	CP	001h
230A    20 09           	JR	NZ, READ_FILE_2 ; モードが01h(Obj)以外は無視
230C    D5              	PUSH	DE
230D    E5              	PUSH	HL
230E    CD BE 14        	CALL	CMP_TEXT
2311    E1              	POP	HL
2312    D1              	POP	DE
2313    38 0D           	JR	C, READ_FILE_3
2315                    READ_FILE_2:
2315                    	; DE = DE + 31
2315    EB              	EX	DE, HL
2316    C5              	PUSH	BC
2317    01 1F 00        	LD	BC, 31
231A    09              	ADD	HL, BC
231B    C1              	POP	BC
231C    EB              	EX	DE, HL
231D                    	; ループ判定
231D    05              	DEC	B
231E    20 E6           	JR	NZ, READ_FILE_1
2320    37              	SCF
2321    C9              	RET			; ファイルが見つからない
2322                    READ_FILE_3:
2322                    	; 読み込むファイルを見つけた
2322                    	; DE = DE + 19
2322    01 13 00        	LD	BC, 19
2325    EB              	EX	DE, HL
2326    09              	ADD	HL, BC
2327    EB              	EX	DE, HL
2328                    	; 読み込みサイズ取得
2328    1A              	LD	A, (DE)
2329    FD 77 02        	LD	(IY+2), A	; 読み込みサイズ下位バイト設定
232C    13              	INC	DE
232D    1A              	LD	A, (DE)
232E    FD 77 03        	LD	(IY+3), A	; 読み込みサイズ上位バイト設定
2331    13              	INC	DE
2332                    	; 読み込みアドレス取得
2332                    ;	LD	A, (DE)
2332    13              	INC	DE
2333                    ;	LD	C, A
2333                    ;	LD	A, (DE)
2333    13              	INC	DE
2334                    ;	LD	B, A
2334                    ;	PUSH	BC
2334                    ;	POP	IX
2334                    	; DE = DE + 6
2334    01 06 00        	LD	BC, 6
2337    EB              	EX	DE, HL
2338    09              	ADD	HL, BC
2339    EB              	EX	DE, HL
233A                    	; 読み込み開始レコード番号
233A    1A              	LD	A, (DE)
233B    13              	INC	DE
233C    4F              	LD	C, A
233D    1A              	LD	A, (DE)
233E    13              	INC	DE
233F    47              	LD	B, A
2340    ED 43 03 25     	LD	(STREC), BC	; レコード番号設定
2344                    	; 読み込み開始
2344    CD 21 24        	CALL	BREAD
2347    F5              	PUSH	AF
2348    CD 95 23        	CALL	MOFF
234B    F1              	POP	AF
234C    C9              	RET
234D
234D                    ; READY
234D    3A 06 25        READY:	LD	A, (MTFG)
2350    0F              	RRCA
2351    CD 7F 23        	CALL	MTON
2354    3A 05 25        	LD	A, (DIRNO)	; DRIVE NO GET
2357    F6 84           	OR	084H
2359    D3 DC           	OUT	(DM), A		; DRIVE SELECT MOTON
235B    AF              	XOR	A
235C    CD B3 14        	CALL	DLY60M
235F    21 00 00        	LD	HL, 00000H
2362    2B              REDY0:	DEC	HL
2363    7C              	LD	A, H
2364    B5              	OR	L
2365    CA EF 24        	JP	Z, DERROR	; NO DISK
2368    DB D8           	IN	A, (CR)		; STATUS GET
236A    2F              	CPL
236B    07              	RLCA
236C    38 F4           	JR	C, REDY0
236E    3A 05 25        	LD	A, (DIRNO)
2371    4F              	LD	C,A
2372    21 01 25        	LD	HL, CLBF0
2375    06 00           	LD	B, 000H
2377    09              	ADD	HL, BC
2378    CB 46           	BIT	0, (HL)
237A    C0              	RET	NZ
237B    CD B0 23        	CALL	RCLB
237E    C9              	RET
237F
237F                    ; MOTOR ON
237F    3E 80           MTON:	LD	A,080H
2381    D3 DC           	OUT	(DM), A
2383    06 0A           	LD	B, 10		; 1SEC DELAY
2385    21 19 3C        MTD1:	LD	HL, 03C19H
2388    2B              MTD2:	DEC	HL
2389    7D              	LD	A, L
238A    B4              	OR	H
238B    20 FB           	JR	NZ, MTD2
238D    10 F6           	DJNZ	MTD1
238F    3E 01           	LD	A, 1
2391    32 06 25        	LD	(MTFG), A
2394    C9              	RET
2395
2395                    ; MOTOR OFF
2395    CD AC 14        MOFF:	CALL	DLY1M		; 1000US DELAY
2398    AF              	XOR	A
2399    D3 DC           	OUT	(DM), A
239B    32 06 25        	LD	(MTFG), A
239E    C9              	RET
239F
239F                    ; SEEK TREATMENT
239F    3E 1B           SEEK:	LD	A, 01BH
23A1    2F              	CPL
23A2    D3 D8           	OUT	(CR), A
23A4    CD C8 23        	CALL	BUSY
23A7    CD B3 14        	CALL	DLY60M
23AA    DB D8           	IN	A, (CR)
23AC    2F              	CPL
23AD    E6 99           	AND	099H
23AF    C9              	RET
23B0
23B0                    ; RECALIBLATION
23B0    E5              RCLB:	PUSH	HL
23B1    3E 0B           	LD	A, 00BH
23B3    2F              	CPL
23B4    D3 D8           	OUT	(CR), A
23B6    CD C8 23        	CALL	BUSY
23B9    CD B3 14        	CALL	DLY60M
23BC    DB D8           	IN	A, (CR)
23BE    2F              	CPL
23BF    E6 85           	AND	085H
23C1    EE 04           	XOR	004H
23C3    E1              	POP	HL
23C4    C8              	RET	Z
23C5    C3 EF 24        	JP	DERROR
23C8
23C8                    ; BUSY AND WAIT
23C8    D5              BUSY:	PUSH	DE
23C9    E5              	PUSH	HL
23CA    CD A5 14        	CALL	DLY80U
23CD    1E 07           	LD	E, 7
23CF    21 00 00        BUSY2:	LD	HL, 000H
23D2    2B              BUSY0:	DEC	HL
23D3    7C              	LD	A, H
23D4    B5              	OR	L
23D5    28 09           	JR	Z, BUSY1
23D7    DB D8           	IN	A, (CR)
23D9    2F              	CPL
23DA    0F              	RRCA
23DB    38 F5           	JR	C, BUSY0
23DD    E1              	POP	HL
23DE    D1              	POP	DE
23DF    C9              	RET
23E0    1D              BUSY1:	DEC	E
23E1    20 EC           	JR	NZ, BUSY2
23E3    C3 EF 24        	JP	DERROR
23E6
23E6                    ; DATA CHECK
23E6    06 00           CONVRT:	LD	B, 0
23E8    11 10 00        	LD	DE, 16
23EB    2A 03 25        	LD	HL, (STREC)		; START RECORD
23EE    AF              	XOR	A
23EF    ED 52           TRANS:	SBC	HL, DE
23F1    38 03           	JR	C, TRANS1
23F3    04              	INC	B
23F4    18 F9           	JR	TRANS
23F6    19              TRANS1:	ADD	HL, DE
23F7    60              	LD	H, B
23F8    2C              	INC	L
23F9    FD 74 04        	LD	(IY+4), H
23FC    FD 75 05        	LD	(IY+5), L
23FF    3A 05 25        DCHK:	LD	A, (DIRNO)
2402    FE 04           	CP	4
2404    30 18           	JR	NC, DTCK1
2406    FD 7E 04        	LD	A, (IY+4)
2409    FE A0           MAXTRK:	CP	160		; MAX TRACK ( 70 -> 35TRACK 2D)
240B                    				; MAX TRACK (160 -> 80TRACK 2D)
240B    30 11           	JR	NC, DTCK1
240D    FD 7E 05        	LD	A, (IY+5)
2410    B7              	OR	A
2411    28 0B           	JR	Z, DTCK1
2413    FE 11           	CP	17		; MAX SECTOR
2415    30 07           	JR	NC, DTCK1
2417    FD 7E 02        	LD	A, (IY+2)
241A    FD B6 03        	OR	(IY+3)
241D    C0              	RET	NZ
241E    C3 EF 24        DTCK1:	JP	DERROR
2421
2421                    ; SEQENTIAL READ
2421                    ; DIRNO: ドライブ番号
2421                    ; IX: 読み込みアドレス
2421                    ; IY: 6バイトのワークエリア
2421                    ; STREC: 読み込みレコード番号
2421                    ; Result Cyフラグ (1:エラー, 0:正常読み込み)
2421    F3              BREAD:	DI
2422    CD E6 23        	CALL	CONVRT
2425    3E 0A           	LD	A, 10
2427    32 07 25        	LD	(RETRY), A
242A    CD 4D 23        READ1:	CALL	READY
242D    FD 56 03        	LD	D, (IY+3)
2430    FD 7E 02        	LD	A, (IY+2)
2433    B7              	OR	A
2434    28 01           	JR	Z, RE0
2436    14              	INC	D
2437    FD 7E 05        RE0:	LD	A, (IY+5)
243A    FD 77 01        	LD	(IY+1), A
243D    FD 7E 04        	LD	A, (IY+4)
2440    FD 77 00        	LD	(IY+0), A
2443    DD E5           	PUSH	IX
2445    E1              	POP	HL
2446    CB 3F           RE8:	SRL	A
2448    2F              	CPL
2449    D3 DB           	OUT	(DR), A
244B    30 04           	JR	NC, RE1
244D    3E 01           	LD	A, 001H
244F    18 02           	JR	RE2
2451    3E 00           RE1:	LD	A, 000H
2453    2F              RE2:	CPL
2454    D3 DD           	OUT	(HS), A
2456    CD 9F 23        	CALL	SEEK
2459    20 6A           	JR	NZ, REE
245B    0E DB           	LD	C, 0DBH
245D    FD 7E 00        	LD	A, (IY+0)
2460    CB 3F           	SRL	A
2462    2F              	CPL
2463    D3 D9           	OUT	(TR), A
2465    FD 7E 01        	LD	A, (IY+1)
2468    2F              	CPL
2469    D3 DA           	OUT	(SCR),A
246B    D9              	EXX
246C    21 9E 24        	LD	HL, RE3
246F    E5              	PUSH	HL
2470    D9              	EXX
2471    3E 94           	LD	A, 094H		;READ & CMD
2473    2F              	CPL
2474    D3 D8           	OUT	(CR), A
2476    CD D4 24        	CALL	WAIT
2479    06 00           RE6:	LD	B, 000H
247B    DB D8           RE4:	IN	A, (CR)
247D    0F              	RRCA
247E    D8              	RET	C
247F    0F              	RRCA
2480    38 F9           	JR	C, RE4
2482    ED A2           	INI
2484    20 F5           	JR	NZ, RE4
2486    FD 34 01        	INC	(IY+1)
2489    FD 7E 01        	LD	A, (IY+1)
248C    FE 11           	CP	17
248E    28 05           	JR	Z, RETS
2490    15              	DEC	D
2491    20 E6           	JR	NZ, RE6
2493    18 01           	JR	RE5
2495    15              RETS:	DEC	D
2496    3E D8           RE5:	LD	A, 0D8H		; FORCE INTER RUPT
2498    2F              	CPL
2499    D3 D8           	OUT	(CR), A
249B    CD C8 23        	CALL	BUSY
249E    DB D8           RE3:	IN	A, (CR)
24A0    2F              	CPL
24A1    E6 FF           	AND	0FFH
24A3    20 20           	JR	NZ, REE
24A5    D9              	EXX
24A6    E1              	POP	HL
24A7    D9              	EXX
24A8    FD 7E 01        	LD	A, (IY+1)
24AB    FE 11           	CP	17
24AD    20 08           	JR	NZ, REX
24AF    3E 01           	LD	A, 001H
24B1    FD 77 01        	LD	(IY+1), A
24B4    FD 34 00        	INC	(IY+0)
24B7    7A              REX:	LD	A, D
24B8    B7              	OR	A
24B9    20 05           	JR	NZ, RE7
24BB    3E 80           	LD	A, 080H
24BD    D3 DC           	OUT	(DM), A
24BF    C9              	RET
24C0    FD 7E 00        RE7:	LD	A, (IY+0)
24C3    18 81           	JR	RE8
24C5    3A 07 25        REE:	LD	A, (RETRY)
24C8    3D              	DEC	A
24C9    32 07 25        	LD	(RETRY), A
24CC    28 21           	JR	Z, DERROR
24CE    CD B0 23        	CALL	RCLB
24D1    C3 2A 24        	JP	READ1
24D4
24D4                    ; WAIT AND BUSY OFF
24D4    D5              WAIT:	PUSH	DE
24D5    E5              	PUSH	HL
24D6    CD A5 14        	CALL	DLY80U
24D9    21 00 00        WAIT2:	LD	HL, 00000H
24DC    2B              WAIT0:	DEC	HL
24DD    7C              	LD	A, H
24DE    B5              	OR	L
24DF    28 09           	JR	Z, WAIT1
24E1    DB D8           	IN	A, (CR)
24E3    2F              	CPL
24E4    0F              	RRCA
24E5    30 F5           	JR	NC, WAIT0
24E7    E1              	POP	HL
24E8    D1              	POP	DE
24E9    C9              	RET
24EA    1D              WAIT1:	DEC	E
24EB    20 EC           	JR	NZ, WAIT2
24ED    18 00           	JR	DERROR
24EF
24EF                    ; ディスクエラー
24EF    CD 95 23        DERROR:	CALL	MOFF
24F2    3E A5           	LD	A, 0A5H
24F4    D3 D9           	OUT	(TR), A
24F6    CD A5 14        	CALL	DLY80U
24F9    21 10 25        	LD	HL, ERROR_MESSAGE
24FC    CD 5B 22        	CALL	MSGOUT_PRINTER
24FF    37              	SCF
2500    C9              	RET
2501
2501    00 00           CLBF0:	DW	0 ; ?
2503    00 00           STREC:	DW	0 ; 読込み開始セクタ
2505    00              DIRNO:	DB	0 ; ドライブ番号(0-3)
2506    00              MTFG:	DB	0 ; モータ0:OFF, 1:ON
2507    00              RETRY:	DB	0 ; 残りリトライ回数
2508    00 00 00 00     WKIY:	DS	6 ; FD READ 指示、ワーク
250C    00 00
250E    00 00           WKIX:	DW	0 ; 読み込みアドレス
2510
2510                    ERROR_MESSAGE:
2510    44 69 73 6B     	DB	"Disk Error\n", 0
2514    20 45 72 72
2518    6F 72 5C 6E
251C    00
251D                    ;INCLUDE "lzdec.mac"
251D
251D                    MSG:
251D    4D 5A 2D 32     	DB	"MZ-2000 DrawTest by kuran-kuran",0
2521    30 30 30 20
2525    44 72 61 77
2529    54 65 73 74
252D    20 62 79 20
2531    6B 75 72 61
2535    6E 2D 6B 75
2539    72 61 6E 00
253D
253D                    ; ソルバルウ
253D                    SOLVALOU:
253D                    SOLVALOU_MASK:
253D                    	; solvalou_mask
253D                    	; 32 x 16 dot
253D    FF 3F FC FF     	DW 03FFFh, 0FFFCh, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 00FFFh, 0FFF0h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 0003Fh, 0FC00h
2541    FF 0F F0 FF
2545    FF 0F F0 FF
2549    FF 0F F0 FF
254D    FF 00 00 FF
2551    FF 00 00 FF
2555    FF 00 00 FF
2559    3F 00 00 FC
255D    0F 00 00 F0     	DW 0000Fh, 0F000h, 00003h, 0C000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00C00h, 00030h, 00FCFh, 0F3F0h
2561    03 00 00 C0
2565    00 00 00 00
2569    00 00 00 00
256D    00 00 00 00
2571    00 00 00 00
2575    00 0C 30 00
2579    CF 0F F0 F3
257D                    	; solvalou
257D                    	; 32 x 16 dot
257D                    	; Blue data
257D                    SOLVALOU_B:
257D    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 0F000h, 0000Fh, 0F000h, 0000Fh, 0FF00h, 000FFh, 0FF00h, 000FFh, 0FF00h, 000FCh, 0FFC0h, 003FFh
2581    00 F0 0F 00
2585    00 F0 0F 00
2589    00 F0 0F 00
258D    00 FF FF 00
2591    00 FF FF 00
2595    00 FF FC 00
2599    C0 FF FF 03
259D    F0 FF FF 0F     	DW 0FFF0h, 00FFFh, 0FFFCh, 03FFFh, 0FFFFh, 0FFFFh, 03FFFh, 0FFFCh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0F3FFh, 0FFCFh, 0F030h, 00C0Fh
25A1    FC FF FF 3F
25A5    FF FF FF FF
25A9    FF 3F FC FF
25AD    FF FF FF FF
25B1    FF FF FF FF
25B5    FF F3 CF FF
25B9    30 F0 0F 0C
25BD                    	; Red data
25BD                    SOLVALOU_R:
25BD    00 40 01 00     	DW 04000h, 00001h, 0F000h, 0000Bh, 03000h, 00004h, 03000h, 00008h, 03F00h, 00044h, 03000h, 00008h, 0BB00h, 00047h, 0F7C0h, 0008Bh
25C1    00 F0 0B 00
25C5    00 30 04 00
25C9    00 30 08 00
25CD    00 3F 44 00
25D1    00 30 08 00
25D5    00 BB 47 00
25D9    C0 F7 8B 00
25DD    30 FB 47 04     	DW 0FB30h, 00447h, 0F7CCh, 0208Bh, 0FBF3h, 04447h, 0F733h, 0888Bh, 0FB33h, 04C47h, 0FF33h, 08C8Bh, 00333h, 04C40h, 0F030h, 00C0Ah
25E1    CC F7 8B 20
25E5    F3 FB 47 44
25E9    33 F7 8B 88
25ED    33 FB 47 4C
25F1    33 FF 8B 8C
25F5    33 03 40 4C
25F9    30 F0 0A 0C
25FD                    	; Green data
25FD                    SOLVALOU_G:
25FD    00 C0 03 00     	DW 0C000h, 00003h, 0F000h, 0000Fh, 07000h, 0000Dh, 0B000h, 0000Ch, 07F00h, 000ECh, 0B000h, 0001Ch, 0FF00h, 000ECh, 0FFC0h, 001DFh
2601    00 F0 0F 00
2605    00 70 0D 00
2609    00 B0 0C 00
260D    00 7F EC 00
2611    00 B0 1C 00
2615    00 FF EC 00
2619    C0 FF DF 01
261D    30 FF CF 0E     	DW 0FF30h, 00ECFh, 0FFCCh, 035CFh, 0FFF3h, 0CECFh, 03F73h, 0CDCCh, 0FFB3h, 0CECFh, 0FF73h, 0CDCFh, 083B3h, 0CECAh, 0F030h, 00C0Fh
2621    CC FF CF 35
2625    F3 FF CF CE
2629    73 3F CC CD
262D    B3 FF CF CE
2631    73 FF CF CD
2635    B3 83 CA CE
2639    30 F0 0F 0C
263D
