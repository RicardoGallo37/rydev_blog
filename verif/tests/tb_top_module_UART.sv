`timescale 1ns / 1ps

module tb_top_module_UART;

    //input stimulus
    logic         clk_pi;
    logic         rst_pi;
    logic         wr_pi;
    logic         reg_sel_pi;
    logic [7 : 0] entrada_pi;
    logic         addr_pi;
    logic         rx;
    
    //output stimulus
    logic [7 : 0] out_po;
    
    //aux 
    logic [1 : 0] test_numb = '0;
    logic [7 : 0] expected_out;
    
    //UART instace
    top_module_UART DUT (
    
        .clk_10MHz  (clk_pi),
        .rst        (rst_pi),
        .wr_pi      (wr_pi),
        .reg_sel_pi (reg_sel_pi),
        .input_pi   (entrada_pi),
        .addr_pi    (addr_pi),
        .rx         (rx),
        .output_po  (out_po),
        .tx         (rx)
    );
    
    //clk stimulus
    initial   clk_pi = 0;
    always #5 clk_pi = ~clk_pi;

    //tests
    initial begin
        //init
        rst_pi      = 0;
        wr_pi       = 0;
        reg_sel_pi  = 0;
        entrada_pi  = '0;
        addr_pi     = 1;
        rx          = 0;

        //disable reset
        #30;
        rst_pi      = 1;

        //test registers after reset
        //data register 0
        #10;
        reg_sel_pi  = 1;
        addr_pi     = 0;
        entrada_pi  = 8'b11111111;
        wr_pi       = 0;

        expected_out = 8'b00000000;
        if (out_po !== expected_out) begin
            $display("Error: data register 0 is not empty after reset in time %0t", $time);
        end

        else begin
            $display("Data register 0 is empty after reset");
        end
        
        //data register 1
        #10;
        reg_sel_pi  = 1;
        addr_pi     = 1;
        entrada_pi  = 8'b10101010;
        wr_pi       = 0;

        expected_out = 8'b00000000;
        if (out_po !== expected_out) begin
            $display("Error: data register 1 is not empty after reset in time %0t", $time);
        end

        else begin
            $display("Data register 1 is empty after reset");
        end
 
        //control register
        #10;
        reg_sel_pi  = 0;
        addr_pi     = 0;
        entrada_pi  = 8'b11111111;
        wr_pi       = 0;

        expected_out = 8'b00000000;
        if (out_po !== expected_out) begin
            $display("Error: control register is not empty after reset in time %0t", $time);
        end

        else begin
            $display("Control register is empty after reset");
        end
        
//////////////////////////////////////////////////////////////////////
//First transaction       

        //test data to send 1
        #100;
        reg_sel_pi  = 1;
        addr_pi     = 0;
        entrada_pi  = 8'b10101010;
        wr_pi       = 1;

        #10;
        reg_sel_pi  = 1;
        addr_pi     = 0;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;

        //test data to send on data registers
        expected_out = 8'b10101010;
        if (out_po !== expected_out) begin
            $display("Error: data register 0 didn't store the data to send", $time);
        end

        else begin
            $display("Data register 0 store the data to send");
        end

        #10;
        reg_sel_pi  = 1;
        addr_pi     = 1;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;
        expected_out = 8'b00000000;
        
        #7;
        if (out_po !== expected_out) begin
            $display($time, "Error: data register 1 store the data to send");
        end

        //test control to send
        #15;
        reg_sel_pi  = 0;
        addr_pi     = 0;
        entrada_pi  = 8'b00000001;
        wr_pi       = 1;

        #10;
        reg_sel_pi  = 0;
        addr_pi     = 0;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;

        expected_out = 8'b00000001;
        if (out_po !== expected_out) begin
            $display("Error: control register didn't store the control word", $time);
        end

        else begin
            $display("Control register store the control word");
        end
        
        #150000;
        
  //////////////////////////////////////////////////////////////////////
  //Second transaction
  
        //test data to send 2
        #100;
        reg_sel_pi  = 1;
        addr_pi     = 0;
        entrada_pi  = 8'b10001100;
        wr_pi       = 1;
        
        #10;
        reg_sel_pi  = 1;
        addr_pi     = 0;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;

        //test data to send on data registers
        expected_out = 8'b10001100;
        if (out_po !== expected_out) begin
            $display("Error: data register 0 didn't store the data to send", $time);
        end

        else begin
            $display("Data register 0 store the data to send");
        end

        #10;
        reg_sel_pi  = 1;
        addr_pi     = 1;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;
        
        expected_out = 8'b10101010;
        #7;
        if (out_po !== expected_out) begin
            $display($time, "Error: data register 1 store the data to send");
        end

        //test control to send
        #15;
        reg_sel_pi  = 0;
        addr_pi     = 0;
        entrada_pi  = 8'b00000001;
        wr_pi       = 1;

        #10;
        reg_sel_pi  = 0;
        addr_pi     = 0;
        entrada_pi  = 8'b00000000;
        wr_pi       = 0;

        expected_out = 8'b00000001;
        if (out_po !== expected_out) begin
            $display("Error: control register didn't store the control word", $time);
        end

        else begin
            $display("Control register store the control word");
        end
        

    end
    
    //test rx
    always @ (posedge clk_pi) begin
    
        if (DUT.UART.receiver.rx_data_rdy) begin
            
            test_numb   = test_numb + 1;
            reg_sel_pi  = 0;
            addr_pi     = 0;
            entrada_pi  = 8'b00000000;
            wr_pi       = 0;
    
            $display("transaction %d completed ", test_numb);
            expected_out = 8'b00000000;
                
            if (out_po !== expected_out) begin
                $display("Error: the send bit was not cleaned ", $time);
            end
                
            else begin
                $display("send bit cleaned");
            end
                
            #15;
                
            expected_out = 8'b00000010;
            if (out_po !== expected_out) begin
                $display("Error: the new_rx bit was not written", $time);
            end
                
            else begin
                $display("new_rx written");
            end
                
            if (test_numb == 1) begin  
                if (DUT.DATA_REG.rf_r [1] !== 8'b10101010) begin
                    $display("Error: wrong data received", $time);
                end
                
                else begin
                    $display("data received correctly");
                end
            end
            
            if (test_numb == 2) begin
                if (DUT.DATA_REG.rf_r [1] !== 8'b10001100) begin
                    $display("Error: wrong data received", $time);
                end
                
                else begin
                     $display("data received correctly");
                end
            end    
            #20;
        end

        if (test_numb == 2) 
            $finish;
    end
endmodule