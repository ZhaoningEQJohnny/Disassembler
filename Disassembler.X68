*-----------------------------------------------------------
* Title      : 422 Disassembler
* Written by : Team Unknown
* Date       : 12/8/19
* Description: Takes in a file by using the load data feature, with specified
* starting and ending address in Config.cfg file and decompiles it into a file called Output.txt

*-----------------------------------------------------------
*****************EA VAR*********************
ZERO_ EQU $400
ONE_ EQU $408
TWO_ EQU $4016
THREE_ EQU $424
FORE_ EQU $432
FIVE_ EQU $440
SIX_ EQU $448
SEVEN_ EQU $456


DATA_REG EQU $464
ADDR_REG EQU $472
ADDR_IND EQU $480
ADDR_INC EQU $488
ADDR_DEC EQU $496
SRC_ABS_WORD EQU $504
SRC_ABS_LONG EQU $512
DEST_ABS_WORD EQU $5C0
DEST_ABS_LONG EQU $5D0
SRC_IMM_VAL EQU $590
DEST_IMM_VAL EQU $5E0


DEST_OUTPUT EQU $528



_OUTPUT  EQU $536
CUR_ADDR EQU $544
SIZE EQU $552

IMM_ABS_CONTAIN EQU $568
REVERSED               EQU $576
MOVEM_BIT_COUNTER EQU $584

USELESS_VAR EQU $5BD

    ORG    $1000    *Don't change this; see hints and tips above
    OPT CRE
    
    
CR EQU $0D
LF EQU $0A
test_st EQU $000011B0

*Opcode variables
bltBitmask  EQU  %0000110100000000
bgeBitmask  EQU  %0000110000000000
bvcBitmaks  EQU  %0000100000000000
bcsBitmask  EQU  %0000010100000000
divsBitmask EQU  %0000000011000000
cmpBitmask  EQU  %0000000100000000
addaBitmask EQU  %0000000011000000
rodBitmask  EQU  %0000011000000000
rolBitmask  EQU  %0000000100000000
lsdBitmask  EQU  %0000001000000000
lslBitmask  EQU  %0000000100000000
aslBitmask  EQU  %0000000100000000

OP_NAME_Nop                 EQU $200 
    
OP_NAME_Blt                 EQU $202                 
OP_NAME_Bge                 EQU $203
OP_NAME_Bvc                 EQU $204
OP_NAME_Bcs                 EQU $205
OP_NAME_Bra                 EQU $206
OP_NAME_Rol                 EQU $207
OP_NAME_Ror                 EQU $208
OP_NAME_Lsl                 EQU $209
OP_NAME_Lsr                 EQU $210
OP_NAME_Asl                 EQU $211
OP_NAME_Asr                 EQU $212

OP_NAME_Adda                EQU $213
OP_NAME_Add                 EQU $214 
  
OP_NAME_Sub                 EQU $215

OP_NAME_Divs                EQU $216
OP_NAME_Or                  EQU $217

OP_NAME_Rts                 EQU $223
OP_NAME_Lea                 EQU $224
OP_NAME_Jsr                 EQU $225
OP_NAME_Neg                 EQU $226
OP_NAME_Movem               EQU $227

OP_NAME_Cmpi                EQU $228
OP_NAME_Bclr                EQU $229
OP_NAME_Ori                 EQU $230

OP_NAME_Data                EQU $231

OP_NAME_MOVE             EQU $232
OP_NAME_MOVEA             EQU $233
OP_NAME_SUBQ             EQU $234
OP_NAME_MULS             EQU $235

OP_NAME_EOR             EQU $236
OP_NAME_CMP             EQU $237
OP_NAME_Rol_Mem                 EQU $243
OP_NAME_Ror_Mem                 EQU $238
OP_NAME_Lsl_Mem                 EQU $239
OP_NAME_Lsr_Mem                 EQU $245
OP_NAME_Asl_Mem                 EQU $244
OP_NAME_Asr_Mem                 EQU $242




OP_NAME                     EQU $600
DN_EA_DIRECTION             EQU $610
REG_MEM_DIRECTION           EQU $620
SHIFT_DIRECTION             EQU $630
OP_SIZE_LIGHT_PURPLE        EQU $640
OP_SIZE_MEDIUM_PURPLE       EQU $650
OP_SIZE_DARK_PURPLE         EQU $660
*SOURCE_MODE                 EQU $670
DEST_MODE                   EQU $680
SOURCE_REG                  EQU $690
DEST_REG                    EQU $6A0
SUBQ_DATA                   EQU $6B0
ROTATION                    EQU $6C0        *for ASd LSd ROd
APPEND_BOOL                 EQU $6D0










CURR_ADDR               EQU  $6E0

*IO variables
SIZE1           EQU     26            ; Max string size
SIZE2           EQU     2000             * Max string size
fileNamecfg     DC.B    'Config.cfg',0  ; name of text file
fileNames68     DC.B    'Test_2.S68',0  * name of S68 file
string1         DS.B    SIZE1           ; I/O buffer
string2         DS.B    SIZE2
strSize         DS.W    1               ; Size of input string
fileID          DS.L    1               ; File ID

stop            EQU  $100
STARTING_ADDRESS_ASCII            EQU    $9F0 * User input starting address ASCII 
ENDING_ADDRESS_ASCII              EQU    $9E0 * User input ending address ASCII
STARTING_ADDRESS_HEX            EQU    $8F0 * User input starting address HEX
ENDING_ADDRESS_HEX              EQU    $8E0 * User input ending address HEX
TEMP_CURRENT_4_NIBBLES      EQU    $9D0 * Temporary variable to hold 4 nibble at a time
DESTINATION_VAR             EQU    $9C0 * Used to hold the Address number     (11-9th bit)
DESTINATION_MODE            EQU    $9B0 * Used to hold the mode of destination (8-6 bit)
SOURCE_MODE                 EQU    $9A0 * used to hold the mode of the source (5-3)
SOURCE_VAR                  EQU    $990 * Used to hold the address number of source (2-0 bit)
THIRD_TEMP_VAR              EQU    $980 * Used as an arbitrary storage for data
FOURTH_TEMP_VAR             EQU    $970 * Used to prevent overwrite to (A1) when getting end address
FIFTH_TEMP_VAR              EQU    $960 * Used to prevent overwrite to (A1) when getting start address
TEMP_CURRENT_2_NIBBLES      EQU    $950 * Temporary variable to store 2 nibble at a time
NEXT_ADDR                   EQU    $960
LEADING_ZEROS               EQU    $950


*---------------------------------------------------------------------------
START:

****************PROGRAM START FROM HERE*****************


*
* Method Name: FILE_to_STRING_CONFIG
* Description: *Loads starting and Ending address into memomry)
*  
* Preconditions:  None
* Postconditions: None
*
FILE_to_STRING_CONFIG
 ; Attempt to open file for input
        lea     fileNamecfg,A1             ; name of file to open
        move.b  #51,D0                  ; trap task #51, open existing file
        trap    #15                     ; perform task
        move.l  D1,fileID               ; save file ID

; Read string from file
        lea     string1,A1               ; location of string buffer
        move.l  fileID,D1               ; file ID of file to read from
        clr.l   D2
        move.w  #SIZE1,D2                ; number of bytes to read
        move.b  #53,D0                  ; trap task #53, read from file
        trap    #15                     ; perform task
; Close file when finished
        move.b  #56,D0                  ; trap task #56, close file, D1 contains fileID
        trap    #15                     ; perform task
                   ; perform task
*store starting/ending address to variable
        move.l  #0000,LEADING_ZEROS
        move.l  $101A,STARTING_ADDRESS_ASCII
        move.l  $1024,ENDING_ADDRESS_ASCII

*
* Method Name: CONVERT_ASCII_ADDR_TO_HEX  
* Description: Convert the ascii address to hex value and store in register
*  
* Preconditions:  None
* Postconditions: None
*


CONVERT_ASCII_ADDR_TO_HEX        
        LEA ENDING_ADDRESS_ASCII, A1
        JSR AsciiToHex 
        
        move.l D7, ENDING_ADDRESS_HEX
        
        LEA STARTING_ADDRESS_ASCII, A1
        JSR AsciiToHex 
        
        move.l D7, STARTING_ADDRESS_HEX
        MOVE.L ENDING_ADDRESS_HEX, D2 *CHECK ENDING ADDRESS
        MOVE.L d2, A6
        
        add.L D7, A3     *INITIALIZE_START_ADDR  
                                     


*
* Method Name: DISASSEMBLER_MAIN_BRANCH  
* Description: Main method to controll the program. Call methods to parse op code and EA. 
*    Output the current address, parsed OP and EA. Print the output to outputfile, and check end address.
*  
* Preconditions:  None
* Postconditions: End after get to the ending address
*


DISASSEMBLER_MAIN_BRANCH
    MOVEA.L A2,A1             *MOVE OUTPUT ARRAY TO A1
    JSR OUTPUT_CUR_ADDR        * CALL CURRENT ADDRESS OUTPUT SUBROUTINE
    JSR CLASSIFY_ADDRESS     *CALL OP SUBROUTINE
    MOVE.B #' ', (A2)+
    MOVE.B #' ', (A2)+
    JSR EA_MAIN_BRANCH
    MOVE.B #0, (A2)           *OUTPUT STOP SIGN
    JSR TrapTask13         *CALL OUTPUT TRAPTASK
    MOVEA.L #$00000150, A2


    JSR LINE_CHANGING     *CHANGE LINE

    CMP.L A6,A3
    BGE STOP_PROG *STOP PROGRAM
    JSR ADDRESS_CONTROLLER   *MOVE TO NEXT ADDRESS
    BRA DISASSEMBLER_MAIN_BRANCH   *BACK TO LOOP
    

*
* Method Name:STOP_PROG
* Description: Simhalt to stop program 
*  
*  
* Preconditions:  When address get to the ending address, call by Main_branch
* Postconditions: None
*

STOP_PROG
    SIMHALT



*
* Method Name: LINE_CHANGING
* Description:  Change line output
*  
* Preconditions: None
* Postconditions: None
*

LINE_CHANGING
    LEA CHANGE_LINE, A1
    MOVE #13, D0
    TRAP #15
    RTS


*
* Method Name: OUTPUT_CUR_ADDR
* Description:  Method call Address_appender to output the current address. Add spacing for format
*  
* Preconditions: None
* Postconditions: None
*

OUTPUT_CUR_ADDR
    JSR ADDRESS_APPENDER
    MOVE.B #' ', (A2)+
    MOVE.B #' ', (A2)+
    RTS


*
* Method Name: CLASSIFY_ADDRESS
* Description:  This subroutine finds the first 4 bits of the current opcode by using bitmask checks
* in hex. Since we know the only exact opcode for RTS and NOP, those are checked first with a simple compare.
*  
* Preconditions: Input opcode to be decoded
* Postconditions: first 4 bits found, go to corresponding subroutine routine
*
CLASSIFY_ADDRESS
    MOVE.W (A3), D2 *move first 16 bit opcode word into D2
    
    CMP.W #$4E71, D2 *do we have a NOP here?
    BEQ foundNop *yes print it
    
    CMP.W #$4E75, D2 *do we have a RTS here?
    BEQ foundRts *yes print it

    MOVE.W (A3), D2
    AND.W #$0000F000, D2 *bitmask check if this starts with E (1110), indicates rod, lsd, asd
    CMP.W #$0000F000, D2 *evaluate bitmask 
    BEQ foundF
    
    MOVE.W (A3), D2
    AND.W #$0000E000, D2 *bitmask check if this starts with E (1110), indicates rod, lsd, asd
    CMP.W #$0000E000, D2 *evaluate bitmask 
    BEQ foundE 
     
    MOVE.W (A3), D2
    AND.W #$0000D000, D2 *bitmask check if this starts with D (1101), indicates adda, add
    CMP.W #$0000D000, D2 *evaluate bitmask 
    BEQ foundD

    MOVE.W (A3), D2
    AND.W #$0000C000, D2 *bitmask check if this starts with C (1100), indicates muls
    CMP.W #$0000C000, D2 *evaluate bitmask 
    BEQ foundC

    MOVE.W (A3), D2
    AND.W #$0000B000, D2 *bitmask check if this starts with B (1011), indicates cmp, eor
    CMP.W #$0000B000, D2 *evaluate bitmask 
    BEQ foundB


    MOVE.W (A3), D2
    AND.W #$00009000, D2 *bitmask check if this starts with 9 (1001), indicates sub
    CMP.W #$00009000, D2 *evaluate bitmask 
    BEQ found9 

    MOVE.W (A3), D2
    AND.W #$00008000, D2 *bitmask check if this starts with 9 (1000), indicates or, divs
    CMP.W #$00008000, D2 *evaluate bitmask 
    BEQ found8 

    MOVE.W (A3), D2
    AND.W #$00006000, D2 *bitmask check if this starts with 6 (0110), indicates blt, bge, bvc, bcs, & bra
    CMP.W #$00006000, D2 *evaluate bitmask 
    BEQ found6   
    
    MOVE.W (A3), D2
    AND.W #$00005000, D2 *bitmask check if this starts with 5 (0101), indicates subq
    CMP.W #$00005000, D2 *evaluate bitmask 
    BEQ found5

    MOVE.W (A3), D2
    AND.W #$00004000, D2 *bitmask check if this starts with 4 (0100), indicates misc
    CMP.W #$00004000, D2 *evaluate bitmask 
    BEQ found4 
    
    MOVE.W (A3), D2
    AND.W #$00003000, D2 *bitmask check if this starts with 3 (0011), indicates move.w
    CMP.W #$00003000, D2 *evaluate bitmask 
    BEQ found3 
    
    MOVE.W (A3), D2
    AND.W #$00002000, D2 *bitmask check if this starts with 2 (0010), indicates move.l
    CMP.W #$00002000, D2 *evaluate bitmask 
    BEQ found2
    
    MOVE.W (A3), D2
    AND.W #$00001000, D2 *bitmask check if this starts with 1 (0001), indicates move.b
    CMP.W #$00001000, D2 *evaluate bitmask 
    BEQ found1
    
    MOVE.W (A3), D2
    AND.W #$00000000, D2 *bitmask check if this starts with 0 (0000), indicates bit manipulation
    CMP.W #$00000000, D2 *evaluate bitmask 
    BEQ found0
            

    MOVE.W (A3), D2
        
    BRA     dispData
    RTS

*
* Method Name: ADDRESS_CONTROLLER
* Description:  Move the current address to the next
*  
* Preconditions: None
* Postconditions: None
*


ADDRESS_CONTROLLER
    ADD.L   #2, A3
    RTS
 
*bitmask started with F*************************************************************
*
* Method Name: foundF
* Description:  default routine in case there is an error finding the first 4 bits
*  
* Preconditions: None
* Postconditions: None
*
foundF
    BRA foundDATA

*bitmask started with E*************************************************************
*
* Method Name: foundE
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with E.
* That means that this opcode will either be a version of asd, rod, or lsd. Further Bitmask checks are used here
* to find the exact opcode name. Since these opcodes are directional and have 2 different 
* versions for different data types, subroutines must be called to find the direction and other data types.
*  
* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either asd, rod, or lsd, with or without a memshift
*
foundE
    MOVE.W (A3), D2
    AND.W #$0EC0, D2    *bitmask check: indicates asd
    CMP.W #$00C0, D2    *evaluate bitmask 
    BEQ foundAsd_MemShift

    MOVE.W (A3), D2
    AND.W #$0000E6C0, D2    *bitmask check: indicates rod for register data
    CMP.W #$0000E6C0, D2    *evaluate bitmask 
    BEQ foundRod_MemShift

    MOVE.W (A3), D2
    AND.W #$0000E2C0, D2    *bitmask check: indicates lsd
    CMP.W #$0000E2C0, D2    *evaluate bitmask 
    BEQ foundLsd_MemShift

    MOVE.W (A3), D2
    AND.W #$0000E018, D2    *bitmask check: indicates rod for immediate data
    CMP.W #$0000E018, D2    *evaluate bitmask 
    BEQ foundRod

    

    MOVE.W (A3), D2
    AND.W #$0000E008, D2    *bitmask check: indicates lsd for immediate data
    CMP.W #$0000E008, D2    *evaluate bitmask 
    BEQ foundLsd

    


    MOVE.W (A3), D2
    AND.W #$0018, D2    *bitmask check: indicates asd
    CMP.W #$0000, D2    *evaluate bitmask      
    BEQ foundAsd            *must be immediate asd 
    
    BRA     dispData
*
* Method Name: foundRod
* Description:  find direction of rod by using bitmasks.
*  
* Preconditions: know the opcode is an ROD
* Postconditions: know the opcode is an ROL or ROR
*


foundRod
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundRol
    
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0000, D2    *evaluate bitmask 
    BEQ foundRor            *didn't find Rol, must be ror
    
    BRA foundData

*
* Method Name: foundLsd
* Description:  find direction of lsd by using bitmasks.
*  
* Preconditions: know the opcode is an Lsd
* Postconditions: know the opcode is an LSR or LSL
*
foundLsd
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundLsl

    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0000, D2    *evaluate bitmask     
    BEQ foundLsr            *didnt find lsl, must be lsr 

    BRA foundData
*
* Method Name: foundAsd
* Description:  find direction of rod by using bitmasks.
*  
* Preconditions: know the opcode is an Asd
* Postconditions: know the opcode is an ASL or ASR
*
foundAsd
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundAsl            *didn't find asl, must be asr
    
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0000, D2    *evaluate bitmask 
    BEQ foundAsr            *didn't find asl, must be asr


    BRA foundData


*
* Method Name: foundRod_MemShift
* Description:  It has been determined that the opcode is foundAsd_MemShift.
* Use bitmasks to find the correct direction, and call the corresponding function.
*  
* Preconditions: known Rod_MemShift 
* Postconditions: known Ror_MemShift or Rol_MemShift
* 

foundRod_MemShift
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundRol_MemShift
    
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rol
    CMP.W #$0000, D2    *evaluate bitmask 
    BEQ foundRor_MemShift            *didn't find Rol, must be ror

    BRA foundData
    
*
* Method Name: foundLsd_MemShift
* Description:  It has been determined that the opcode is foundLsd_MemShift.
* Use bitmasks to find the correct direction, and call the corresponding function.
*  
* Preconditions: known Lsd_MemShift 
* Postconditions: known Lsr_MemShift or Lsl_MemShift
* 
foundLsd_MemShift
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates lsl
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundLsl_MemShift

    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates lsl
    CMP.W #$0000, D2    *evaluate bitmask     
    BEQ foundLsr_MemShift            *didnt find lsl, must be lsr 
  
    BRA foundData

*
* Method Name: foundAsd_MemShift
* Description:  It has been determined that the opcode is foundAsd_MemShift.
* Use bitmasks to find the correct direction, and call the corresponding function.
*  
* Preconditions: known Asd_MemShift 
* Postconditions: known Asr_MemShift or Asl_MemShift
* 
foundAsd_MemShift
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates rod
    CMP.W #$0100, D2    *evaluate bitmask 
    BEQ foundAsl_MemShift            *didn't find asl, must be asr
    
    MOVE.W (A3), D2
    AND.W #$0100, D2    *bitmask check: indicates lsl
    CMP.W #$0000, D2    *evaluate bitmask 
    BEQ foundAsr_MemShift            *didn't find asl, must be asr

    BRA foundData

******************************************************************************************

*********************************************************
*
*bitmask started with D*************************************************************
*
* Method Name: foundD
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with D.
* That means that this opcode will either be add or adda. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.
* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either add or adda.
*
foundD
    MOVE.W (A3), D2
    AND.W #$0000D0C0, D2    *bitmask check: indicates adda
    CMP.W #$0000D0C0, D2    *evaluate bitmask 
    BEQ foundAdda
    MOVE.W (A3), D2
    BRA foundAdd            *bitmask invalid, go to add

*bitmask started with C*************************************************************
*
* Method Name: foundC
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with C.
* That means that this opcode will be muls since it is the only opcode starting with C.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is muls.
*
foundC
    MOVE.W (A3), D2
    AND.W #$0000C1C0, D2    *bitmask check: indicates muls
    CMP.W #$C1C0,D2

    BEQ foundMuls
    BRA foundDATA

*
*bitmask started with B*************************************************************
*
* Method Name: foundB
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with B.
* That means that this opcode will either be EOR or CMP. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.
* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either eor or cmp.
*
foundB
    MOVE.W (A3), D2
    AND.W #$0000B100, D2    *bitmask check: indicates eor
    CMP.W #$B100,D2

    BEQ     foundEor

    

    BRA     foundCmp



*
*bitmask started with 9*************************************************************
*
* Method Name: found9
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 9.
* That means that this opcode must be sub. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is sub.
*
found9
    MOVE.W (A3), D2
    BRA foundSub    *go to sub since its the only opcode that starts with 9 (1001)

*bitmask started with 8*************************************************************
*
* Method Name: found8
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 8.
* That means that this opcode will either be DIVS, DATA or OR. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either DIVS, DATA or OR.
*
found8
    MOVE.W (A3), D2
    AND.W #$000081C0, D2    *bitmask check: indicates divs
    CMP.W #$000081C0, D2    *evaluate bitmask 
    BEQ foundDivs
    
    AND.W #$01F0,D2
    CMP.W #$0100,D2
    BEQ foundDATA
    
    AND.W #$00C0,D2
    CMP.W #$00C0,D2
    BNE foundOR
    



    BRA foundDATA          *bitmask invalid
**********************************************************
*bitmask started with 6*************************************************************
*
* Method Name: found6
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 6.
* That means that this opcode will either be BLT, BGE, BVC, BCS or BRA. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either BLT, BGE, BVC, BCS or BRA.
*
found6
    MOVE.W (A3), D2
    AND.W #$00006D00, D2    *bitmask check: indicates blt
    CMP.W #$00006D00, D2    *evaluate bitmask
    BEQ foundBlt
    
    MOVE.W (A3), D2
    AND.W #$00006C00, D2    *bitmask check: indicates blt
    CMP.W #$00006C00, D2    *evaluate bitmask 
    BEQ foundBge
    
    MOVE.W (A3), D2
    AND.W #$00006800, D2    *bitmask check: indicates blt
    CMP.W #$00006800, D2    *evaluate bitmask 
    BEQ foundBvc
    
    MOVE.W (A3), D2
    AND.W #$00006500, D2    *bitmask check: indicates blt
    CMP.W #$00006500, D2    *evaluate bitmask 
    BEQ foundBcs
    
    MOVE.W (A3), D2
    BRA foundBra
    
*********************************************************
*bitmask started with 5*************************************************************
*
* Method Name: found5
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 5.
* That means that this opcode must be SUBQ. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either SUBQ.
*
found5
    MOVE.W (A3), D2
    AND.W #$5100, D2 
    CMP.W #$5100, D2
    BEQ foundSubq
    
   BRA foundData


*********************************************************
*bitmask started with 4*************************************************************
*
* Method Name: found4
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 4.
* That means that this opcode will either be RTS, LEA, JSR, MOVEM, or NEG. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either RTS, LEA, JSR, MOVEM, or NEG.
*
found4

    MOVE.W (A3), D2
    AND.W #$00004E75, D2    *bitmask check: indicates rts
    CMP.W #$00004E75, D2    *evaluate bitmask
    BEQ foundRts
    
    MOVE.W (A3), D2
    AND.W #$000041C0, D2    *bitmask check: indicates lea
    CMP.W #$000041C0, D2    *evaluate bitmask 
    BEQ foundLea

    MOVE.W (A3), D2
    AND.W #$00004E90, D2    *bitmask check: indicates jsr
    CMP.W #$00004E90, D2    *evaluate bitmask 
    BEQ foundJsr
    
    MOVE.W (A3), D2
    AND.W #$0B80,D2
    CMP.W #$0880,D2
    BEQ foundMovem

    MOVE.W (A3), D2
    AND.W #$00004400, D2    *bitmask check: indicates neg
    CMP.W #$00004400, D2    *evaluate bitmask 
    BEQ foundNeg
    
    BRA     dispData
*********************************************************
*bitmask started with 3*************************************************************
*
* Method Name: found3
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 3.
* That means that this opcode will either be MOVEA.W or MOVE.W. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either MOVEA.W or MOVE.W.
*
found3 *move.W
    MOVE.W (A3), D2
    AND.W #$0140,D2
    CMP.W #$0040,D2
    BEQ foundMOVEAW
    BRA foundMOVEW


*********************************************************
*bitmask started with 2*************************************************************
*
* Method Name: found3
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 2.
* That means that this opcode will either be MOVEA.L or MOVE.L. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either MOVEA.L or MOVE.L.
*
found2 *move.L
    MOVE.W (A3), D2
    AND.W #$0140,D2
    CMP.W #$0040,D2
    BEQ foundMOVEAL
    BRA foundMOVEL   

*********************************************************
*bitmask started with 1*************************************************************
*
* Method Name: found1
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 1.
* That means that this opcode will either be MOVEA.B or MOVE.B. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either MOVEA.B or MOVE.B.
*
found1 *move.B
    MOVE.W (A3), D2
    AND.W #$0140,D2
    CMP.W #$0040,D2
    BEQ foundMOVEAB
    BRA foundMOVEB
*********************************************************
*bitmask started with 0*************************************************************
*
* Method Name: found0
* Description:  If CLASSIFY_ADDRESS calls this method, it is implied that the opcode starts with 0.
* That means that this opcode will either be ORI, CMPI, or BCLR. Further Bitmask checks are used here
* to find the exact opcode name. The coresponding opcode subroutine is then called.

* Preconditions: Unknown opcode
* Postconditions: know exact name of opcode is either ORI, CMPI, or BCLR.
*
found0 *bit manip
    MOVE.W (A3), D2
    AND.W #$FF00, D2
    CMP.W #$0000, D2
    BEQ foundOri



    MOVE.W (A3), D2
    AND.W #$00000C00, D2    *bitmask check: indicates cmpi
    CMP.W #$00000C00, D2    *evaluate bitmask
    BEQ foundCmpi
    
    MOVE.W (A3), D2
    AND.W #$00000180, D2    *bitmask check: indicates Bclr
    CMP.W #$00000180, D2    *evaluate bitmask 
    BEQ foundBclr

    BRA foundDATA
   

    
*found the opcode, now find suffix and send to EA

*
* Method Name: SIZE_APPENDER
* Description:  Append the size output to the addr reg
*  
* Preconditions: unknown size suffix
* Postconditions: call append method
*
SIZE_APPENDER
    MOVE.W (A3), D2
    AND.W #$00C0, D2    *bitmask check: indicates L
    CMP.W #$0080, D2 
    BEQ APPEND_L  
    
    MOVE.W (A3), D2
    AND.W #$00C0, D2    *bitmask check: indicates W
    CMP.W #$0040, D2
    BEQ APPEND_W 
    
    MOVE.W (A3), D2     *default B
    AND.W #$00C0, D2    *bitmask check: indicates W
    CMP.W #$0000, D2
    BEQ APPEND_B
    
    MOVE.L #0, (APPEND_BOOL)

    RTS


*
* Method Name: SIZE_APPENDER_MEDIUM_PURPLE
* Description:  Call correct method to append the size output to the addr reg
* Different because certean opcodes store the size in different places.
*  
* Preconditions: unknown size suffix
* Postconditions: call append method
*
SIZE_APPENDER_MEDIUM_PURPLE
    MOVE.W (A3), D2
    AND.W #$00C0, D2    *bitmask check: indicates L
    CMP.W #$0080, D2 
    BEQ APPEND_L  
    
    MOVE.W (A3), D2
    AND.W #$00C0, D2    *bitmask check: indicates W
    CMP.W #$0040, D2
    BEQ APPEND_W 
    
    MOVE.W (A3), D2     *default B
    AND.W #$00C0, D2    *bitmask check: indicates W
    CMP.W #$0000, D2
    BEQ APPEND_B
    
    MOVE.L #0, (APPEND_BOOL)

    RTS

*
* Method Name: APPEND_L
* Description:  It has been determined that the suffix is a .L. Append that information to the stack
*  
* Preconditions: known size suffix
* Postconditions: size suffix added to A2 stack
*    
APPEND_L
    MOVE.B #'.', (A2)+
    MOVE.B #'L', (A2)+
    MOVE.B #4, SIZE
    MOVE.L #1, (APPEND_BOOL)
    RTS

*
* Method Name: APPEND_W
* Description:  It has been determined that the suffix is a .W. Append that information to the stack
*  
* Preconditions: known size suffix
* Postconditions: size suffix added to A2 stack
* 
APPEND_W
    MOVE.B #'.', (A2)+
    MOVE.B #'W', (A2)+
    MOVE.B #2, SIZE
    MOVE.L #1, (APPEND_BOOL)
    RTS

*
* Method Name: APPEND_B
* Description:  It has been determined that the suffix is a .B. Append that information to the stack
*  
* Preconditions: known size suffix
* Postconditions: size suffix added to A2 stack
* 
APPEND_B
    MOVE.B #1, SIZE
    MOVE.B #'.', (A2)+
    MOVE.B #'B', (A2)+
    MOVE.L #1, (APPEND_BOOL)
    RTS

*
* Method Name: foundMOVEAW
* Description:  It has been determined that the opcode is a MOVEA.W.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundMOVEAW
    MOVE.W #OP_NAME_MOVEA, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'A', (A2)+    
    MOVE.B #'.', (A2)+    
    MOVE.B #'W', (A2)+    
    MOVE.B #2, SIZE
    RTS
    
*
* Method Name: foundMOVEAB
* Description:  It has been determined that the opcode is a MOVEA.B.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundMOVEAB
    MOVE.W #OP_NAME_MOVEA, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'A', (A2)+    
    MOVE.B #'.', (A2)+    
    MOVE.B #'B', (A2)+    
    MOVE.B #1, SIZE
    RTS
    
*
* Method Name: foundMOVEAL
* Description:  It has been determined that the opcode is a MOVEA.L
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundMOVEAL
    MOVE.W #OP_NAME_MOVEA, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'A', (A2)+    
    MOVE.B #'.', (A2)+    
    MOVE.B #'L', (A2)+    
    MOVE.B #4, SIZE
    RTS

*
* Method Name: foundMOVEW
* Description:  It has been determined that the opcode is a MOVE.W.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
*     
foundMOVEW
    MOVE.W #OP_NAME_MOVE, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+  
    MOVE.B #'.', (A2)+    
    MOVE.B #'W', (A2)+    
    MOVE.B #2, SIZE
    RTS
    
* Method Name: foundMOVEB
* Description:  It has been determined that the opcode is a MOVE.B.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundMOVEB
    MOVE.W #OP_NAME_MOVE, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+  
    MOVE.B #'.', (A2)+    
    MOVE.B #'B', (A2)+    
    MOVE.B #1, SIZE
    RTS
    
*
* Method Name: foundMOVEl
* Description:  It has been determined that the opcode is a MOVE.L.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack as well as the size. No need to call SIZE_APPENDER since we know
* the size already.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundMOVEL
    MOVE.W #OP_NAME_MOVE, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+  
    MOVE.B #'.', (A2)+    
    MOVE.B #'L', (A2)+    
    MOVE.B #4, SIZE
    RTS
    
*
* Method Name: foundEor
* Description:  It has been determined that the opcode is an EOR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundEor
    MOVE.W #OP_NAME_EOR, (OP_NAME)
    MOVE.B #'E', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'R', (A2)+
    
    JSR SIZE_APPENDER



    RTS
*
* Method Name: foundCmp
* Description:  It has been determined that the opcode is a Cmp.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundCmp
    MOVE.W #OP_NAME_CMP, (OP_NAME)
    MOVE.B #'C', (A2)+
    MOVE.B #'M', (A2)+
    MOVE.B #'P', (A2)+

    JSR SIZE_APPENDER



    RTS
*
* Method Name: foundMuls
* Description:  It has been determined that the opcode is a MULS.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundMuls
    MOVE.B #2, SIZE
    MOVE.W #OP_NAME_MULS, (OP_NAME)
    MOVE.B #'M', (A2)+
    MOVE.B #'U', (A2)+
    MOVE.B #'L', (A2)+
    MOVE.B #'S', (A2)+
    RTS
*
* Method Name: foundSubq
* Description:  It has been determined that the opcode is a Subq.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundSubq
    MOVE.W #OP_NAME_SUBQ, (OP_NAME)
    MOVE.B #'S', (A2)+
    MOVE.B #'U', (A2)+
    MOVE.B #'B', (A2)+
    MOVE.B #'Q', (A2)+

    JSR SIZE_APPENDER

    RTS
*
* Method Name: foundNop
* Description:  It has been determined that the opcode is foundNop.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundNop
    MOVE.W #OP_NAME_Nop, (OP_NAME)
    MOVE.B #'N', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'P', (A2)+
    RTS
*
* Method Name: foundRts
* Description:  It has been determined that the opcode is RTS.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundRts
    MOVE.W #OP_NAME_Rts, OP_NAME
    MOVE.B #'R', (A2)+
    MOVE.B #'T', (A2)+
    MOVE.B #'S', (A2)+
    RTS
*

* Method Name: foundRol
* Description:  It has been determined that the opcode is a ROL.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundRol
    MOVE.W #OP_NAME_Rol, OP_NAME
    MOVE.B #'R', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'L', (A2)+
    JSR SIZE_APPENDER
    RTS

*
* Method Name: foundRor
* Description:  It has been determined that the opcode is a ROR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundRor
    MOVE.W #OP_NAME_Ror, OP_NAME
    MOVE.B #'R', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'R', (A2)+
    JSR SIZE_APPENDER
    RTS


* Method Name: foundLsl
* Description:  It has been determined that the opcode is a LSL.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundLsl
    MOVE.W #OP_NAME_Lsl, OP_NAME
    MOVE.B #'L', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'L', (A2)+
    JSR SIZE_APPENDER
    RTS
*
* Method Name: foundLsr
* Description:  It has been determined that the opcode is a LSR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundLsr
    MOVE.W #OP_NAME_Lsr, OP_NAME
    MOVE.B #'L', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'R', (A2)+
    JSR SIZE_APPENDER
    RTS

* Method Name: foundAsl
* Description:  It has been determined that the opcode is a Asl.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundAsl
    MOVE.W #OP_NAME_Asl, OP_NAME
    MOVE.B #'A', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'L', (A2)+
    JSR SIZE_APPENDER
    RTS
*
* Method Name: foundAsr
* Description:  It has been determined that the opcode is a ASR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundAsr
    MOVE.W #OP_NAME_Asr, OP_NAME
    MOVE.B #'A', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'R', (A2)+
    JSR SIZE_APPENDER
    RTS


*
* Method Name: foundRol_MemShift
* Description:  It has been determined that the opcode is foundRol_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 


foundRol_MemShift
    MOVE.W #OP_NAME_Rol_Mem, OP_NAME
    MOVE.B #'R', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'L', (A2)+
    RTS

*
* Method Name: foundRor_MemShift
* Description:  It has been determined that the opcode is foundRor_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundRor_MemShift
    MOVE.W #OP_NAME_Ror_Mem, OP_NAME
    MOVE.B #'R', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'R', (A2)+
    RTS
*
* Method Name: foundLsl_MemShift
* Description:  It has been determined that the opcode is foundLsl_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundLsl_MemShift
    MOVE.W #OP_NAME_Lsl_Mem, OP_NAME
    MOVE.B #'L', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'L', (A2)+
    RTS
*
* Method Name: foundLsr_MemShift
* Description:  It has been determined that the opcode is foundLsr_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundLsr_MemShift
    MOVE.W #OP_NAME_Lsr_Mem, OP_NAME
    MOVE.B #'L', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'R', (A2)+
    RTS
*
* Method Name: foundAsl_MemShift
* Description:  It has been determined that the opcode is foundAsl_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundAsl_MemShift
    MOVE.W #OP_NAME_Asl_Mem, OP_NAME
    MOVE.B #'A', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'L', (A2)+

    RTS
*
* Method Name: foundAsr_MemShift
* Description:  It has been determined that the opcode is foundAsr_MemShift.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundAsr_MemShift
    MOVE.W #OP_NAME_Asr_Mem, OP_NAME
    MOVE.B #'A', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'R', (A2)+

    RTS



* Method Name: foundAdda
* Description:  It has been determined that the opcode is a ADDA.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack and call SIZE_APPENDER_MEDIUM_PURPLE.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundAdda
    MOVE.W #OP_NAME_Adda, OP_NAME
    MOVE.B #'A', (A2)+
    MOVE.B #'D', (A2)+
    MOVE.B #'D', (A2)+
    MOVE.B #'A', (A2)+
    
    JSR SIZE_APPENDER_MEDIUM_PURPLE


    MOVE.W (A3), D2
    AND.W #$00000100, D2    *bitmask check: indicates L
    CMP.W #$00000100, D2
    BEQ APPEND_L
    BRA APPEND_W


    RTS
*
* Method Name: foundAdd
* Description:  It has been determined that the opcode is a ADD.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundAdd
    MOVE.W #OP_NAME_Add, OP_NAME 
    MOVE.B #'A', (A2)+
    MOVE.B #'D', (A2)+
    MOVE.B #'D', (A2)+

    JSR SIZE_APPENDER


    RTS
*
* Method Name: foundSub
* Description:  It has been determined that the opcode is a Sub.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundSub
    MOVE.W #OP_NAME_Sub, OP_NAME
    MOVE.B #'S', (A2)+
    MOVE.B #'U', (A2)+
    MOVE.B #'B', (A2)+

    JSR SIZE_APPENDER


    RTS
*
* Method Name: foundDivs
* Description:  It has been determined that the opcode is DIVS.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundDivs
    MOVE.W #OP_NAME_Divs, OP_NAME
    MOVE.B #'D', (A2)+
    MOVE.B #'I', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'S', (A2)+

    RTS
*
* Method Name: foundOr
* Description:  It has been determined that the opcode is an OR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundOr
    MOVE.W #OP_NAME_Or, OP_NAME
    MOVE.B #'O', (A2)+
    MOVE.B #'R', (A2)+
    JSR SIZE_APPENDER
    RTS
*
* Method Name: foundBlt
* Description:  It has been determined that the opcode is BLT.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 


foundBlt
    MOVE.W #OP_NAME_Blt, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'L', (A2)+
    MOVE.B #'T', (A2)+

    RTS
*
* Method Name: foundBge
* Description:  It has been determined that the opcode is BGE.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundBge
    MOVE.W #OP_NAME_Bge, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'G', (A2)+
    MOVE.B #'E', (A2)+

    RTS
*
* Method Name: foundBvc
* Description:  It has been determined that the opcode is BVC.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundBvc
    MOVE.W #OP_NAME_Bvc, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'C', (A2)+

    RTS
*
* Method Name: foundBcs
* Description:  It has been determined that the opcode is BCS.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundBcs
    MOVE.W #OP_NAME_Bcs, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'C', (A2)+
    MOVE.B #'S', (A2)+

    RTS
*
* Method Name: foundBra
* Description:  It has been determined that the opcode is BRA.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundBra
    MOVE.W #OP_NAME_Bra, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'R', (A2)+
    MOVE.B #'A', (A2)+

    RTS

*
* Method Name: foundLea
* Description:  It has been determined that the opcode is LEA.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundLea
    MOVE.W #OP_NAME_Lea, OP_NAME
    MOVE.B #'L', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'A', (A2)+

    RTS

* Method Name: foundJsr
* Description:  It has been determined that the opcode is JSR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundJsr
    MOVE.W #OP_NAME_Jsr, OP_NAME
    MOVE.B #'J', (A2)+
    MOVE.B #'S', (A2)+
    MOVE.B #'R', (A2)+

    RTS

*
* Method Name: foundNeg
* Description:  It has been determined that the opcode is a NEG.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundNeg
    MOVE.W #OP_NAME_Neg, OP_NAME
    MOVE.B #'N', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'G', (A2)+

    JSR SIZE_APPENDER


    RTS
*

* Method Name: foundMovem
* Description:  It has been determined that the opcode is a Movem.
* Save the opcode name to the OP_NAME var,
* Append that information to the stack, find the correct size, and call the APPEND method.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundMovem
    MOVE.W #OP_NAME_Movem, OP_NAME
    MOVE.B #'M', (A2)+
    MOVE.B #'O', (A2)+
    MOVE.B #'V', (A2)+
    MOVE.B #'E', (A2)+
    MOVE.B #'M', (A2)+

    
    MOVE.W (A3), D2
    AND.W #$00000040, D2    *bitmask check: indicates L
    CMP.W #$00000040, D2
    BEQ APPEND_L
    BRA APPEND_W






    RTS


* Method Name: foundCmpi
* Description:  It has been determined that the opcode is a Cmpi.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundCmpi
    MOVE.W #OP_NAME_Cmpi, OP_NAME
    MOVE.B #'C', (A2)+
    MOVE.B #'M', (A2)+
    MOVE.B #'P', (A2)+
    MOVE.B #'I', (A2)+

    JSR SIZE_APPENDER



    RTS
*
* Method Name: founBclr
* Description:  It has been determined that the opcode is BCLR.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 

foundBclr
    MOVE.W #OP_NAME_Bclr, OP_NAME
    MOVE.B #'B', (A2)+
    MOVE.B #'C', (A2)+
    MOVE.B #'L', (A2)+
    MOVE.B #'R', (A2)+
    RTS


* Method Name: foundOri
* Description:  It has been determined that the opcode is a ORI.
* Save the opcode name to the OP_NAME var, Append that information to the stack and call SIZE_APPENDER.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundOri
    MOVE.W #OP_NAME_Ori, OP_NAME
    MOVE.B #'O', (A2)+
    MOVE.B #'R', (A2)+
    MOVE.B #'I', (A2)+
    JSR SIZE_APPENDER



    RTS


* Method Name: foundData
* Description:  It has been determined that the opcode is DATA.
* Save the opcode name to the OP_NAME var, Append that information to the stack and return.
*  
* Preconditions: known opcode
* Postconditions: opcode information added to A2 stack
* 
foundData
    MOVE.W #OP_NAME_Data, OP_NAME
    MOVE.B #'D', (A2)+
    MOVE.B #'A', (A2)+
    MOVE.B #'T', (A2)+
    MOVE.B #'A', (A2)+
    RTS

    


****************EA BRANCH********************

***********ASSUME address store in CUR_ADDR***************
***********After all, my EA parse output will store in DEST_OUTPUT, SRC_OUTPU T*************
*
* Method Name: EA_MAIN_BRANCH
* Description:  The main method for EA routine. 
*  
* Preconditions: Call by Disassembler_Main_Branch
* Postconditions: End after EA finished parsing
*

EA_MAIN_BRANCH
    MOVE.W (A3),CUR_ADDR
    JSR EA_VAR_INIT
    JSR OP_SELECTOR
    RTS


*
* Method Name: EA_VAR_INIT
* Description:  Initialize the EA variable
*  
* Preconditions: Call by EA_MAIN_BRANCH
* Postconditions: None
*

EA_VAR_INIT
    MOVE.W #%000, ZERO_
    MOVE.W #%001, ONE_
    MOVE.W #%010, TWO_
    MOVE.W #%011, THREE_
    MOVE.W #%100, FORE_
    MOVE.W #%101, FIVE_
    MOVE.W #%110, SIX_
    MOVE.W #%111, SEVEN_

    MOVE.W #%000, DATA_REG
    MOVE.W #%001, ADDR_REG
    MOVE.W #%010, ADDR_IND
    MOVE.W #%011, ADDR_INC
    MOVE.W #%100, ADDR_DEC
    MOVE.W #%111000, SRC_ABS_WORD
    MOVE.W #%111001, SRC_ABS_LONG
    MOVE.W #%111100, SRC_IMM_VAL
    MOVE.W #%111, DEST_ABS_WORD
    MOVE.W #%1111, DEST_ABS_LONG
    MOVE.W #%100111, DEST_IMM_VAL
    RTS


************************************************************
********************OP SELECTOR********************
************************************************************
*
* Method Name: OP_SELECTOR
* Description:  Check the op_name which op routine passed, and go to each different subroutine
*  
* Preconditions: None
* Postconditions: None
*

OP_SELECTOR
    CMP.W #OP_NAME_Nop   , OP_NAME
    BEQ NOP_EA_PARSE
    CMP.W #OP_NAME_Blt   , OP_NAME
    BEQ BLT_EA_PARSE
    CMP.W #OP_NAME_Bge   , OP_NAME
    BEQ BGE_EA_PARSE
    CMP.W #OP_NAME_Bvc   , OP_NAME
    BEQ BVC_EA_PARSE
    CMP.W #OP_NAME_Bcs   , OP_NAME
    BEQ BCS_EA_PARSE
    CMP.W #OP_NAME_Bra   , OP_NAME
    BEQ BRA_EA_PARSE
    CMP.W #OP_NAME_Rol   , OP_NAME
    BEQ ROL_EA_PARSE
    CMP.W #OP_NAME_Ror   , OP_NAME
    BEQ ROR_EA_PARSE
    CMP.W #OP_NAME_Lsl   , OP_NAME
    BEQ LSL_EA_PARSE
    CMP.W #OP_NAME_Lsr   , OP_NAME
    BEQ LSR_EA_PARSE
    CMP.W #OP_NAME_Asl   , OP_NAME
    BEQ ASL_EA_PARSE
    CMP.W #OP_NAME_Asr   , OP_NAME
    BEQ ASR_EA_PARSE
    CMP.W #OP_NAME_Rol_Mem     , OP_NAME
    BEQ ROL_MEM_EA_PARSE
    CMP.W #OP_NAME_Ror_Mem   , OP_NAME
    BEQ ROR_MEM_EA_PARSE
    CMP.W #OP_NAME_Lsl_Mem   , OP_NAME
    BEQ LSL_MEM_EA_PARSE
    CMP.W #OP_NAME_Lsr_Mem   , OP_NAME
    BEQ LSR_MEM_EA_PARSE
    CMP.W #OP_NAME_Asl_Mem   , OP_NAME
    BEQ ASL_MEM_EA_PARSE
    CMP.W #OP_NAME_Asr_Mem   , OP_NAME
    BEQ ASR_MEM_EA_PARSE
    CMP.W #OP_NAME_Adda  , OP_NAME
    BEQ ADDA_EA_PARSE
    CMP.W #OP_NAME_Add   , OP_NAME
    BEQ ADD_EA_PARSE
    CMP.W #OP_NAME_Sub   , OP_NAME
    BEQ SUB_EA_PARSE
    CMP.W #OP_NAME_Divs  , OP_NAME
    BEQ DIVS_EA_PARSE
    CMP.W #OP_NAME_Or    , OP_NAME
    BEQ OR_EA_PARSE
    CMP.W #OP_NAME_Rts   , OP_NAME
    BEQ RTS_EA_PARSE
    CMP.W #OP_NAME_Lea   , OP_NAME
    BEQ LEA_EA_PARSE
    CMP.W #OP_NAME_Jsr   , OP_NAME
    BEQ JSR_EA_PARSE
    CMP.W #OP_NAME_Neg   , OP_NAME
    BEQ NEG_EA_PARSE
    CMP.W #OP_NAME_Movem , OP_NAME
    BEQ MOVEM_EA_PARSE
    CMP.W #OP_NAME_Cmpi  , OP_NAME
    BEQ CMPI_EA_PARSE
    CMP.W #OP_NAME_Bclr  , OP_NAME
    BEQ BCLR_EA_PARSE
    CMP.W #OP_NAME_Ori   , OP_NAME
    BEQ ORI_EA_PARSE
    CMP.W #OP_NAME_MOVE  , OP_NAME
    BEQ MOVE_EA_PARSE
    CMP.W #OP_NAME_MOVEA  , OP_NAME
    BEQ MOVEA_EA_PARSE
    CMP.W #OP_NAME_SUBQ  , OP_NAME
    BEQ SUBQ_EA_PARSE
    CMP.W #OP_NAME_MULS  , OP_NAME
    BEQ MULS_EA_PARSE
    CMP.W #OP_NAME_EOR, OP_NAME
    BEQ EOR_EA_PARSE
    CMP.W #OP_NAME_CMP, OP_NAME
    BEQ   CMP_EA_PARSE
    CMP.W #OP_NAME_Data  , OP_NAME
    BEQ DATA_EA_PARSE

    RTS

*
* Method Name: NOP/RTS_EA_PARSE
* Description:  Parse routine for NOP/RTS
*  
* Preconditions: None
* Postconditions: None
*

NOP_EA_PARSE
RTS_EA_PARSE
    MOVE.B #' ',(A2)+
    RTS



*
* Method Name: ROL/ROR/LSL/LSR/ASL/ASR_MEM_EA_PARSE
* Description:  Parse routine for shifter family when shifting to memory
*  
* Preconditions: None
* Postconditions: None
*

ROL_MEM_EA_PARSE
ROR_MEM_EA_PARSE
LSL_MEM_EA_PARSE
LSR_MEM_EA_PARSE
ASL_MEM_EA_PARSE
ASR_MEM_EA_PARSE
    JSR SRC_PARSER
    RTS

*
* Method Name: ROL/ROR/LSL/LSR/ASL/ASR_EA_PARSE
* Description:  Parse routine for shifter family 
*  
* Preconditions: None
* Postconditions: None
*

ROL_EA_PARSE
ROR_EA_PARSE
LSL_EA_PARSE
LSR_EA_PARSE
ASL_EA_PARSE
ASR_EA_PARSE
    MOVE.W CUR_ADDR, D2
    AND.W #$0020,D2
    CMP.W #$0020,D2
    BEQ ROTATION_REG_PARSING
    MOVE.B #1,SIZE
    JSR  DEST_REG_RECV
    JSR DATA_VALUE_OUTPUT_APPEND
    JSR COMMA_ADDER
    JSR DATA_SRC_PARSER
    RTS
*
* Method Name: ROTATION_REG_PARSING
* Description:  Parse when shifter use data register 
*  
* Preconditions: None
* Postconditions: None
*

ROTATION_REG_PARSING
    JSR DATA_DEST_PARSER
    JSR COMMA_ADDER
    JSR DATA_SRC_PARSER
    RTS


*
* Method Name: OR/SUB_ADD_EA_PARSE
* Description:  Parse routine for OR/SUB/ADD
*  
* Preconditions: None
* Postconditions: None
*

OR_EA_PARSE    
SUB_EA_PARSE    
ADD_EA_PARSE
    JSR DIRECTION_PARSER
    CMP #1,D2
    BEQ REVERSED_ADD
    JSR SRC_PARSER
    JSR COMMA_ADDER
    JSR DATA_DEST_PARSER
    RTS
*
* Method Name: REVERSED_ADD
* Description:  reversed the output of dest and src
*  
* Preconditions:direction bit is 1
* Postconditions: None
*
REVERSED_ADD
    JSR DATA_DEST_PARSER
    JSR COMMA_ADDER
    JSR SRC_PARSER
    RTS

*
* Method Name: ADDA_EA_PARSE
* Description:  Parse routine for ADDA
*  
* Preconditions: None
* Postconditions: None
*
ADDA_EA_PARSE
    JSR DIRECTION_PARSER
    CMP #0,D2
    BEQ REVERSED_ADDA
    JSR SRC_PARSER
    JSR COMMA_ADDER
    JSR ADDR_DEST_PARSER
    RTS
*
* Method Name: REVERSED_ADDA
* Description:  reversed the output of dest and src
*  
* Preconditions:direction bit is 1
* Postconditions: None
*
REVERSED_ADDA
    JSR ADDR_DEST_PARSER
    JSR COMMA_ADDER
    JSR SRC_PARSER
    RTS


        
*
* Method Name:  NEG/JSR_EA_PARSE
* Description:  Parse routine for NEG and JSR
*  
* Preconditions: None
* Postconditions: None
*
NEG_EA_PARSE
JSR_EA_PARSE
     JSR SRC_PARSER
     RTS
     
             
*
* Method Name: MOVE_EA_PARSE
* Description:  Parse routine for MOVE
*  
* Preconditions: None
* Postconditions: None
*
MOVE_EA_PARSE 
    JSR SRC_PARSER
    JSR COMMA_ADDER
    JSR DEST_PARSER
    RTS
        
*
* Method Name: MOVEA/lea_ea_PARSE
* Description:  Parse routine for MOVEA and LEA
*  
* Preconditions: None
* Postconditions: None
*
MOVEA_EA_PARSE 
LEA_EA_PARSE
    JSR SRC_PARSER
    JSR COMMA_ADDER
    JSR ADDR_REG_PARSE
    JSR DEST_REG_RECV
    JSR REG_PARSING
    RTS

        
*
* Method Name: EOR/BCLR_EA_PARSE
* Description:  Parse routine for EOR and BCLR
*  
* Preconditions: None
* Postconditions: None
*
EOR_EA_PARSE    
BCLR_EA_PARSE
    JSR DATA_DEST_PARSER    
    JSR COMMA_ADDER
    JSR SRC_PARSER    
    RTS
        
*
* Method Name: DIVS/MULS/CMP_EA_PARSE
* Description:  Parse routine for DIVS/MULS/CMP
*  
* Preconditions: None
* Postconditions: None
*
DIVS_EA_PARSE     
MULS_EA_PARSE 
CMP_EA_PARSE
    JSR SRC_PARSER
    JSR COMMA_ADDER
    JSR DATA_DEST_PARSER
    RTS
        
*
* Method Name: CMPI/ORI_EA_PARSE
* Description:  Parse routine for CMPI/ORI
*  
* Preconditions: None
* Postconditions: None
*
CMPI_EA_PARSE
ORI_EA_PARSE
    JSR IMME_VAL_RETRIEVER
    JSR COMMA_ADDER
    JSR SRC_PARSER
    RTS
    
    
        
*
* Method Name: SUBQ_EA_PARSE
* Description:  Parse routine for SUB
*  
* Preconditions: None
* Postconditions: None
*
SUBQ_EA_PARSE 
    JSR DEST_REG_RECV 
    JSR DATA_VALUE_OUTPUT_APPEND
    JSR COMMA_ADDER
    JSR SRC_PARSER
    RTS

        
*
* Method Name: DATA_VALUE_OUTPUT_APPEND
* Description:  Append the 1-8 number to addr reg
*  
* Preconditions: None
* Postconditions: None
*
DATA_VALUE_OUTPUT_APPEND
    MOVE.B #'#',(A2)+
    cmp.b #0, D2
    BEQ append_8
    cmp.b #1, D2
    BEQ append_1
    cmp.b #2, D2
    BEQ append_2
    cmp.b #3, D2
    BEQ append_3
    cmp.b #4, D2
    BEQ append_4
    cmp.b #5, D2
    BEQ append_5
    cmp.b #6, D2
    BEQ append_6
    cmp.b #7, D2
    BEQ append_7

append_8
    MOVE.B #'8', (A2)+
    RTS
append_1
    MOVE.B #'1', (A2)+
    RTS
append_2
    MOVE.B #'2', (A2)+
    RTS
append_3
    MOVE.B #'3', (A2)+
    RTS
append_4
    MOVE.B #'4', (A2)+
    RTS
append_5
    MOVE.B #'5', (A2)+           
    RTS
append_6
    MOVE.B #'6', (A2)+   
    RTS
append_7
    MOVE.B #'7', (A2)+   
    RTS

********************************MOVEM********************************
            
*
* Method Name: MOVEM_EA_PARS
* Description:  Parse routine for MOVEM
*  
* Preconditions: None
* Postconditions: None
*
MOVEM_EA_PARSE
    MOVE.W #0000, REVERSED
    MOVE.W (CUR_ADDR), D2
    LSL.W #5, D2
    LSR.W #8, D2
    LSR.W #2, D2
    LSR.W #5, D2
    MOVE.W D2, REVERSED
    ADD.L #2, A3
    MOVE.W (A3), D2
    MOVE.W #0000, MOVEM_BIT_COUNTER                    *store counter value
    CMP.W #1, REVERSED                                       *****MOVE TO REVERSED SUBROUTIN IF DIRECTION REVERSED
    BEQ REVERSED_MOVEM
    BRA MOVEM_CHECK_LOOP                               * Go to checking loop 
 
        
*
* Method Name: MOVEM_CHECK_LOOP
* Description:  Loop routine to check each bit of reg mask list
*  
* Preconditions: None
* Postconditions: When movem_bit_counter reach to specific value
*
MOVEM_CHECK_LOOP
   CMPI.W #1, REVERSED
    BEQ REVERSED_COUNTER
    ADDQ.B #2, (MOVEM_BIT_COUNTER)
REVERSED_COUNTER    
    SUBQ.B #1, (MOVEM_BIT_COUNTER)

    ROL.W   #1,D2       * roll the bits
    MOVE.W  D2,D6       * 
    ANDI.W  #$0001,D6   * isolate to get lsb

    CMP.B #0,(MOVEM_BIT_COUNTER)
    BEQ MOVEM_CHECK_REVERSED_SRC_PARSE
    
    CMP.B #17,(MOVEM_BIT_COUNTER)
    BEQ MOVEM_CHECK_REVERSED_SRC_PARSE
    
    CMP.B #1,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D0
    
    CMP.B #1,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D0
    
    CMP.B #2,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D1
    
    CMP.B #3,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D2
    
    CMP.B #4,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D3
    
    CMP.B #5,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D4
    
    CMP.B #6,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D5
    
    CMP.B #7,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D6
    
    CMP.B #8,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_D7
    
    CMP.B #9,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A0
    
    CMP.B #10,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A1
    
    CMP.B #11,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A2

    CMP.B #12,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A3

    CMP.B #13,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A4

    CMP.B #14,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A5

    CMP.B #15,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A6

    CMP.B #16,(MOVEM_BIT_COUNTER)
    BEQ CHECK_CONTAIN_A7
        
*
* Method Name: MOVEM_CHECK_END
* Description:  Return to main branch
*  
* Preconditions: When movem loop ends
* Postconditions: None
*
MOVEM_CHECK_END
    CLR.L D6
    CLR.L D2
    RTS   

        
*
* Method Name: MOVEM_CHECK_REVERSED_SRC_PARSE
* Description:  Parse src and check reversed
*  
* Preconditions: None
* Postconditions: None
*
MOVEM_CHECK_REVERSED_SRC_PARSE
    MOVE.B -(A2), USELESS_VAR
    CMP.W #0, REVERSED
    BEQ MOVEM_PARSE_SRC
    MOVE.B #' ', (A2)+
    BRA MOVEM_CHECK_END
        
*
* Method Name: MOVEM_PARSE_SRC
* Description:  Parse source reg
*  
* Preconditions: None
* Postconditions: None
*
MOVEM_PARSE_SRC
    JSR COMMA_ADDER
    JSR SRC_PARSER
    BRA MOVEM_CHECK_END

        
*
* Method Name: REVERSED_MOVEM
* Description:  A subroutine for MOVEM parsing when direction is reversed
*  
* Preconditions: REVERSED =1
* Postconditions: None
*
REVERSED_MOVEM
    JSR SRC_PARSER
    JSR COMMA_ADDER
    MOVE.W (A3),D2
    MOVE.B #17, (MOVEM_BIT_COUNTER)
    BRA MOVEM_CHECK_LOOP  

****************MOVEM CHECKING APPEND OUTPUT***************    
        
*
* Method Name: CHECK_CONTAIN_XX  Family
* Description:  Check each reg mask list bit, if bit =1, append the output to reg
*  
* Preconditions: None
* Postconditions: None
*
CHECK_CONTAIN_D0    
    CMP.B #01, D6
    BEQ CONTAIN_D0
    BRA MOVEM_CHECK_LOOP

CONTAIN_D0
    MOVE.B #'D', (A2)+
    MOVE.B #'0', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D1    
    CMP.B #01, D6
    BEQ CONTAIN_D1
    BRA MOVEM_CHECK_LOOP

CONTAIN_D1
    MOVE.B #'D', (A2)+
    MOVE.B #'1', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D2    
    CMP.B #01, D6
    BEQ CONTAIN_D2
    BRA MOVEM_CHECK_LOOP

CONTAIN_D2
    MOVE.B #'D', (A2)+
    MOVE.B #'2', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D3    
    CMP.B #01, D6
    BEQ CONTAIN_D3
    BRA MOVEM_CHECK_LOOP

CONTAIN_D3
    MOVE.B #'D', (A2)+
    MOVE.B #'3', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D4    
    CMP.B #01, D6
    BEQ CONTAIN_D4
    BRA MOVEM_CHECK_LOOP
CONTAIN_D4
    MOVE.B #'D', (A2)+
    MOVE.B #'4', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D5    
    CMP.B #01, D6
    BEQ CONTAIN_D5
    BRA MOVEM_CHECK_LOOP
CONTAIN_D5
    MOVE.B #'D', (A2)+
    MOVE.B #'5', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D6    
    CMP.B #01, D6
    BEQ CONTAIN_D6
    BRA MOVEM_CHECK_LOOP
CONTAIN_D6
    MOVE.B #'D', (A2)+
    MOVE.B #'6', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_D7
    CMP.B #01, D6
    BEQ CONTAIN_D7
    BRA MOVEM_CHECK_LOOP

CONTAIN_D7
    MOVE.B #'D', (A2)+
    MOVE.B #'7', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP


    
CHECK_CONTAIN_A0    
    CMP.B #01, D6
    BEQ CONTAIN_A0
    BRA MOVEM_CHECK_LOOP

CONTAIN_A0
    MOVE.B #'A', (A2)+
    MOVE.B #'0', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A1    
    CMP.B #01, D6
    BEQ CONTAIN_A1
    BRA MOVEM_CHECK_LOOP

CONTAIN_A1
    MOVE.B #'A', (A2)+
    MOVE.B #'1', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A2    
    CMP.B #01, D6
    BEQ CONTAIN_A2
    BRA MOVEM_CHECK_LOOP

CONTAIN_A2
    MOVE.B #'A', (A2)+
    MOVE.B #'2', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A3    
    CMP.B #01, D6
    BEQ CONTAIN_A3
    BRA MOVEM_CHECK_LOOP

CONTAIN_A3
    MOVE.B #'A', (A2)+
    MOVE.B #'3', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A4    
    CMP.B #01, D6
    BEQ CONTAIN_A4
    BRA MOVEM_CHECK_LOOP
CONTAIN_A4
    MOVE.B #'A', (A2)+
    MOVE.B #'4', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A5    
    CMP.B #01, D6
    BEQ CONTAIN_A5
    BRA MOVEM_CHECK_LOOP
CONTAIN_A5
    MOVE.B #'A', (A2)+
    MOVE.B #'5', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A6    
    CMP.B #01, D6
    BEQ CONTAIN_A6
    BRA MOVEM_CHECK_LOOP
CONTAIN_A6
    MOVE.B #'A', (A2)+
    MOVE.B #'6', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

CHECK_CONTAIN_A7
    CMP.B #01, D6
    BEQ CONTAIN_A7
    BRA MOVEM_CHECK_LOOP

CONTAIN_A7
    MOVE.B #'A', (A2)+
    MOVE.B #'7', (A2)+
    MOVE.B #'/',(A2)+
    BRA MOVEM_CHECK_LOOP

    
*************************BCC Family Parsing***************************************

        
*
* Method Name: BLT/BGE/BVC/BCS/BRA_EA_PARRSE
* Description:  PARSE routine for bcc family and bra
*  Check displacement value to determine how many displacement it has (8/16/32)
* Preconditions: None
* Postconditions: None
*
BLT_EA_PARSE
BGE_EA_PARSE
BVC_EA_PARSE
BCS_EA_PARSE
BRA_EA_PARSE
    MOVE.B #' ', (A2)+
    MOVE.B #'$', (A2)+
    MOVE.W CUR_ADDR, D2
    LSL.W #8 ,D2
    LSR.W #8 ,D2  
    CMP.W #$00, D2
    BEQ SIXTEEN_BIT_DISPLACEMENT
    CMP.W #$FF, D2
    BEQ THIRTY_TWO_BIT_DISPLACEMENT

    MOVE.W CUR_ADDR, D3
    LSL.W #8 ,D3
    LSR.W #8 ,D3  
    MOVE.B D3,D2
    BMI NEG_EIGHT_B_DISPLACEMENT 
    ADD.W A3, D2
    MOVE.L D2,D3
    ADDQ #2,D3
    JSR WORD_VALUE_ASSIGN
    RTS
        
*
* Method Name: NEG_EIGHT_B_DISPLACEMENT
* Description:  Parse for 8 bit displaement when the value is negtive
*  
* Preconditions: displacement is negtive
* Postconditions: None
*
NEG_EIGHT_B_DISPLACEMENT
    MOVE.W A3, D4
    MOVE.B D4,D3
    ADD.B D3, D2
    CLR.W D3
    MOVE.W A3 , D3
    ANDI.W #$FF00, D3
    ADD.W D2 ,D3
    ADDQ #2,D3
    JSR WORD_VALUE_ASSIGN
    RTS
        
*
* Method Name: SIXTEEN_BIT_DISPLACEMENT
* Description: Parse for 16 bit displaement
*  
* Preconditions: displacement is 16
* Postconditions: if displacement neg, go to neg subroutine
*
SIXTEEN_BIT_DISPLACEMENT
    MOVE.W A3, D2
    ADD.L #2, A3
    MOVE.W (A3),D3
    BMI NEG_SIXTEEN_B_DISPLACEMENT 
    MOVE.L D2, D6
    MOVE.L D6, D2
    MOVE.L D3, D6
    MOVE.L D6, D3
    ADD.L D3,D2
    CLR.L D3
    MOVE.L D2,D3
    ADDQ #2,D3
    MOVE.L D3 , D4
    ANDI.L #$FFFF0000,D4
    CMPI.L #$00000000, D4
    BNE PRINT_LONG_SIXTEEN_DISP
    JSR WORD_VALUE_ASSIGN
    RTS
    *
* Method Name: PRINT_LONG_SIXTEEN_DISP
* Description:  If dest address out of word size, print long size output
*  
* Preconditions: address out of size
* Postconditions: None
*
PRINT_LONG_SIXTEEN_DISP
    JSR LONG_VALUE_ASSIGN
    RTS  
    *
* Method Name: NEG_SIXTEEN_B_DISPLACEMENT 
* Description:  16 displacement parse subroutine when it is negative
*  
* Preconditions: when displacement negative
* Postconditions: None
*
NEG_SIXTEEN_B_DISPLACEMENT 
    NEG D3
    SUB.W D3, D2
    MOVE.W D2, D3
    ADDQ #2,D3
    JSR WORD_VALUE_ASSIGN
    RTS
*
* Method Name: THIRTY_TWO_BIT_DISPLACEMENT
* Description:  Parse function for 32 bits displacement
*  
* Preconditions: None
* Postconditions: None
*
THIRTY_TWO_BIT_DISPLACEMENT
    MOVE.L A3, D2
    ADD.L #2, A3
    ADD.L (A3),D2
    MOVE.L D2,D3
    ADDQ #2,D3   
    JSR LONG_VALUE_ASSIGN
    ADD.L #4,A3
    RTS
        
*
* Method Name: DATA_EA_PARSE
* Description:  Parse routine for DATA
*  
* Preconditions: None
* Postconditions: None
*
DATA_EA_PARSE
    MOVE.W (A3), D3
    JSR WORD_VALUE_ASSIGN
    RTS
*
* Method Name: DIRECTION_PARSER
* Description:  Check direction bits
*  
* Preconditions: None
* Postconditions: None
*
DIRECTION_PARSER
    MOVE.W (CUR_ADDR),D2
    LSL.W #7,D2
    LSR.W #8,D2
    LSR.W #7,D2
    RTS

********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************




***************************************************************************************
****************************Parsing Subroutine*****************************
***************************************************************************************

*
* Method Name: SRC_PARSER
* Description:  General parser for source 
*  
* Preconditions: None
* Postconditions: None
*

SRC_PARSER
    JSR IMME_ABS_SRC_MOD_CHECKING
    CMP.W #2001, (IMM_ABS_CONTAIN)                    ***********Check if contain abs/imm value
    BEQ END_PARSER
    JSR SRC_MOD_RECV
    JSR MOD_PARSING
    JSR SRC_REG_RECV
    JSR REG_PARSING
    RTS

*
* Method Name: COMMA_ADDER
* Description:  Append comma to output reg
*  
* Preconditions: None
* Postconditions: None
*
COMMA_ADDER
    MOVE.B #',', (A2)+
    RTS

*
* Method Name: DEST_PARSER
* Description:  General parser for dest
*  
* Preconditions: None
* Postconditions: None
*
DEST_PARSER
    JSR IMME_ABS_DEST_MOD_CHECKING
    CMP.W #2001, (IMM_ABS_CONTAIN)                   ***********Check if contain abs/imm value
    BEQ END_PARSER
    JSR DEST_MOD_RECV
    JSR MOD_PARSING
    JSR DEST_REG_RECV
    JSR REG_PARSING
    RTS
*
* Method Name: DATA_DEST_PARSER
* Description:  Dest parse routine when dest reg is DATA type
*  
* Preconditions: None
* Postconditions: None
*
DATA_DEST_PARSER
    MOVE.W #1001, D4
    JSR DEST_REG_RECV
    JSR REG_PARSING
    RTS

*
* Method Name: DATA_SRC_PARSER
* Description:  Source parse routine when dest reg is DATA type
*  
* Preconditions: None
* Postconditions: None
*
DATA_SRC_PARSER
    MOVE.W #1001, D4
    JSR SRC_REG_RECV
    JSR REG_PARSING
    RTS
    *
* Method Name: ADDR_DEST_PARSER
* Description:  Dest parse routine when dest reg is addr type
*  
* Preconditions: None
* Postconditions: None
*
ADDR_DEST_PARSER
    MOVE.W #1002, D4
    JSR DEST_REG_RECV
    JSR REG_PARSING
    RTS
*
* Method Name: END_PARSER
* Description:  Return to master branch
*  
* Preconditions: None
* Postconditions: None
*
END_PARSER
    RTS

*
* Method Name: DEST_REG_RECV
* Description: Receive dest reg value
*  
* Preconditions: None
* Postconditions: None
*
DEST_REG_RECV     

    MOVE.W (CUR_ADDR), D2
    LSL.W #4,D2
    LSR.W #8,D2        
    LSR.W #1,D2   
    LSR.W #4,D2
    RTS
*
* Method Name: DEST_MOD_RECV
* Description: Receive dest mod value
*  
* Preconditions: None
* Postconditions: None
*

    
DEST_MOD_RECV

    MOVE.W (CUR_ADDR), D2
    LSL.W #7, D2   
    LSR.W #6,D2
    LSR.W #7,D2  
    RTS
    
*
* Method Name: SRC_MOD_RECV
* Description: Receive source mod value
*  
* Preconditions: None
* Postconditions: None
*
SRC_MOD_RECV

    MOVE.W (CUR_ADDR), D2
    LSL.W #8,D2
    LSL.W #2,D2
    LSR.W #3,D2
    LSR.W #8,D2
    LSR.W #2,D2
    RTS
    
*
* Method Name: SRC_REG_RECV
* Description: Receive source reg value
*  
* Preconditions: None
* Postconditions: None
*
SRC_REG_RECV
    MOVE.W (CUR_ADDR), D2
    LSL.W #8, D2
    LSL.W #5,D2
    LSR.W #8,D2
    LSR.W #5,D2
    RTS


*******************Immediate& Absolute value parsing subroutine***************************

******************Byte size append*****************

*
* Method Name: BYTE_APPENDER
* Description: append the extra hex bits to output reg when size is byte
*  
* Preconditions: None
* Postconditions: None
*
BYTE_APPENDER 
            MOVE.B  #'$',(A2)+  
            CLR.L   D3          
            ADD.L #2, A3
            Move.W (A3), D3

*
* Method Name: BYTE_VALUE_ASSIGN
* Description: Assign byte value
*  
* Preconditions: None
* Postconditions: None
*
BYTE_VALUE_ASSIGN
            move.B d3,d2
            CLR.L   D4          
            MOVE.B  #2,D4       * LOOP COUNTER
*
* Method Name: BYTE_LOOPER   
* Description: loop for retrieve each bit and append to output reg
*  
* Preconditions: None
* Postconditions: None
*
BYTE_LOOPER                
            CMP.B   #$00,D4     
            BEQ     END_LOOPER      
            ROL.B   #4,D2       
            MOVE.B  D2,D6       
            ANDI.B  #$0F,D6          *retrieve the lsb
            JSR     APPEND_ASCII      * Append the character to array   
            SUBQ.B  #$1,D4      
            JMP     BYTE_LOOPER                






******************Word size append*****************
*
* Method Name: WORD_APPENDER
* Description: append the extra hex bits to output reg when size is WORD
*  
* Preconditions: None
* Postconditions: None
*
WORD_APPENDER 
            MOVE.B  #'$',(A2)+  
            CLR.L   D3          
           ADD.L #2, A3
            Move.W  (A3), D3

*
* Method Name: WORD_VALUE_ASSIGN
* Description: Assign word value
*  
* Preconditions: None
* Postconditions: None
WORD_VALUE_ASSIGN
            move.W d3,d2
            CLR.L   D4          
            MOVE.B  #4,D4       * LOOP COUNTER
*
* Method Name:WORD_LOOPER   
* Description: loop for retrieve each bit and append to output reg
*  
* Preconditions: None
* Postconditions: None
*
WORD_LOOPER                
            CMP.B   #$00,D4     
            BEQ     END_LOOPER      
            ROL.W   #4,D2     
            MOVE.W  D2,D6       
            ANDI.W  #$000F,D6          *retrieve the lsb
            JSR     APPEND_ASCII      * Append the character to array   
            SUBQ.B  #$1,D4      
            JMP     WORD_LOOPER      



******************Long size append*****************
*
* Method Name: LONG_APPENDER
* Description: append the extra hex bits to output reg when size is LONG
*  
* Preconditions: None
* Postconditions: None
*
LONG_APPENDER 
            MOVE.B  #'$',(A2)+  
            CLR.L   D3          
            ADD.L #2, A3
            Move.L  (A3), D3
            ADD.L #2, A3
*
* Method Name: LONG_VALUE_ASSIGN
* Description: Assign long value
*  
* Preconditions: None
* Postconditions: None
*
LONG_VALUE_ASSIGN
            MOVE.L d3,d2
            CLR.L   D4          
            MOVE.L  #8,D4       * LOOP COUNTER
*
* Method Name: LONG_LOOPER   
* Description: loop for retrieve each bit and append to output reg
*  
* Preconditions: None
* Postconditions: None
*
LONG_LOOPER                
            CMP.B   #$00,D4     
            BEQ     END_LOOPER      
            ROL.L   #4,D2       
            MOVE.L  D2,D6       
            ANDI.W  #$000F,D6          *retrieve the lsb
            JSR     APPEND_ASCII      * Append the character to array   
            SUBQ.B  #$1,D4      
            JMP     LONG_LOOPER                
          *
* Method Name: END_LOOPER   
* Description: Stop loop
*  
* Preconditions: None
* Postconditions: None
*
END_LOOPER
           MOVE.W  D3,D2                 
           RTS                 



****************ADDRESS APPENDER*******************

* Method Name:  ADDRESS_APPENDER
* Description: Append the address output to reg
*  
* Preconditions: None
* Postconditions: None
*
ADDRESS_APPENDER
            Move.L  A3, D3
            MOVE.L d3,d2
            CLR.L   D4          
            MOVE.L  #8,D4       * LOOP COUNTER
            JSR LONG_LOOPER
            RTS         



* Method Name:  PPEND_ASCII
* Description: Append the ascii to output REG
*  
* Preconditions: None
* Postconditions: None
*
APPEND_ASCII     
     CMP.B   #$A,D6              
     BGE     HAS_LETTER              
     ADDI.B  #$30,D6             
     BRA     APPEND_TO_ARRAY
     
* Method Name:  HAS_LETTER
* Description: add the 37 convert to ascii when it is letter 
*  
* Preconditions: Ascii is letter
* Postconditions: None
*
HAS_LETTER     
      ADDI.B  #$37,D6
    
* Method Name:  APPEND_TO_ARRAY
* Description:  Append the ascii to array
*  
* Preconditions: None
* Postconditions: None
*
APPEND_TO_ARRAY  
      MOVE.B  D6,(A2)+
      RTS    
    
    






*****************IMMEDIATE_AND_ABS_PARSING***********************    
* Method Name: IMME_VAL_RETRIEVER
* Description: Retrieve immediate value
*  
* Preconditions: None
* Postconditions: None
*
IMME_VAL_RETRIEVER
    JSR DEST_IMM_VAL_PARSE 
    RTS

* Method Name: IMME_ABS_DEST_MOD_CHECKING
* Description:  Check if dest contain immediate or absolute 
*  
* Preconditions: None
* Postconditions: None
*
IMME_ABS_DEST_MOD_CHECKING    
    MOVE.W CUR_ADDR, D2
    LSL.W #4,D2
    LSR.W #4,D2
    LSR.W #6,D2
    CMP.W DEST_ABS_WORD, D2
    BEQ DEST_ABS_WORD_PARSE
    CMP.W DEST_ABS_LONG, D2
    BEQ DEST_ABS_LONG_PARSE
    CMP.W DEST_IMM_VAL, D2
    BEQ DEST_IMM_VAL_PARSE
    MOVE.W #2000,IMM_ABS_CONTAIN           *No imm/abs value conclude
    RTS
* Method Name: IMME_ABS_SRC_MOD_CHECKING
* Description:  Check if source contain immediate or absolute 
*  
* Preconditions: None
* Postconditions: None
*
IMME_ABS_SRC_MOD_CHECKING
    MOVE.W CUR_ADDR, D2
    LSL.W #8,D2
    LSL.W #2,D2
    LSR.W #8,D2
    LSR.W #2,D2
    CMP.W SRC_ABS_WORD, D2
    BEQ SRC_ABS_WORD_PARSE
    CMP.W SRC_ABS_LONG, D2
    BEQ SRC_ABS_LONG_PARSE
    CMP.W SRC_IMM_VAL, D2
    BEQ SRC_IMM_VAL_PARSE
    MOVE.W #2000,IMM_ABS_CONTAIN        *No imm/abs value conclude
    RTS
    
* Method Name: src/dest_ABS_WORD_PARSE
* Description: Parse routine for absolute address when size is word
*  
* Preconditions: None
* Postconditions: None
*
    
SRC_ABS_WORD_PARSE
DEST_ABS_WORD_PARSE
    MOVE.W #2001,IMM_ABS_CONTAIN
    JSR WORD_APPENDER
    RTS
    
* Method Name: src/dest_ABS_WORD_PARSE
* Description: Parse routine for absolute address when size is long
*  
* Preconditions: None
* Postconditions: None
*
SRC_ABS_LONG_PARSE
DEST_ABS_LONG_PARSE      
    MOVE.W #2001,IMM_ABS_CONTAIN 
    JSR LONG_APPENDER
    RTS

* Method Name: SRC/DEST_IMM_VAL_PARSE
* Description: Parse routine for immediate value
*  
* Preconditions: None
* Postconditions: None
*
    
SRC_IMM_VAL_PARSE
DEST_IMM_VAL_PARSE 
    MOVE.W #2001,IMM_ABS_CONTAIN 
    MOVE.B #'#', (A2)+
    CMP.B #1,(SIZE)
    BEQ BYTE_SIZE_IMM_PARSER
    CMP.B #2,(SIZE)
    BEQ WORD_SIZE_IMM_PARSER
    CMP.B #4,(SIZE)
    BEQ LONG_SIZE_IMM_PARSER
    RTS

    
* Method Name: BYTE_SIZE_IMM_PARSER
* Description: Parse and append output for immediate value when size is byte
*  
* Preconditions: None
* Postconditions: None
*
BYTE_SIZE_IMM_PARSER
    JSR BYTE_APPENDER
    RTS
    
* Method Name: WORD_SIZE_IMM_PARSER
* Description: Parse and append output for immediate value when size is word
*  
* Preconditions: None
* Postconditions: None
*
WORD_SIZE_IMM_PARSER
    JSR WORD_APPENDER
    RTS
    
* Method Name: LONG_SIZE_IMM_PARSER
* Description: Parse and append output for immediate value when size is long
*  
* Preconditions: None
* Postconditions: None
*
LONG_SIZE_IMM_PARSER
    JSR LONG_APPENDER
    RTS


********* MOD PARSING**************
    
* Method Name: MOD_PARSING
* Description: Check the mod type
*  
* Preconditions: None
* Postconditions: None
*
MOD_PARSING
    CMP.W DATA_REG, D2
    BEQ DATA_REG_PARSE
    CMP.W ADDR_REG, D2
    BEQ ADDR_REG_PARSE
    CMP.W ADDR_IND, D2
    BEQ ADDR_IND_PARSE
    CMP.W ADDR_INC, D2
    BEQ ADDR_INC_PARSE
    CMP.W ADDR_DEC, D2
    BEQ ADDR_DEC_PARSE
    ****INVALID EA******
    JSR INVALID_EA
    RTS

*********REG PARSING**************   
* Method Name: REG_PARSING
* Description: Check reg value
*  
* Preconditions: None
* Postconditions: None
* 
REG_PARSING
    CMP.W ZERO_,D2
    BEQ REG0
    CMP.W ONE_,D2
    BEQ REG1
    CMP.W TWO_,D2
    BEQ REG2
    CMP.W THREE_,D2
    BEQ REG3
    CMP.W FORE_,D2
    BEQ REG4
    CMP.W FIVE_,D2
    BEQ REG5
    CMP.W SIX_,D2
    BEQ REG6
    CMP.W SEVEN_,D2
    BEQ REG7
    RTS


*************REG BRANCH*****************
* Method Name: XXXX_REG_PARSE
* Description: Assign different code to D4 to recognize different reg mod
*  
* Preconditions: None
* Postconditions: None
*
DATA_REG_PARSE
    MOVE.W #1001, D4
    RTS
ADDR_REG_PARSE
    MOVE.W #1002, D4
    RTS
ADDR_IND_PARSE
    MOVE.W #1003,D4
    RTS
ADDR_INC_PARSE
    MOVE.W #1004,D4
    RTS
ADDR_DEC_PARSE
    MOVE.W #1005,D4
    RTS

INVALID_EA
    ****PRINT INVALID*******
    RTS
    
    
    
******************REG BRANCH********************** 
******DETERMINE WITCH OUTPUT BRANCH TO GO*********
* Method Name: REGX
* Description: Check the reg mod to determine which output to append for each reg value
*  
* Preconditions: None
* Postconditions: None
*
REG0
    CMP.W #1001, D4
    BEQ ASSIGN_D0
    CMP.W #1002, D4
    BEQ ASSIGN_A0
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND0
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC0
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC0

REG1
    CMP.W #1001, D4
    BEQ ASSIGN_D1
    CMP.W #1002, D4
    BEQ ASSIGN_A1
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND1
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC1
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC1

REG2
    CMP.W #1001, D4
    BEQ ASSIGN_D2
    CMP.W #1002, D4
    BEQ ASSIGN_A2
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND2
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC2
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC2    

    
REG3
    CMP.W #1001, D4
    BEQ ASSIGN_D3
    CMP.W #1002, D4
    BEQ ASSIGN_A3
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND3
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC3
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC3    
    
REG4
    CMP.W #1001, D4
    BEQ ASSIGN_D4
    CMP.W #1002, D4
    BEQ ASSIGN_A4
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND4
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC4
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC4
       
REG5
    CMP.W #1001, D4
    BEQ ASSIGN_D5
    CMP.W #1002, D4
    BEQ ASSIGN_A5
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND5
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC5
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC5
    
    
REG6
    CMP.W #1001, D4
    BEQ ASSIGN_D6
    CMP.W #1002, D4
    BEQ ASSIGN_A6
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND6
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC6
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC6
    

    
REG7
    CMP.W #1001, D4
    BEQ ASSIGN_D7
    CMP.W #1002, D4
    BEQ ASSIGN_A7
    CMP.W #1003, D4
    BEQ ASSIGN_ADDR_IND7
    CMP.W #1004, D4
    BEQ ASSIGN_ADDR_INC7
    CMP.W #1005, D4
    BEQ ASSIGN_ADDR_DEC7
    
 
************************OUTPUT ASSIGN BRANCH***************************
* Method Name: Assign_XX
* Description: Append the output which depends on reg value and reg mod to the output reg
*  
* Preconditions: None
* Postconditions: None
*
ASSIGN_D0 
    MOVE.B #'D', (A2)+
    MOVE.B #'0', (A2)+
    RTS
ASSIGN_D1 
    MOVE.B #'D', (A2)+
    MOVE.B #'1', (A2)+
    RTS
ASSIGN_D2 
    MOVE.B #'D', (A2)+
    MOVE.B #'2', (A2)+
    RTS
ASSIGN_D3 
    MOVE.B #'D', (A2)+
    MOVE.B #'3', (A2)+
    RTS
ASSIGN_D4 
    MOVE.B #'D', (A2)+
    MOVE.B #'4', (A2)+
    RTS
ASSIGN_D5 
    MOVE.B #'D', (A2)+
    MOVE.B #'5', (A2)+
    RTS
ASSIGN_D6 
    MOVE.B #'D', (A2)+
    MOVE.B #'6', (A2)+
    RTS

ASSIGN_D7 
    MOVE.B #'D', (A2)+
    MOVE.B #'7', (A2)+
    RTS
*************ADDR DIRECT BRANCH***************
ASSIGN_A0 
    MOVE.B #'A', (A2)+
    MOVE.B #'0', (A2)+
    RTS

ASSIGN_A1 
    MOVE.B #'A', (A2)+
    MOVE.B #'1', (A2)+
    RTS

ASSIGN_A2 
    MOVE.B #'A', (A2)+
    MOVE.B #'2', (A2)+
    RTS
ASSIGN_A3 
    MOVE.B #'A', (A2)+
    MOVE.B #'3', (A2)+
    RTS
ASSIGN_A4 
    MOVE.B #'A', (A2)+
    MOVE.B #'4', (A2)+
    RTS
ASSIGN_A5 
    MOVE.B #'A', (A2)+
    MOVE.B #'5', (A2)+
    RTS
ASSIGN_A6 
    MOVE.B #'A', (A2)+
    MOVE.B #'6', (A2)+
    RTS
ASSIGN_A7 
    MOVE.B #'A', (A2)+
    MOVE.B #'7', (A2)+
    RTS





*************ADDR INDIRECT BRANCH***************

ASSIGN_ADDR_IND0
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'0', (A2)+
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND1
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'1', (A2)+  
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND2
    MOVE.B #'(', (A2)+
     MOVE.B #'A', (A2)+
    MOVE.B #'2', (A2)+  
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND3
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'3', (A2)+   
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND4
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'4', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND5
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'5', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND6
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'6', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_IND7
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'7', (A2)+     
    MOVE.B #')', (A2)+
    RTS

*************ADDR INCREMENT BRANCH***************


ASSIGN_ADDR_INC0
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'0', (A2)+    
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC1
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'1', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC2
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'2', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC3
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'3', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC4
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'4', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC5
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'5', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC6
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'6', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS
ASSIGN_ADDR_INC7
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'7', (A2)+     
    MOVE.B #')', (A2)+
    MOVE.B #'+', (A2)+
    RTS

*************ADDR DECREMENT BRANCH***************

ASSIGN_ADDR_DEC0
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'0', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC1
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'1', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC2
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'2', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC3
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'3', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC4
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'4', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC5
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'5', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC6
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+
    MOVE.B #'A', (A2)+
    MOVE.B #'6', (A2)+     
    MOVE.B #')', (A2)+
    RTS
ASSIGN_ADDR_DEC7
    MOVE.B #'-', (A2)+
    MOVE.B #'(', (A2)+ 
    MOVE.B #'A', (A2)+
    MOVE.B #'7', (A2)+     
    MOVE.B #')', (A2)+
    RTS







    SIMHALT



*********************************************************************************
* Method Name: yourDisassemblerFirstMethodHere
* Description: call this method from your code above; see the examples above on
*   how to call methods and use them profusely as you build your final project
*
* Preconditions:  TBA
* Postconditions: TBA
*********************************************************************************
method1:
        NOP
        RTS

registerList REG D0-D5/A2-A3
hexToBinary
                                               
    MOVEM.L registerList, -(SP)
    
    

*********************************************************************************

*startsWith4:
   * BRA checkNOP
   * LEA disp4, A1
 
  *  MOVE.B  #14, D0
 *   TRAP    #15
 *   BRA loop

*checkNOP:
 *   CMP.L   (A3),           #$4E71   *test pattern
 *   BNE     dispData
 *   BRA     loop                 *go back and try again
*checkRTS:


dispData:
    LEA DATA,    A1
    MOVE.B  #14,    D0
    TRAP    #15

* Method Name: yourDisassemblerSecondMethodHere
* Description:    TBA
*
* Preconditions:  TBA
* Postconditions: TBA
*********************************************************************************
method2:
        NOP
        RTS
*********************************************************************************
* Method Name: TrapTask13
* Description: Creates a file if none exists, and appends bytes to that file
*   while also echoing the written bytes to the screen.  You shouldn't need to
*   change this code.
*
* Calling Convention: Callee-Saved 
*
* Preconditions & Method Input:
*   A1 points to the null-terminated buffer to write (newline will be added for you)
*
* Postconditions & Output:
*   ALL files that were previously open will be CLOSED (FileIDs will be invalid)
*   See 'Output.txt' in directory for the results, also piped to the console
*
*
*  A2 holds a pointer to null terminated string to write (input)
*  A3 points to the null-terminated file name
*  D3 holds the number of bytes already in the file to write
*
*  D5 holds number of bytes to write
********************************************************************************
toSave REG D0-D5/A2-A3
TrapTask13:
    *******************************************************************
    * Method initialization, regsiter spilling, parameter saving, etc.
    *******************************************************************
    MOVEM.L toSave, -(SP)   ;  Callee-Saved, so save and restore     
      
    MOVEA.L A1, A2 ; save this buffer to write
    LEA outFilename, A3  ; save this for later, too
      
    move #50,d0   
    trap #15 ; close all files, suggested to begin any IO 
    *******************************************************************
    * End Method Init
    *******************************************************************

    ******************************************************************************************
    * Calculate the number of bytes to write by searching for the null in the target buffer A0
    ******************************************************************************************
    CLR.L D5 *D5 is now the number of bytes to write
nullLoop:
    MOVE.B (A1)+, D0
    CMPI.B #0,D0  * compare to null
    BEQ findNullLoopDone
    ADDI.W #1, D5
    BRA nullLoop
    
findNullLoopDone:
    MOVEA.L A3, A1 * reset A1 so it points to the file to write to (to open, next)
    
    ;check if file exists, and open with task 51 if so, otherwise 52
    ;(precondition here is A1 points to the null-terminated filename )
    MOVE.B #51, D0      ;open file (task 51 is existing, 52 is new)
    trap #15
      
    if.w D0 <NE> #0 then.s         ; if file error (404, not found)
        MOVE.B #52, D0             ; open new file (52 is new)
        trap #15
    endi
    
    ********************************************************************************************************* 
    * Seek to END of FILE by counting the number of bytes, closing, reopening, then seeking.
    *    (first, count number of bytes already in the file to obtain seek position)
    *********************************************************************************************************
    Clr.L D3   ;TODO: reg save, D3 is now our count of bytes read
    MOVE.L #1, D2 ; read one byte at a time
    LEA byteRead, A1
    
countLoop:
    MOVE.B #53, D0 ; try to read one byte (TODO: move out of loop)
    trap #15
    
    CMPI.W #1,D0  ;1 == EOF
    BEQ countDone
    ADDI #1, D3
    BRA countLoop
    
countDone:    
    * close this file
     move #56,d0  
     trap #15 
     
     * reopen the target file
     MOVE.L A3,A1
     MOVE #51, D0
     trap #15
     
    * seek to right position, then continue with writing
    MOVE.L D3, D2 ; move the number of bytes found in the file to D2
    MOVE #55, D0  ; position file task
    trap #15

    ******************************************************************************
    * Actually write the buffer to the file, after caculating the number of bytes 
    *  to write and after seeking to the right location in the file for append
    ******************************************************************************

    MOVE.L D5, D2 ; restore this for the actually writing the buffer 
    ; assumes A0 hasnt changed since handed to this method      
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk
    ; assumes file ID is still stored in D1.L  
    MOVE.B #54, D0 ; subtask 54 is write to open file (append, or?), assumes D2 holds # of bytes
    trap #15

    ; add a newline to the file output
    LEA NEWLINE, A1
    MOVE.B #54, D0 
    MOVE.B #2,D2  ; kills # of bytes to write from input param
    trap #15
    
    ; finally, close only this file
    MOVE.B #56, D0 ; close file task
    trap #15
  
    ; report to screen
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk & screen
    MOVE.B #13, D0
    trap #15
      
    ; restore context
    MOVEM.L (SP)+, toSave
    
    
    
    
*----------------------------------------------------------------------------------
* Method Name: AsciiToHex
* Written by : Berger, Modified by Nash
* Date       : 3/1/2019
* Description: Converts chars '0'-'9' and 'a'-'f' to 0-9,a-F
*              Transforms/unpacks 8 chars (8b each) pointed to by A1 into 
*              its (4b each) equivalent hex value 
*  
*  Preconditions & Input
*       A1 (input) points to a memory buffer holding 8 ascii chars (not null-terminated) 
*       This function calls another function (strip_ascii)
*
*  Postconditions & Output
*       D7 (output) holds the converted value 
*       Caller-Saved : D0 is temp, D6 is a loop var
*----------------------------------------------------------------------------------
AsciiToHexRegList REG D0,D6
AsciiToHex     
    MOVEM.L asciiToHexRegList, -(SP)  *save context
    CLR.L D7 * clear our return value
    MOVE.L #4, D6 ; and set up our loop counter

chrLoop
    MOVE.B (A1)+,D0 * Get the first byte
    jsr strip_ascii * Get rid of the ascii code    
    OR.W D0,D7 * Load the bits into D7
    
    subI.B #1,D6  *decrement our loop variable
    BEQ chrDone   *skip shifting if we are done
    
    ASL.L #4,D7 * shift left 4 bits to prepare for next byte
    BRA chrLoop

chrDone
    MOVEM.L (SP)+,asciiToHexRegList 
    RTS


**********************************************************************
* SUBROUTINE: strip_ascii
* remove the ascii code from the digits 0-9,a-f, or A-F
* Input Parameters: <D0> = ascii code
*
* Return parameters: D0.B = number 0...F, returned as 00...0F
* Registers used internally: D0
* Assumptions: D0 contains $30-$39, $41-$46 or $61-66
*
***********************************************************************
strip_ascii
      CMP.B #$39,D0 * Is it in range of 0-9?
      BLE sub30 * Its a number
      CMP.B #$46,D0 * Is is A...F?
      BLE sub37 * Its A...F
      SUB.B #$57,D0 * Its a...f
      BRA ret_sa * Go back
sub37 SUB.B #$37,D0 * Strip 37
      BRA ret_sa * Go back
sub30 SUB.B #$30,D0 * Strip 30
ret_sa RTS * Go back

    
* Required variables and constants go here for your Disassembler
CR                  EQU $0D
LF                  EQU $0A
NEWLINE             DC.B CR,LF,0  
DATA                DC.B 'DATA', CR, LF, 0 
dispNOP             DC.B 'NOP', CR, LF, 0
dispRTS             DC.B 'RTS', CR, LF, 0
MSG1                DC.B 'MOVE.L D4,D5',0
MSG2                DC.B 'ADD.B D0,D1',0
outFilename         DC.B 'Output.txt',0
byteRead            DS.B 1
ascii_val           DC.B $31,$41,$30,$30,$31,$41,$30,$30 * Test value $1A001A00


CHANGE_LINE          DC.W       CR,LF,0


INVALID_EA_OUTPUT DC.B 'INVLIAD EA',CR,0
END
   END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
