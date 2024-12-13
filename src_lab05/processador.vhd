library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
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
end entity processador;

architecture a_processador of processador is

    component PC_1 is
        port
         ( 
           clk               : in std_logic;
           wr_en             : in std_logic;
           rst               : in std_logic;
           jump_en           : in std_logic;
           data_increment_in : in unsigned  (17 downto 0); -- data_in + incremento 
           data_out          : out unsigned (17 downto 0)
        );
     end component PC_1;

     component ROM is
        port 
        (
            clk      : in std_logic;
            endereco : in unsigned (17 downto 0);
            data     : out unsigned (17 downto 0)
        );
    end component ROM;

    component bancoReg is
        port( clock      : in std_logic;
              reset      : in std_logic;
              write_en   : in std_logic;
    
              data_wr    : in unsigned(15 downto 0);
              reg_wr     : in unsigned (2 downto 0);
              
              reg_r1     : in unsigned (2 downto 0);
              data_r1    : out unsigned (15 downto 0)
        );
     end component bancoReg;

    component UnidadeControle is  
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
                estado_out                  : out unsigned (2 downto 0)
             
            );
    end component UnidadeControle;

    component reg18bits is
        port( clk      : in std_logic;
              rst      : in std_logic;
              wr_en    : in std_logic;
              data_in  : in unsigned(17 downto 0);
              data_out : out unsigned(17 downto 0)
        );
     end component reg18bits; --Registrador de Instrução 

     component reg16bits is
        port( clk      : in std_logic;
              rst      : in std_logic;
              wr_en    : in std_logic;
              data_in  : in unsigned(15 downto 0);
              data_out : out unsigned(15 downto 0)
        );
     end component reg16bits; -- Acumulador

     component ULA is 
        port
        (
            A, B                    : in unsigned (15 downto 0); -- A é o acumulador. Ex. A <- A - B
            resultado               : out unsigned (15 downto 0);
            seletor                 : in unsigned (1 downto 0); -- 4 opções operacionais ("00" +, "01" -, "10" ,"11")
            negativo, zero, carry   : out std_logic   -- PL => negativo = 0; LS => carry = 0 ou zero = 1
        );
    end component ULA;


    --sinais PC
    signal saida_pc : unsigned (17 downto 0); -- entrada ROM
    signal incremento_pc : unsigned (17 downto 0);

    --sinais ROM
    signal saida_rom : unsigned (17 downto 0); -- entrada registrador de instrução

    --sinais registrador de instrução
    signal saida_reg_inst : unsigned (17 downto 0); -- entradas: UC e Banco Reg e Imediato
    signal imediato : unsigned (15 downto 0);

    --sinais banco reg
    signal saida_banco_reg : unsigned (15 downto 0);
    signal valor_para_registrar_banco : unsigned (15 downto 0);

    --sinais acumulador
    signal entrada_val_acumulador : unsigned (15 downto 0);
    signal saida_val_acumulador : unsigned (15 downto 0);

    --sinais ula
    signal valor_A_ula : unsigned (15 downto 0);
    signal valor_B_ula : unsigned (15 downto 0);
    signal saida_ula : unsigned (15 downto 0);
    signal saida_zero : std_logic;
    signal saida_carry : std_logic;
    signal saida_negativo : std_logic;

    --sinais Unidade de Controle
    signal jump_en_s : std_logic;
    signal nop_sel_s : std_logic;
    signal pc_wr_en : std_logic;
    signal reg_instrucao_wr_en : std_logic;
    signal banco_registradores_wr_en : std_logic;
    signal acumulador_wr_en_s : std_logic;
    signal escolhe_op_ula_s : unsigned (1 downto 0);
    signal escolhe_entrada_A_ULA_s : std_logic;
    signal escolhe_entrada_B_ULA_s : std_logic;
    signal escolhe_entrada_acumulador_s : std_logic;
    signal estado_out_s : unsigned (2 downto 0);
    signal escolhe_data_banco_reg_s : unsigned (1 downto 0);


    begin
    
        unidadeC: UnidadeControle port map 
                (
                    clk => clk,
                    rst => rst,
                    data_in => saida_reg_inst,

                    pc_wr => pc_wr_en,

                    banco_reg_wr_en => banco_registradores_wr_en,

                    escolhe_data_banco_reg => escolhe_data_banco_reg_s,
        
                    reg_inst_wr_en => reg_instrucao_wr_en,
        
                    escolhe_entrada_acumulador => escolhe_entrada_acumulador_s,
                    acumulador_wr_en => acumulador_wr_en_s,
        
                    escolhe_entrada_A_ULA => escolhe_entrada_A_ULA_s,
                    escolhe_entrada_B_ULA => escolhe_entrada_B_ULA_s,
                    escolhe_op_ULA => escolhe_op_ula_s,
        
                    jump_sel => jump_en_s,                
                    nop_sel => nop_sel_s,
                    estado_out => estado
                );
        pc:  PC_1 port map
             ( 
                clk => clk,
                wr_en => pc_wr_en,        
                rst => rst,     
                jump_en => jump_en_s, 
                
                data_increment_in => incremento_pc,
                
                data_out => saida_pc
            );

        ro: ROM port map 
                (
                    clk => clk,
                    endereco => saida_pc,
                    data => saida_rom
                );

        registrador_instrucao: reg18bits port map
                    (
                        clk => clk,
                        rst => rst,
                        wr_en => reg_instrucao_wr_en,
                        data_in => saida_rom,
                        data_out => saida_reg_inst
                    ); 
        
        bancoRegistradores: bancoReg port map
            (
                clock => clk,
                reset => rst,
                write_en => banco_registradores_wr_en,
    
                data_wr => valor_para_registrar_banco,
                reg_wr => saida_reg_inst(13 downto 11),
              
                reg_r1 => saida_reg_inst(10 downto 8),
                data_r1 => saida_banco_reg
            );
                                  
        
        unidadeLogicaA: ULA port map
            (
                A => valor_A_ula,
                B => valor_B_ula,
                resultado => saida_ula,
                seletor => escolhe_op_ula_s,
                negativo => saida_negativo,
                zero => saida_zero,
                carry => saida_carry
            );

            acumulador : reg16bits port map 
            (
                clk => clk,
                rst => rst,
                wr_en => acumulador_wr_en_s,
                data_in => entrada_val_acumulador,
                data_out => saida_val_acumulador
            );
        
       
        --PC 
        incremento_pc <= "000000000000000001" when (jump_en_s = '0' or nop_sel_s = '1') else               
                          ("000000000000" & saida_reg_inst (7 downto 2) ) when jump_en_s = '1' else     
                          "000000000000000001";                          
        
        -- Banco de Registradores
        imediato <= "0000000000" & saida_reg_inst (7 downto 2) when saida_reg_inst (7) = '0' else
                    "1111111111" & saida_reg_inst (7 downto 2) when saida_reg_inst (7) = '1' else
                    "0000000000000000";

        valor_para_registrar_banco <= imediato when escolhe_data_banco_reg_s = "00"
                                    else saida_val_acumulador when escolhe_data_banco_reg_s = "01"
                                    else saida_ula;

        -- ULA
        valor_A_ula <= saida_banco_reg when escolhe_entrada_A_ULA_s = '1' --soma
                        else saida_val_acumulador ; --sub
        
        valor_B_ula <= saida_val_acumulador when escolhe_entrada_B_ULA_s = '1' --soma
                        else imediato; --sub

        --acumulador
        entrada_val_acumulador <= saida_banco_reg when escolhe_entrada_acumulador_s = '1'
                                else saida_ula;
        


        -- saidas processador
        pc_s <= saida_pc;
        instrucao <= saida_reg_inst;
        data_reg_o <= saida_banco_reg;
        data_acum_o <= saida_val_acumulador;
        ula_o <= saida_ula ;



end architecture;

