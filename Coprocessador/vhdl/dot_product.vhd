-- ###################################################################################################
-- # << ISS2718 - Scalar Product Entity for Matrix Multiplication Accelerator >>                     #
-- # *********************************************************************************************** #
-- # This entity implements the calculation of the scalar product, a fundamental operation in        #
-- # matrix multiplication. It is the central part of the matrix multiplication accelerator.         #
-- #                                                                                                 #
-- # NOTE: This code was entirely developed by Daniel Contente, Hugo Nakamura, Isaac Soares,         #
-- # Mateus Messias.                                                                                 #
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

-- Entity that implements the dot product of two 16-bit vectors with 63 elements.
entity dot_product is
  port (
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
end entity dot_product;

-- rtl -> Register Transfer Level
architecture rtl of dot_product is
  type reg_array is array (0 to 62) of unsigned(15 downto 0); -- 63 registers with 16 bits
  signal a : reg_array;
  signal b : reg_array;
  
  type result_mult_array is array (0 to 62) of unsigned(31 downto 0); -- 63 registers with 32 bits
	signal result_mult : result_mult_array;

	signal result_sum : unsigned(31 downto 0);
begin
  -- Splitting the 32-bit input into two 16-bit inputs
  a(0) <= unsigned(reg_mult_in_0(31 downto 16));
  b(0) <= unsigned(reg_mult_in_0(15 downto 0));
  
  a(1) <= unsigned(reg_mult_in_1(31 downto 16));
  b(1) <= unsigned(reg_mult_in_1(15 downto 0));
  
  a(2) <= unsigned(reg_mult_in_2(31 downto 16));
  b(2) <= unsigned(reg_mult_in_2(15 downto 0));
  
  a(3) <= unsigned(reg_mult_in_3(31 downto 16));
  b(3) <= unsigned(reg_mult_in_3(15 downto 0));
  
  a(4) <= unsigned(reg_mult_in_4(31 downto 16));
  b(4) <= unsigned(reg_mult_in_4(15 downto 0));
  
  a(5) <= unsigned(reg_mult_in_5(31 downto 16));
  b(5) <= unsigned(reg_mult_in_5(15 downto 0));
  
  a(6) <= unsigned(reg_mult_in_6(31 downto 16));
  b(6) <= unsigned(reg_mult_in_6(15 downto 0));
  
  a(7) <= unsigned(reg_mult_in_7(31 downto 16));
  b(7) <= unsigned(reg_mult_in_7(15 downto 0));
  
  a(8) <= unsigned(reg_mult_in_8(31 downto 16));
  b(8) <= unsigned(reg_mult_in_8(15 downto 0));
  
  a(9) <= unsigned(reg_mult_in_9(31 downto 16));
  b(9) <= unsigned(reg_mult_in_9(15 downto 0));
  
  a(10) <= unsigned(reg_mult_in_10(31 downto 16));
  b(10) <= unsigned(reg_mult_in_10(15 downto 0));
  
  a(11) <= unsigned(reg_mult_in_11(31 downto 16));
  b(11) <= unsigned(reg_mult_in_11(15 downto 0));
  
  a(12) <= unsigned(reg_mult_in_12(31 downto 16));
  b(12) <= unsigned(reg_mult_in_12(15 downto 0));
  
  a(13) <= unsigned(reg_mult_in_13(31 downto 16));
  b(13) <= unsigned(reg_mult_in_13(15 downto 0));
  
  a(14) <= unsigned(reg_mult_in_14(31 downto 16));
  b(14) <= unsigned(reg_mult_in_14(15 downto 0));
  
  a(15) <= unsigned(reg_mult_in_15(31 downto 16));
  b(15) <= unsigned(reg_mult_in_15(15 downto 0));
  
  a(16) <= unsigned(reg_mult_in_16(31 downto 16));
  b(16) <= unsigned(reg_mult_in_16(15 downto 0));
  
  a(17) <= unsigned(reg_mult_in_17(31 downto 16));
  b(17) <= unsigned(reg_mult_in_17(15 downto 0));
  
  a(18) <= unsigned(reg_mult_in_18(31 downto 16));
  b(18) <= unsigned(reg_mult_in_18(15 downto 0));
  
  a(19) <= unsigned(reg_mult_in_19(31 downto 16));
  b(19) <= unsigned(reg_mult_in_19(15 downto 0));
  
  a(20) <= unsigned(reg_mult_in_20(31 downto 16));
  b(20) <= unsigned(reg_mult_in_20(15 downto 0));
  
  a(21) <= unsigned(reg_mult_in_21(31 downto 16));
  b(21) <= unsigned(reg_mult_in_21(15 downto 0));
  
  a(22) <= unsigned(reg_mult_in_22(31 downto 16));
  b(22) <= unsigned(reg_mult_in_22(15 downto 0));
  
  a(23) <= unsigned(reg_mult_in_23(31 downto 16));
  b(23) <= unsigned(reg_mult_in_23(15 downto 0));
  
  a(24) <= unsigned(reg_mult_in_24(31 downto 16));
  b(24) <= unsigned(reg_mult_in_24(15 downto 0));
  
  a(25) <= unsigned(reg_mult_in_25(31 downto 16));
  b(25) <= unsigned(reg_mult_in_25(15 downto 0));
  
  a(26) <= unsigned(reg_mult_in_26(31 downto 16));
  b(26) <= unsigned(reg_mult_in_26(15 downto 0));
  
  a(27) <= unsigned(reg_mult_in_27(31 downto 16));
  b(27) <= unsigned(reg_mult_in_27(15 downto 0));
  
  a(28) <= unsigned(reg_mult_in_28(31 downto 16));
  b(28) <= unsigned(reg_mult_in_28(15 downto 0));
  
  a(29) <= unsigned(reg_mult_in_29(31 downto 16));
  b(29) <= unsigned(reg_mult_in_29(15 downto 0));
  
  a(30) <= unsigned(reg_mult_in_30(31 downto 16));
  b(30) <= unsigned(reg_mult_in_30(15 downto 0));
  
  a(31) <= unsigned(reg_mult_in_31(31 downto 16));
  b(31) <= unsigned(reg_mult_in_31(15 downto 0));
  
  a(32) <= unsigned(reg_mult_in_32(31 downto 16));
  b(32) <= unsigned(reg_mult_in_32(15 downto 0));
  
  a(33) <= unsigned(reg_mult_in_33(31 downto 16));
  b(33) <= unsigned(reg_mult_in_33(15 downto 0));
  
  a(34) <= unsigned(reg_mult_in_34(31 downto 16));
  b(34) <= unsigned(reg_mult_in_34(15 downto 0));
  
  a(35) <= unsigned(reg_mult_in_35(31 downto 16));
  b(35) <= unsigned(reg_mult_in_35(15 downto 0));
  
  a(36) <= unsigned(reg_mult_in_36(31 downto 16));
  b(36) <= unsigned(reg_mult_in_36(15 downto 0));
  
  a(37) <= unsigned(reg_mult_in_37(31 downto 16));
  b(37) <= unsigned(reg_mult_in_37(15 downto 0));
  
  a(38) <= unsigned(reg_mult_in_38(31 downto 16));
  b(38) <= unsigned(reg_mult_in_38(15 downto 0));
  
  a(39) <= unsigned(reg_mult_in_39(31 downto 16));
  b(39) <= unsigned(reg_mult_in_39(15 downto 0));
  
  a(40) <= unsigned(reg_mult_in_40(31 downto 16));
  b(40) <= unsigned(reg_mult_in_40(15 downto 0));
  
  a(41) <= unsigned(reg_mult_in_41(31 downto 16));
  b(41) <= unsigned(reg_mult_in_41(15 downto 0));
  
  a(42) <= unsigned(reg_mult_in_42(31 downto 16));
  b(42) <= unsigned(reg_mult_in_42(15 downto 0));
  
  a(43) <= unsigned(reg_mult_in_43(31 downto 16));
  b(43) <= unsigned(reg_mult_in_43(15 downto 0));
  
  a(44) <= unsigned(reg_mult_in_44(31 downto 16));
  b(44) <= unsigned(reg_mult_in_44(15 downto 0));
  
  a(45) <= unsigned(reg_mult_in_45(31 downto 16));
  b(45) <= unsigned(reg_mult_in_45(15 downto 0));
  
  a(46) <= unsigned(reg_mult_in_46(31 downto 16));
  b(46) <= unsigned(reg_mult_in_46(15 downto 0));
  
  a(47) <= unsigned(reg_mult_in_47(31 downto 16));
  b(47) <= unsigned(reg_mult_in_47(15 downto 0));
  
  a(48) <= unsigned(reg_mult_in_48(31 downto 16));
  b(48) <= unsigned(reg_mult_in_48(15 downto 0));
  
  a(49) <= unsigned(reg_mult_in_49(31 downto 16));
  b(49) <= unsigned(reg_mult_in_49(15 downto 0));
  
  a(50) <= unsigned(reg_mult_in_50(31 downto 16));
  b(50) <= unsigned(reg_mult_in_50(15 downto 0));
  
  a(51) <= unsigned(reg_mult_in_51(31 downto 16));
  b(51) <= unsigned(reg_mult_in_51(15 downto 0));
  
  a(52) <= unsigned(reg_mult_in_52(31 downto 16));
  b(52) <= unsigned(reg_mult_in_52(15 downto 0));
  
  a(53) <= unsigned(reg_mult_in_53(31 downto 16));
  b(53) <= unsigned(reg_mult_in_53(15 downto 0));
  
  a(54) <= unsigned(reg_mult_in_54(31 downto 16));
  b(54) <= unsigned(reg_mult_in_54(15 downto 0));
  
  a(55) <= unsigned(reg_mult_in_55(31 downto 16));
  b(55) <= unsigned(reg_mult_in_55(15 downto 0));
  
  a(56) <= unsigned(reg_mult_in_56(31 downto 16));
  b(56) <= unsigned(reg_mult_in_56(15 downto 0));
  
  a(57) <= unsigned(reg_mult_in_57(31 downto 16));
  b(57) <= unsigned(reg_mult_in_57(15 downto 0));
  
  a(58) <= unsigned(reg_mult_in_58(31 downto 16));
  b(58) <= unsigned(reg_mult_in_58(15 downto 0));
  
  a(59) <= unsigned(reg_mult_in_59(31 downto 16));
  b(59) <= unsigned(reg_mult_in_59(15 downto 0));
  
  a(60) <= unsigned(reg_mult_in_60(31 downto 16));
  b(60) <= unsigned(reg_mult_in_60(15 downto 0));
  
  a(61) <= unsigned(reg_mult_in_61(31 downto 16));
  b(61) <= unsigned(reg_mult_in_61(15 downto 0));
  
  a(62) <= unsigned(reg_mult_in_62(31 downto 16));
  b(62) <= unsigned(reg_mult_in_62(15 downto 0));

  -- Multiplication of each element of the vectors
  result_mult(0) <= (a(0) * b(0));
  result_mult(1) <= (a(1) * b(1));
  result_mult(2) <= (a(2) * b(2));
  result_mult(3) <= (a(3) * b(3));
  result_mult(4) <= (a(4) * b(4));
  result_mult(5) <= (a(5) * b(5));
  result_mult(6) <= (a(6) * b(6));
  result_mult(7) <= (a(7) * b(7));
  result_mult(8) <= (a(8) * b(8));
  result_mult(9) <= (a(9) * b(9));
  result_mult(10) <= (a(10) * b(10));
  result_mult(11) <= (a(11) * b(11));
  result_mult(12) <= (a(12) * b(12));
  result_mult(13) <= (a(13) * b(13));
  result_mult(14) <= (a(14) * b(14));
  result_mult(15) <= (a(15) * b(15));
  result_mult(16) <= (a(16) * b(16));
  result_mult(17) <= (a(17) * b(17));
  result_mult(18) <= (a(18) * b(18));
  result_mult(19) <= (a(19) * b(19));
  result_mult(20) <= (a(20) * b(20));
  result_mult(21) <= (a(21) * b(21));
  result_mult(22) <= (a(22) * b(22));
  result_mult(23) <= (a(23) * b(23));
  result_mult(24) <= (a(24) * b(24));
  result_mult(25) <= (a(25) * b(25));
  result_mult(26) <= (a(26) * b(26));
  result_mult(27) <= (a(27) * b(27));
  result_mult(28) <= (a(28) * b(28));
  result_mult(29) <= (a(29) * b(29));
  result_mult(30) <= (a(30) * b(30));
  result_mult(31) <= (a(31) * b(31));
  result_mult(32) <= (a(32) * b(32));
  result_mult(33) <= (a(33) * b(33));
  result_mult(34) <= (a(34) * b(34));
  result_mult(35) <= (a(35) * b(35));
  result_mult(36) <= (a(36) * b(36));
  result_mult(37) <= (a(37) * b(37));
  result_mult(38) <= (a(38) * b(38));
  result_mult(39) <= (a(39) * b(39));
  result_mult(40) <= (a(40) * b(40));
  result_mult(41) <= (a(41) * b(41));
  result_mult(42) <= (a(42) * b(42));
  result_mult(43) <= (a(43) * b(43));
  result_mult(44) <= (a(44) * b(44));
  result_mult(45) <= (a(45) * b(45));
  result_mult(46) <= (a(46) * b(46));
  result_mult(47) <= (a(47) * b(47));
  result_mult(48) <= (a(48) * b(48));
  result_mult(49) <= (a(49) * b(49));
  result_mult(50) <= (a(50) * b(50));
  result_mult(51) <= (a(51) * b(51));
  result_mult(52) <= (a(52) * b(52));
  result_mult(53) <= (a(53) * b(53));
  result_mult(54) <= (a(54) * b(54));
  result_mult(55) <= (a(55) * b(55));
  result_mult(56) <= (a(56) * b(56));
  result_mult(57) <= (a(57) * b(57));
  result_mult(58) <= (a(58) * b(58));
  result_mult(59) <= (a(59) * b(59));
  result_mult(60) <= (a(60) * b(60));
  result_mult(61) <= (a(61) * b(61));
  result_mult(62) <= (a(62) * b(62));

  -- Sum of all the results
  result_sum <= result_mult(0) + result_mult(1) + result_mult(2) + result_mult(3) + result_mult(4) +
                result_mult(5) + result_mult(6) + result_mult(7) + result_mult(8) + result_mult(9) +
                result_mult(10) + result_mult(11) + result_mult(12) + result_mult(13) + result_mult(14) +
                result_mult(15) + result_mult(16) + result_mult(17) + result_mult(18) + result_mult(19) +
                result_mult(20) + result_mult(21) + result_mult(22) + result_mult(23) + result_mult(24) +
                result_mult(25) + result_mult(26) + result_mult(27) + result_mult(28) + result_mult(29) +
                result_mult(30) + result_mult(31) + result_mult(32) + result_mult(33) + result_mult(34) +
                result_mult(35) + result_mult(36) + result_mult(37) + result_mult(38) + result_mult(39) +
                result_mult(40) + result_mult(41) + result_mult(42) + result_mult(43) + result_mult(44) +
                result_mult(45) + result_mult(46) + result_mult(47) + result_mult(48) + result_mult(49) +
                result_mult(50) + result_mult(51) + result_mult(52) + result_mult(53) + result_mult(54) +
                result_mult(55) + result_mult(56) + result_mult(57) + result_mult(58) + result_mult(59) +
                result_mult(60) + result_mult(61) + result_mult(62);
	
  reg_sum_out <= std_ulogic_vector(result_sum);  -- Resultado armazenado de volta no registrador
end architecture rtl;
