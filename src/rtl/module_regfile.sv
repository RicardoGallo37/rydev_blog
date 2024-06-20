//Register file 
module module_regfile (

    input logic            clk_i, //clk
    input logic            rst_i, //reset (active low)
    input logic            we3_i, //write enable
    input logic   [4 : 0]  a1_i,  //read port 1 pointer
    input logic   [4 : 0]  a2_i,  //read port 2 pointer
    input logic   [4 : 0]  a3_i,  //write port pointer
    input logic   [31 : 0] wd3_i, //write port

    output logic  [31 : 0] rd1_o, //read port 1
    output logic  [31 : 0] rd2_o  //read port 2
    
);

    //regfile model
    typedef logic [31 : 0] register; 
    register      [31 : 0] rf_r;   

   //write op 
    always_ff @ (negedge clk_i) begin
        
        if (!rst_i)
            rf_r <= '0;
            
        else if (we3_i) 
            rf_r[a3_i] <= wd3_i;
        
        else
            rf_r[a3_i] <= rf_r[a3_i];
    end
    
    //read op
    assign rd1_o = (a1_i != 0) ? rf_r[a1_i] : 0; //reg zero == 0
    assign rd2_o = (a2_i != 0) ? rf_r[a2_i] : 0; //reg zero == 0

endmodule