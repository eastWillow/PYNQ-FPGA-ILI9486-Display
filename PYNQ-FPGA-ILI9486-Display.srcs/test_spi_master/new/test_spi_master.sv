///////////////////////////////////////////////////////////////////////////////
// Description:       Simple test bench for SPI Master module
///////////////////////////////////////////////////////////////////////////////

module test_spi_master();
    parameter SPI_MODE = 0; // CPOL = 0, CPHA = 0
    parameter CLKS_PER_HALF_BIT = 16;  // 7.8125 MHz
    parameter MAIN_CLK_DELAY = 1;     // 125 MHz

    logic r_Rst_L     = 1'b0;
    logic w_SPI_Clk;
    logic r_Clk       = 1'b0;
    logic w_SPI_MOSI;
    logic r_SPI_MISO  = 1'b0;

    // Master Specific
    logic [7:0] r_Master_TX_Byte = 0;
    logic r_Master_TX_DV = 1'b0;
    logic w_Master_TX_Ready;
    logic r_Master_RX_DV;
    logic [7:0] r_Master_RX_Byte;

    // Clock Generators:
    always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

    // Instantiate UUT
    SPI_Master
    #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
    (
    // Control/Data Signals,
    .i_Rst_L(r_Rst_L),     // FPGA Reset
    .i_Clk(r_Clk),         // FPGA Clock

    // TX (MOSI) Signals
    .i_TX_Byte(r_Master_TX_Byte),     // Byte to transmit on MOSI
    .i_TX_DV(r_Master_TX_DV),         // Data Valid Pulse with i_TX_Byte
    .o_TX_Ready(w_Master_TX_Ready),   // Transmit Ready for Byte

    // RX (MISO) Signals
    .o_RX_DV(r_Master_RX_DV),       // Data Valid pulse (1 clock cycle)
    .o_RX_Byte(r_Master_RX_Byte),   // Byte received on MISO

    // SPI Interface
    .o_SPI_Clk(w_SPI_Clk),
    .i_SPI_MISO(r_SPI_MISO),
    .o_SPI_MOSI(w_SPI_MOSI)
    );

    // Sends a single byte from master.
    task SendSingleByte(input [7:0] data);
    @(posedge r_Clk);
    r_Master_TX_Byte <= data;
    r_Master_TX_DV   <= 1'b1;
    @(posedge r_Clk);
    r_Master_TX_DV <= 1'b0;
    @(posedge w_Master_TX_Ready);
    endtask // SendSingleByte

    // Sends a single byte from master.
    task ReadSingleByte(input [7:0] data);
    @(posedge r_Clk);
    r_Master_TX_Byte <= 8'hFF;
    r_Master_TX_DV   <= 1'b1;
    @(posedge r_Clk);
    r_Master_TX_DV   <= 1'b0;
    r_SPI_MISO       <= data[7];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[6];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[5];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[4];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[3];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[2];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[1];
    repeat(CLKS_PER_HALF_BIT*2) @(posedge r_Clk);
    r_SPI_MISO       <= data[0];
    @(posedge w_Master_TX_Ready);
    endtask // SendSingleByte

    initial
    begin
      // Required for EDA Playground
      $dumpfile("dump.vcd");
      $dumpvars;

      repeat(10) @(posedge r_Clk);
      r_Rst_L  = 1'b0;
      repeat(10) @(posedge r_Clk);
      r_Rst_L   = 1'b1;

      w_SPI_MOSI = 1'b0;
      // Test single byte
      SendSingleByte(8'hDA);//Send MOSI Command
      ReadSingleByte(8'h5A);//Read MISO Data
      $display("Expect Read 0x5A, Actual Received 0x%X", r_Master_RX_Byte);

      repeat(10) @(posedge r_Clk);
      $finish();
    end // initial begin
endmodule
