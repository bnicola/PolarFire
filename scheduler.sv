module scheduler #
(
    parameter depth = 8, // up till 'depth' trigger events can be schecduled
    parameter THRESHOLD = 4,
    parameter TIMER_WIDTH = 64
)
(
   input logic clk, rst_n,
   input write,
   input read,
   input logic [TIMER_WIDTH - 1:0] value,
   output logic [TIMER_WIDTH - 1:0] current_time,
   output logic trigger
);

localparam integer WRITE_POINTER_WIDTH = $clog2(depth);
reg  [WRITE_POINTER_WIDTH - 1:0] writepointer;
reg  [TIMER_WIDTH - 1:0] sched_regs[0:depth - 1];
reg  [TIMER_WIDTH - 1:0] internal_counter;
reg  [depth - 1:0] triger_reg;
wire [depth - 1:0] triger_out;
reg  [WRITE_POINTER_WIDTH - 1:0] writepointer_cnt;

// free running 64 bit counter (our actual time passing counter)
always @(posedge clk or negedge rst_n) begin 
   if (!rst_n) begin 
      internal_counter <= 32'h0;
   end
   else begin 
      internal_counter <= internal_counter + 1'b1;
   end
end

// Reading out the current time
always @(posedge clk or negedge rst_n) begin 
   if (!rst_n) begin 
      current_time <= 0;
   end
   else begin 
      if (read) begin 
         current_time <= internal_counter + 1'b1;
      end 
      else begin 
         current_time <= 0;
      end 
   end
end 

// Writing events to the scheduler
always @(posedge clk or negedge rst_n) begin 
   if (!rst_n) begin 
      writepointer <= 0;
      writepointer_cnt <= 0;
   end
   else begin 
      if (write && (value > internal_counter)) begin 
         sched_regs[writepointer] <= value;
         writepointer <= writepointer + 1'b1;
         writepointer_cnt <= writepointer_cnt + 1'b1;
      end
   end 
end

integer i;
always @(posedge clk or negedge rst_n) begin 
   if (!rst_n) begin 
      triger_reg[i] <= 32'h0;
   end
   else begin 
      for (i = 0; i < depth; i = i + 1) begin 
      if (internal_counter == sched_regs[i] - 1  && writepointer > 0) begin 
         triger_reg[i] <=  1'b1;
         writepointer_cnt <= writepointer_cnt - 1'b1;
      end
      else begin 
         triger_reg[i] <=  1'b0;
         writepointer_cnt <= writepointer_cnt;
      end 
    end
   end
end

wire [depth-1:0] y;

generate
  genvar j;
  for(j = 0 ; j < depth ; j = j + 1) begin
    assign y[j] = triger_reg[j];
  end
endgenerate

assign trigger = |y;

endmodule
