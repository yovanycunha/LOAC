//Aluno: Yovany Marroquin da Cunha - 115210445
//Roteiro 2

// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    // SEG <= SWI;
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  /*************Problema 1*************/
  logic [1:0] entrada_1;
  logic [1:0] entrada_2;

  parameter umidade_adequada = 'b00000000;
  parameter area0_baixa = 'b00111111;
  parameter area1_baixa = 'b00000110;
  parameter area10_baixa = 'b01011011;

  always_comb entrada_1 <= SWI[0];
  always_comb entrada_2 <= SWI[1];

  always_comb begin
    if ((entrada_1 == 0) & (entrada_2 == 0)) begin
      SEG <= umidade_adequada;
    end

    else if ((entrada_1 == 0) & (entrada_2 == 1)) begin
      SEG <= area1_baixa;
    end

    else if ((entrada_1 == 1) & (entrada_2 == 0)) begin
      SEG <= area0_baixa;
    end

    else SEG <= area10_baixa;
  end

  /*************Problema 1*************/
  logic [1:0] entrada_A;
  logic [1:0] entrada_B;
  logic [1:0] entrada_escolha;

  always_comb entrada_A <= SWI[7:6];
  always_comb entrada_B <= SWI[5:4];

  always_comb entrada_escolha <= SWI[3];

  always_comb begin
    if (entrada_escolha == 0) begin
      LED[7:6] <= entrada_A;
    end

    else LED[7:6] <= entrada_B;
  end


endmodule