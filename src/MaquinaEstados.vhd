library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MaquinaEstados is
    port( clk,rst: in std_logic;
          estado: out unsigned(2 downto 0)
    );
 end entity;
 architecture a_MaquinaEstados of MaquinaEstados is
    signal estado_s: unsigned(2 downto 0);
 begin
    process(clk,rst)
    begin
       if rst='1' then
          estado_s <= "000";
       elsif rising_edge(clk) then
          if estado_s="100" then        -- se agora esta em 4
             estado_s <= "000";         -- o prox vai voltar ao zero
          else
             estado_s <= estado_s+1;   -- senao avanca
          end if;
       end if;
    end process;
    estado <= estado_s;
 end architecture;
