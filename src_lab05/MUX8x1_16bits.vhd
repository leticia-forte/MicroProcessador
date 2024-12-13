library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX8x1_16bits is
    port( seletor                                         : in unsigned (2 downto 0);
          entr0,entr1,entr2,entr3,entr4,entr5,entr6 : in unsigned (15 downto 0);
          saida                                           : out unsigned (15 downto 0)
    );   
 end entity;

 architecture a_MUX8x1_16bits of MUX8x1_16bits is
    begin
      saida <= entr0 when seletor = "000" else
               entr1 when seletor = "001" else
               entr2 when seletor = "010" else
               entr3 when seletor = "011" else
               entr4 when seletor = "100" else
               entr5 when seletor = "101" else
               entr6 when seletor = "110" else
               "0000000000000000";     
    end architecture;