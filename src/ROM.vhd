library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port 
    (
        clk     : in std_logic;
        endereco : in unsigned (17 downto 0);
        data    : out unsigned (17 downto 0)
    );
end entity ROM;

architecture a_ROM of ROM is
    type memory is array (0 to 65535) of unsigned (17 downto 0);
    constant rom_data : memory := (
        --(INICIO DA RAM)
        0 => B"0110_110_000_000_001_00",--LD r6,1
        1 => B"0110_001_000_000_010_00",--LD R1,2

        2 => B"0111_000_001_000_000_01",--MOV A,R1 --COLOCA NA RAM
        3 => B"0010_000_001_000_000_01", --SW R1, RAM

        4 => B"0100_000_110_000_000_01",-- ADD A, R6
        5 => B"0111_001_000_000_000_01",-- MOV R1, A

        6 => B"0101_000_000_100_001_01",--SUBI A,33 --enquanto menor continua loop
        7 => B"0001_000_000_000_010_00",--BLS -> {COLOCA NA RAM}
        ---------------------------------------------------
        
        --(PROXIMO PRIMO)
        8 => B"0110_001_000_000_000_00", --LD R1,0
        9 => B"0110_010_000_000_010_00", --LD R2,2 
        10 => B"0110_011_000_000_000_00", --LD R3,0
        ---------------------------------------------------
        11 => B"0111_000_010_000_000_01", --MOV A, r2 -- carrega da ram
        12 => B"0011_011_000_000_000_01",-- LW R3, RAM

        13 => B"0111_000_011_000_000_01",-- MOV A, R3 
        14 => B"0101_000_000_000_000_01", --SUBI A,0 --** se esta zero no indice ou nao
        15 => B"0001_000_000_011_100_00", --BLS -> BRANCH AQUI
        --(REMOVE MULTIPLOS)
        16 => B"0111_000_010_000_000_01", --MOV A,R2
        17 => B"0111_100_000_000_000_01", --MOV R4,A
    
        18 => B"0111_000_100_000_000_01", --MOV A, R4 -- PROX MULTIPLO
        19 => B"0100_000_010_000_000_01", --ADD A, R2 
        20 => B"0111_100_000_000_000_01", --MOV R4,A

        21 => B"0110_101_000_000_000_00", -- LD r5, 0
        22 => B"0111_000_100_000_000_01", -- MOV A, r4
        23 => B"0010_000_101_000_000_11", -- SW r5, RAM 

        24 => B"0111_000_100_000_000_01", -- MOV A, r4
        25 => B"0100_000_010_000_000_01", --ADD A, R2 
        26 => B"0101_000_000_100_001_01", --SUBI A,33 --**
        27 => B"0001_000_000_010_010_00", --BLS -> prox multiplo -- enquanto for menor, retorna
        28 => B"0111_000_010_000_000_01", -- MOV A, r2 --branch aqui
        29 => B"0100_000_110_000_000_01", -- ADD A, r6 
        30 => B"0111_010_000_000_000_01", -- MOV r2, A
        31 => B"0101_000_000_000_110_01", -- SUBI A,6 **
        32 => B"0001_000_000_001_011_00", -- BLS -> carrega da ram
        --CRIVO FINISH
            --
        33 => B"0110_001_000_000_010_00", -- LD r1, 2
        34 => B"0110_010_000_100_001_00", -- LD r2, 33

        35 => B"0111_000_001_000_000_01", -- MOV A, r1 -- le da memo
        36 => B"0011_011_000_000_000_01", -- LW r3, RAM

        37 => B"0111_000_011_000_000_01", -- MOV A, r3
        38 => B"0101_000_000_000_001_01", -- SUBI A,1 **
        39 => B"0001_000_000_101_010_00", -- BLS -> eu aqui

        40 => B"0111_000_011_000_000_01", -- MOV A, r3
        41 => B"0111_100_000_000_000_01", -- MOV r4, A

        42 => B"0111_000_001_000_000_01", -- MOV A, r1 --eu aqui
        43 => B"0100_000_110_000_000_01", -- ADD A, r6 
        44 => B"0111_001_000_000_000_01", -- MOV r1, A

        45 => B"0111_000_001_000_000_01", -- MOV A, r1
        46 => B"0101_000_000_100_001_01", -- SUBI A,33
        47 => B"0001_000_000_100_011_00", -- BLS -> le da memo
    
        others => (others=>'0')
        --NOP 0000_xxx_xxx_xxx_xxx_xx
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            data <= rom_data(to_integer(endereco));
        end if;
    end process;
end architecture a_ROM;