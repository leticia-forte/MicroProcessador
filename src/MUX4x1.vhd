library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity MUX4x1 is
    port
    (   
        seletor_MUX                             : in std_logic_vector (1 downto 0);
        soma, subtracao, opAnd, opXor  : in unsigned (15 downto 0);
        resultado_MUX                           : out unsigned (15 downto 0)
    );
 end entity;

 architecture a_MUX4x1 of mux4x1 is
    begin
        resultado_MUX <=    
                   soma          when  seletor_MUX(1)='0' and seletor_MUX(0)='0' else
                   subtracao     when  seletor_MUX(1)='0' and seletor_MUX(0)='1' else
                   opAnd     when  seletor_MUX(1)='1' and seletor_MUX(0)='0' else
                   opXor    when  seletor_MUX(1)='1' and seletor_MUX(0)='1' else
                   "0000000000000000";
    end architecture;