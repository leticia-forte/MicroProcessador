library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity ULA is 
    port
    (
    A, B                    : in unsigned (15 downto 0); -- A é o acumulador. Ex. A <- A - B
    resultado               : out unsigned (15 downto 0);
    seletor                 : in unsigned (1 downto 0); -- 4 opções operacionais ("00" +, "01" -, "10" ,"11")
    negativo, zero, carry   : out std_logic   -- PL => negativo = 0; LS => carry = 0 ou zero = 1
    );
end entity;

architecture UnidadeAritmetica of ULA is

    signal resultado_s               : unsigned (15 downto 0);
    signal registrador_soma          : unsigned (15 downto 0);
    signal registrador_subtracao     : unsigned (15 downto 0);
    signal registrador_and           : unsigned (15 downto 0);
    signal registrador_xor           : unsigned (15 downto 0);
    signal definir_carry             : unsigned (16 downto 0);

    begin
        registrador_soma <= A + B;
        registrador_subtracao <= A - B; 
        registrador_and <= A and B;
        registrador_xor <= A xor B;
        
                resultado_s <= registrador_soma when seletor = "00" else
                             registrador_subtracao when seletor = "01" else
                             registrador_and when seletor = "10" else
                             registrador_xor when seletor = "11" else
                             "0000000000000000";     

                definir_carry <= ('0' & A ) + ( '0' & B) when seletor = "00" else
                                 ('0' & A ) - ( '0' & B) when seletor = "01" else
                                 ('0' & A) and ('0' & B) when seletor = "10" else
                                 ('0' & A) xor ('0' & B) when seletor = "11" else
                                "00000000000000000";    
                    
                
                carry <= '0' when seletor = "10" or seletor = "11" else
                         definir_carry (16) when seletor = "00" or seletor = "01" else
                         '0';
                
                negativo <= definir_carry (15); 
                zero <= '1' when resultado_s = "0000000000000000" else '0';
                
                resultado <= resultado_s;


    end architecture;