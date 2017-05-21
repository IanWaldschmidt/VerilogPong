//	Copyright (C) 1988-2012 Altera Corporation

//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.


module nco_nco_ii_0(clk, reset_n, clken, phi_inc_i, fsin_o, out_valid);

parameter mpr = 12;
parameter apr = 32;
parameter apri= 12;
parameter aprf= 32;
parameter aprp= 16;
parameter aprid=17;
parameter dpri= 4;
parameter rdw = 11;
parameter raw = 9;
parameter rnw = 512;
parameter rsf = "nco_nco_ii_0_sin.hex";
parameter rcf = "nco_nco_ii_0_cos.hex";
parameter nc = 4;
parameter log2nc =2;
parameter outselinit = 2;
parameter paci0= 0;
parameter paci1= 0;
parameter paci2= 0;
parameter paci3= 0;
parameter paci4= 0;
parameter paci5= 0;
parameter paci6= 0;
parameter paci7= 0;
//parameter numba = 1;
//parameter log2numba = 0;

input clk;
input reset_n;
input clken;
input [apr-1:0] phi_inc_i;

output [mpr-1:0] fsin_o;
output out_valid;
wire reset;
assign reset = !reset_n;

wire [apr-1:0]  phi_inc_i_w;
wire [mpr-1:0] sin_rom_2c_w;
wire [mpr-1:0] cos_rom_2c_w;
wire [mpr-2:0] sin_rom_d_w;
wire [mpr-2:0] cos_rom_d_w;
wire [raw-1:0] raxx001w;
wire [apr-1:0] phi_acc_w;
wire [mpr-1:0] sin_o_w;
wire [mpr-1:0] cos_o_w;
wire [mpr-2:0] rxs_w;
wire [mpr-2:0] rxc_w;
wire [mpr-1:0] fsin_o_w;	
wire [mpr-1:0] fcos_o_w;	
wire [2:0] selector_rot;
wire [2:0] nq;
wire [mpr-1:0] fsin_o;
wire [mpr-1:0] fcos_o;
wire [mpr-1:0] fsin_o_ch0;
wire [mpr-1:0] fsin_o_ch1;
wire [mpr-1:0] fsin_o_ch2;
wire [mpr-1:0] fsin_o_ch3;
wire [log2nc-1:0] inputsel_w;
wire [log2nc-1:0] outputsel_w;
wire [nc*apr-1:0] phi_inc_i_bus;
wire [nc*mpr-1:0] fcos_o_bus;
wire [nc*mpr-1:0] fsin_o_bus;





asj_xnqg u011(.phi_a(phi_acc_w),
             .xnq(nq)
             );
defparam u011.apr=apr;


segment_arr_tdl tdl( .clk(clk),
                     .reset(reset),
                     .clken(clken), 
                     .current_seg(nq),
                     .seg_rot(selector_rot)
                      );
defparam tdl.npiperom = 2;
defparam tdl.npiperot = 4;

assign phi_inc_i_w = phi_inc_i;

asj_altqmcash ux000 (.clk(clk),
             .reset(reset),
             .clken(clken),
             .phi_inc_int(phi_inc_i_w),
             .phi_acc_reg(phi_acc_w)
             );

defparam ux000.nc = nc ;
defparam ux000.apr = apr ;
defparam ux000.lat = 1 ;
defparam ux000.paci0 = paci0 ;
defparam ux000.paci1 = paci1 ;
defparam ux000.paci2 = paci2 ;
defparam ux000.paci3 = paci3 ;
defparam ux000.paci4 = paci4 ;
defparam ux000.paci5 = paci5 ;
defparam ux000.paci6 = paci6 ;
defparam ux000.paci7 = paci7 ;


asj_gar ux007( .clk(clk),
                   .reset(reset),
                   .phi_acc_w(phi_acc_w[apr-4:apr-3-raw]),
                   .clken(clken),
                   .segment_lsb(nq[0]),
                   .rom_add(raxx001w)
                   );
defparam ux007.raw = raw;
defparam ux007.apr = apr;

sid_2c_1p sid2c(.clk(clk),
                .reset(reset),
                .clken(clken),
                .sin_rom(rxs_w),
                .cos_rom(rxc_w),
                .sin_rom_2c(sin_rom_2c_w),
                .cos_rom_2c(cos_rom_2c_w),
                .sin_rom_d(sin_rom_d_w),
                .cos_rom_d(cos_rom_d_w)
                );

defparam sid2c.mpr = mpr;

asj_nco_as_m_cen ux0120(.clk(clk),
                   .clken (clken),
                   .raxx (raxx001w[raw-1:0]),
                   .srw_int_res(rxs_w[mpr-2:0])
                    );

defparam ux0120.mpr = mpr;
defparam ux0120.rdw = rdw;
defparam ux0120.raw = raw;
defparam ux0120.rnw = rnw;
defparam ux0120.rf = rsf;
defparam ux0120.dev = "Cyclone V";

asj_nco_as_m_cen ux0121(.clk(clk),
                   .clken (clken),
                   .raxx (raxx001w[raw-1:0]),
                   .srw_int_res(rxc_w[mpr-2:0])
                    );

defparam ux0121.mpr = mpr;
defparam ux0121.rdw = rdw;
defparam ux0121.raw = raw;
defparam ux0121.rnw = rnw;
defparam ux0121.rf = rcf;
defparam ux0121.dev = "Cyclone V";

segment_sel  rot(.clk(clk),
                 .reset(reset),
                 .clken(clken),
                 .segment(selector_rot),
                 .sin_rom_d(sin_rom_d_w),
                 .cos_rom_d(cos_rom_d_w),
                 .sin_rom_2c(sin_rom_2c_w),
                 .cos_rom_2c(cos_rom_2c_w),
                 .sin_o(sin_o_w)
		     );

defparam rot.mpr = mpr;

asj_nco_mob_rw ux122(.data_in(sin_o_w),
                     .data_out(fsin_o_w),
                     .reset(reset),
                     .clken(clken),
                     .clk(clk)
);
defparam ux122.mpr = mpr;
defparam ux122.sel = 0;
asj_nco_mob_rw ux123(.data_in(cos_o_w),
                     .data_out(fcos_o_w),
                     .reset(reset),
                     .clken(clken),
                     .clk(clk)
);
defparam ux123.mpr = mpr;
defparam ux123.sel = 0;
assign fsin_o = fsin_o_w;



asj_nco_isdr ux710isdr(.clk(clk),
                    .reset(reset),
                    .clken(clken),
                    .data_ready(out_valid)
                    );
defparam ux710isdr.ctc=7;
defparam ux710isdr.cpr=3;



endmodule
