  module DE1_SoC
    #(parameter ROM_ADDR_WIDTH=10, parameter RAM_ADDR_WIDTH=10)
    (
     ///////// clock /////////
     input logic 	clock_50,

     ///////// hex  /////////
     output logic [6:0] hex0,
     output logic [6:0] hex1,
     output logic [6:0] hex2,
     output logic [6:0] hex3,
     output logic [6:0] hex4,
     output logic [6:0] hex5,

     ///////// key /////////
     input logic [3:0] 	key,

     ///////// ledr /////////
     output logic [9:0] ledr,

     ///////// sw /////////
     input logic [9:0] 	sw,

     ///////// VGA  /////////
     output logic 	VGA_CLK,
     output logic 	VGA_HS,
     output logic 	VGA_VS,
     output logic 	VGA_BLANK,
     output logic [7:0] VGA_R,
     output logic [7:0] VGA_G,
     output logic [7:0] VGA_B,
     output logic 	VGA_SYNC

     );


   // Génération d'un reset à partir du bouton key[0]
   logic 			    reset_n;
   gene_reset gene_reset(.clk(clock_50), .key(key[0]), .reset_n(reset_n));

   // Instantication de la RAM pour les données
   logic [31:0] 		    ram_addr;
   logic [31:0] 		    d_data_write;
   logic [31:0]       d_data_read;
   logic 			    write_enable;
   logic 			    ram_rdata_valid;


   // periferiques
   logic leds_cs, switches_cs, cs_ram;
   logic [31:0] ram_rdata;
   logic [31:0] sw_rdata;
   logic [31:0] leds_rdata;

   ram #(.ADDR_WIDTH(RAM_ADDR_WIDTH)) ram_data
     (
      .clk         ( clock_50                         ),
      .addr        ( ram_addr[(RAM_ADDR_WIDTH-1)+2:2] ),
      .we          ( write_enable                     ),
      .wdata       ( d_data_write                     ),
      .rdata       ( ram_rdata                        ),
      .rdata_valid ( ram_rdata_valid                  )
      );

   // Instantication de la ROM pour les instructions
   logic [31:0] 		    rom_addr;
   logic [31:0] 		    rom_rdata;
   logic 			    rom_rdata_valid;

   rom #(.ADDR_WIDTH(ROM_ADDR_WIDTH)) rom_instructions
     (
      .clk         ( clock_50                         ),
      .addr        ( rom_addr[(ROM_ADDR_WIDTH-1)+2:2] ),
      .rdata       ( rom_rdata                        ),
      .rdata_valid ( rom_rdata_valid                  )
      );


   // Instanciation du processeur
   DLX dlx
     (
      .clk            ( clock_50        ),
      .reset_n        ( reset_n         ),
      .d_address      ( ram_addr        ),
      .d_data_read    ( d_data_read     ),
      .d_data_write   ( d_data_write    ),
      .d_write_enable (write_enable),
      .d_data_valid   ( ram_rdata_valid ),
      .i_address      ( rom_addr        ),
      .i_data_read    ( rom_rdata       ),
      .i_data_valid   ( rom_rdata_valid )
      );

   driver_leds led1(.chip_select(leds_cs),
            .clk(clock_50),
            .reset_n(reset_n),
            .write_enable(write_enable),
            .data_write(d_data_write), 
            .data_read(leds_rdata),
            .ledr(ledr));

  driver_switches sw1(.data(sw_rdata), .sw(sw));

  chip_select chip_select1(
    .address(ram_addr),
    .cs_led(leds_cs),
    .cs_ram(cs_ram)
  );

  always@(posedge clock_50) begin
    casez ({leds_cs, cs_ram})
      2'b10:   d_data_read <= leds_rdata;
      2'b01:   d_data_read <= ram_rdata;
      default: d_data_read <= sw_rdata;
    endcase
  end
endmodule
