library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnidadeControle is 
    port
    (
        clk         : in std_logic;
        rst         : in std_logic;
        data_in     : in unsigned (17 downto 0);

        pc_wr                       : out std_logic;

        banco_reg_wr_en             : out std_logic;

        escolhe_data_banco_reg      : out unsigned (1 downto 0);
        
        reg_inst_wr_en              : out std_logic;
        
        escolhe_entrada_acumulador  : out std_logic;
        acumulador_wr_en            : out std_logic;
        
        escolhe_entrada_A_ULA       : out std_logic;
        escolhe_entrada_B_ULA       : out std_logic;
        escolhe_op_ULA              : out unsigned (1 downto 0);
        
        jump_sel                    : out std_logic;                
        nop_sel                     : out std_logic;
        estado_out                  : out unsigned (2 downto 0);

        ffp_zero_wr                 : out std_logic;
        ffp_carry_wr                : out std_logic;
        ffp_negativo_wr             : out std_logic;

        ram_wr_en                   : out std_logic

    );
end UnidadeControle;

architecture a_UnidadeControle of UnidadeControle is

    component MaquinaEstados is
        port
        (
            clk       : in std_logic;
            rst       : in std_logic;
            estado    : out unsigned(2 downto 0)
        );
    end component;

    signal estado_s            : unsigned(2 downto 0);
    signal opcode              : unsigned (3 downto 0);
    signal uso_acumulador      : std_logic;
    
    

    begin
        opcode <= data_in (17 downto 14);

        uso_acumulador <= data_in (0);

        maquinas : MaquinaEstados port map (clk => clk, rst => rst, estado => estado_s);
        
        pc_wr <= '1' when estado_s = "010" or (opcode = "1111" and estado_s = "010") or (opcode = "0001" and estado_s = "010") else --mudei de 01 para 10 pq senao lia a instruçao pos jump
                 '0';
        
        reg_inst_wr_en <= '1' when estado_s = "001" else 
                          '0';
    
        banco_reg_wr_en <= '1' when (opcode = "0111"  or opcode = "0110" or opcode = "0101" or opcode = "0011") and estado_s = "100" else 
                           '0'; -- mov de A, ld
        
        escolhe_entrada_acumulador <= '1' when (opcode = "0111" and data_in (13 downto 11) = "000") else -- MOV registrador -> ACUMULADOR
                                      '0'; -- ULA

        escolhe_data_banco_reg <= "00" when opcode = "0110"         -- LD, data direto do reg inst
                                else "01" when opcode = "0111"      -- MOV,do acumulador para registrador
                                else "11" when opcode = "0011"      -- LW, escreve valor RAM no reg
                                else "10";                          -- vem da ula
        
        acumulador_wr_en <= '1' when (estado_s = "001" and data_in (13 downto 11) = "000" and data_in (1 downto 0) = "01") else
                            '0';
        
        escolhe_entrada_A_ULA <= '1' when ((opcode = "0100" or opcode = "0011" or opcode = "0010") and data_in (10 downto 8) /= "000") else -- 1 = BANCO; 0 = ACUMULADOR
                                 '0';

        escolhe_entrada_B_ULA <= '1' when ((opcode = "0100" or opcode = "0011" or opcode = "0010") and data_in (10 downto 8) /= "000") else '0'; -- 1 = ACUMULADOR; 0 = IMEDIATO

        escolhe_op_ULA <= "00" when (opcode = "0100" or opcode = "0011" or (opcode = "0010" and data_in (1 downto 0) = "11")) else -- ADD
                          "01" when opcode = "0101" else -- SUBI
                          "10";

        ffp_zero_wr <= '1' when (opcode="0100" or opcode = "0101")  else '0'; -- ADD ou SUBI 
        ffp_carry_wr <= '1' when (opcode="0100" or opcode = "0101") else '0';
        ffp_negativo_wr <= '1' when (opcode="0100" or opcode = "0101") else '0';

        jump_sel <= '1' when opcode = "1111" else '0'; 
        nop_sel  <= '1' when opcode = "0000" else '0'; 

        ram_wr_en <= '1' when opcode = "0010" else '0';

        estado_out <= estado_s;
end a_UnidadeControle;