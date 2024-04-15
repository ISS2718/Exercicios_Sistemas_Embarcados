-- ###################################################################################################
-- # << ISS2718 - Subsystem of Custom Functions for Matrix Multiplication >>                         #
-- # *********************************************************************************************** #
-- # This module provides a 64x 32-bit interface, an interrupt request signal, and                   #
-- # custom IO conduits for external interface to the processor or chip.                             #
-- #                                                                                                 #
-- # NOTE: This is a custom subsystem for accelerating matrix multiplication,                        #
-- # through a scalar product hardware accelerator.                                                  #
-- #                                                                                                 #
-- #       This code is a modification of the NEORV32 RISC-V Processor,                              #
-- #       available at https://github.com/stnolting/neorv32                                         #
-- # *********************************************************************************************** #
-- # BSD 3-Clause License                                                                            #
-- #                                                                                                 #
-- # Hardware matrix accelerator,                                                                    #
-- # https://github.com/ISS2718/Sistemas_Embarcados/Coprocessador                                    #
-- #                                                                                                 #
-- # Copyright (c) 2024, Daniel Contente, Hugo Nakamura, Isaac Soares, Mateus Messias. All rights    #
-- # reserved.                                                                                       #
-- #                                                                                                 #
-- # Redistribution and use in source and binary forms, with or without modification, are            #
-- # permitted provided that the following conditions are met:                                       #
-- #                                                                                                 #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of          #
-- #    conditions and the following disclaimer.                                                     #
-- #                                                                                                 #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of       #
-- #    conditions and the following disclaimer in the documentation and/or other materials          #
-- #    provided with the distribution.                                                              #
-- #                                                                                                 #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to    #
-- #    endorse or promote products derived from this software without specific prior written        #
-- #    permission.                                                                                  #
-- #                                                                                                 #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS     #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY #
-- # AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER     #
-- # OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR          #
-- # CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR        #
-- # SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY    #
-- # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE       #
-- # OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE        #
-- # POSSIBILITY OF SUCH DAMAGE.                                                                     #
-- ###################################################################################################


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_cfs is
  generic (
    CFS_CONFIG   : std_ulogic_vector(31 downto 0); -- custom CFS configuration generic
    CFS_IN_SIZE  : natural; -- size of CFS input conduit in bits
    CFS_OUT_SIZE : natural  -- size of CFS output conduit in bits
  );
  port (
    clk_i       : in  std_ulogic; -- global clock line
    rstn_i      : in  std_ulogic; -- global reset line, low-active, use as async
    bus_req_i   : in  bus_req_t; -- bus request
    bus_rsp_o   : out bus_rsp_t := rsp_terminate_c; -- bus response
    clkgen_en_o : out std_ulogic := '0'; -- enable clock generator
    clkgen_i    : in  std_ulogic_vector(7 downto 0); -- "clock" inputs
    irq_o       : out std_ulogic := '0'; -- interrupt request
    cfs_in_i    : in  std_ulogic_vector(CFS_IN_SIZE-1 downto 0); -- custom inputs
    cfs_out_o   : out std_ulogic_vector(CFS_OUT_SIZE-1 downto 0) := (others => '0') -- custom outputs
  );
end neorv32_cfs;

architecture neorv32_cfs_rtl of neorv32_cfs is

  -- default CFS interface registers --
  type cfs_regs_t is array (0 to 63) of std_ulogic_vector(31 downto 0); -- implement all the 64 registers
  signal cfs_reg_wr : cfs_regs_t; -- interface registers for WRITE accesses
  signal cfs_reg_rd : cfs_regs_t; -- interface registers for READ accesses

  -- custom entities/functions --
  component dot_product 
    port(
      reg_mult_in_0 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_1 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_2 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_3 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_4 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_5 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_6 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_7 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_8 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_9 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_10 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_11 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_12 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_13 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_14 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_15 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_16 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_17 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_18 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_19 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_20 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_21 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_22 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_23 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_24 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_25 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_26 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_27 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_28 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_29 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_30 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_31 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_32 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_33 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_34 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_35 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_36 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_37 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_38 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_39 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_40 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_41 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_42 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_43 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_44 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_45 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_46 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_47 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_48 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_49 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_50 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_51 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_52 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_53 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_54 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_55 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_56 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_57 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_58 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_59 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_60 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_61 : in std_ulogic_vector(31 downto 0);
      reg_mult_in_62 : in std_ulogic_vector(31 downto 0);

      reg_sum_out : out std_ulogic_vector(31 downto 0)
    );
  end component;
begin
  -- CFS IOs --
  cfs_out_o <= (others => '0'); -- not used for this minimal example

  -- Clock System --
  clkgen_en_o <= '0'; -- not used for this minimal example


  -- Interrupt --
  irq_o <= '0'; -- not used for this minimal example


  -- Read/Write Access --
  bus_access: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      cfs_reg_wr(0)  <= (others => '0');
      cfs_reg_wr(1)  <= (others => '0');
      cfs_reg_wr(2)  <= (others => '0');
      cfs_reg_wr(3)  <= (others => '0');
      cfs_reg_wr(4)  <= (others => '0');
      cfs_reg_wr(5)  <= (others => '0');
      cfs_reg_wr(6)  <= (others => '0');
      cfs_reg_wr(7)  <= (others => '0');
      cfs_reg_wr(8)  <= (others => '0');
      cfs_reg_wr(9)  <= (others => '0');
      cfs_reg_wr(10) <= (others => '0');
      cfs_reg_wr(11) <= (others => '0');
      cfs_reg_wr(12) <= (others => '0');
      cfs_reg_wr(13) <= (others => '0');
      cfs_reg_wr(14) <= (others => '0');
      cfs_reg_wr(15) <= (others => '0');
      cfs_reg_wr(16) <= (others => '0');
      cfs_reg_wr(17) <= (others => '0');
      cfs_reg_wr(18) <= (others => '0');
      cfs_reg_wr(19) <= (others => '0');
      cfs_reg_wr(20) <= (others => '0');
      cfs_reg_wr(21) <= (others => '0');
      cfs_reg_wr(22) <= (others => '0');
      cfs_reg_wr(23) <= (others => '0');
      cfs_reg_wr(24) <= (others => '0');
      cfs_reg_wr(25) <= (others => '0');
      cfs_reg_wr(26) <= (others => '0');
      cfs_reg_wr(27) <= (others => '0');
      cfs_reg_wr(28) <= (others => '0');
      cfs_reg_wr(29) <= (others => '0');
      cfs_reg_wr(30) <= (others => '0');
      cfs_reg_wr(31) <= (others => '0');
      cfs_reg_wr(32) <= (others => '0');
      cfs_reg_wr(33) <= (others => '0');
      cfs_reg_wr(34) <= (others => '0');
      cfs_reg_wr(35) <= (others => '0');
      cfs_reg_wr(36) <= (others => '0');
      cfs_reg_wr(37) <= (others => '0');
      cfs_reg_wr(38) <= (others => '0');
      cfs_reg_wr(39) <= (others => '0');
      cfs_reg_wr(40) <= (others => '0');
      cfs_reg_wr(41) <= (others => '0');
      cfs_reg_wr(42) <= (others => '0');
      cfs_reg_wr(43) <= (others => '0');
      cfs_reg_wr(44) <= (others => '0');
      cfs_reg_wr(45) <= (others => '0');
      cfs_reg_wr(46) <= (others => '0');
      cfs_reg_wr(47) <= (others => '0');
      cfs_reg_wr(48) <= (others => '0');
      cfs_reg_wr(49) <= (others => '0');
      cfs_reg_wr(50) <= (others => '0');
      cfs_reg_wr(51) <= (others => '0');
      cfs_reg_wr(52) <= (others => '0');
      cfs_reg_wr(53) <= (others => '0');
      cfs_reg_wr(54) <= (others => '0');
      cfs_reg_wr(55) <= (others => '0');
      cfs_reg_wr(56) <= (others => '0');
      cfs_reg_wr(57) <= (others => '0');
      cfs_reg_wr(58) <= (others => '0');
      cfs_reg_wr(59) <= (others => '0');
      cfs_reg_wr(60) <= (others => '0');
      cfs_reg_wr(61) <= (others => '0');
      cfs_reg_wr(62) <= (others => '0');
      cfs_reg_wr(63) <= (others => '0');

      bus_rsp_o.ack  <= '0';
      bus_rsp_o.err  <= '0';
      bus_rsp_o.data <= (others => '0');
    elsif rising_edge(clk_i) then -- synchronous interface for read and write accesses
      -- transfer/access acknowledge --
      bus_rsp_o.ack <= bus_req_i.stb;

      -- tie to zero if not explicitly used --
      bus_rsp_o.err <= '0';

      -- defaults --
      bus_rsp_o.data <= (others => '0'); -- the output HAS TO BE ZERO if there is no actual (read) access

      -- bus access --
      if (bus_req_i.stb = '1') then -- valid access cycle, STB is high for one cycle

        -- write access --
        if (bus_req_i.rw = '1') then

          case bus_req_i.addr(7 downto 2) is
            when "000000" =>              cfs_reg_wr(0) <= bus_req_i.data;
            when "000001" =>              cfs_reg_wr(1) <= bus_req_i.data;
            when "000010" =>              cfs_reg_wr(2) <= bus_req_i.data;
            when "000011" =>              cfs_reg_wr(3) <= bus_req_i.data;
            when "000100" =>              cfs_reg_wr(4) <= bus_req_i.data;
            when "000101" =>              cfs_reg_wr(5) <= bus_req_i.data;
            when "000110" =>              cfs_reg_wr(6) <= bus_req_i.data;
            when "000111" =>              cfs_reg_wr(7) <= bus_req_i.data;
            when "001000" =>              cfs_reg_wr(8) <= bus_req_i.data;
            when "001001" =>              cfs_reg_wr(9) <= bus_req_i.data;
            when "001010" =>              cfs_reg_wr(10) <= bus_req_i.data;
            when "001011" =>              cfs_reg_wr(11) <= bus_req_i.data;
            when "001100" =>              cfs_reg_wr(12) <= bus_req_i.data;
            when "001101" =>              cfs_reg_wr(13) <= bus_req_i.data;
            when "001110" =>              cfs_reg_wr(14) <= bus_req_i.data;
            when "001111" =>              cfs_reg_wr(15) <= bus_req_i.data;
            when "010000" =>              cfs_reg_wr(16) <= bus_req_i.data;
            when "010001" =>              cfs_reg_wr(17) <= bus_req_i.data;
            when "010010" =>              cfs_reg_wr(18) <= bus_req_i.data;
            when "010011" =>              cfs_reg_wr(19) <= bus_req_i.data;
            when "010100" =>              cfs_reg_wr(20) <= bus_req_i.data;
            when "010101" =>              cfs_reg_wr(21) <= bus_req_i.data;
            when "010110" =>              cfs_reg_wr(22) <= bus_req_i.data;
            when "010111" =>              cfs_reg_wr(23) <= bus_req_i.data;
            when "011000" =>              cfs_reg_wr(24) <= bus_req_i.data;
            when "011001" =>              cfs_reg_wr(25) <= bus_req_i.data;
            when "011010" =>              cfs_reg_wr(26) <= bus_req_i.data;
            when "011011" =>              cfs_reg_wr(27) <= bus_req_i.data;
            when "011100" =>              cfs_reg_wr(28) <= bus_req_i.data;
            when "011101" =>              cfs_reg_wr(29) <= bus_req_i.data;
            when "011110" =>              cfs_reg_wr(30) <= bus_req_i.data;
            when "011111" =>              cfs_reg_wr(31) <= bus_req_i.data;
            when "100000" =>              cfs_reg_wr(32) <= bus_req_i.data;
            when "100001" =>              cfs_reg_wr(33) <= bus_req_i.data;
            when "100010" =>              cfs_reg_wr(34) <= bus_req_i.data;
            when "100011" =>              cfs_reg_wr(35) <= bus_req_i.data;
            when "100100" =>              cfs_reg_wr(36) <= bus_req_i.data;
            when "100101" =>              cfs_reg_wr(37) <= bus_req_i.data;
            when "100110" =>              cfs_reg_wr(38) <= bus_req_i.data;
            when "100111" =>              cfs_reg_wr(39) <= bus_req_i.data;
            when "101000" =>              cfs_reg_wr(40) <= bus_req_i.data;
            when "101001" =>              cfs_reg_wr(41) <= bus_req_i.data;
            when "101010" =>              cfs_reg_wr(42) <= bus_req_i.data;
            when "101011" =>              cfs_reg_wr(43) <= bus_req_i.data;
            when "101100" =>              cfs_reg_wr(44) <= bus_req_i.data;
            when "101101" =>              cfs_reg_wr(45) <= bus_req_i.data;
            when "101110" =>              cfs_reg_wr(46) <= bus_req_i.data;
            when "101111" =>              cfs_reg_wr(47) <= bus_req_i.data;
            when "110000" =>              cfs_reg_wr(48) <= bus_req_i.data;
            when "110001" =>              cfs_reg_wr(49) <= bus_req_i.data;
            when "110010" =>              cfs_reg_wr(50) <= bus_req_i.data;
            when "110011" =>              cfs_reg_wr(51) <= bus_req_i.data;
            when "110100" =>              cfs_reg_wr(52) <= bus_req_i.data;
            when "110101" =>              cfs_reg_wr(53) <= bus_req_i.data;
            when "110110" =>              cfs_reg_wr(54) <= bus_req_i.data;
            when "110111" =>              cfs_reg_wr(55) <= bus_req_i.data;
            when "111000" =>              cfs_reg_wr(56) <= bus_req_i.data;
            when "111001" =>              cfs_reg_wr(57) <= bus_req_i.data;
            when "111010" =>              cfs_reg_wr(58) <= bus_req_i.data;
            when "111011" =>              cfs_reg_wr(59) <= bus_req_i.data;
            when "111100" =>              cfs_reg_wr(60) <= bus_req_i.data;
            when "111101" =>              cfs_reg_wr(61) <= bus_req_i.data;
            when "111110" =>              cfs_reg_wr(62) <= bus_req_i.data;
            when "111111" =>              cfs_reg_wr(63) <= bus_req_i.data;
            when others =>              null; -- ou algum outro comportamento padrão
          end case;

        -- read access --
        else 
          case bus_req_i.addr(7 downto 2) is
            when "000000" => bus_rsp_o.data <= cfs_reg_rd(0);
            when "000001" => bus_rsp_o.data <= cfs_reg_rd(1);
            when "000010" => bus_rsp_o.data <= cfs_reg_rd(2);
            when "000011" => bus_rsp_o.data <= cfs_reg_rd(3);
            when "000100" => bus_rsp_o.data <= cfs_reg_rd(4);
            when "000101" => bus_rsp_o.data <= cfs_reg_rd(5);
            when "000110" => bus_rsp_o.data <= cfs_reg_rd(6);
            when "000111" => bus_rsp_o.data <= cfs_reg_rd(7);
            when "001000" => bus_rsp_o.data <= cfs_reg_rd(8);
            when "001001" => bus_rsp_o.data <= cfs_reg_rd(9);
            when "001010" => bus_rsp_o.data <= cfs_reg_rd(10);
            when "001011" => bus_rsp_o.data <= cfs_reg_rd(11);
            when "001100" => bus_rsp_o.data <= cfs_reg_rd(12);
            when "001101" => bus_rsp_o.data <= cfs_reg_rd(13);
            when "001110" => bus_rsp_o.data <= cfs_reg_rd(14);
            when "001111" => bus_rsp_o.data <= cfs_reg_rd(15);
            when "010000" => bus_rsp_o.data <= cfs_reg_rd(16);
            when "010001" => bus_rsp_o.data <= cfs_reg_rd(17);
            when "010010" => bus_rsp_o.data <= cfs_reg_rd(18);
            when "010011" => bus_rsp_o.data <= cfs_reg_rd(19);
            when "010100" => bus_rsp_o.data <= cfs_reg_rd(20);
            when "010101" => bus_rsp_o.data <= cfs_reg_rd(21);
            when "010110" => bus_rsp_o.data <= cfs_reg_rd(22);
            when "010111" => bus_rsp_o.data <= cfs_reg_rd(23);
            when "011000" => bus_rsp_o.data <= cfs_reg_rd(24);
            when "011001" => bus_rsp_o.data <= cfs_reg_rd(25);
            when "011010" => bus_rsp_o.data <= cfs_reg_rd(26);
            when "011011" => bus_rsp_o.data <= cfs_reg_rd(27);
            when "011100" => bus_rsp_o.data <= cfs_reg_rd(28);
            when "011101" => bus_rsp_o.data <= cfs_reg_rd(29);
            when "011110" => bus_rsp_o.data <= cfs_reg_rd(30);
            when "011111" => bus_rsp_o.data <= cfs_reg_rd(31);
            when "100000" => bus_rsp_o.data <= cfs_reg_rd(32);
            when "100001" => bus_rsp_o.data <= cfs_reg_rd(33);
            when "100010" => bus_rsp_o.data <= cfs_reg_rd(34);
            when "100011" => bus_rsp_o.data <= cfs_reg_rd(35);
            when "100100" => bus_rsp_o.data <= cfs_reg_rd(36);
            when "100101" => bus_rsp_o.data <= cfs_reg_rd(37);
            when "100110" => bus_rsp_o.data <= cfs_reg_rd(38);
            when "100111" => bus_rsp_o.data <= cfs_reg_rd(39);
            when "101000" => bus_rsp_o.data <= cfs_reg_rd(40);
            when "101001" => bus_rsp_o.data <= cfs_reg_rd(41);
            when "101010" => bus_rsp_o.data <= cfs_reg_rd(42);
            when "101011" => bus_rsp_o.data <= cfs_reg_rd(43);
            when "101100" => bus_rsp_o.data <= cfs_reg_rd(44);
            when "101101" => bus_rsp_o.data <= cfs_reg_rd(45);
            when "101110" => bus_rsp_o.data <= cfs_reg_rd(46);
            when "101111" => bus_rsp_o.data <= cfs_reg_rd(47);
            when "110000" => bus_rsp_o.data <= cfs_reg_rd(48);
            when "110001" => bus_rsp_o.data <= cfs_reg_rd(49);
            when "110010" => bus_rsp_o.data <= cfs_reg_rd(50);
            when "110011" => bus_rsp_o.data <= cfs_reg_rd(51);
            when "110100" => bus_rsp_o.data <= cfs_reg_rd(52);
            when "110101" => bus_rsp_o.data <= cfs_reg_rd(53);
            when "110110" => bus_rsp_o.data <= cfs_reg_rd(54);
            when "110111" => bus_rsp_o.data <= cfs_reg_rd(55);
            when "111000" => bus_rsp_o.data <= cfs_reg_rd(56);
            when "111001" => bus_rsp_o.data <= cfs_reg_rd(57);
            when "111010" => bus_rsp_o.data <= cfs_reg_rd(58);
            when "111011" => bus_rsp_o.data <= cfs_reg_rd(59);
            when "111100" => bus_rsp_o.data <= cfs_reg_rd(60);
            when "111101" => bus_rsp_o.data <= cfs_reg_rd(61);
            when "111110" => bus_rsp_o.data <= cfs_reg_rd(62);
            when "111111" => bus_rsp_o.data <= cfs_reg_rd(63);
            when others   => bus_rsp_o.data <= (others => '0');
          end case;
        end if;

      end if;
    end if;
  end process bus_access;

  -- ---------------------------------------------| 
  -- _wr é o valor que foi escrito pelo "codigo". |
  -- _rd é o valor que será lido pelo "codigo".   |
  -- ---------------------------------------------|

  -- CFS Function Core --
	 matrixs_multiply : dot_product port map(
      reg_mult_in_0 => cfs_reg_wr(0),
      reg_mult_in_1 => cfs_reg_wr(1),
      reg_mult_in_2 => cfs_reg_wr(2),
      reg_mult_in_3 => cfs_reg_wr(3),
      reg_mult_in_4 => cfs_reg_wr(4),
      reg_mult_in_5 => cfs_reg_wr(5),
      reg_mult_in_6 => cfs_reg_wr(6),
      reg_mult_in_7 => cfs_reg_wr(7),
      reg_mult_in_8 => cfs_reg_wr(8),
      reg_mult_in_9 => cfs_reg_wr(9),
      reg_mult_in_10 => cfs_reg_wr(10),
      reg_mult_in_11 => cfs_reg_wr(11),
      reg_mult_in_12 => cfs_reg_wr(12),
      reg_mult_in_13 => cfs_reg_wr(13),
      reg_mult_in_14 => cfs_reg_wr(14),
      reg_mult_in_15 => cfs_reg_wr(15),
      reg_mult_in_16 => cfs_reg_wr(16),
      reg_mult_in_17 => cfs_reg_wr(17),
      reg_mult_in_18 => cfs_reg_wr(18),
      reg_mult_in_19 => cfs_reg_wr(19),
      reg_mult_in_20 => cfs_reg_wr(20),
      reg_mult_in_21 => cfs_reg_wr(21),
      reg_mult_in_22 => cfs_reg_wr(22),
      reg_mult_in_23 => cfs_reg_wr(23),
      reg_mult_in_24 => cfs_reg_wr(24),
      reg_mult_in_25 => cfs_reg_wr(25),
      reg_mult_in_26 => cfs_reg_wr(26),
      reg_mult_in_27 => cfs_reg_wr(27),
      reg_mult_in_28 => cfs_reg_wr(28),
      reg_mult_in_29 => cfs_reg_wr(29),
      reg_mult_in_30 => cfs_reg_wr(30),
      reg_mult_in_31 => cfs_reg_wr(31),
      reg_mult_in_32 => cfs_reg_wr(32),
      reg_mult_in_33 => cfs_reg_wr(33),
      reg_mult_in_34 => cfs_reg_wr(34),
      reg_mult_in_35 => cfs_reg_wr(35),
      reg_mult_in_36 => cfs_reg_wr(36),
      reg_mult_in_37 => cfs_reg_wr(37),
      reg_mult_in_38 => cfs_reg_wr(38),
      reg_mult_in_39 => cfs_reg_wr(39),
      reg_mult_in_40 => cfs_reg_wr(40),
      reg_mult_in_41 => cfs_reg_wr(41),
      reg_mult_in_42 => cfs_reg_wr(42),
      reg_mult_in_43 => cfs_reg_wr(43),
      reg_mult_in_44 => cfs_reg_wr(44),
      reg_mult_in_45 => cfs_reg_wr(45),
      reg_mult_in_46 => cfs_reg_wr(46),
      reg_mult_in_47 => cfs_reg_wr(47),
      reg_mult_in_48 => cfs_reg_wr(48),
      reg_mult_in_49 => cfs_reg_wr(49),
      reg_mult_in_50 => cfs_reg_wr(50),
      reg_mult_in_51 => cfs_reg_wr(51),
      reg_mult_in_52 => cfs_reg_wr(52),
      reg_mult_in_53 => cfs_reg_wr(53),
      reg_mult_in_54 => cfs_reg_wr(54),
      reg_mult_in_55 => cfs_reg_wr(55),
      reg_mult_in_56 => cfs_reg_wr(56),
      reg_mult_in_57 => cfs_reg_wr(57),
      reg_mult_in_58 => cfs_reg_wr(58),
      reg_mult_in_59 => cfs_reg_wr(59),
      reg_mult_in_60 => cfs_reg_wr(60),
      reg_mult_in_61 => cfs_reg_wr(61),
      reg_mult_in_62 => cfs_reg_wr(62),
		
      reg_sum_out => cfs_reg_rd(63)
    );
	 
end neorv32_cfs_rtl;
