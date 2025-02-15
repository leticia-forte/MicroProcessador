library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_1 is
    port
     ( 
       clk               : in std_logic;
       wr_en             : in std_logic;
       rst               : in std_logic;
       jump_en           : in std_logic;
       data_increment_in : in unsigned  (17 downto 0); -- data_in + incremento 
       data_out          : out unsigned (17 downto 0)
    );
 end entity PC_1;
 
 architecture struct of PC_1 is 
     
     component reg18bits is
       port 
         (  
             clk      : in std_logic;
             rst      : in std_logic;
             wr_en    : in std_logic;
             data_in  : in unsigned (17 downto 0);
             data_out : out unsigned(17 downto 0)
         );
     end component;
 
     component ADICIONAR is
         port
             (
                 incremento   : in unsigned  (17 downto 0);
                 data_in      : in unsigned  (17 downto 0);
                 jump : in std_logic;
                 data_out     : out unsigned (17 downto 0)
             );
         end component;
 
     signal pc_o          : unsigned (17 downto 0);
     signal incrementos   : unsigned (17 downto 0);
 
 begin
 
     P: reg18bits port map (clk => clk, rst => rst, wr_en => wr_en, 
                           data_in => incrementos, data_out => pc_o);
     
     incremento: ADICIONAR port map (incremento => data_increment_in, jump => jump_en, data_in => pc_o, data_out => incrementos);
 
     data_out <= pc_o;
 
 end struct;