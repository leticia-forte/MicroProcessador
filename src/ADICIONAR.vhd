library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADICIONAR is
    port
    (
        incremento   : in unsigned  (17 downto 0);
        data_in      : in unsigned  (17 downto 0);
        jump : in std_logic;
        data_out     : out unsigned (17 downto 0)
    );
    end entity ADICIONAR;
 
architecture struct of ADICIONAR is 
    begin
        data_out <= data_in + incremento when jump = '0' else incremento ;
end architecture;