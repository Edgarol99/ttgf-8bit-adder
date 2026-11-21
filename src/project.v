/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // VGA signals
  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // Tiny VGA Pmod
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  hvsync_generator vga_sync_gen (
      .clk(clk),
      .reset(~rst_n),
      .hsync(hsync),
      .vsync(vsync),
      .display_on(video_active),
      .hpos(pix_x),
      .vpos(pix_y)
  );

  // Colors
  localparam [5:0] BLACK = {2'b00, 2'b00, 2'b00};
  localparam [5:0] GRIS1 = {2'b01, 2'b01, 2'b01};
  localparam [5:0] GRIS2 = {2'b10, 2'b10, 2'b10};
  localparam [5:0] RED = {2'b11, 2'b00, 2'b00};

  // RGB output logic
  always @(posedge clk) begin
    if (~rst_n) begin
      R <= 0;
      G <= 0;
      B <= 0;
    end else begin
      if (video_active) begin
        if (pos_x==player_x & pos_y==player_y)
          {R, G, B} <= RED;
        else
          {R, G, B} <= pos_y+pos_x;
      end
    end
  end

    // Gamepad Pmod
  wire inp_b, inp_y, inp_select, inp_start, inp_up, inp_down, inp_left, inp_right, inp_a, inp_x, inp_l, inp_r;

  gamepad_pmod_single u2 (
      // Inputs:
      .rst_n(rst_n),
      .clk(clk),
      .pmod_data(ui_in[6]),
      .pmod_clk(ui_in[5]),
      .pmod_latch(ui_in[4]),
      // Outputs:
      .b(inp_b),
      .y(inp_y),
      .select(inp_select),
      .start(inp_start),
      .up(inp_up),
      .down(inp_down),
      .left(inp_left),
      .right(inp_right),
      .a(inp_a),
      .x(inp_x),
      .l(inp_l),
      .r(inp_r)
  );

  //Bandera
  localparam [7:0] LEFT_GLYPH[0:7] = '{
      8'b00001000,
      8'b00011000,
      8'b00111000,
      8'b00011000,
      8'b00001000,
      8'b00001000,
      8'b00001000,
      8'b00111100
  };

//Uno
localparam [7:0] DOWN_GLYPH[0:7] = '{
      8'b00010000,
      8'b00110000,
      8'b00010000,
      8'b00010000,
      8'b00010000,
      8'b00010000,
      8'b00111000,
      8'b00000000
};
//Dos
localparam [7:0] UP_GLYPH[0:7] = '{
      8'b00011000,
      8'b00100100,
      8'b00000100,
      8'b00001000,
      8'b00010000,
      8'b00100000,
      8'b00111100,
      8'b00000000
};
//Tres
localparam [7:0] RIGHT_GLYPH[0:7] = '{
      8'b00011000,
      8'b00000100,
      8'b00000100,
      8'b00011000,
      8'b00000100,
      8'b00000100,
      8'b00011000,
      8'b00000000
};
//cuatro
  localparam [7:0] B_GLYPH[0:7] = '{
      8'b00100100,
      8'b00100100,
      8'b00100100,
      8'b00111110,
      8'b00000100,
      8'b00000100,
      8'b00000100,
      8'b00000000
  };
  //cinco
  localparam [7:0] X_GLYPH[0:7] = '{
      8'b00000000,
      8'b01111100,
      8'b01000000,
      8'b01111000,
      8'b00000100,
      8'b01000100,
      8'b00111000,
      8'b00000000
  };
  //seis
  localparam [7:0] Y_GLYPH[0:7] = '{
      8'b00000000,
      8'b00011100,
      8'b00100000,
      8'b00100000,
      8'b00111100,
      8'b00100010,
      8'b00100010,
      8'b00011100
  };
//mina
  localparam [7:0] A_GLYPH[0:7] = '{
      8'b00001000,
      8'b00011100,
      8'b00101110,
      8'b01100111,
      8'b00111110,
      8'b00011100,
      8'b00001000,
      8'b00000000
  };

  wire [3:0] pos_x = pix_x/40;
  wire [3:0] pos_y = pix_y/40;

  reg [3:0] player_x=0;
  reg [3:0] player_y=0;

  
  always @(posedge clk) begin
    if (inp_up) begin
      player_y <= player_y+1;
    end
    if (inp_down) begin
      player_y <= player_y-11;
    end
    if (inp_left) begin
      player_x <= player_x-1;
    end
    if (inp_right) begin
      player_x <= player_x+1;
    end

  end
/*
    always @(posedge clk) begin
      if (inp_up)
        pos_x=pos_x+1;
      if (inp_down)
        pos_x=pos_x-1;
  end
*/
  
endmodule
