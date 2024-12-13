library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador_tb is
end entity Processador_tb;

architecture a_Processador_tb of Processador_tb is
    component Processador is
        port 
        (
            clk          : in std_logic;
            rst          : in std_logic;
            estado       : out unsigned (2 downto 0);
            pc_s         : out unsigned (17 downto 0);
            instrucao    : out unsigned (17 downto 0);
            data_reg_o   : out unsigned (15 downto 0);
            data_acum_o  : out unsigned (15 downto 0);
            ula_o        : out unsigned (15 downto 0)
        );
    end component;


        signal clk          : std_logic;
        signal rst          : std_logic;
        signal estado       : unsigned (2 downto 0);
        signal pc_s         : unsigned (17 downto 0);
        signal instrucao    : unsigned (17 downto 0);
        signal data_reg_o   : unsigned (15 downto 0);
        signal data_acum_o  : unsigned (15 downto 0);
        signal ula_o        : unsigned (15 downto 0);
        
        constant period_time : time      := 10 ns;
        signal   finished    : std_logic := '0';

        begin
            uut : processador port map (
                clk => clk,
                rst => rst,
                estado => estado,
                pc_s => pc_s,
                instrucao => instrucao,
                data_reg_o => data_reg_o,
                data_acum_o => data_acum_o,
                ula_o => ula_o
            );
    
            reset_global: process
                begin
                    rst <= '1';
                    wait for period_time*2; -- espera 2 clocks, pra garantir
                    rst <= '0';
                    wait;
                end process; 


            sim_time_proc: process
            begin
                wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
                finished <= '1';
                wait;
            end process sim_time_proc;

            clock: process
            begin                       -- gera clock até que sim_time_proc termine
            while finished = '0' loop
                clk <= '0';
                wait for 5 ns;
                clk <= '1';
                wait for 5 ns;
            end loop;
            wait;
            end process clock;

            tb: process
            begin 
                wait for 2*period_time;
                wait;
            end process tb;

end architecture a_Processador_tb;