//Aluno: Yovany Marroquin da Cunha - 115210445
//Roteiro 5

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

  parameter NBITS_COUNT = 4;
  parameter ZERO   = 'b00111111;
  parameter UM     = 'b00000110;
  parameter DOIS   = 'b01011011;
  parameter TRES   = 'b01001111;
  parameter QUATRO = 'b01100110;
  parameter CINCO  = 'b01101101;
  parameter SEIS   = 'b01111101;
  parameter SETE   = 'b00000111;
  parameter OITO   = 'b01111111;
  parameter NOVE   = 'b01101111;
  parameter A      = 'b01110111;
  parameter B      = 'b01111111;
  parameter C      = 'b00111001;
  parameter D      = 'b00111111;
  parameter E      = 'b01111001;
  parameter F      = 'b01110001;

  parameter tamanho = 4;
  
  logic [NBITS_COUNT-1:0] data_in, count;
  logic reset, count_up, counter_on, serial_input, find_success;
  
  enum logic [tamanho -1 : 0] {inicial, primeiro_1, segundo_1, terceiro_1} state;

  always_comb begin
    reset <= SWI[0];
    count_up <= SWI[1];
    serial_input <= SWI[3];
    data_in <= SWI[7:4];
  end

  always_ff @(posedge reset or posedge clk_2 ) begin
    if (reset) begin
      count <= 0;
    end
    else if (count_up) begin
      count <= count + 1;
    end
    else begin
      count <= count - 1;
    end
  end

  always_ff @( posedge clk_2 ) begin
    if (reset) begin
      state <= inicial;
    end
    else begin
      unique case (state)
      inicial: 
        if (serial_input == 1) begin
          state <= primeiro_1;
        end
        else begin
          state <= inicial;
        end

      primeiro_1:
        if (serial_input == 1) begin
          state <= segundo_1;
        end
        else begin
          state <= inicial;
        end

      segundo_1:
        if (serial_input == 1) begin
          state <= terceiro_1;
        end
        else begin
          state <= inicial;
        end
        
      terceiro_1:
        if (serial_input == 1) begin
          state <= terceiro_1;
        end
        else begin
          state <= inicial;
        end
      endcase
    end
  end

  always_comb begin
    unique case(count)
      0 : SEG <= ZERO;
      1 : SEG <= UM;
      2 : SEG <= DOIS;
      3 : SEG <= TRES;
      4 : SEG <= QUATRO;
      5 : SEG <= CINCO;
      6 : SEG <= SEIS;
      7 : SEG <= SETE;
      8 : SEG <= OITO;
      9 : SEG <= NOVE;
      10: SEG <= A;
      11: SEG <= B;
      12: SEG <= C;
      13: SEG <= D;
      14: SEG <= E;
      15: SEG <= F;
    endcase
  end

  always_comb find_success <= (state == terceiro_1);

  always_comb begin
    LED[0] <= find_success;
    LED[1] <= count_up;
    LED[7] <= clk_2;
  end

endmodule