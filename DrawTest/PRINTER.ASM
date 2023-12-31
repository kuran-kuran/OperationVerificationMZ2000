; プリンタリセット
RESET_PRINTER:
	XOR	A
	OUT	(0FEh), A
	LD	A, 080h
	OUT	(0FEh), A
	XOR	A
	OUT	(0FEh), A
	RET

;一文字プリンタに送る
;	LD	A, 'A'
PUT_PRINTER1:
	PUSH	AF
PUT_PRINTER1_L1:
	IN	A, (0FEh)
	BIT	0, A
	JR	NZ, PUT_PRINTER1_L1
	POP	AF
	OUT	(0FFh), A ; 1文字分送る
	LD	A, 080h
	OUT	(0FEh), A ; Hi
	XOR	A
	OUT	(0FEh), A ; Lo
	RET

;メッセージをプリンタに送る
;	LD	HL, MES
MSGOUT_PRINTER:
	PUSH	HL
MSGOUT_PRINTER_L1:
	LD	A, (HL)
	OR	A
	JR	Z, MSGOUT_PRINTER_END
	CALL	PUT_PRINTER1
	INC	HL
	JR	MSGOUT_PRINTER_L1
MSGOUT_PRINTER_END:
	POP	HL
	RET

;0Dhで終わるメッセージをプリンタに送る
;	LD	HL, MES
MSG0D_OUT_PRINTER:
	PUSH	HL
MSG0D_OUT_PRINTER_L1:
	LD	A, (HL)
	CP	0Dh
	JR	Z, MSG0D_OUT_PRINTER_END
	CALL	PUT_PRINTER1
	INC	HL
	JR	MSG0D_OUT_PRINTER_L1
MSG0D_OUT_PRINTER_END:
	POP	HL
	RET

; HLレジスタの値を16進数2桁でプリンタに送る
PUTHEX16_PRINTER:
	PUSH	HL
	LD	A, H
	CALL	PUTHEX_PRINTER
	LD	A, L
	CALL	PUTHEX_PRINTER
	POP	HL
	RET

; Aレジスタの値を16進数2桁でプリンタに送る
PUTHEX_PRINTER:
	PUSH	AF
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	AND	00FH
	CALL	PUTHEX1_PRINTER
	POP	AF
	PUSH	AF
	AND	00FH
	CALL	PUTHEX1_PRINTER
	POP	AF
	RET

; Aレジスタの0〜Fをプリンタに送る
PUTHEX1_PRINTER:
	PUSH	AF
	PUSH	BC
	PUSH	HL
	CALL	A_TO_HEX
	CALL	PUT_PRINTER1
	POP	HL
	POP	BC
	POP	AF
	RET

; ダンプする
; LD	HL, Addr
; LD	DE, size
DUMP_PRINTER:
	PUSH	BC
	PUSH	DE
	PUSH	HL
DUMP_PRINTER_1:
	; アドレス
	LD	A, H
	CALL	PUTHEX_PRINTER
	LD	A, L
	CALL	PUTHEX_PRINTER
	LD	A, ':'
	CALL	PUT_PRINTER1
	LD	A, ' '
	CALL	PUT_PRINTER1
	LD	B, 16
DUMP_PRINTER_2:
	LD	A, (HL)
	CALL	PUTHEX_PRINTER
	LD	A, ' '
	CALL	PUT_PRINTER1
	INC	HL
	DEC	DE
	LD	A, D
	OR	E
	JR	Z, DUMP_PRINTER_3
	DEC	B
	JR	NZ, DUMP_PRINTER_2
	LD	A, 00Dh
	CALL	PUT_PRINTER1
	LD	A, 00Ah
	CALL	PUT_PRINTER1
	JR	DUMP_PRINTER_1
DUMP_PRINTER_3:
	POP	HL
	POP	DE
	POP	BC
	RET
