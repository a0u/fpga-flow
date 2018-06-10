`timescale 1ns/1ps

module top(
	input GCLK,
	/* OLED display */
	output OLED_DC,
	output OLED_RES,
	output OLED_SCLK,
	output OLED_SDIN,
	output OLED_VBAT,
	output OLED_VDD,
	/* User LEDs */
	output LD0,
	output LD1,
	output LD2,
	output LD3,
	output LD4,
	output LD5,
	output LD6,
	output LD7,
	/* User push buttons */
	input BTNC, /* D-pad center */
	input BTND, /* D-pad down */
	input BTNL, /* D-pad left */
	input BTNR, /* D-pad right */
	input BTNU, /* D-pad up */
	/* User DIP switches */
	input SW0,
	input SW1,
	input SW2,
	input SW3,
	input SW4,
	input SW5,
	input SW6,
	input SW7,

	/* Wrapper */
	inout [14:0] DDR_addr,
	inout [2:0] DDR_ba,
	inout DDR_cas_n,
	inout DDR_ck_n,
	inout DDR_ck_p,
	inout DDR_cke,
	inout DDR_cs_n,
	inout [3:0] DDR_dm,
	inout [31:0] DDR_dq,
	inout [3:0] DDR_dqs_n,
	inout [3:0] DDR_dqs_p,
	inout DDR_odt,
	inout DDR_ras_n,
	inout DDR_reset_n,
	inout DDR_we_n,
	inout FIXED_IO_ddr_vrn,
	inout FIXED_IO_ddr_vrp,
	inout [53:0] FIXED_IO_mio,
	inout FIXED_IO_ps_clk,
	inout FIXED_IO_ps_porb,
	inout FIXED_IO_ps_srstb
);

	wire sys_clock;
	wire sys_reset;

	wire        axi_mem_aclk;
	/* AXI GP0 slave AR channel */
	wire        axi_mem_arvalid;
	wire        axi_mem_arready;
	wire [5:0]  axi_mem_arid;
	wire [31:0] axi_mem_araddr;
	wire [3:0]  axi_mem_arlen;
	wire [2:0]  axi_mem_arsize;
	wire [1:0]  axi_mem_arburst;
	wire        axi_mem_arlock;
	wire [3:0]  axi_mem_arcache;
	wire [2:0]  axi_mem_arprot;
	wire [3:0]  axi_mem_arqos;
	/* AXI GP0 slave AW channel */
	wire        axi_mem_awvalid;
	wire        axi_mem_awready;
	wire [5:0]  axi_mem_awid;
	wire [31:0] axi_mem_awaddr;
	wire [3:0]  axi_mem_awlen;
	wire [2:0]  axi_mem_awsize;
	wire [1:0]  axi_mem_awburst;
	wire        axi_mem_awlock;
	wire [3:0]  axi_mem_awcache;
	wire [2:0]  axi_mem_awprot;
	wire [3:0]  axi_mem_awqos;
	/* AXI GP0 slave W channel */
	wire        axi_mem_wvalid;
	wire        axi_mem_wready;
	wire [5:0]  axi_mem_wid;
	wire [63:0] axi_mem_wdata;
	wire [3:0]  axi_mem_wstrb;
	wire        axi_mem_wlast;
	/* AXI GP0 slave R channel */
	wire        axi_mem_rvalid;
	wire        axi_mem_rready;
	wire [5:0]  axi_mem_rid;
	wire [63:0] axi_mem_rdata;
	wire [1:0]  axi_mem_rresp;
	wire        axi_mem_rlast;
	/* AXI GP0 slave B channel */
	wire        axi_mem_bvalid;
	wire        axi_mem_bready;
	wire [5:0]  axi_mem_bid;
	wire [1:0]  axi_mem_bresp;

	zedboard_ps ps (
		.DDR_addr(DDR_addr),
		.DDR_ba(DDR_ba),
		.DDR_cas_n(DDR_cas_n),
		.DDR_ck_n(DDR_ck_n),
		.DDR_ck_p(DDR_ck_p),
		.DDR_cke(DDR_cke),
		.DDR_cs_n(DDR_cs_n),
		.DDR_dm(DDR_dm),
		.DDR_dq(DDR_dq),
		.DDR_dqs_n(DDR_dqs_n),
		.DDR_dqs_p(DDR_dqs_p),
		.DDR_odt(DDR_odt),
		.DDR_ras_n(DDR_ras_n),
		.DDR_reset_n(DDR_reset_n),
		.DDR_we_n(DDR_we_n),
		.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
		.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
		.FIXED_IO_mio(FIXED_IO_mio),
		.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
		.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
		.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
		.axi_mem_araddr(axi_mem_araddr),
		.axi_mem_arburst(axi_mem_arburst),
		.axi_mem_arcache(axi_mem_arcache),
		.axi_mem_arid(axi_mem_arid),
		.axi_mem_arlen(axi_mem_arlen),
		.axi_mem_arlock(axi_mem_arlock),
		.axi_mem_arprot(axi_mem_arprot),
		.axi_mem_arqos(axi_mem_arqos),
		.axi_mem_arready(axi_mem_arready),
		.axi_mem_arsize(axi_mem_arsize),
		.axi_mem_arvalid(axi_mem_arvalid),
		.axi_mem_awaddr(axi_mem_awaddr),
		.axi_mem_awburst(axi_mem_awburst),
		.axi_mem_awcache(axi_mem_awcache),
		.axi_mem_awid(axi_mem_awid),
		.axi_mem_awlen(axi_mem_awlen),
		.axi_mem_awlock(axi_mem_awlock),
		.axi_mem_awprot(axi_mem_awprot),
		.axi_mem_awqos(axi_mem_awqos),
		.axi_mem_awready(axi_mem_awready),
		.axi_mem_awsize(axi_mem_awsize),
		.axi_mem_awvalid(axi_mem_awvalid),
		.axi_mem_bid(axi_mem_bid),
		.axi_mem_bready(axi_mem_bready),
		.axi_mem_bresp(axi_mem_bresp),
		.axi_mem_bvalid(axi_mem_bvalid),
		.axi_mem_rdata(axi_mem_rdata),
		.axi_mem_rid(axi_mem_rid),
		.axi_mem_rlast(axi_mem_rlast),
		.axi_mem_rready(axi_mem_rready),
		.axi_mem_rresp(axi_mem_rresp),
		.axi_mem_rvalid(axi_mem_rvalid),
		.axi_mem_wdata(axi_mem_wdata),
		.axi_mem_wlast(axi_mem_wlast),
		.axi_mem_wready(axi_mem_wready),
		.axi_mem_wstrb(axi_mem_wstrb),
		.axi_mem_wvalid(axi_mem_wvalid),
		.host_clock(host_clock),
		.host_reset(host_reset),
		.sys_clock(GCLK));

	/*
	 * LED counter demo
	 */

	wire press_up, press_down;

	edge_detector up (
		.clock(host_clock),
		.reset(host_reset),
		.in(BTNU),
		.out(press_up));

	edge_detector down (
		.clock(host_clock),
		.reset(host_reset),
		.in(BTND),
		.out(press_down));

	up_down_counter counter (
		.clock(host_clock),
		.reset(host_reset),
		.up(press_up),
		.down(press_down),
		.count({LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0}));

endmodule
