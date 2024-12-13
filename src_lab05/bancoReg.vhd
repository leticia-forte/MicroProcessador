library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoReg is
    port( clock      : in std_logic;
          reset      : in std_logic;
          write_en   : in std_logic;

          data_wr : in unsigned(15 downto 0);
          reg_wr : in unsigned (2 downto 0); -- qual reg vai escrever
          
          reg_r1 : in unsigned   (2 downto 0); -- qual reg vai ler
          data_r1 : out unsigned (15 downto 0)
    );
 end entity;

 architecture a_bancoReg of bancoReg is
    
    component reg16bits is
        port (  clk      : in std_logic;
                rst      : in std_logic;
                wr_en    : in std_logic;
                data_in  : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
        );
    end component;
    
    component MUX8x1_16bits is
        port
        ( 
            seletor                                         : in unsigned (2 downto 0);
            entr0,entr1,entr2,entr3,entr4,entr5,entr6 : in unsigned (15 downto 0);
            saida                                           : out unsigned (15 downto 0)
        );
    end component;

    signal reg0, reg1, reg2, reg3, reg4, reg5, reg6  : std_logic;
    signal mux0, mux1, mux2, mux3, mux4, mux5, mux6  : unsigned(15 downto 0);

begin
    mux : MUX8x1_16bits
    port map (
                entr0 => mux0, entr1 => mux1, entr2 => mux2, entr3 => mux3,
                entr4 => mux4, entr5 => mux5, entr6 => mux6,
                saida => data_r1,
                seletor => reg_r1
             );
    
    reg0 <= '1' when reg_wr = "000" and write_en = '1' else '0';
    reg1 <= '1' when reg_wr = "001" and write_en = '1' else '0';
    reg2 <= '1' when reg_wr = "010" and write_en = '1' else '0';
    reg3 <= '1' when reg_wr = "011" and write_en = '1' else '0';
    reg4 <= '1' when reg_wr = "100" and write_en = '1' else '0';
    reg5 <= '1' when reg_wr = "101" and write_en = '1' else '0';
    reg6 <= '1' when reg_wr = "110" and write_en = '1' else '0';

    reg_0 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>'0', data_in=>"0000000000000000", data_out=>mux0); -- sempre zero por causa do acumulador
    reg_1 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg1, data_in=>data_wr, data_out=>mux1);
    reg_2 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg2, data_in=>data_wr, data_out=>mux2);
    reg_3 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg3, data_in=>data_wr, data_out=>mux3);
    reg_4 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg4, data_in=>data_wr, data_out=>mux4);
    reg_5 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg5, data_in=>data_wr, data_out=>mux5);
    reg_6 : reg16bits port map (clk=>clock, rst=>reset, wr_en=>reg6, data_in=>data_wr, data_out=>mux6);
    
 end architecture;