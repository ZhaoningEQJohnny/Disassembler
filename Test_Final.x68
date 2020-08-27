    

    ORG    $9000

    *MOVE, MOVEA, MOVEM
    MOVE        D3,$00005454
    MOVE.W      D7, $00005421
    MOVE.B      (A1),$00001214
    MOVE.W      -(A2),$FFFF1234
    MOVE.L      (A1)+, D5
    
    MOVE.L      $00005454,D6
    MOVE.B      $FFFF5432,D6
    
    MOVE.B      #12,D6 *bug 9020
*    MOVE.W      A4,D1
*    MOVE.W      #257, D6
*
*    
    MOVEA.W     $00005565,A2
    MOVEA.L     $FFFF1222,A4
    MOVEA.W     (A3),A2
    MOVEA.L     (A3)+,A1
    MOVEA.W     -(A7),A1
    MOVEA.W     -(SP),A2 *a7 not sp
    MOVEA.W     -(A3),A2
    
    MOVEM       (A7)+, D0/A5/A4/D3  
*  
*    *ADD, ADDA
    ADD.B       D1,D2
    ADD.W       D3,D2
    ADD.B       D2, $FFFF4534
    ADDA.W      $0004511,A5
    ADDA.L      $FFFF4151,A0

    ADD.L       $00004455,D2
    ADD         D3,$00006458
    ADD.L       $FFFF1234,D3
*
*    
*    *SUB, SUBQ
*
    SUBQ.L       #5,$00001234
    SUBQ.L       #5,D1   
    SUBQ.B       #4,D5
    SUBQ.W       #7,D7
    SUBQ.L       #3,D2

    SUB.L       D1,$00001234
    SUB.L       $00001234,D1   
    SUB.B       D4,D5
    SUB.W       D3,D7
    SUB.L       D7,D2
    SUB.L       D1, $FFFF6767
    SUB.L       $FFFF9999,D1 *reduced to 9999
    SUB         (A1),D5
    SUB         D6, (A3)
    SUB         -(A7),D5 
*    
*    *MULS, DIVS
    MULS        #45,D3
    MULS        $00003344,D5
    MULS        $FFFF1444, D4 
    
    *LEA
    LEA         $00003322, A4
    LEA         (A2),A7
    
    *OR, ORI
    ORI          #1,D6 *bug with ori
    ORI          #2, $00006542
    ORI          #3, (A2)
    ORI          #4,D2
    ORI          #5, (A2)+
    ORI          #7,D3
    
    OR          D2,D6
    OR          D5, $00006542
    OR          D5, (A2)
    OR          (A7),D2
    OR          D1, (A2)+
    OR          -(A2),D3
    
    *NEG
    NEG        D2 
    
    *EOR
    EOR          D2,D6 *bug, or not eor
    EOR          D5, $00006542 *bug, or not eor, cause of ORI
    
    *LSR, LSL

    LSR         (A1)+
    LSR         -(A2)  
    LSR         $00006742
    LSR         $FFFF3567
 
    LSL         $00005555
    LSL         $FFFF4545

    LSL.B       D1,D2
    LSL.W       D1,D2
    LSL.L       D3,D4
    
    LSL.L       #2,D1 
    LSL.B       #4,D5
    LSL.W       #5,D6
* 
*    
*    *ASR, ASL
    ASL.B       D1,D2
    ASL.W       D1,D2
    ASL.L       D3,D4
    ASL.B       #6,D5
    ASL.W       #3,D6
    ASL.L       #8,D1  
    ASL         $00009999
    ASL         $FFFFAAAA *reduced to AAAA
    
    ASR         $FFFFCCCC *reduced to CCCC
    ASR         $0000BBBB
    ASR         (A1)+
    ASR         -(A2)    
*    
*    *ROL, ROR
    ROL.L       D1,D2
    ROL.B       #5,D7
    ROL.W       #4,D5
    ROL.L       #2,D3 
    ROL         $00005432
    ROL         $FFFF2222
    ROL.B       D5,D6
    ROL.W       D2,D4
    
    ROR.B       #5,D4
    ROR.W       #4,D7
    ROR.L       #2,D2
    ROR.B       D7,D3
    ROR.W       D1,D3
    ROR         $00005432
    ROR         $FFFF5432
    ROR         (A7)+
    ROR         -(A2)    

    
BCC_BRANCH    
    *BCLR
    
    BCLR        D2, D4
    *CMP, CMPI
    
    CMP.B       D1,D2
    CMP.W       D1,D2
    CMP.L       D3,D4
    CMPI.B       #6,D5 *bug, #$00
    CMPI.W       #3,D6 *extra zeros
    CMPI.L       #8,D1  
    CMP         $00009999, D3
    
    *BCS, BGE, BLT, BVC
    BCS         BCC_BRANCH
    BGE         BCC_BRANCH
    BLT         BCC_BRANCH
    BVC         BCC_BRANCH
    
    *BRA, JSR, RTS, NOP
    BRA         BCC_BRANCH
    JSR         (A7)
    JSR         $00123658
    RTS
    NOP
    
    SUBQ.L       #5,$00001234
    

    

    *   JUST NOW IMPLEMENTED

      
    SIMHALT             ; halt simulator





