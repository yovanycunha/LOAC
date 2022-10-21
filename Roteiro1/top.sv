//Aluno: Yovany Marroquin da Cunha - 115210445
//Roteiro 1: Agencia Bancária e Estufa

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

  //AGENCIA BANCARIA
  logic cofre;
  logic expediente;
  logic gerente_interrupt;

  always_comb begin
    cofre <= SWI[0];
    expediente <= SWI[1];
    gerente_interrupt <= SWI[2];

    LED[1] <= ~cofre & (~expediente | gerente_interrupt);
  end

  //ESTUFA
  logic temp_acima_de_15;
  logic temp_acima_de_20;

  always_comb begin
    temp_acima_de_20 <= SWI[6];
    temp_acima_de_15 <= SWI[7];

    if(~temp_acima_de_15 & ~temp_acima_de_20) begin
      LED[7] <= 1;
      LED[6] <= 0;
      LED[7] <= 0;
    end

    else if(temp_acima_de_15 & temp_acima_de_20) begin
      LED[6] <= 1;
      LED[7] <= 0;
      LED[7] <= 0;
    end

    else begin
      LED[7] <= 0;
      LED[7] <= 0;
      LED[6] <= 0;
    end
  end


endmodule